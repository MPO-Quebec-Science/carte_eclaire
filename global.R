library(sf)

source("./open_deck.R")

# light <- bslib::bs_theme(version = 5, bootswatch = "yeti")
# dark <- bslib::bs_theme(
#   version = 5,
#   bg = "black",
#   fg = "white",
#   primary = "purple"
# )

available_decks <- list.files("./decks/")

# remove .csv from deck filename
available_decks <- strsplit(available_decks, ".csv")

catch <- read.csv("./catch.csv")

world <- sf::st_read(
    "./ne_110m_admin_0_countries/ne_110m_admin_0_countries.shp"
)
canada <- world[world$NAME == "Canada", ]
canada_3348 <- sf::st_transform(canada, crs = 3348)
world <- NULL
canada <- NULL
