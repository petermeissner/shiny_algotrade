
# function retrieving data and adding it to the store
get_data <- function(fname=NULL){
  
  # processing inputs
  if( is.null(fname) ){
    fname <- "data_store.json"
  }
  if(is.numeric(fname)){
    if(fname < 0){
      fname <- get_file_list()[length(get_file_list())+fname]
    }else if (fname > 0){
      fname <- get_file_list()[fname]
    }else if(fname==0){
      fname <- "data_store.json"  
    }
  }
  
  # download page
  url = "http://46.165.219.173/stockdata/"
  url <- paste0(url, fname)
  message(url)
  data_store <- fromJSON(url)
  data_store <- data_store[!is.na(data_store$timestamp),]
  data_store <- data_store[!(data_store$timestamp=="-3600"),]
  
  # character to timestamp
  iffer <- grepl("-",data_store$timestamp)
  
  data_store$timestamp[iffer] <- 
    as.POSIXct(data_store$timestamp[iffer])
  
  data_store$timestamp <- 
    as.POSIXct(as.numeric(data_store$timestamp), origin="1970-01-01")
  
  # return
  return(
    data_store
  )  
}

# function for getting list of availible files
get_file_list <- function(){
  readLines("http://46.165.219.173/stockdata/ls")
}
 
# function for running bot and recording decisions and effects
run_bot_worker <- function(dat, bot, cache=TRUE, ...){
  hash <- paste("run_bot_worker", digest(dat, "xxhash32"), digest(bot, algo = "xxhash32"), sep="_")
  if(hash %in% ls(bot_store) & cache){
    dat <- get(hash, bot_store)
  }else{
    dat_length      <- length(dat[,1])
    
    dat$decision        <- rep(NA, dat_length)
    dat$decision_clean  <- rep(NA, dat_length)
    dat$effect          <- rep(NA, dat_length)
    dat$shares          <- rep(NA, dat_length)
    dat$money           <- rep(NA, dat_length)
    
    dat$i <- seq_len(dat_length)
    dat$I <- dat_length
    
    for(i in seq_len(dat_length) ){
      shares_i <- ifelse(i==1, 0, dat$shares[i-1])
      dat$decision[i] <- bot(dat[1:i,], ...)
      if(i==dat_length){
        dat$decision_clean[i] <- "sell"
      }else{
        dat$decision_clean[i] <- dat$decision[i]
      }
      dat$effect[i] <- 
        switch(
          dat$decision_clean[i],
          "sell" = dat$ask_price[i] * shares_i,
          "keep" = 0,
          "buy"  = -dat$bid_price[i]
        )
      dat$shares[i] <- 
        switch(
          dat$decision_clean[i],
          "sell" = 0,
          "keep" = shares_i,
          "buy"  = shares_i + 1
        )
      dat$money <- cumsum(dat$effect)
      dat$value   <- dat$money + dat$shares * dat$ask_price
      assign(hash, dat, envir = bot_store)
    }
  }
  return(dat)
}

# function running bots on all data
run_bot <- function(data_store, bot, cache=TRUE, ...){
  hash <- paste("run_bot", digest(data_store, "xxhash32"), digest(bot, algo = "xxhash32"), sep="_")
  if(hash %in% ls(bot_store) & cache){
    RES <- get(hash, bot_store)
  }else{
    DAT <- split(data_store, data_store$name)
    data <- lapply(DAT, run_bot_worker, bot=bot, cache=cache)
    res <- do.call(rbind, data)
    res <- res[order(res$timestamp, decreasing=TRUE),]
    
    timestamps <- sort(unique(res$timestamp))
    agg        <- data.frame(timestamps, shares=NA, value=NA, money=NA)
    for(i in seq_len(dim(agg)[1]) ){
      iffer <- res$timestamp <= timestamps[i]
      tmp <- res[iffer,]
      tmp <- tmp[!duplicated(tmp$name),]
      agg$shares[i]  <- sum(tmp$shares, na.rm = TRUE)
      agg$value[i]   <- sum(tmp$value, na.rm = TRUE)
      agg$money[i]   <- sum(tmp$money, na.rm = TRUE)
    }
    result <- agg[order(agg$timestamps, decreasing = TRUE),][1,]$money
    RES <- list(result=result, decissions=data, aggregate=agg)
    assign(hash, RES, bot_store)
  }
  invisible(RES)
}


#' make automatically named list 
#' 
#' ricardo: \link{http://stackoverflow.com/a/21059868/1144966}
named_list <- function(...){
  anonList <- list(...)
  names(anonList) <- as.character(substitute(list(...)))[-1]
  anonList
}


# bots
random_bot <- function(dat){
  sample(c("buy","sell","keep"), 1)
}

buy_bot <- function(dat){
  return("buy")
}

simple_bot <- function(dat){
  if( tail(dat$ask_price,2)[1]-tail(dat$ask_price,1) > 0  ){
    return("sell")
  }
  if( tail(dat$bid_price,1) < mean( tail(dat$ask_price,5) ) ){
    return("buy")
  }
  return("keep")
}


easy_bot <- function(dat){
  if( tail(dat$ask_price,1) > tail(dat$price_last_day,1)  ){
    return("sell")
  }else{
    return("buy")
  }
  return(keep)
}





# show bot definition
show_bot_definition <- function(botname, bots){
  paste0(
    "# bot definition: \n",
    botname, " <- ",
    paste0(
      try(deparse(get(botname, bots))), 
      collapse = "\n"
    ), 
    collapse = "\n"
  )
}



# proper lag and lead functions
lead <- function(x){
  c(x[2:length(x)], NA)[seq_len(length(x))]
}

lag <- function(x){
  c(NA, x[1:(length(x)-1)])[seq_len(length(x))]
}






