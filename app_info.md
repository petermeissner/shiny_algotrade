# app info


This app shows ***stock prices*** for DAX companies, ***runs bots*** (algorithms) on the data and ***visualizes*** their performance. Furthermore, the app allows to manually add bots to be run on the data. The data itself is collected by a webbot on an external server that scrapes the DAX info page at [Boerse Frankfurt](http://en.boerse-frankfurt.de/equities/realtime-quotes).


# bot simulation

The simulation environment for the bots is held very very simple. 
One simulation run is for one bot on one day only. 

For a given time point the bot knows the following measures as well as their history for the given day up to the current time point:

- name of the company for which to buy and sell shares (`name`)
- ISIN of the company for which to buy and sell shares (`id`)
- the maximum number of time points to process (`I`)
- the current time point (`i`)
- the current timestamp (`timestamp`)
- price of one share (`price`)
- ask price of one share (`ask_price`)
- bid price of one share (`bid_price`)
- last days price of one share (`price_last_day`)
- the decision (buy, sell, keep) returned by the bot at previous time points (`decision`)
- the decision really executed on behalf of the bot (`decision_clean`)
- the effect the decision had on the money balance (`effect`)
- how many shares the bot holds of a certain company (`shares`)
- the amount of money (positive or negative) the bot holds (`money`)


Given that data, the bot is expected to return one of the following:

- `"buy"` - the bot will buy one share for the current bid price (on the last time point the bot is forced to sell all shares independent of her decision)
- `"sell"` - the bot will sell all shares for the current ask price (if the bot owns no shares this will be sanatized to `"keep"`)
- `"keep"` - neither are shares bought nor sold (on the last time point the bot is forced to sell all shares  independent of her decision)


<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>

