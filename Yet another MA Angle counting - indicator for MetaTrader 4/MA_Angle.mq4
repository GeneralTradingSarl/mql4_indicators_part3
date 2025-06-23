//+------------------------------------------------------------------+
//|                                                     MA_Angle.mq4 |
//|                                       Copyright 2009, KoliEr Li. |
//|                                                 http://kolier.li |
//+------------------------------------------------------------------+
#property copyright "Copyright 2009, KoliEr Li."
#property link      "http://kolier.li"

/*
 * I here get paid to program for you. Just $15 for all scripts.
 *
 * I am a bachelor major in Financial-Mathematics.
 * I am good at programming in MQL for Meta Trader 4 platform. The ability is between medium and top level.
 * No matter what it is, create or modify any indicators, expert advisors and scripts.
 * I will ask these jobs which are not too large for only $15, surely refundable if you are not appreciate mine.
 * All products will deliver in 3 days.
 * Also, I am providing EA, Indicator and Trade System Improvement Consultant services, contact me for the detail.
 * If you need to have it done, don't hesitate to contact me at: kolier.li@gmail.com
 */
 
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Yellow
#property indicator_width1 1

//+------------------------------------------------------------------+
//| User input variables                                             |
//+------------------------------------------------------------------+
extern string     IndicatorName = "MA_Angle"; // For Logging
extern int             MAPeriod = 50;         // MA Period
extern int            ATRPeriod = 10;         // 10% of MAPeriod
extern double         ATRFactor = 50;         // 500 = ATRPeriod * ATRFactor
extern int           BarsToLoad = 1000;       // Change to 0 to count all bars.

//+------------------------------------------------------------------+
//| Universal variables                                              |
//+------------------------------------------------------------------+
double ma, ma_pre, atr;
double buffer_angle[];
double buffer_ma[], buffer_ma_pre[], buffer_atr[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorShortName(IndicatorName);
   IndicatorBuffers(4);
   SetIndexBuffer(0, buffer_angle);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexLabel(0, "MA Angle");
   SetIndexBuffer(1, buffer_ma);
   SetIndexStyle(1, DRAW_NONE);
   SetIndexBuffer(2, buffer_ma_pre);
   SetIndexStyle(2, DRAW_NONE);
   SetIndexBuffer(3, buffer_atr);
   SetIndexStyle(3, DRAW_NONE);
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
   int bars_counted = IndicatorCounted();
   if(bars_counted < 0)
   {
      return(1);
   }
   bars_counted--;
   int limit = Bars - bars_counted;
   if(limit>BarsToLoad && BarsToLoad>0)
   {
      limit = BarsToLoad;
   }
   for(int i=limit; i>=0; i--)
   {
      buffer_ma[i] = iMA(Symbol(), 0, MAPeriod, 0, MODE_SMA, PRICE_CLOSE, i);
      buffer_ma_pre[i] = iMA(Symbol(), 0, MAPeriod, 0, MODE_SMA, PRICE_CLOSE, i+ATRPeriod);
      buffer_atr[i] = iATR(Symbol(), 0, ATRPeriod, i);
   }
   for(int j=limit; j>=0; j--)
   {
      buffer_angle[j] = ATRFactor*(buffer_ma[j]-buffer_ma_pre[j])/buffer_atr[j];
   }
   return(0);
  }