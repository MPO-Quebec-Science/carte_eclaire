source("./download_media.R")
source("./open_deck.R")
source("./make_special_deck.R")
source("./make_catch_list.R")

# create deck from mission
deck <- open_deck(deckname = "nGSL-2025")
andes_base_url <- "http://wgqciml9036141.ent.dfo-mpo.ca:25015/"
download_deck_media(deck, andes_base_url)


# create subset deck
make_fish_deck()

# create subset deck
make_invertabrate_deck()

# create subset deck
make_flatfish_deck()

# make a list of all observed catches (assumes updated taxonomy)
make_catch_list()
