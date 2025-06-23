//+------------------------------------------------------------------+
//|                                         KM-Strength Arrow v1.mq4 |
//|                                                  Khurram Mustafa |
//|                             https://www.mql5.com/en/users/kc1981 |
//+------------------------------------------------------------------+

#property copyright "KHURRAM MUSTAFA"
#property link      "https://www.mql5.com/en/users/kc1981/seller"
#property description "KM-Strength Arrow"
#property description "Recommended: Higher Time Frames"
#property version   "1.0"
#property strict
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_width1 0
#property indicator_width2 0
#property indicator_color1 Black
#property indicator_color2 Black
int rsiperiod = 5;
double buffy1[];
double buffy2[];
int cb = 0;
int bar ;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   int draw = 0;
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,233);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,234);
   SetIndexEmptyValue(0,0.0);
   SetIndexLabel(0,"Buy Now");
   SetIndexLabel(1,"Sell Now");
   SetIndexDrawBegin(0,draw);
   SetIndexDrawBegin(1,draw);
   SetIndexBuffer(0,buffy1);
   SetIndexBuffer(1,buffy2);
   return(0);
  }
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectsDeleteAll(0,OBJ_ARROW);
   return(0);
  }
//+------------------------------------------------------------------+
int start()
  {
   int IndicatorCounted = cb;
   if (bar == Time[0]) return(0);
   int x;
   if(Bars<=100) return(0);
   if (cb<0) return(-1);
   if (cb>0) cb--;
   x=Bars-cb;
   for(int i=0; i<x; i++)
   {
    double r1 = iRSI(NULL,0,rsiperiod,PRICE_CLOSE,i);
    double r2 = iRSI(NULL,0,rsiperiod,PRICE_CLOSE,i+1);
    if (r1>25 && r2<25)
    buffy1[i] = Low[i+1]-15*Point;
    
    if (r1<75 && r2>75)
    buffy2[i] = High[i+1]+15*Point;
      
   } 
   return(0);  
   }
//+------------------------------------------------------------------+
