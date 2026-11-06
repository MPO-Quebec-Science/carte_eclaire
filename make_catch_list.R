# concat all catches from all decks
# another idea is only to have choices from the deck itself
make_catch_list <- function() {
  # load all decks
  available_decks <- list.files("./decks/")
  # remove .csv from deck filename
  available_decks <- strsplit(available_decks, ".csv")

  monolithic_deck <- NULL

  for (deck_file in available_decks) {

    # skip the _intro_ deck
    if (deck_file != "_intro_") {
      deck <- open_deck(deck_file)
      deck <- subset(
        deck,
        select = c(
          "scientific_name",
          "strap_code",
          "common_name_en",
          "common_name_fr"
        )
      )
      monolithic_deck <- rbind(monolithic_deck, unique(deck))
      monolithic_deck <- unique(monolithic_deck)
    }
  }

  # concat all key columns into one string (to compare with deck card string)
  monolithic_deck$string <- paste(
    monolithic_deck$strap_code,
    monolithic_deck$scientific_name,
    monolithic_deck$common_name_en,
    monolithic_deck$common_name_fr
  )
  write.csv(monolithic_deck, file = "catch.csv", )
}
