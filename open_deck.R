open_deck <- function(deckname) {
  library(stringr)


  # add the folder and extension
  filename <- paste0("./decks/", deckname, ".csv")
  deck <- read.csv(filename)

  # concat all key columns into one string (to compare with catch string)
  deck$string <- paste(
    deck$strap_code,
    deck$scientific_name,
    deck$common_name_en,
    deck$common_name_fr
  )

  # flag to say if the guess is correct, NA or incorrect
  deck$correct_guess <- NA

  # flag to say if the the card is forfeited
  deck$is_forfeit <- FALSE

  return(deck)
}
