//+------------------------------------------------------------------+
//|                                                  spread swap.mq4 |
//|                      Copyright © 2007, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
#property indicator_separate_window
//----
double    swaplong,swapshort;
int spread;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  int init()
  {
   IndicatorShortName("spread/swap monitor ("+Symbol()+")");
//----
  return(0);}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
   {
      return(0);
   }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   spread=MarketInfo(Symbol(),13);
   swaplong=NormalizeDouble(MarketInfo(Symbol(),18),2);
   swapshort=NormalizeDouble(MarketInfo(Symbol(),19),2);
//----
   ObjectCreate("spread/swap monitor1", OBJ_LABEL, WindowFind("spread/swap monitor ("+Symbol()+")"), 0, 0);
   ObjectSetText("spread/swap monitor1","Current Spread :", 9, "Arial Black", Gold);
   ObjectSet("spread/swap monitor", OBJPROP_CORNER, 0);
   ObjectSet("spread/swap monitor1", OBJPROP_XDISTANCE, 200);
   ObjectSet("spread/swap monitor1", OBJPROP_YDISTANCE, 2);
//----
   ObjectCreate("spread/swap monitor2", OBJ_LABEL, WindowFind("spread/swap monitor ("+Symbol()+")"), 0, 0);
   ObjectSetText("spread/swap monitor2",DoubleToStr(spread ,0),9, "Arial Black", Gold);
   ObjectSet("spread/swap monitor2", OBJPROP_CORNER, 0);
   ObjectSet("spread/swap monitor2", OBJPROP_XDISTANCE, 320);
   ObjectSet("spread/swap monitor2", OBJPROP_YDISTANCE, 2);
//----
   ObjectCreate("spread/swap monitor3", OBJ_LABEL, WindowFind("spread/swap monitor ("+Symbol()+")"), 0, 0);
   ObjectSetText("spread/swap monitor3","Buy Swap :", 9, "Arial Black", Blue);
   ObjectSet("spread/swap monitor3", OBJPROP_CORNER, 0);
   ObjectSet("spread/swap monitor3", OBJPROP_XDISTANCE, 470);
   ObjectSet("spread/swap monitor3", OBJPROP_YDISTANCE, 2);
//----
   ObjectCreate("spread/swap monitor4", OBJ_LABEL, WindowFind("spread/swap monitor ("+Symbol()+")"), 0, 0);
   ObjectSetText("spread/swap monitor4",DoubleToStr( swaplong ,2),9, "Arial Black", Blue);
   ObjectSet("spread/swap monitor4", OBJPROP_CORNER, 0);
   ObjectSet("spread/swap monitor4", OBJPROP_XDISTANCE, 550);
   ObjectSet("spread/swap monitor4", OBJPROP_YDISTANCE, 2);
//----
   ObjectCreate("spread/swap monitor5", OBJ_LABEL, WindowFind("spread/swap monitor ("+Symbol()+")"), 0, 0);
   ObjectSetText("spread/swap monitor5","Sell Swap :", 9, "Arial Black", Red);
   ObjectSet("spread/swap monitor5", OBJPROP_CORNER, 0);
   ObjectSet("spread/swap monitor5", OBJPROP_XDISTANCE, 660);
   ObjectSet("spread/swap monitor5", OBJPROP_YDISTANCE, 2);
//----
   ObjectCreate("spread/swap monitor6", OBJ_LABEL, WindowFind("spread/swap monitor ("+Symbol()+")"), 0, 0);
   ObjectSetText("spread/swap monitor6",DoubleToStr( swapshort ,2),9, "Arial Black", Red);
   ObjectSet("spread/swap monitor6", OBJPROP_CORNER, 0);
   ObjectSet("spread/swap monitor6", OBJPROP_XDISTANCE, 740);
   ObjectSet("spread/swap monitor6", OBJPROP_YDISTANCE, 2);
//----
   return(0);
  }
//+------------------------------------------------------------------+