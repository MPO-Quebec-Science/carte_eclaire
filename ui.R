library(shiny)
library(bslib)

ui <- bslib::page_fluid(
  bslib::input_dark_mode(id = "mode", mode = "dark"),

  titlePanel(NULL),

  sidebarLayout(
    sidebarPanel(
      # Input: Select game deck
      selectInput(
        inputId = "selectDeck",
        label = "Select the deck",
        selected = "intro",
        multiple = FALSE,
        choices = available_decks
      ),

      bslib::value_box(
        NULL,
        htmlOutput("cardStatus"),
      ),
      plotOutput("map", height = "200px"),

      selectInput(
        inputId = "guess",
        label = "Catch",
        choices = catch$string,
        width = "100%"
      ),

      actionButton("prevBtn", "prev"), #⬅️ <- ⬅

      actionButton("submitBtn", "OK"),

      actionButton("forfeitBtn", "🤷?"),

      actionButton("nextBtn", "next"), #➡️ ->

      htmlOutput("score"),

      # actionButton("reportBtn", "Report error")
    ),

    mainPanel(
      imageOutput("cardImage", width = "100%", height = "300px")
    )
  )
)
