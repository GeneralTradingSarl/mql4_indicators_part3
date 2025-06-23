//+------------------------------------------------------------------+
//|                                                    Rads MACD.mq4 |
//|                                    Copyright © 2007 Steve Bowley |
//|                                        http://www.9squaredfx.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007 Steve Bowley"
#property link      "http://www.9squaredfx.com"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 2
#property  indicator_color1  Lime
#property  indicator_color2  Red
//---- indicator buffers
double     ind_buffer1[];
double     ind_buffer2[];
double     ind_buffer3[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 1 additional buffer used for counting.
   IndicatorBuffers(3);
//---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,2);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,2);
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+1);
   SetIndexDrawBegin(0,36);
   SetIndexDrawBegin(1,36);
//---- 3 indicator buffers mapping
   SetIndexBuffer(0,ind_buffer1);
   SetIndexBuffer(1,ind_buffer2);
   SetIndexBuffer(2,ind_buffer3);

//---- Set level Color and Style 
   SetLevelStyle(0, 2, RoyalBlue);
   SetLevelValue(0 , 0);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("Rads MACD");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| 9Squared Oscillator                                              |
//+------------------------------------------------------------------+
int start()
  {
   int    limit;
   double prev,current;
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+1;
   
//---- macd counted in the 1-st additional buffer
   for(int i=0; i<limit; i++)
      ind_buffer3[i]=iMA(NULL,0,18,0,MODE_EMA,PRICE_WEIGHTED,i)-iMA(NULL,0,27,0,MODE_EMA,PRICE_WEIGHTED,i);
//---- dispatch values between 2 buffers
   bool up=true;
   for(i=limit-1; i>=0; i--)
     {
      current=ind_buffer3[i];
      prev=ind_buffer3[i+1];
      if(current>prev) up=true;
      if(current<prev) up=false;
      if(!up)
        {
         ind_buffer2[i]=current;
         ind_buffer1[i]=0.0;
        }
      else
        {
         ind_buffer1[i]=current;
         ind_buffer2[i]=0.0;
        }
     }
//---- done
   return(0);
  }
//+------------------------------------------------------------------+