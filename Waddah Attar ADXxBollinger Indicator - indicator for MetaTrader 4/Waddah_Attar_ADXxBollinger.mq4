//+------------------------------------------------------------------+
//|                                   Waddah Attar ADXxBollinger.mq4 |
//|                              Copyright © 2006, Eng. Waddah Attar |
//|                                          waddahattar@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Waddah Attar www.metaforex.net"
#property link      "www.metaforex.net waddahattar@hotmail.com"
//----
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_minimum 0
//----
extern int ADXPeriod = 13;
extern int BandsPeriod=20;
//----
double ExtBuffer1[];
double ExtBuffer2[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0, ExtBuffer1);
   SetIndexStyle(0, DRAW_HISTOGRAM, 0, 2);
//----
   SetIndexBuffer(1, ExtBuffer2);
   SetIndexStyle(1, DRAW_HISTOGRAM, 0, 2);
//----
   IndicatorShortName("Waddah Attar ADXxBollinger - ADX (" + ADXPeriod + ") x Bollinger ("+BandsPeriod+")");
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int i, limit;
   double ADX0,ADX1,ADX2,Explo;
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0) 
       return(-1);
   if(counted_bars > 0) 
       counted_bars--;
   limit = Bars - counted_bars; 
//----   
   for(i = 0; i < limit ; i++)
     {
       ADX0 = iADX(NULL, 0, ADXPeriod, PRICE_WEIGHTED, MODE_MAIN, i);
       ADX1 = iADX(NULL, 0, ADXPeriod, PRICE_WEIGHTED, MODE_PLUSDI, i);
       ADX2 = iADX(NULL, 0, ADXPeriod, PRICE_WEIGHTED, MODE_MINUSDI, i);
       Explo = (iBands(NULL, 0, BandsPeriod, 2, 0, PRICE_CLOSE, MODE_UPPER, i) - 
                iBands(NULL, 0, BandsPeriod, 2, 0, PRICE_CLOSE, MODE_LOWER, i));

       //----
       if(ADX1 >= ADX2)
         {
           ExtBuffer1[i] = ADX0*Explo;
           ExtBuffer2[i] = 0;
         }
       else
         {
           ExtBuffer1[i] = 0;
           ExtBuffer2[i] = ADX0*Explo;
         }
     }
   return(0);
  }
//+------------------------------------------------------------------+

