//+------------------------------------------------------------------+
//|                                                                  |
//|               Ticker Awesome Oscillator.mq4                      |
//+------------------------------------------------------------------+
#property copyright "mandorr@gmail.com"
//----
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Black
#property indicator_width1 1
#property indicator_style1 0
#property indicator_color2 Green
#property indicator_width2 1
#property indicator_style2 0
#property indicator_color3 Red
#property indicator_width3 1
#property indicator_style3 0
//----
extern int CountBars=1000;   // Количество отображаемых баров
//----
int count;
int price;
int price_prev;
double period_fast=5;
double period_slow=34;
double ma_fast;             // Fast SMA
double ma_slow;             // Slow SMA
double ticker[10];          // Ticker
double array0[10];
double array1[10];
double array2[10];
double buffer0[];
double buffer1[];
double buffer2[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void init()
  {
   SetIndexStyle(0,DRAW_NONE);
   SetIndexBuffer(0,buffer0);
   SetIndexLabel(0,"Value");
   SetIndexDrawBegin(0,0);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexBuffer(1,buffer1);
   SetIndexLabel(1,NULL);
   SetIndexDrawBegin(1,0);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexBuffer(2,buffer2);
   SetIndexLabel(2,NULL);
   SetIndexDrawBegin(2,0);
   IndicatorDigits(Digits+2);
//----   
   count=ArrayResize(ticker,CountBars);
   count=ArrayResize(array0,CountBars);
   count=ArrayResize(array1,CountBars);
   count=ArrayResize(array2,CountBars);
   count=0;
//----
   ArrayInitialize(array0,0);
   ArrayInitialize(array1,0);
   ArrayInitialize(array2,0);
   price_prev=0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void start()
  {
   int i;
   double sum;
   if (price_prev==0)
     {
      ArrayInitialize(buffer0,0);
      ArrayInitialize(buffer1,0);
      ArrayInitialize(buffer2,0);
      array0[0]=0;
      array1[0]=0.01*Point;
      array2[0]=-0.01*Point;
      buffer0[0]=array0[0];
      buffer1[0]=array1[0];
      buffer2[0]=array2[0];
      price=MathRound(Bid/Point);
      price_prev=price;
      ticker[0]=price*Point;
      IndicatorShortName("Ticker ("+count+") AO");
      return;
     }
   price=MathRound(Bid/Point);
   if (price==price_prev) return;
   price_prev=price;
   for(i=count; i>=0; i--)
     {
      ticker[i+1]=ticker[i];
      array0[i+1]=array0[i];
      array1[i+1]=array1[i];
      array2[i+1]=array2[i];
     }
   ticker[0]=price*Point;
   if (count<CountBars-1) count++;
   IndicatorShortName("Ticker ("+count+") AO");
   if (count<period_slow-1)
     {
      array0[0]=0;
      array1[0]=0.01*Point;
      array2[0]=-0.01*Point;
      for(i=0; i<=count; i++)
        {
         buffer0[i]=array0[i];
         buffer1[i]=array1[i];
         buffer2[i]=array2[i];
        }
      return;
     }
   sum=0;
   for(i=0; i<=period_fast-1; i++) sum+=ticker[i];
   ma_fast=sum/period_fast;
   sum=0;
   for(i=0; i<=period_slow-1; i++) sum+=ticker[i];
   ma_slow=sum/period_slow;
   array0[0]=ma_fast-ma_slow;
   array1[0]=0;
   array2[0]=0;
   if (array0[0]>=array0[1]) array1[0]=array0[0]; else array2[0]=array0[0];
   for(i=0; i<=count; i++)
     {
      buffer0[i]=array0[i];
      buffer1[i]=array1[i];
      buffer2[i]=array2[i];
     }
  }
//+------------------------------------------------------------------+