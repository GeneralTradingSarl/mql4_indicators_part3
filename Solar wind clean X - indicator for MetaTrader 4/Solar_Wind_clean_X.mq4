//+------------------------------------------------------------------+
//| Solar wind clean XXX(based on Solar wind clean  (FisherTransform)|
//| revised by Mladen    Copyright © 2005, MetaQuotes Software Corp. |
//| ForexTSD mladen nittany  mod fxbs  ki http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2005,  MetaQuotes Software Corp."
#property  link      "http://www.metaquotes.net/ www.ForexTSD.com"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 2
//----
#property  indicator_color1  Lime
#property  indicator_color2  Red
//----
extern int period   =10;
extern int smoozing =2;
//----
double         ExtBuffer0[];
double         ExtBuffer1[];
double         ExtBuffer2[];
double         Value[];
double         ExtBuffer3[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(5);
   SetIndexBuffer(0,ExtBuffer1);
   SetIndexBuffer(1,ExtBuffer2);
   SetIndexBuffer(2,ExtBuffer0);
   SetIndexBuffer(3,Value);
   SetIndexBuffer(4,ExtBuffer3);
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_HISTOGRAM);
//---  mod to show currency pair and Period by nittany1 forex-tsd
   //     IndicatorShortName("SOLAR WIND Clean("+Symbol()+","+period+")");
   IndicatorShortName("SOLARWIND CleanX ("+period+")("+smoozing+")");
   IndicatorDigits(Digits+1);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+period;
//----
   for(int i=limit; i>=0; i--)
     {
      double MaxH =High[iHighest(NULL,0,MODE_HIGH,period,i)];
      double MinL =Low [iLowest( NULL,0,MODE_LOW, period,i)];
      double price=(High[i]+Low[i])/2;
      if (MaxH!=MinL)
         Value[i]=0.33*2*((price-MinL)/(MaxH-MinL)-0.5);
      else  Value[i]=0.00;
      Value[i]=MathMin(MathMax(Value[i],-0.999),0.999);
      ExtBuffer0[i]=0.5*MathLog((1+Value[i])/(1-Value[i]));
     }
   for( i=limit; i>=0; i--)
     {
      ExtBuffer3[i]=iMAOnArray(ExtBuffer0,0,smoozing,0,MODE_EMA,i);
      if(ExtBuffer3[i]<0)
        {
         ExtBuffer2[i]=ExtBuffer3[i];
         ExtBuffer1[i]=0.0;
        }
      else
        {
         ExtBuffer1[i]=ExtBuffer3[i];
         ExtBuffer2[i]=0.0;
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+