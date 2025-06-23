//+------------------------------------------------------------------+
//|                                         GC_SupportResistance.mq4 |
//|                         Copyright 2023, Gurchiek Consulting LLC. |
//|                               https://www.gurchiekconsulting.com |
//+------------------------------------------------------------------+
#property strict
//--- inputs
input int Lookback = 50;

//--- indicator buffers
double         SupportBuffer[];
double         ResistanceBuffer[];
double         MidLineBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,SupportBuffer);
   SetIndexBuffer(1,ResistanceBuffer);
   SetIndexBuffer(2,MidLineBuffer);

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
//--- Core logic here
//int N = 50; // Number of bars to look back for support and resistance
   double nearestSupport = 0.0;
   double nearestResistance = 0.0;

// Initializing to extreme values
   double highestHigh = -1e9;
   double lowestLow = 1e9;

   for(int i =0; i < Lookback && i < rates_total; i++)
     {
      if(high[i] > highestHigh)
        {
         highestHigh = high[i];
        }

      if(low[i] < lowestLow)
        {
         lowestLow = low[i];
        }
     }

// Setting the nearest support and resistance levels
   nearestSupport = lowestLow;
   nearestResistance = highestHigh;

// Calculate mid-line as the average of support and resistance
   double midLine = (nearestSupport + nearestResistance) / 2;

// Filling the indicator buffers
   for(int i = 0; i < rates_total; i++)
     {
      SupportBuffer[i] = nearestSupport;
      ResistanceBuffer[i] = nearestResistance;
      MidLineBuffer[i] = midLine;
     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
