//+------------------------------------------------------------------+
//|                                                      TSI.mq4     |
//|                        Copyright 2024, MetaQuotes Software Corp. |
//|                                       https://www.metaquotes.net |
//+------------------------------------------------------------------+
#property description "Trend Strenght Index"
#property strict
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red

// Input parameters
input int period = 14; //number of bars indicator uses

// Buffers
double tsiBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {
// Indicator buffers mapping
   SetIndexBuffer(0, tsiBuffer);

// Indicator settings
   IndicatorShortName("Trend Strength Index (TSI)");
   SetIndexStyle(0, DRAW_LINE);
   SetIndexLabel(0, "TSI");

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
// Check for sufficient bars
   if(rates_total < period)
      return(0);

// Calculate TSI
   for(int i = 0; i < rates_total; i++)
     {
         tsiBuffer[i] = Correlation(close, i, period);
     }

   return(rates_total);
  }

//+------------------------------------------------------------------+
//| Custom correlation function                                      |
//+------------------------------------------------------------------+
double Correlation(const double &data[], int currentIndex, int length)
  {
   double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0, sumY2 = 0;
   for(int i = 0; i < length; i++)
     {
      int count = ArraySize(data);
      if(count > currentIndex + i)
      {
         double x = currentIndex + i;
         double y = data[currentIndex + i];
   
         sumX += x;
         sumY += y;
         sumXY += x * y;
         sumX2 += x * x;
         sumY2 += y * y;
      }
     }

   double numerator = (length * sumXY) - (sumX * sumY);
   double denominator = MathSqrt((length * sumX2 - sumX * sumX) * (length * sumY2 - sumY * sumY));

   if(denominator == 0)
   {
      Print("denominator was null");
      return 0;
   }
   return (numerator / denominator)*-1;
  }
//+------------------------------------------------------------------+
