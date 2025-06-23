//+------------------------------------------------------------------+
//|                                                         VROC.mq4 |
//|                      Copyright © 2007, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.ru/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.ru/"
//----
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 clrGreen
//---- input parameters
extern int PeriodROC=25;
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
   IndicatorShortName("VROC("+(string)PeriodROC+")");
   IndicatorDigits(2);
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
   int counted_bars=IndicatorCounted();
   int i,limit;
//----
   if(counted_bars==0)
      limit=Bars-PeriodROC;
   if(counted_bars>0)
      limit=Bars-counted_bars;
   limit--;
   for(i=limit; i>=0; i--)
      ExtMapBuffer1[i]=((double)Volume[i]-(double)Volume[i+PeriodROC])/(double)Volume[i+PeriodROC]*100;
//----
   return(0);
  }
//+------------------------------------------------------------------+
