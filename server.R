library(shiny)

library(sf)


server <- function(input, output, session) {
  #
  # user sessions setup
  #
  if (is.null(session$userData)) {
    session$userData <- new.env()
  }
  session$userData$deck <- reactiveVal(NULL) # current deck
  session$userData$game_cards <- reactiveVal(NULL) # current random cards from deck (defines the game)
  session$userData$num_tries <- reactiveVal(0) # num tries in game
  session$userData$num_success <- reactiveVal(0) # num success in game
  session$userData$num_forfeit <- reactiveVal(0)
  session$userData$show_answer <- reactiveVal(FALSE) # flag to reveal answer
  session$userData$current_card_idx <- reactiveVal(1) # index of of top (current) card in game

  num_game_cards <- 20

  #
  # helper functions
  #
  new_game <- function(num_cards) {
    print("new game")
    # mix and sample num_cards cards frome deck
    deck <- session$userData$deck()
    session$userData$game_cards(deck[sample(nrow(deck), num_cards), ])
    session$userData$current_card_idx(1)
    session$userData$num_tries(0)
    session$userData$num_success(0)
    session$userData$num_forfeit(0)
    print(str(session$userData$game_cards()))
  }

  #
  # UI EVENTS
  #
  observeEvent(input$selectDeck, {
    print("trigger new deck")
    print(paste0("./decks/", input$selectDeck))
    session$userData$deck(open_deck(input$selectDeck))
    session$userData$current_card_idx(1)
    new_game(num_cards = num_game_cards)
  })

  # next
  observeEvent(input$nextBtn, {
    new_index <- (session$userData$current_card_idx() + 1)
    if (new_index > num_game_cards) {
      new_index <- num_game_cards
    }
    session$userData$current_card_idx(new_index)
  })

  # prev
  observeEvent(input$prevBtn, {
    new_index <- (session$userData$current_card_idx() - 1)
    if (new_index < 1) {
      new_index <- 1
    }
    session$userData$current_card_idx(new_index)
  })

  # submit
  observeEvent(input$submitBtn, {
    game_cards <- session$userData$game_cards()
    card <- game_cards[session$userData$current_card_idx(), ]

    # nothing to do, if the card is forfeit
    if (card$is_forfeit == TRUE) {
      print("cannot submit value to a fortfeit card")
      return()
    }

    # if already got it, nothing to do
    if (!is.na(card$correct_guess) & card$correct_guess == TRUE) {
      print("cannot submit value to an already correctly guessed card")
      return()
    }

    session$userData$num_tries(session$userData$num_tries() + 1)
    print(card$string)

    if (input$guess == card$string) {
      print("you got it!")
      session$userData$num_success(session$userData$num_success() + 1)
      card$correct_guess <- TRUE
      game_cards[session$userData$current_card_idx(), ] <- card
      session$userData$game_cards(game_cards)
    } else {
      print("nope!")
      card$correct_guess <- FALSE
      game_cards[session$userData$current_card_idx(), ] <- card
      session$userData$game_cards(game_cards)
    }
  })

  # forfeit the card
  observeEvent(input$forfeitBtn, {
    game_cards <- session$userData$game_cards()
    card <- game_cards[session$userData$current_card_idx(), ]

    # if already got it, nothing to do
    if (!is.na(card$correct_guess) & card$correct_guess == TRUE) {
      print("cannot forfeit a correctly guessed card")
      return()
    }

    session$userData$num_forfeit(session$userData$num_forfeit() + 1)

    card$is_forfeit <- TRUE
    card$correct_guess <- FALSE

    game_cards[session$userData$current_card_idx(), ] <- card
    session$userData$game_cards(game_cards)
  })

  output$cardImage <- renderImage(
    {
      card <- session$userData$game_cards()[
        session$userData$current_card_idx(),
      ]

      img_path <- paste0(
        "./media/",
        card$filename
      )

      print(img_path)

      list(
        src = img_path,
        contentType = 'image/jpg',
        alt = "Identiy this!",
        width = "100%"
      )
    },
    deleteFile = FALSE,
  )

  # scoreboard
  output$score <- renderText({
    session$userData$num_tries()
    session$userData$num_success()
    # num_game_cards
    card_nav <- paste0(session$userData$current_card_idx(), "/", num_game_cards)
    attempts <- paste0(session$userData$num_tries(), " attempts")
    success <- paste0(session$userData$num_success(), " sucessful IDs")
    forfeit <- paste0(session$userData$num_forfeit(), " forfeit cards")
    return(paste(card_nav, attempts, success, forfeit, sep = "<br/>"))
  })

  output$cardStatus <- renderText({
    card <- session$userData$game_cards()[session$userData$current_card_idx(), ]

    if (card$is_forfeit == TRUE) {
      return(paste("❌</br>", card$scientific_name))
    }

    if (is.na(card$correct_guess)) {
      return("?")
    }

    if (card$correct_guess == TRUE) {
      return(paste("⭐</br>", card$scientific_name))
    }

    if (card$correct_guess == FALSE) {
      return("❌</br>🙅")
    }
  })

  # plot canada map with card coordinate
  output$map <- renderPlot(
    {
      card <- session$userData$game_cards()[
        session$userData$current_card_idx(),
      ]
      # point for image
      pos <- st_sfc(
        st_point(c(card$start_longitude, card$start_latitude)),
        crs = 4326
      )
      pos_3348 <- st_transform(pos, crs = 3348)

      par(mar = c(1, 1, 1, 1))

      # $ white   : chr "#000000 !default"
      # $ gray-100: chr "#1A1A1A !default"
      # $ gray-200: chr "#333333 !default"
      # $ gray-300: chr "#4C4C4C !default"
      # $ gray-400: chr "#666666 !default"
      # $ gray-500: chr "#808080 !default"
      # $ gray-600: chr "#999999 !default"
      # $ gray-700: chr "#B2B2B2 !default"
      # $ gray-800: chr "#CCCCCC !default"
      # $ gray-900: chr "#E6E6E6 !default"
      # $ black   : chr "#FFFFFF !default"
      # current_theme <- bslib::bs_current_theme()
      # primary_hex <- bslib::bs_get_variables(current_theme, "primary")
      # grey_hex <- bslib::bs_get_variables(current_theme, "gray-500")

      # map of Canada
      plot(
        st_geometry(canada_3348),
        col = "#808080",
        border = "#808080",
        axes = FALSE,
        bg = "transparent"
      )

      abline(
        h = st_coordinates(pos_3348)[2],
        v = st_coordinates(pos_3348)[1],
        col = "purple",
        lwd = 2,
        lty = "dashed"
      )

      points(
        st_geometry(pos_3348),
        col = "purple",
        cex = 6.0,
        type = "p"
      )

      points(
        st_geometry(pos_3348),
        col = "purple",
        cex = 2.0,
        pch = 20
      )
    },
    bg = "transparent"
  )
}
