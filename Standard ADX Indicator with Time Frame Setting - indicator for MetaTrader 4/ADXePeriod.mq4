//+------------------------------------------------------------------+
//|                                                   ADX+Period.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|рихтован 1 декабря 2008 г.             http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp. && Yuriy Tokman"
#property link      "http://www.metaquotes.net/  &&  yuriytokman@gmail.com"

#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Yellow
#property indicator_color2 Aqua
#property indicator_color3 Red

//---- input parameters
extern int ADXPeriod=6;
extern int timeframe=1;
//---- buffers
double ADXBuffer[];
double PlusDiBuffer[];
double MinusDiBuffer[];
double PlusSdiBuffer[];
double MinusSdiBuffer[];
double TempBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 3 additional buffers are used for counting.
   IndicatorBuffers(6);
//---- indicator buffers
   SetIndexBuffer(0,ADXBuffer);
   SetIndexBuffer(1,PlusDiBuffer);
   SetIndexBuffer(2,MinusDiBuffer);
   SetIndexBuffer(3,PlusSdiBuffer);
   SetIndexBuffer(4,MinusSdiBuffer);
   SetIndexBuffer(5,TempBuffer);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("ADX ("+ADXPeriod+")  Per ("+timeframe+")  ");
   SetIndexLabel(0,"ADX");
   SetIndexLabel(1,"+DI");
   SetIndexLabel(2,"-DI");
//----
   SetIndexDrawBegin(0,ADXPeriod);
   SetIndexDrawBegin(1,ADXPeriod);
   SetIndexDrawBegin(2,ADXPeriod);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Average Directional Movement Index                               |
//+------------------------------------------------------------------+
int start()
  {
   double pdm,mdm,tr;
   double price_high,price_low;
   int    starti,i;
//---- 
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+1;

   starti=limit;
   i=starti;
//----
   while(i>=0)
     {
      price_low=iLow(NULL,timeframe,i);
      price_high=iHigh(NULL,timeframe,i);
      //----
      pdm=price_high-iHigh(NULL,timeframe,i+1);
      mdm=iLow(NULL,timeframe,i+1)-price_low;
      if(pdm<0) pdm=0;  // +DM
      if(mdm<0) mdm=0;  // -DM
      if(pdm==mdm) { pdm=0; mdm=0; }
      else if(pdm<mdm) pdm=0;
      else if(mdm<pdm) mdm=0;
      //---- вычисляем истинный интервал
      double num1=MathAbs(price_high-price_low);
      double num2=MathAbs(price_high-iClose(NULL,timeframe,i+1));
      double num3=MathAbs(price_low-iClose(NULL,timeframe,i+1));
      tr=MathMax(num1,num2);
      tr=MathMax(tr,num3);
      //---- counting plus/minus direction
      if(tr==0) { PlusSdiBuffer[i]=0; MinusSdiBuffer[i]=0; }
      else      { PlusSdiBuffer[i]=100.0*pdm/tr; MinusSdiBuffer[i]=100.0*mdm/tr; }
      //----
      i--;
     }
//---- last counted bar will be recounted
//---- apply EMA to +DI
   for(i=0; i<=limit; i++)
      PlusDiBuffer[i]=iMAOnArray(PlusSdiBuffer,Bars,ADXPeriod,0,MODE_EMA,i);
//---- apply EMA to -DI
   for(i=0; i<=limit; i++)
      MinusDiBuffer[i]=iMAOnArray(MinusSdiBuffer,Bars,ADXPeriod,0,MODE_EMA,i);
//---- Directional Movement (DX)
   i=starti;
   while(i>=0)
     {
      double div=MathAbs(PlusDiBuffer[i]+MinusDiBuffer[i]);
      if(div==0.00) TempBuffer[i]=0;
      else TempBuffer[i]=100*(MathAbs(PlusDiBuffer[i]-MinusDiBuffer[i])/div);
      i--;
     }
//---- ADX is exponential moving average on DX
   for(i=0; i<limit; i++)
      ADXBuffer[i]=iMAOnArray(TempBuffer,Bars,ADXPeriod,0,MODE_EMA,i);
//----
   return(0);
  }
//+------------------------------------------------------------------+
