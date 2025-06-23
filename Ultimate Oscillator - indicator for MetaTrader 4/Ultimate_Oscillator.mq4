//+------------------------------------------------------------------+
//|                                          Ultimate Oscillator.mq4 |
//|                      Copyright © 2007, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.ru/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.ru/"
//----
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Blue
#property indicator_level1 30
#property indicator_level2 70
#property indicator_levelcolor Blue
//#property indicator_maximum 100
//#property indicator_minimum 0
//---- input parameters
extern int fastperiod = 7;
extern int middleperiod = 14;
extern int slowperiod = 28;
extern int fastK = 4;
extern int middleK = 2;
extern int slowK = 1;
//---- buffers
double UOBuffer[];
double BPBuffer[];
double divider;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   string name;
   name="UOS(" + fastperiod + ", " + middleperiod + ", " + slowperiod + ")";
   IndicatorBuffers(2);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, UOBuffer);
   SetIndexDrawBegin(0, slowperiod);
   SetIndexBuffer(1, BPBuffer);
   IndicatorShortName(name);
   IndicatorDigits(1);
   divider = fastK + middleK + slowK;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars = IndicatorCounted();
//----
   int i, limit, limit2;
   double TL, RawUO;
   if(counted_bars == 0) 
     {
       limit = Bars - 2;
       limit2 = Bars - slowperiod;
     }
   if(counted_bars > 0) 
     {
       limit = Bars - counted_bars;
       limit2 = limit;
     }
   for(i = limit; i >= 0; i--)
     {
       TL = MathMin(Low[i], Close[i+1]);
       BPBuffer[i] = Close[i] - TL;
     }
   for(i = limit2; i >= 0; i--)
     {
       RawUO = fastK*iMAOnArray(BPBuffer, 0, fastperiod, 0, MODE_SMA, i) / 
               iATR(NULL, 0, fastperiod, i) +
               middleK*iMAOnArray(BPBuffer, 0, middleperiod, 0, MODE_SMA, i) /
               iATR(NULL, 0, middleperiod, i) +
               slowK*iMAOnArray(BPBuffer, 0, slowperiod, 0, MODE_SMA, i) / 
               iATR(NULL, 0, slowperiod, i);
       UOBuffer[i] = RawUO / divider*100;
     }     
//----
   return(0);
  }
//+------------------------------------------------------------------+