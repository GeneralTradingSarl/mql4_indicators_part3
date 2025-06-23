//+------------------------------------------------------------------+
//|                                                          TMA.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//| Converted to post 2014 new build code:                           |
//| file45 - https://www.mql5.com/en/users/file45/publications       |
//+------------------------------------------------------------------+
#property copyright "mladen"
#property link      "www.forex-tsd.com"
#property indicator_chart_window
#property version   "1.00"
#property description "Draws a Triangular Moving Average on chart." 
#property strict
#property indicator_chart_window
//---
#property indicator_buffers 1
#property indicator_color1 DodgerBlue
#property indicator_width1  2
//---
input int Length =89;
input int Shift  = 0;
input ENUM_APPLIED_PRICE Price=PRICE_CLOSE;
//---
double buffer1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   SetIndexBuffer(0,buffer1); SetIndexShift(0,Shift);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars < 0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=MathMin(Bars-counted_bars,Bars-1);
//---
   for(int i=limit; i>=0; i--)
      buffer1[i]=iTma(iMA(NULL,0,1,0,MODE_SMA,Price,i),Length,i);
//---
   return(rates_total);
  }
//---
double workTma[][1];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double iTma(double price,double period,int r,int instanceNo=0)
  {
   if(ArrayRange(workTma,0)!=Bars) ArrayResize(workTma,Bars); r=Bars-r-1;
//---
   workTma[r][instanceNo]=price;
//---
   double half = (period+1.0)/2.0;
   double sum  = price;
   double sumw = 1;
//---
   for(int k=1; k<period && (r-k)>=0; k++)
     {
      double weight=k+1; if(weight>half) weight=period-k;
      sumw  += weight;
      sum   += weight*workTma[r-k][instanceNo];
     }
   return(sum/sumw);
  }
//+------------------------------------------------------------------+
