# why

I wrote this app for two reasons: (1) To showcase my fit for a position at [put company name here] (2) To finally have a reason to wrap my head as well as my guts and typing fingers around the shiny Shiny framework that buzzes around my head for some time, but managed to be unfit for whatever work or side project I had at hand. 


# first ideas

I started with ideas around something like an interactive CV with some small funny things, like a live histogram of the colors of an area of my picture under the mouse cursor. Another idea was to somehow use wikipedia page view data, since I have written one of the two packages to get those into R. Some time went into scraping, cleaning and visualizing data on the jobs of [put company name here]: The idea was to calculate string/word/text distances between the jobs at [put company name here] webpage and my own cover letter / cv. 

In the end I dismissed them all as too ME-centric and not appealing enough.


# building the app

The next idea was to go for a simple app that would **visualize stock data**. To make the app more appealing and fun this simple stock data visualization would be accompanied by **bots trading** on the data. 

The first step was to **get some data**. Initially, I though it would be very easy to get some hundred data points on stock market data (somthing live like if possible), but it turns out that there are no obvious near-real-time-stock-market-data-apis on the one hand and the obvious quantmod package failed the I-have-an-general-idea-of-how-it-works-within-five-minutes test, so I took some detour and put a scraper bot gathering data from [Boerse Frankfurt](http://en.boerse-frankfurt.de/equities/realtime-quotes) every 5 minutes. The app then retrieves a list of availible data and by default downloads data for the current date. With dataset for the current day this allows for **kind of realtime data** - approximatly with a 6 minutes lag. 

Equipped with some relevant data I could start building a basic **ggplot visualization** of the data. Along the way I decided that the app should be **dark themed**. Fortunate enough, there is a solarized-dark theme within the ggthemes package, which goes nicely with strong greens, yellows and reds for indicating positive and negative stock values. 

Next, the **Shiny theme** was tuned to the dark ggplot theme with a custom (bootstrap / bootswatch) CSS file and some manual adjustments. Maybe a little custom map (everybody loves maps and network graphs) showing Oststeinbeck? The Elbe and Hamburg harbor give a nice structure to headline the app. After fiddling around with static google maps and Paint/Gimp fo a while to get some nice colors and googling back and forth for an easy way to make simple custom maps, I re-discovered my mapbox account and got everything set up very nicely with just some clicks. 

Back to the app I did some research on stock prices and thought about how to implement the **bot simulation system**. I went for an implement-first-reorganize-later developement strategy. Basically a bot should be a function simply deciding to buy, keep or sell shares. This function then would be put into a system that feeds the bot data-snippets and records the bot's decisions and the effects on the bot's performance (making money). The first solution that came to my mind was using a loop for feeding different data snippets of one particular stock and using a wrapper function and lapply to let a bot run through all 30 stocks. Because this is not very fast, bot run **results are cached** depending on data and bot definition hashes. 

A bit of a challange was the idea to **allow for manually adding bots** while the app is running already. While the shinyAce package provides a superb way of having a full fledged text editor within a Shiny app, it complicates the app by factor 10. (1) I had to find a way of evaluating code. (2) This code had to affect data on which other parts of the UI and the server depend. (3) This change of data had to be recognized by UI and server. (4) A function's specific search lists had to be considered. A combination of using the **observe construct** within the server, the **update functions** to change UI elements and building a designated **change-data-function** with side effects, solved those problems. 

The rest was a simple re-organization of the UI by using tabsets to give it more structure and isolating unrelated parts from each other and writing up app info and development notes. 


# discussion 

I think that in general the app is a good proof-that-I-can-make-Shiny-apps, showing diverse points of my skillset and involving a diverse range of problems to be understood / solved working with the Shiny framework. 

The only things that I can think of at the moment from the Shiny-verse that I did not tab are conditional UI elements / **building UI on the fly** as well as **hosting shiny apps** on a server. In this application I see no use for the former. I thought about the latter, but decided that to host the app on my own server I would first have to overhaul the whole bot simulation part which would be beyond the aimed for proof-of-concept. 

**Given more time** I would improve four things about the app: (1) tweak stock data visualizations to center on ask price and bid price instead of only price; (2) overhaul the bot simulation system so that it is better structured and faster: stock market and bots could be implemented in an OO framework with bots and stockmarket passing information more explicit and being placed within a loop ticking through time; (3) relating to (2) the writing of manual bots could be made easier with a general bot class from which specific implementations could inherit from. (4) build up **a more perfomant bot** by first making a bot's decisions dependent on a large range of measures (price, differing lag prices, ask-bid-price-range and lags, global market developement, ... ) plus allowing those measures' importance to be tweaked by parameters that in turn are **optimized based on running simulations**. 


















<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
