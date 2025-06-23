//+------------------------------------------------------------------+
//|                                             PriceQtIndicator.mq4 |
//|                                                             linx |
//|                             https://login.mql5.com/en/users/linx |
//+------------------------------------------------------------------+
#property copyright "linx"
#property link      "https://login.mql5.com/en/users/linx"

string symbol;
int handle;

#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   symbol = Symbol();
   
   handle=FileOpen(symbol+"_tick.csv", FILE_CSV|FILE_WRITE,',');
   if (handle>0)
      FileWrite(handle, "datatime", "open", "high", "low", "close", "volume");
   else
      Alert("Failed to open data file. Please check if you have write priviledge!");

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   if (handle>0)
      FileClose(handle);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   //int    counted_bars=IndicatorCounted();
//----
   if (handle>0) {
      FileWrite(handle,iTime(symbol,PERIOD_M1,0), iOpen(symbol,PERIOD_M1,0),
                       iHigh(symbol,PERIOD_M1,0), iLow(symbol,PERIOD_M1,0),
                       iClose(symbol,PERIOD_M1,0), iVolume(symbol,PERIOD_M1,0));
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+