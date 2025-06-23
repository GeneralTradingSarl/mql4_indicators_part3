//--- Renko Time Indicator - time difference between candles / bricks / blocks
#property copyright "Copyright 2015, Paul Reed."
#property version   "2.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1  Blue
#property indicator_width1  2
#property indicator_minimum 0 // Set indicator fixed min is 0
double timebuffer[]; // Buffer to hold the array of time differences
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit(void)
  {
   IndicatorDigits(0); // We don't need to display fractions of a second!  
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,timebuffer);
   IndicatorShortName("RenkoTime v 2.0");
   SetIndexLabel(0,"Seconds");

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
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
   int i,limit;
   limit=rates_total-prev_calculated; // Set limit to the number of candles
   if(prev_calculated>0) limit++;

   for(i=1; i<limit; i++) // For each candle...
      timebuffer[i]=(double)(time[i-1]-time[i]); // Calculate time difference and put in buffer

   timebuffer[0]=(double)(TimeCurrent()-time[0]); // Calculate last bar from the current time

   return(rates_total);
  }
//+------------------------------------------------------------------+
