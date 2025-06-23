
//+------------------------------------------------------------------+
//|                                                   RSI_Mirror.mq4 |
//|                                   Copyright © 2010, Andy Tjatur. |
//|                                            andy.tjatur@gmail.com |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2010, Andy Tjatur."
#property  link      "andy.tjatur@gmail.com"
//---- indicator settings
#property  indicator_separate_window
#property indicator_level1 1
#property indicator_levelcolor White
#property  indicator_buffers 2
#property  indicator_color1  Red
#property  indicator_color2  Blue
#property  indicator_width1 2
#property  indicator_width2 2

extern double RSI_Period       = 20;

double     RsiBuffer1[];
double     RsiBuffer2[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);

   
   IndicatorDigits(Digits+1);
//---- indicator buffers mapping
   SetIndexBuffer(0,RsiBuffer1);
   SetIndexBuffer(1,RsiBuffer2);
 
   

   IndicatorShortName("RSI_Mirror by Andy Tjatur");
   SetIndexLabel(0,"RSI_Close");
   SetIndexLabel(1,"RSI_Open");
 
   

   return(0);
  }
//+------------------------------------------------------------------+
//| RSI Mirror                                           |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();

   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;

  
   for(int i=0; i<limit; i++)
      RsiBuffer1[i]=iRSI(NULL, 0, RSI_Period, PRICE_CLOSE, i)- iRSI(NULL, 0, RSI_Period, PRICE_OPEN, i);
    
    
   for(i=0; i<limit; i++)
      RsiBuffer2[i]=iRSI(NULL, 0, RSI_Period, PRICE_OPEN, i)- iRSI(NULL, 0, RSI_Period, PRICE_CLOSE, i);
    
    


   return(0);
  }
//+------------------------------------------------------------------+