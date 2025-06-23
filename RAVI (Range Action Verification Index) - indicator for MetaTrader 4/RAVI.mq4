//+------------------------------------------------------------------+
//|                                                         RAVI.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//----
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red
//---- indicator parameters 
extern int Period1=7;
extern int Period2=65;
//---- buffers 
double ExtBuffer[];
//+------------------------------------------------------------------+ 
//| Custom indicator initialization function                         | 
//+------------------------------------------------------------------+ 
int init()
  {
//---- indicators 
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtBuffer);
   IndicatorShortName("RAVI (" + (string)Period1+ ","+(string)Period2+")");
//---- 
   return(0);
  }
//+------------------------------------------------------------------+ 
//| Custor indicator deinitialization function                       | 
//+------------------------------------------------------------------+ 
int deinit()
  {
//---- TODO: add your code here 
//---- 
   return(0);
  }
//+------------------------------------------------------------------+ 
//| Custom indicator iteration function                              | 
//+------------------------------------------------------------------+ 
int start()
  {
   int counted_bars=IndicatorCounted();
   int limit = Bars - counted_bars;
   int shift=0;
    if(counted_bars==0)
      limit-=Period2;
   //---
   double SMA1,SMA2,result;
//---- TODO: add your code here 
   PrintFormat("counted_bars=%d Bars=%d",counted_bars,Bars);
   for(shift=limit;shift>=0;shift--)
     {
      SMA1=iMA(NULL,0,Period1,0,MODE_SMA,PRICE_CLOSE,shift);
      SMA2=iMA(NULL,0,Period2,0,MODE_SMA,PRICE_CLOSE,shift);
      PrintFormat("shift=%d SMA1 = %f SMA2 = %f",shift,SMA1,SMA2);
      result=((SMA1-SMA2)/SMA2)*100;
      ExtBuffer[shift]=result;
     }
//---- 
   return(0);
  }
//+------------------------------------------------------------------+ 

