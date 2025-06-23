//+------------------------------------------------------------------+
//|                                                QGFuturesPair.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1
//--- plot FuturesPairValue
#property indicator_label1  "FuturesPairValue"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrMidnightBlue
#property indicator_style1  STYLE_DOT
#property indicator_width1  3
//--- indicator buffers
double         FuturesPairValueBuffer[];

extern string Instrument1 = "US500.cash";
extern string Instrument2 = "US100.cash";
extern double Multiplier1 = 10;
extern double Multiplier2 = 2;
extern bool ChartDifference =  true;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,FuturesPairValueBuffer);
 
//
   return(0);
   
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
//---
int limit = rates_total - 1 - 100;//app bars requires
   if(prev_calculated > 0)
      limit = rates_total - prev_calculated + 1;

   for(int i = limit; i >= 0; i--)
     {
     if(ChartDifference)
         {
           FuturesPairValueBuffer[i] = (iClose(Instrument1,0,i)*Multiplier1)-(iClose(Instrument2,0,i)*Multiplier2);
         }
         else
         {
           FuturesPairValueBuffer[i] = (iClose(Instrument1,0,i)*Multiplier1)/(iClose(Instrument2,0,i)*Multiplier2);
         }
     }
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
