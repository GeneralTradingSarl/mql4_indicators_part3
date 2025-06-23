//+------------------------------------------------------------------+
//|                                                                  |
//|                  Ticker MACD                                     |  
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "mandorr@gmail.com"
//----
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Gray
#property indicator_width1 2
#property indicator_style1 0
#property indicator_color2 Red
#property indicator_width2 1
#property indicator_style2 2
//----
extern int PeriodFast=12;
extern int PeriodSlow=26;
extern int PeriodSignal=9;
extern int CountBars=1000;   // Количество отображаемых баров
//----
int count;
int price;
int price_prev;
double period_fast;
double period_slow;
double period_sign;
double const_fast;
double const_slow;
double ma_fast[10];         // Fast EMA
double ma_slow[10];         // Slow EMA
double ma_sign[10];         // Signal SMA
double buffer0[];           // Main
double buffer1[];           // Signal
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void init()
  {
   SetIndexBuffer(0,buffer0);
   SetIndexLabel(0,"Main");
   SetIndexDrawBegin(0,0);
   SetIndexBuffer(1,buffer1);
   SetIndexLabel(1,"Signal");
   SetIndexDrawBegin(1,0);
   count=ArrayResize(ma_fast,CountBars);
   count=ArrayResize(ma_slow,CountBars);
   count=ArrayResize(ma_sign,CountBars);
   count=0;
   ArrayInitialize(ma_sign,EMPTY_VALUE); // EMPTY_VALUE=+2147483647
   price_prev=0;
   period_fast=MathMax(1,PeriodFast);
   period_slow=MathMax(1,PeriodSlow);
   period_sign=MathMax(1,PeriodSignal);
   const_fast=2/(1+period_fast);
   const_slow=2/(1+period_slow);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void start()
  {
   int i, N;
   double sum;
   price=MathRound(Bid/Point);
   if (price_prev==0)
     {
      count=0;
      price_prev=price;
      ma_fast[0]=price;
      ma_slow[0]=price;
      buffer0[0]=0;
      IndicatorShortName("Ticker ("+count+") MACD ("+DoubleToStr(period_fast,0)+","+DoubleToStr(period_slow,0)+","+DoubleToStr(period_sign,0)+")");
      return;
     }
   if (price==price_prev) return;
   price_prev=price;
   for(i=count; i>=0; i--)
     {
      ma_fast[i+1]=ma_fast[i];
      ma_slow[i+1]=ma_slow[i];
      ma_sign[i+1]=ma_sign[i];
     }
   ma_fast[0]=ma_fast[1]+const_fast*(price-ma_fast[1]);
   ma_slow[0]=ma_slow[1]+const_slow*(price-ma_slow[1]);
   if (count<CountBars-1) count++;
   N=period_sign-1;
   if (count>=N)
     {
      sum=0;
      for(i=0; i<=N; i++) sum+=ma_fast[i]-ma_slow[i];
      ma_sign[0]=sum/period_sign;
     }
   for(i=0; i<=count; i++)
     {
      buffer0[i]=ma_fast[i]-ma_slow[i];
      buffer1[i]=ma_sign[i];
     }
   string cmd="";
   if (count>=N)
     {
      if (ma_fast[0]-ma_slow[0]>ma_sign[0]) cmd=" Buy";
      if (ma_fast[0]-ma_slow[0]<ma_sign[0]) cmd=" Sell";
     }
   IndicatorShortName("Ticker ("+count+") MACD ("+DoubleToStr(period_fast,0)+","+DoubleToStr(period_slow,0)+","+DoubleToStr(period_sign,0)+")"+cmd);
  }
//+------------------------------------------------------------------+