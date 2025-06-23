//+------------------------------------------------------------------+
//|                                                   WelchHMABB.mq4 |
//|                                  Copyright © 2011, Timothy Welch |
//|                                     http://www.timothy-welch.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, Timothy Welch"
#property link      "http://www.timothy-welch.com"

#property indicator_separate_window
#property indicator_buffers 7
#property indicator_color1 Lime
#property indicator_width1 4
#property indicator_color2 Yellow
#property indicator_width2 4
#property indicator_color3 Red
#property indicator_width3 4
#property indicator_color4 DodgerBlue
#property indicator_width4 2



#property  indicator_minimum 0
#property  indicator_maximum 300

//---- indicator parameters
extern int     BandsPeriod=20;
extern int     BandsShift=0;
extern double  BandsDeviations=2.0;
extern int     MinRangePercent=20;
extern string  Note1="How far back to look for Max/Min width";
extern int     WidthCalcPeriod=100;
extern string  Note2="If TRUE, shows the the Width on a line chart";
extern bool    ShowWidthLine=false;

//---- buffers
double devBuffer[];
double squishyBuffer1[];
double squishyBuffer2[];
double squishyBuffer3[];

double MovingBuffer[];
double UpperBuffer[];
double LowerBuffer[];

double dVal=1;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(7);
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,squishyBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexBuffer(1,squishyBuffer2);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexBuffer(2,squishyBuffer3);

   if(ShowWidthLine)
     {
      SetIndexStyle(3,DRAW_LINE);
        } else {
      SetIndexStyle(3,DRAW_NONE);
     }
   SetIndexBuffer(3,devBuffer);
   SetIndexBuffer(4,MovingBuffer);
   SetIndexBuffer(5,UpperBuffer);
   SetIndexBuffer(6,LowerBuffer);
//----
   SetIndexDrawBegin(0,BandsPeriod+BandsShift);
   SetIndexDrawBegin(1,BandsPeriod+BandsShift);
   SetIndexDrawBegin(2,BandsPeriod+BandsShift);
//----
// If we have 5 digits, or 4 digits and the symbol is a JPY currency, then dVal is 10.
   if(Digits==5 || (Digits==4 && StringFind(Symbol(),"JPY",0)>0)) { dVal=10; }

   if(BandsPeriod==0) { BandsPeriod=20; }
   if(MinRangePercent==0) { MinRangePercent=10; }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Bollinger Bands                                                  |
//+------------------------------------------------------------------+
int start()
  {
   if(Bars<=BandsPeriod) return(0);
//----
   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+BandsPeriod;
//----
   int    i,k;
   double deviation;
   double sum,oldval,newres;
//----
   for(i=0; i<limit; i++)
      MovingBuffer[i]=iMA(NULL,0,BandsPeriod,BandsShift,MODE_SMA,PRICE_CLOSE,i);
//----
   i=limit;
   while(i>=0)
     {
      sum=0.0;
      k=i+BandsPeriod-1;
      oldval=MovingBuffer[i];
      while(k>=i)
        {
         newres=Close[k]-oldval;
         sum+=newres*newres;
         k--;
        }
      deviation=BandsDeviations*MathSqrt(sum/BandsPeriod);
      UpperBuffer[i]=oldval+deviation;
      LowerBuffer[i]=oldval-deviation;
      devBuffer[i]=MathAbs(UpperBuffer[i]-LowerBuffer[i])/Point/dVal;

      int tMaxIdx = ArrayMaximum(devBuffer, WidthCalcPeriod, i);
      int tMinIdx = ArrayMinimum(devBuffer, WidthCalcPeriod, i);

      // This will give us the percentage of closeness compared to each of tMin and tMax.
      // If we are < MinRangePercent away from the tMin value, we are considered in a rangebound market.
      // i.e. tMin=30, tMax=150, devBuffer[0]=42.  In that case, tLow=10, tHigh=90. tLow <15% from tMin
      double tLow=(MathAbs(devBuffer[tMinIdx]-devBuffer[i])/MathAbs(devBuffer[tMinIdx]-devBuffer[tMaxIdx]))*100;
      double tHigh=(MathAbs(devBuffer[tMaxIdx]-devBuffer[i])/MathAbs(devBuffer[tMinIdx]-devBuffer[tMaxIdx]))*100;

      if(tLow<tHigh && tLow<=MinRangePercent)
        {
         squishyBuffer1[i]=300; // Ranging
           } else if(tLow<tHigh && tLow<=(MinRangePercent*2)) {
         squishyBuffer2[i]=300; // Start/End of Range
           } else {
         squishyBuffer3[i]=300; // Not ranging
        }
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
