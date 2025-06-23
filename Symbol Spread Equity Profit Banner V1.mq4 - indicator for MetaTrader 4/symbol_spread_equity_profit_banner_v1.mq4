//+------------------------------------------------------------------+
//|                       Symbol Spread Equity Profit Banner V1.mq4  |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+----------------------------------------------------------------------------------------------------+
//|A very simple Indicator banner showing Symbol Spread Equity Profit
//|I use it every day in full chart mode so I don't have to open the terminal panel to check equity,
//|and to see optimal spread to entry symbol trade. I consider it useful enough to share it with you.  
//+----------------------------------------------------------------------------------------------------+
#property copyright     "Copyright 2024, MetaQuotes Ltd."
#property link          "https://www.mql5.com"
#property version       "1.01"
#property description   "persinaru@gmail.com"
#property description   "IP 2024 - free open source"
#property description   "Symbol Spread Equity Profit Banner"
#property description   ""
#property description   "WARNING: Use this software at your own risk."
#property description   "The creator of this script cannot be held responsible for any damage or loss,"
#property description   "nor for happiness and euphoria on gains."
#property strict

#property indicator_chart_window
#property indicator_buffers 0



extern color LabelColor  = DarkGreen;

#define OBJ_NAME "Symbol Spread Equity Profit"

int init()
{
   ShowSpread();
      return(0);

}

int start()
{
   ShowSpread();
      return(0);
}

int deinit()
{
   ObjectDelete(OBJ_NAME);
   return(0);
}

void ShowSpread()
{
   static double spread = 00.00;
   
   spread = MarketInfo(Symbol(), MODE_SPREAD);

   
    
   DrawSpreadOnChart(spread/10);
}

void DrawSpreadOnChart(double spread)
{

   double bid = MarketInfo(Symbol(), MODE_BID);
   double equity = AccountEquity();
   double profit   = AccountEquity()-AccountBalance();


   string symbo = Symbol();

   string s =  " : "+DoubleToStr(spread, 1);
   
   
   if(ObjectFind(OBJ_NAME) < 0)
   {
      ObjectCreate(OBJ_NAME, OBJ_LABEL, 0, 0, 0);
      ObjectSet(OBJ_NAME, OBJPROP_CORNER, 1);
      ObjectSet(OBJ_NAME, OBJPROP_YDISTANCE, 12);
      ObjectSet(OBJ_NAME, OBJPROP_XDISTANCE, 3);
   

      ObjectSetText(OBJ_NAME, s, 20, "FixedSyss", LabelColor);
   }
   
   ObjectSetText(OBJ_NAME, symbo + s + " Equity " + DoubleToStr(equity, 2) + " Profit " + DoubleToStr(profit, 2));

   
   WindowRedraw();
}