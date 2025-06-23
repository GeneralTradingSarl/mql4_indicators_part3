//+------------------------------------------------------------------+
//|                                              spread_on_chart.mq4 |
//|                                    Copyright © 2010, Forexometer |
//|                                       http://www.forexometer.com |
//|                                           master@forexometer.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, Forexometer"
#property link      "http://www.forexometer.com"

#property indicator_chart_window

extern string  _1="// --- Place settings ---";
extern int     Corner=0;
extern string  Corner_tips="// 0 - upper left, 1 - upper right, 2 - lower left, 3 - lower right";
extern int     XMargin=7;
extern int     YMargin=12;
extern string  _2="// --- Font settings ---";
extern string  Font="Arial";
extern color   Color=DarkOrange;
extern int     Size=8;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   if((Corner==1 || Corner==3) && XMargin<1)  XMargin=1;
   if(XMargin<0)  XMargin=0;

   if(Corner>1 && YMargin<1)  YMargin=1;
   if(YMargin<0)  YMargin=0;

   ObjectCreate("spread",     OBJ_LABEL, 0, 0, 0);
   ObjectSet(   "spread",     OBJPROP_CORNER,   Corner);
   ObjectSet(   "spread",     OBJPROP_XDISTANCE,XMargin);
   ObjectSet(   "spread",     OBJPROP_YDISTANCE,YMargin);
   
   ObjectCreate("stoplevel",  OBJ_LABEL, 0, 0, 0);
   ObjectSet(   "stoplevel",  OBJPROP_CORNER,   Corner);
   ObjectSet(   "stoplevel",  OBJPROP_XDISTANCE,XMargin);
   ObjectSet(   "stoplevel",  OBJPROP_YDISTANCE,YMargin+1.5*Size);
   
   ObjectCreate("freezelevel",OBJ_LABEL, 0, 0, 0);
   ObjectSet(   "freezelevel",OBJPROP_CORNER,   Corner);
   ObjectSet(   "freezelevel",OBJPROP_XDISTANCE,XMargin);
   ObjectSet(   "freezelevel",OBJPROP_YDISTANCE,YMargin+3*Size);

   return(0);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
   ObjectDelete("spread");
   ObjectDelete("stoplevel");
   ObjectDelete("freezelevel");

   return(0);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   ObjectSetText("spread",     "spread = "      +DoubleToStr(MarketInfo(Symbol(),MODE_SPREAD),1),     Size,Font,Color);
   ObjectSetText("stoplevel",  "stop level = "  +DoubleToStr(MarketInfo(Symbol(),MODE_STOPLEVEL),1),  Size,Font,Color);
   ObjectSetText("freezelevel","freeze level = "+DoubleToStr(MarketInfo(Symbol(),MODE_FREEZELEVEL),1),Size,Font,Color);

   return(0);
}
//+------------------------------------------------------------------+

