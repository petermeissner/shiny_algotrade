
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output, session) {

  output$tsplot <- renderPlot({
    
    # filter data
    data_store  <- get_data(fname = input$files)
    iffer       <- data_store$name==input$stock
    tmp         <- data_store[iffer, ]
    
    price_mid   <- mean(tmp$price)
    price_min   <- min(tmp$price)
    price_max   <- max(tmp$price)
    
    time_min    <- min(tmp$timestamp)
    time_max    <- max(tmp$timestamp)
    time_breaks <- as.POSIXct(round(seq(time_min-60*60, time_max+60*60, "hour"), "hour"))
    time_labels <- format(time_breaks, "%H:%M")
    
    ggplot(
      tmp, 
      aes(
        x=timestamp, 
        y=price-mean(price), 
        fill=price-mean(price)
      )
    ) +
      geom_bar(stat = "identity", position = "dodge") +
      scale_y_continuous(
        breaks = c(price_min-price_mid,0, price_max-price_mid), 
        labels = round(c(price_min, price_mid, price_max), 2) 
      ) +
      scale_x_datetime(breaks = time_breaks, labels=time_labels) +
      scale_fill_gradient2(low="red", high="green", mid="yellow") +
      theme_solarized(light=FALSE) +
      theme(legend.position="none") +
      ggtitle(input$stock) +
      labs(
        list(title = input$stock, y = "price", x = "time of the day")
      ) +
      geom_hline(yintercept=0, color="#ebebeb")
  }
  #, bg="transparent"
  )
  
  output$botplot <- renderPlot({
    bot      <- input$botselection
    stock    <- input$stock
    fname    <- input$files

    bot_data <- get_data(fname)
    bot_data <- bot_data[bot_data$name==stock,]

    bot_data <- run_bot(bot_data, get(bot, bots_store))

    tmp      <- bot_data$aggregate
    ind      <- do.call(rbind, bot_data$decissions)
    par      <- ind[ind$name==stock,]

    value_mid   <- 0
    value_min   <- -max(abs(range(tmp$value)))
    value_max   <- max(abs(range(tmp$value)))

    time_min    <- min(tmp$timestamp)
    time_max    <- max(tmp$timestamp)
    time_breaks <- as.POSIXct(round(seq(time_min-60*60, time_max+60*60, "hour"), "hour"))
    time_labels <- format(time_breaks, "%H:%M")

    end_labels  <- round(tmp$value,2)
    end_labels[!(end_labels %in% c(max(end_labels), min(end_labels), tail(end_labels,1)) )] <- ""
    end_labels[duplicated(end_labels)] <- ""

    ggplot() +
      geom_line(data=tmp, aes(x=timestamps, y=value, color=value)) +
      geom_text(data=tmp, aes(x=timestamps, y=value, color=value), label=end_labels, nudge_x = diff(range(as.numeric(tmp$timestamps)))/20 , nudge_y = diff(range(tmp$value))/50 )+
      ylim(value_min,value_max)+
      scale_x_datetime(breaks = time_breaks, labels=time_labels) +
      scale_color_gradient2(low="red", high="green", mid="yellow") +
      theme_solarized(light=FALSE) +
      theme(legend.position="none") +
      labs(
        list(title = input$botselection, y = "Aktienwert + Geld", x = "Uhrzeit")
      ) +
      geom_hline(yintercept=0, color="#ebebeb")

  })  
  
  observe({
    updateAceEditor(
      session, 
      editorId = "botcode", 
      value = show_bot_definition(input$botselection, bots_store), 
      mode="r", 
      theme="solarized_dark"
    )
  })
  
  observe({
    input$eval
    tmp <- try(isolate(eval(parse(text=input$manual_bot_ace))))
    updateSelectInput(
      session,
      inputId = "botselection",  
      choices = ls(bots_store)
    )
    return(tmp)
  })  
  
  
  
})
