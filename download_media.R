#  make sure the link actually contains the thumbnail,
download_image_thumbnail <- function(andes_base_url, local_fname, andes_fname) {
  library(httr2)

  img_url <- paste0(andes_base_url, "media/images/", andes_fname)

  req <- httr2::request(img_url)
  res <- httr2::req_perform(req, path = local_fname)

  if (res$status_code != 200) {
    warning(paste0("was not able to download ", img_url))
  }
}


download_deck_media <- function(deck, andes_base_url) {
  for (image_file in deck$filename) {
    print(paste0("downloading ", image_file))
    local_filename <- paste0("./media/", image_file)

    # construct andes filename
    #  example. "http://<ANDES_BASE_URL>/media/images/3e7dfa65-293a-348c-aa92-ce646ee303f5__image_THUMBNAIL.jpg"

    andes_fname <- stringr::str_split_i(image_file, "/", i = -1)
    andes_fname <- paste0("/media/images/", andes_fname)

    if (!file.exists(local_filename)) {
      download_image_thumbnail(andes_base_url, local_filename, andes_fname)
    } else {
      print(paste0("Found ", local_filename, " skipping download!"))
    }
  }
}
