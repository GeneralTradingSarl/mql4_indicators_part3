//+------------------------------------------------------------------+
//|                                             StrangeIndicator.mq4 |
//|                            MT4 realization created by CrazyChart |
//|                                    mailto:newcomer2003@yandex.ru |
//+------------------------------------------------------------------+
#property copyright "MT4 realization created by CrazyChart"
#property link      "mailto:newcomer2003@yandex.ru"
//----
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Blue
//---- input parameters
extern int       shift=5;
//---- buffers
double ExtMapBuffer1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   int cb=1;
   double EMAclose,EMAhigh,EMAlow,ma3;
   for(cb=1;cb<iBars(_Symbol,PERIOD_CURRENT);cb++)
     {
      EMAclose=iMA(NULL,0,shift,0,MODE_EMA,PRICE_CLOSE,cb);
      EMAlow=iMA(NULL,0,shift,0,MODE_EMA,PRICE_LOW,cb);
      EMAhigh=iMA(NULL,0,shift,0,MODE_EMA,PRICE_HIGH,cb);
      //----
      ma3=(EMAclose-EMAlow)/(EMAhigh-EMAlow)*100;
      //---- 
      ExtMapBuffer1[cb-1]=ma3;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+