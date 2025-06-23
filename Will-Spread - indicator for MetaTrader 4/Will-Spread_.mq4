//+------------------------------------------------------------------+
//|                                                      Will-Spread |
//|                                       Copyright © Larry Williams |
//|                                    Coded/Verified by Profitrader |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, Profitrader."
#property link      "profitrader@inbox.ru"
//----
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red
//---- input parameters
extern int FastMAPeriod = 3;
extern int SlowMAPeriod = 15;
extern string SecondMarket = "GOLD";
extern bool MarketsDirectCorrelation = true;
//---- buffers
double WillSpread[];
double Spread[];
double FastEMA[];
double SlowEMA[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string Correlation = "Invert Correlation";
   if(MarketsDirectCorrelation == TRUE) 
       Correlation = "Direct Correlation";
   IndicatorShortName("Will-Spread(" + FastMAPeriod + "," + SlowMAPeriod + 
                      "," + SecondMarket + "," + Correlation + ")");
   IndicatorDigits(Digits + 2);
   IndicatorBuffers(4);
   SetIndexBuffer(0, WillSpread);
   SetIndexBuffer(1, Spread);
   SetIndexBuffer(2, FastEMA);
   SetIndexBuffer(3, SlowEMA);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexLabel(0, "W-S");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i, counted_bars = IndicatorCounted();
//---- check for possible errors
   if(counted_bars < 0) 
       return(-1);
//---- last counted bar will be recounted
   if(counted_bars > 0) 
       counted_bars--; 
   int limit = Bars - counted_bars;
   if(MarketsDirectCorrelation == TRUE)
     {
       for(i = 0; i < limit; i++)
           Spread[i] = iClose(SecondMarket, 0, i) / Close[i]*100;
     }
   else
     {
       for(i = 0; i < limit; i++)
           Spread[i] = Close[i] / iClose(SecondMarket, 0, i)*100;
     }
   for(i = limit - 1; i >= 0; i--)
     {
       FastEMA[i] = iMAOnArray(Spread, 0, FastMAPeriod, 0, MODE_EMA, i);
       SlowEMA[i] = iMAOnArray(Spread, 0, SlowMAPeriod, 0, MODE_EMA, i);
       WillSpread[i] = FastEMA[i] - SlowEMA[i];
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+