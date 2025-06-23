//+------------------------------------------------------------------+
//|                                                   AwesomeMod.mq4 |
//|                                                    Manel Sanchon |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Manel Sanchon"
#property link      ""
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 3
#property  indicator_color1  Green
#property  indicator_color2  Red
 
// External parameters
extern int short_mean = 5;
extern int long_mean = 34;
extern int meanAO = 7;
 
 
//---- indicator buffers
double UpBuffer[];
double DownBuffer[];
double ExtBuffer[];
 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   //---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexStyle(2,DRAW_NONE);
   IndicatorDigits(Digits+1);
   SetIndexDrawBegin(0,34);
   SetIndexDrawBegin(1,34);
   SetIndexDrawBegin(2,34);
//---- 3 indicator buffers mapping
   SetIndexBuffer(0,UpBuffer);
   SetIndexBuffer(1,DownBuffer);
   SetIndexBuffer(2,ExtBuffer);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("AwesomeMod("+short_mean+","+long_mean+";"+meanAO+")");
   SetIndexLabel(0,"UpAO");
   SetIndexLabel(1,"DownAO");
 
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Awesome Oscillator                                               |
//+------------------------------------------------------------------+
int start()
  {
 
  double ShortMA, LongMA;
  double MAExtBufferCurrent,MAExtBufferPrev;
  int Count;
 
  if(Bars<=long_mean)
    {
      Comment("Not enough bars to make computations"); 
      return(0);
    }
 
  if(meanAO>long_mean)
    {
      Comment("Mean AO has to be smaller than Long mean"); 
      return(0);
    }
 
  int counted_bars = IndicatorCounted();  
  int CalculateBars = Bars-counted_bars-(long_mean+1);
  if(counted_bars>long_mean)
     {
      CalculateBars=Bars-counted_bars-1;
     }    
 
  
//--- handles for MAs
  for(Count = CalculateBars; Count >=0 ; Count--)
   {
     ShortMA = iMA(NULL,0,short_mean,0,MODE_SMMA,PRICE_MEDIAN,Count);
     LongMA = iMA(NULL,0,long_mean,0,MODE_SMMA,PRICE_MEDIAN,Count);
     ExtBuffer[Count] = (ShortMA/LongMA-1)*100;
   }
   
//---- dispatch values between 2 buffers
   bool up=true;
   for(Count = CalculateBars; Count >= 0; Count--)
     {
        MAExtBufferCurrent = iMAOnArray(ExtBuffer,0,meanAO,0,MODE_SMMA,Count); 
        MAExtBufferPrev = iMAOnArray(ExtBuffer,0,meanAO,0,MODE_SMMA,Count+1);
        if(MAExtBufferCurrent>MAExtBufferPrev) up=true;
      if(MAExtBufferCurrent<MAExtBufferPrev) up=false;
      if(!up)
        {
         UpBuffer[Count]=0.0;
         DownBuffer[Count]=MAExtBufferCurrent;
        }
      else
        {
         DownBuffer[Count]=0.0;
         UpBuffer[Count]=MAExtBufferCurrent;
        }
     }
//---- done
   return(0);
  }
//+------------------------------------------------------------------+