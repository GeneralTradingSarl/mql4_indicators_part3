//+------------------------------------------------------------------+
//|                                       MovingAverage Steigung.mq4 |
//|                                 Copyright © 2010, Thomas Quester |
//|                                                 www.olfolders.de |
//+------------------------------------------------------------------+

// mad = Moving Average Delta
#property copyright "Copyright © 2010, Thomas Quester"
#property link      "www.olfolders.de"

#property indicator_separate_window

#property indicator_buffers 1
#property indicator_color1 Red
//---- input parameters
extern int       Periode=50;
//---- buffers
double ExtMapBuffer1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   int i;
   int col;
   string name;
   double p,d;
   double a,b,c;
   
   
   //p = iMA(NULL,0,Periode,0,MODE_SMMA,PRICE_MEDIAN,Bars-counted_bars);
   
   for (i=Bars;i>0;i--)
   {
       d = iMA(NULL,0,Periode,0,MODE_SMA,PRICE_OPEN,i-1);
       //p = iMA(NULL,0,Periode,0,MODE_SMA,PRICE_OPEN,i);
       ExtMapBuffer1[i-1] = (d-p)/Point;
      
       p=d;
   }
   
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

