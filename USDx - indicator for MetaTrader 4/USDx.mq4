//+------------------------------------------------------------------+
//|                                                         USDx.mq4 |
//|                                    Copyright © 2009, EADeveloper |
//|                                      mailto:forex.trading@gmx.at |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, EADeveloper"
#property link      "mailto:forex.trading@gmx.at"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Green

extern int MA=12;
double ExtMapBuffer1[];
double ExtMapBuffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(2);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(0,DRAW_HISTOGRAM,0,1);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(1,DRAW_LINE,0,1);

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
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
  int counted_bars = IndicatorCounted();
   int i,  limit;
   if(counted_bars == 0) 
       limit = Bars - 30;
   if(counted_bars > 0)  
       limit = Bars - counted_bars; 
   for(i = limit; i >= 0; i--)
     {   
      double Open_EURUSD=iOpen("EURUSD",0,i);
      double Open_USDJPY=iOpen("USDJPY",0,i);
      double Open_GBPUSD=iOpen("GBPUSD",0,i);
      double Open_USDCAD=iOpen("USDCAD",0,i);
      double Open_USDSEK=iOpen("USDSEK",0,i);
      double Open_USDCHF=iOpen("USDCHF",0,i);
      double USDx=50.14348112 * MathPow(Open_EURUSD, -0.576) * MathPow(Open_USDJPY, 0.136) * MathPow(Open_GBPUSD, -0.119) * MathPow(Open_USDCAD, 0.091) * MathPow(Open_USDSEK, 0.042) * MathPow(Open_USDCHF, 0.036);
       ExtMapBuffer1[i] = USDx;
   }
   for(i = limit; i >= 0; i--)
    {
     double r = iMAOnArray(ExtMapBuffer1,0,MA,0,MODE_SMA,i) ;
     ExtMapBuffer2[i]=r;
    } 
   //*

//----
   return(0);
  }
//+------------------------------------------------------------------+