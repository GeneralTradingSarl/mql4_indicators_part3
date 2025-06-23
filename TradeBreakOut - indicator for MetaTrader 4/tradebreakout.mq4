//+------------------------------------------------------------------+
//|                                                TradeBreakOut.mq4 |
//|                                  Copyright © 2013, Andriy Moraru |
//+------------------------------------------------------------------+
#property copyright ""
#property link      "http://www.earnforex.com"
/*
Red line crossing 0 from above is a support breakout signal.
Green line crossing 0 from below is a resistance breakout signal.
*/
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_width1 1
#property indicator_color1 Green
#property indicator_color2 Red
//---
extern int L=50; // Period
extern int PriceType=1; // 0 - Close, 1 - High/Low
//--- Buffers
double TBR_R[],TBR_S[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(2);
   SetIndexBuffer(0,TBR_R);
   SetIndexBuffer(1,TBR_S);
//---
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,1);
//---
   SetIndexDrawBegin(0,L);
   SetIndexDrawBegin(1,L);
//---
   SetIndexEmptyValue(0,EMPTY_VALUE);
   SetIndexEmptyValue(1,EMPTY_VALUE);
//---
   IndicatorDigits(Digits);
//---
   IndicatorShortName("TBR("+L+")");
//---
   return(0);
  }
//+------------------------------------------------------------------+
//| TradeBreakOut                                                    |
//+------------------------------------------------------------------+
int start()
  {
   if(Bars <= L) return(0);
//---
   int counted_bars=IndicatorCounted();
   if(counted_bars>0) counted_bars--;
//--- Skip calculated bars
   int end=Bars-counted_bars;
//--- Cannot calculate bars that are too close to the end. There won't be enough bars to calculate ArrayMin/Max
   if(Bars-end<=L) end=Bars -(L+1);
//---
   for(int i=0; i<end; i++)
     {
      if(PriceType==0) // Close
        {
         TBR_R[i] = (Close[i] - Close[ArrayMaximum(Close, L, i + 1)]) / Close[ArrayMaximum(Close, L, i + 1)];
         TBR_S[i] = (Close[i] - Close[ArrayMinimum(Close, L, i + 1)]) / Close[ArrayMinimum(Close, L, i + 1)];
        }
      else if(PriceType==1) // High/Low
        {
         TBR_R[i] = (High[i] - High[ArrayMaximum(High, L, i + 1)]) / High[ArrayMaximum(High, L, i + 1)];
         TBR_S[i] = (Low[i] - Low[ArrayMinimum(Low, L, i + 1)]) / Low[ArrayMinimum(Low, L, i + 1)];
        }
     }
//---
   return(0);
  }
//+------------------------------------------------------------------+
