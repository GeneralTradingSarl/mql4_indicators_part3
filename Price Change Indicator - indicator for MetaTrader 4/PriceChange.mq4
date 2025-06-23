//+------------------------------------------------------------------+
//|                                                  PriceChange.mq4 |
//|                                                    Shon Shampain |
//|                                       http://www.zencowsgomu.com |
//|                                                                  |
//|       Visit http://www.zencowsgomu.com, an oasis of sanity       |
//|                      for currency traders.                       |
//|                                                                  |
//|       Original out-of-the-box thinking, ideas, indicators,       |
//|                    educational EAs and more.                     |
//|                                                                  |
//|         Home of the consistent T4 Forex trading signal.          |
//|             Backtesting profitably since 1-1-2002.               |
//+------------------------------------------------------------------+

#property copyright "Shon Shampain"
#property link      "http://www.zencowsgomu.com"

#property indicator_separate_window

#property indicator_buffers 1
#property indicator_color1 Aqua

double Change [];

extern bool tenths = true;
double mult;

int init()
{
   int d = Digits;
   if (tenths) d -= 1;
   mult = 1.0;
   for (int x = 0; x < d; x++)
      mult *= 10.0;

   SetIndexBuffer(0, Change);
      
   SetLevelValue(0, 0.0);
   SetLevelStyle(STYLE_DOT, 1, Silver);
  
   return(0);
}

int deinit()
{
   return(0);
}
   
int start()
{
   int counted_bars;
   int i;
   
   counted_bars = IndicatorCounted();
   
   i = Bars - counted_bars - 1;
   while(i>=0)
   {
      Change[i] = (Close[i] - Open[i]) * mult;
      i--;
   }
   
   return(0);
}

