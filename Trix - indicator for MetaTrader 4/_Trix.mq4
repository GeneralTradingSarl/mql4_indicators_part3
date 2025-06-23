//+------------------------------------------------------------------+
//|                                                         Trix.mq4 |
//|                                       Copyright © 2006, systrad5 |
//|                                                         17/09/06 |
//|               Feedback or comments welcome at systrad5@yahoo.com |
//+------------------------------------------------------------------+
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red
//---- input parameters
extern int Depth = 16;
//---- buffers
double TrixBuf[];
double T1Buf[];
double T2Buf[];
double T3Buf[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(4);
//---- additional buffers
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, TrixBuf);
   SetIndexBuffer(1, T1Buf);
   SetIndexBuffer(2, T2Buf);
   SetIndexBuffer(3, T3Buf);
   //---- name for DataWindow and indicator subwindow label
   string short_name = "Trix(" + Depth + ")";
   IndicatorShortName(short_name);
   SetIndexLabel(0, short_name);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int i;
//----
   if(Bars <= Depth + 10) 
       return(0);
//---- last counted bar will be recounted
   int counted_bars = IndicatorCounted();
   int limit = Bars - counted_bars;
   if(counted_bars > 0) 
       limit++;
//-- The Trix Calc
   for(i = limit; i >= 0; i--)
       T1Buf[i] = iMA(NULL, 0, Depth, 0, MODE_EMA, PRICE_TYPICAL, i);
//----
   for(i = limit; i >= 0; i--)
       T2Buf[i] = iMAOnArray(T1Buf, 0, Depth, 0, MODE_EMA, i);
//----
   for(i = limit; i >= 0; i--)
       T3Buf[i] = iMAOnArray(T2Buf, 0, Depth, 0, MODE_EMA, i);
//----
   for(i = limit; i >= 0; i--)
     {
       if(T3Buf[i+1] != 0) 
           TrixBuf[i] = ((T3Buf[i] - T3Buf[i+1]) / T3Buf[i+1])*100;       
     }  
   return(0);
  }
//+------------------------------------------------------------------+

