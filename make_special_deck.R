make_fish_deck <- function() {
  # This deck borrows images from exisitng decks.
  # It uses the strap code value to determine if it is a fish

  # start empty
  deck <- data.frame()

  # append IML-2025-015, but just fishes
  temp_deck <- read.csv("./decks/nGSL-2025.csv")
  temp_deck <- temp_deck[temp_deck$strap_code < 990, ]
  deck <- rbind(deck, temp_deck)

  # save the deck
  write.csv(deck, file = "./decks/poissons.csv", row.names = FALSE)

  # # new deck is done, but need to copy images to it's own folder
  # # remove the images/ prefix
  # temp_deck$filename <- stringr::str_replace(temp_deck$filename, "images/", "")
  # temp_deck$filename <- stringr::str_replace(temp_deck$filename, ".jpg", "")

  # temp_deck$filename <- paste0(temp_deck$filename, "_THUMBNAIL.jpg")

  # # need ot make directory, 
  # # file.create("./media/poissons")

  # for (i in seq_along(temp_deck$filename)) {
  #   src_path <- paste0("./media/IML-2025-015/", temp_deck$filename[i])
  #   dst_path <- paste0("./media/poissons/", temp_deck$filename[i])
  #   file.copy(src_path, dst_path)
  # }

}



make_invertabrate_deck <- function() {
  # This deck borrows images from exisitng decks.
  # It uses the strap code value to determine if it is an invertebrate

  # start empty
  deck <- data.frame()

  # append IML-2025-015, but just invertabrates
  temp_deck <- read.csv("./decks/nGSL-2025.csv")
  temp_deck <- temp_deck[temp_deck$strap_code > 1100, ]
  deck <- rbind(deck, temp_deck)

  # save the deck
  write.csv(deck, file = "./decks/invertebres.csv", row.names = FALSE)

}


make_flatfish_deck <- function() {
  # start empty
  deck <- data.frame()

  strap_code_to_keep = c(882, 887, 889, 890, 891, 892, 893, 894, 895, 902, 907)
  # open fish deck (should contain different missions)
  temp_deck <- read.csv("./decks/poisson.csv")
  temp_deck <- temp_deck[temp_deck$strap_code %in% strap_code_to_keep, ]
  deck <- rbind(deck, temp_deck)

  # save the deck
  write.csv(deck, file = "./decks/poisson_plat.csv", row.names = FALSE)
}
