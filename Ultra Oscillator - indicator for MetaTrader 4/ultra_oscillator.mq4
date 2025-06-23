//+------------------------------------------------------------------+
//|                                             Ultra Oscillator.mq4 |
//|                                               Yuriy Tokman (YTG) |
//|                                               http://ytg.com.ua/ |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman (YTG)"
#property link      "http://ytg.com.ua/"
#property version   "1.00"
#property strict
#property indicator_separate_window
//---
#property indicator_buffers 1
#property indicator_color1 Green
//---
double B0[];
int shift_begin=28;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   IndicatorShortName("Ultra Oscillator");
   SetIndexBuffer(0,B0);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexDrawBegin(0,shift_begin);
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
   int limit=rates_total-prev_calculated;
   if(prev_calculated==0)limit--;
   else  limit++;
//---
   for(int i=0; i<limit && !IsStopped(); i++)
      B0[i]=iMA(Symbol(),0,7,0,MODE_LWMA,PRICE_CLOSE,i)+
            iMA(Symbol(),0,14,0,MODE_LWMA,PRICE_CLOSE,i)+
            iMA(Symbol(),0,28,0,MODE_LWMA,PRICE_CLOSE,i);
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
