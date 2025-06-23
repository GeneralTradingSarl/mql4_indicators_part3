//+------------------------------------------------------------------+
//|                                               Time indicator.mq4 |
//|                            Copyright © 2013, www.FxAutomated.com |
//|                                       http://www.FxAutomated.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2013, www.FxAutomated.com"
#property link      "http://www.FxAutomated.com"

#property indicator_chart_window

extern color BrokerTimeColor=Red;
extern color ComputerTimeColor=Lime;
extern int   DistanceFromTopLeft=10;
extern double ZoomLevel=1;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   ObjectCreate("Label_bt", OBJ_LABEL, 0, 0, 0);  // Creating obj.
   ObjectSet("Label_bt", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_bt", OBJPROP_XDISTANCE, DistanceFromTopLeft*ZoomLevel);// X coordinate   
   ObjectSet("Label_bt", OBJPROP_YDISTANCE, 30*ZoomLevel);// Y coordinate

   ObjectCreate("Label_ct", OBJ_LABEL, 0, 0, 0);  // Creating obj.
   ObjectSet("Label_ct", OBJPROP_CORNER, 0);    // Reference corner
   ObjectSet("Label_ct", OBJPROP_XDISTANCE, DistanceFromTopLeft*ZoomLevel);// X coordinate   
   ObjectSet("Label_ct", OBJPROP_YDISTANCE, 60*ZoomLevel);// Y coordinate

//----
   return(0);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
  
//----
   ObjectSetText("Label_bt",TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS),20*ZoomLevel,"Arial",BrokerTimeColor);
   ObjectSetText("Label_ct",TimeToStr(TimeLocal(),TIME_DATE|TIME_SECONDS),20*ZoomLevel,"Arial",ComputerTimeColor);
//----
   return(0);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete("Label_bt");
   ObjectDelete("Label_ct");
//----
   return(0);
  }