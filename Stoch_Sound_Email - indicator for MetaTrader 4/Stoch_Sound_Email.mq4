//+------------------------------------------------------------------+
//|                                            Stoch_Sound_Email.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"
#property link      " Alerts added by cja"
//----
#property indicator_separate_window
//----
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_buffers 2
#property indicator_color1 LightSeaGreen
#property indicator_color2 Red
//---- input parameters
extern int KPeriod=5;
extern int DPeriod=3;
extern int Slowing=3;
extern bool SoundAlert_ON=false;
extern string SoundFile ="alert2.wav";
extern bool SendEmail=false;
extern int StochLEVEL_UP=80;
extern int StochLEVEL_DN=20;
//---- buffers
double MainBuffer[];
double SignalBuffer[];
double HighesBuffer[];
double LowesBuffer[];
//----
int draw_begin1=0;
int draw_begin2=0;
//----
#define SIGNAL_BAR 1
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//---- 2 additional buffers are used for counting.
   IndicatorBuffers(4);
   SetIndexBuffer(2, HighesBuffer);
   SetIndexBuffer(3, LowesBuffer);
//---- indicator lines
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0, MainBuffer);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1, SignalBuffer);
//---- name for DataWindow and indicator subwindow label
   string ALRT1="",ALRT2="";
   if(SoundAlert_ON==true)ALRT1="ON";
   if(SoundAlert_ON==false)ALRT1="OFF";
   if(SendEmail==true)ALRT2="ON";
   if(SendEmail==false)ALRT2="OFF";
   short_name="Sto("+KPeriod+","+DPeriod+","+Slowing+") [ Sound Alert "+ALRT1+" ] [ Email Alert "+ALRT2+" ]";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
   SetIndexLabel(1,"Signal");
//----
   draw_begin1=KPeriod+Slowing;
   draw_begin2=draw_begin1+DPeriod;
   SetIndexDrawBegin(0,draw_begin1);
   SetIndexDrawBegin(1,draw_begin2);
   SetLevelValue(0,StochLEVEL_UP);
   SetLevelValue(1,StochLEVEL_DN);
   SetLevelStyle(2,0,DarkSlateGray);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Stochastic oscillator                                            |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k;
   int    counted_bars=IndicatorCounted();
   double price;
//----
   if(Bars<=draw_begin2) return(0);
//---- initial zero
   if(counted_bars<1)
     {
      for(i=1;i<=draw_begin1;i++) MainBuffer[Bars-i]=0;
      for(i=1;i<=draw_begin2;i++) SignalBuffer[Bars-i]=0;
     }
//---- minimums counting
   i=Bars-KPeriod;
   if(counted_bars>KPeriod) i=Bars-counted_bars-1;
   while(i>=0)
     {
      double min=1000000;
      k=i+KPeriod-1;
      while(k>=i)
        {
         price=Low[k];
         if(min>price) min=price;
         k--;
        }
      LowesBuffer[i]=min;
      i--;
     }
//---- maximums counting
   i=Bars-KPeriod;
   if(counted_bars>KPeriod) i=Bars-counted_bars-1;
   while(i>=0)
     {
      double max=-1000000;
      k=i+KPeriod-1;
      while(k>=i)
        {
         price=High[k];
         if(max<price) max=price;
         k--;
        }
      HighesBuffer[i]=max;
      i--;
     }
//---- %K line
   i=Bars-draw_begin1;
   if(counted_bars>draw_begin1) i=Bars-counted_bars-1;
   while(i>=0)
     {
      double sumlow=0.0;
      double sumhigh=0.0;
      for(k=(i+Slowing-1);k>=i;k--)
        {
         sumlow+=Close[k]-LowesBuffer[k];
         sumhigh+=HighesBuffer[k]-LowesBuffer[k];
        }
      if(sumhigh==0.0) MainBuffer[i]=100.0;
      else MainBuffer[i]=sumlow/sumhigh*100;
      i--;
     }
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
//---- signal line is simple movimg average
   for(i=0; i<limit; i++)
      SignalBuffer[i]=iMAOnArray(MainBuffer,Bars,DPeriod,0,MODE_SMA,i);
   // Alert code
   static int PrevSignal=0, PrevTime=0;
   if(SIGNAL_BAR > 0 && Time[0]<=PrevTime)
      return(0);
   PrevTime=Time[0];
   if(PrevSignal<=0)
     {
      if(MainBuffer[SIGNAL_BAR]>SignalBuffer[SIGNAL_BAR])
         if (SendEmail==true)SendMail("Stochastic "+Symbol()+" M"+Period()+"","Stochastic Xrossed UP"+"\n"+Symbol()+" M"+Period()+", BUY  @ "+DoubleToStr(Bid,Digits)+"\n"
         +"Time = "+TimeToStr(TimeLocal(),TIME_SECONDS)+"\n"+"Date = "+TimeToStr(TimeLocal(),TIME_DATE)+"");
        {
         PrevSignal=1;
         if(SoundAlert_ON==true)PlaySound(SoundFile);
        }
     }
   if(PrevSignal>=0)
     {
      if(MainBuffer[SIGNAL_BAR] < SignalBuffer[SIGNAL_BAR])
         if (SendEmail==true)SendMail("Stochastic "+Symbol()+" M"+Period()+"","Stochastic Xrossed DOWN"+"\n "+Symbol()+" M"+Period()+", SELL  @ "+DoubleToStr(Bid,Digits)+"\n"
        +"Time = "+TimeToStr(TimeLocal(),TIME_SECONDS)+"\n"+"Date = "+TimeToStr(TimeLocal(),TIME_DATE)+"");
        {
         PrevSignal=-1;
         if(SoundAlert_ON==true)PlaySound(SoundFile);
        }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+