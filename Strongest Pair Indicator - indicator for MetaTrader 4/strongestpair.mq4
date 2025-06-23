//+------------------------------------------------------------------+
//|                                                StrongestPair.mq4 |
//|                                          Copyright 2023,JBlanked |
//|                                  https://www.github.com/jblanked |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023,JBlanked"
#property link      "https://www.thehyenahut.com/request-custom-bots/"
#property description "This will return the pair with the most growth in the user input start time and end time"
#property strict
#property indicator_chart_window

input datetime time_to_start = D'2023.04.26 00:00'; // Start time
input datetime time_to_stop = D'2023.04.28 16:00'; // Stop time

enum which_message
  {
   comment = 0, // Comment
   print = 1, // Print
   alert = 2, // Alert
   phone = 3, // Phone
   email = 4, // Email
   all = 5, // All
  };

input which_message message_type = print; // Message Type
input ENUM_TIMEFRAMES timeframe_to_send = PERIOD_M1; // Send Message Each X
string message; // initialized variable to change later

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {

// notification to inform users where to contact me at
   Print("Indicator started! GO to https://www.thehyenahut.com/request-custom-bots/ for more bots");
//---
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
// final message to send (currency pair and the growth)
   message = (StrongestPair(time_to_start, time_to_stop,"Pair") + " has grown the most by " + StrongestPair(time_to_start, time_to_stop,"Growth") + "%");
//---
   datetime message_time = iTime(_Symbol,timeframe_to_send,0); // start of the desired candle/timeframe
   datetime current_time = TimeCurrent(); // current time

// if current time is the start of the desired candle/timeframe
   if(current_time == message_time)
     {

      switch(message_type) // get the message type
        {

         // send comment if its a comment
         case comment:
            Comment(message);
            break;

         // print if its print
         case print:
            Print(message);
            break;

         // send alert if its a alert
         case alert:
            Alert(message);
            break;

         // send phone alert if its a phone alert
         case phone:
            SendNotification(message);
            break;

         // send email if its a email
         case email:
            SendMail("Strongest Pair report",message);
            break;

         // send all if its a all
         case all:
            Comment(message);
            Print(message);
            Alert(message);
            SendNotification(message);
            SendMail("Strongest Pair report",message);
            break;


        }

     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }


//+------------------------------------------------------------------+
//|    Returns the strongest growth pair                             |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string StrongestPair(datetime start_time, datetime stop_time, string pair_or_growth)
  {
   string currency_pair = ""; // empty variable to change later
   double most_growth_percent = 0; // empty variable to change later

   for(int i = 0; i < SymbolsTotal(true); i++) // loop through symbols available in terminal
     {
      string current_symbol = SymbolName(i, true); // get current symbol name

      int stop_candle = iBarShift(current_symbol, PERIOD_M1, stop_time); // get the candle shift for stop candle
      int start_candle = iBarShift(current_symbol, PERIOD_M1, start_time); // get the candle shift for start candle

      double ending_price = iClose(current_symbol, PERIOD_M1, stop_candle); // current price
      double starting_price = iOpen(current_symbol, PERIOD_M1, start_candle); // starting price

      double growth = Division((ending_price - starting_price), starting_price) * 100; // growth as a percent

      if(growth > most_growth_percent) // if current pair's growth is greater than current highest
        {
         currency_pair = current_symbol; // current pair is the highest pair
         most_growth_percent = growth; // current growth is the highest growth
        }
     }

// ternary operator to return Pair if user input is pair, or growth if user input is groqth
   return pair_or_growth == "Pair" ? currency_pair : DoubleToStr(most_growth_percent,3);
  }

//+------------------------------------------------------------------+
//|    Function to divide in case of 0s                             |
//+------------------------------------------------------------------+
double Division(double numerator, double denominator)
  {
// ternary operator to divide unless the denominator equals 0
   return denominator == 0 ? 0 : (numerator / denominator);
  }

//+------------------------------------------------------------------+
//|      Function to convert time into string                        |
//+------------------------------------------------------------------+
datetime StringToTimeFix(string time) // replaces MQL5's StringToTime function'
  {
   MqlDateTime day; // define today as a datetime object
   TimeCurrent(day); // grab the current date's info

// Find the position of ":"
   int colon_position = StringFind(time, ":");
   if(colon_position < 0)  // if there are none in the input
     {
      Print("Error: Invalid time format"); // print an error
      return 0; // return 0
     }

// Extract hour and minute substrings
   string hourStr = StringSubstr(time, 0, colon_position); // find hour
   string minuteStr = StringSubstr(time, colon_position + 1); // find minute

   int hour = (int)StringToInteger(hourStr); // set hour as an integer
   int minute = (int)StringToInteger(minuteStr); // set minutes as an integer

   day.hour = hour; // set the hour to today's hours
   day.min = minute; // set the minutes to today's minutes
   day.sec = 0; // set seconds to 0

   datetime date = StructToTime(day); // convert MqlDateTime back to datetime

   return date; // return user input's time as the hour, minutes, and seconds set to 0
  }
//+------------------------------------------------------------------+
