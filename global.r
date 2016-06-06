#### packages ==================================================================

# needed
cran_packages <- c("jsonlite", "ggplot2", "ggthemes", "digest", "shinyAce", "markdown")
packages_not_installed <- cran_packages[!(cran_packages %in% installed.packages())]

# install
for(i in packages_not_installed){
  install.packages(i)
}

# loading
for(i in cran_packages){
  library(i, character.only = TRUE)
}



#### tools and helper functions ================================================

source("tools.R")



#### setting things up =========================================================

# global data
data_files <- get_file_list()              # availible data
data_store <- get_data(-1)                 # data to start with
bot_store  <- new.env(parent = emptyenv()) # cache for bot runs


bots_store <- new.env(parent = emptyenv()) # place to store bots
add_bot <- function(bot){
  botname <- as.character(as.list(match.call())$bot)
  assign(botname, bot, envir = bots_store)
}

add_bot(easy_bot)
add_bot(random_bot)


