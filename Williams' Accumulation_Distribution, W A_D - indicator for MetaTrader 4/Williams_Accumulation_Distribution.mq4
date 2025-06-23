//+------------------------------------------------------------------+
//|                          Williams' Accumulation/Distribution.mq4 |
//|                      Copyright © 2007, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//----
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 LightSeaGreen
//---- buffers
double ExtMapBuffer1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorShortName("W_A/D");
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
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   double AD,TRH,TRL;
   int  i,counted_bars=IndicatorCounted();
   uint start=GetTickCount();
//----
   i=Bars-counted_bars-1;
   if(counted_bars==0)
     {
      ExtMapBuffer1[i]=0;
      i--;
     }
   while(i>=0)
     {
      TRH = MathMax(High[i], Close[i+1]);
      TRL = MathMin(Low[i], Close[i+1]);
      if(Close[i]>Close[i+1]+Point)
         AD=Close[i]-TRL;
      else
      if(Close[i]<Close[i+1]-Point)
         AD=Close[i]-TRH;
      else
         AD=0;
      ExtMapBuffer1[i]=ExtMapBuffer1[i+1]+AD;
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
