//+------------------------------------------------------------------+
//|                                            Spread Normalized.mq4 |
//|                                                   Vangabestia 69 |
//|                           http://www.automatikforex.blogspot.com |
//+------------------------------------------------------------------+
#property copyright "Vangabestia 69"
#property link      "http://www.automatikforex.blogspot.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red
//---- input parameters
extern int MAPeriod = 20;
extern string FirstMarket = "EURUSD";
extern string SecondMarket = "AUDUSD";
extern bool MarketsDirectCorrelation = true;
//---- buffers
double SpreadMod[];
double Spread[];
double SPRSMA[];
double Cov[];
double sDev[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string Correlation = "Invert Correlation";
   if(MarketsDirectCorrelation == TRUE) 
       Correlation = "Direct Correlation";
   IndicatorShortName("SpreadMod(" + MAPeriod + "," + FirstMarket + "," + SecondMarket + "," + Correlation + ")");
   IndicatorDigits(Digits + 2);
   IndicatorBuffers(5);
   SetIndexBuffer(0, SpreadMod);
   SetIndexBuffer(1, Spread);
   SetIndexBuffer(2, SPRSMA);
   SetIndexBuffer(3, Cov);
   SetIndexBuffer(4, sDev);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexLabel(0, "SpreadMod");
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
           Spread[i] = iClose(SecondMarket, 0, i) - iClose(FirstMarket, 0, i);//Close[i];

     }
   else
     {
       for(i = 0; i < limit; i++)
           Spread[i] = iClose(FirstMarket, 0, i) - iClose(SecondMarket, 0, i);
     }
   for(i = limit - 1; i >= 0; i--)
     { //Spread[i] = iClose(SecondMarket, 0, i) - Close[i];
       SPRSMA[i] = iMAOnArray(Spread, 0, MAPeriod, 0, MODE_SMA, i);
       Cov[i]=(Spread[i])*(Spread[i]);
       sDev[i]=MathSqrt(Cov[i]/MAPeriod);
       SpreadMod[i] =-((Spread[i]-SPRSMA[i])/sDev[i]) ;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+