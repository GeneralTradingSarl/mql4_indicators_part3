//+------------------------------------------------------------------+
//|                                       SVS_Oscillator 03.05.2008. |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010"
#property link      ""
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_color3 Brown
#property indicator_color4 Green

extern int period=1;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM,0,2);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM,0,2);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_HISTOGRAM,0,2);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_HISTOGRAM,0,2);
   SetIndexBuffer(3,ExtMapBuffer4);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+   
int start()
  {
   double d1,d11,d111;
   double a1,a11,a111,a1111,a2,a22,a222,a2222,a3,a33,a333,a3333;
   double a4,a44,a444,a4444,a5,a55,a555,a5555,a6,a66,a666,a6666;
   double z,m1,m2,m3,m4,m5,mp1,mp2,mp3,mp11,mp22,mp33;
   int pp1,pp2,pp3,pp4,p1,p2,p3,p4,p5,MODE;
   
   if (period==1) {p1=5;p2=15;p3=60;p4=240;p5=1440;}
   if (period==2) {p1=3;p2=12;p3=48;p4=288;p5=1440;}   
   if (period==3) {p1=4;p2=16;p3=96;p4=480;p5=1920;}   
   if (period==4) {p1=4;p2=24;p3=120;p4=480;p5=1920;}   
   if (period==5) {p1=6;p2=30;p3=120;p4=480;p5=1920;}   
   if (period==6) {p1=5;p2=20;p3=80;p4=320;p5=1280;}   
   if (period==7) {p1=4;p2=16;p3=64;p4=256;p5=1024;}   
   if (period==8) {p1=4;p2=16;p3=64;p4=256;p5=1024;}
   
   pp1=(p1+p2);pp2=(p2+p3);pp3=(p3+p4);
   
   int limit;
   int counted_bars=IndicatorCounted();
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars-1;
   for(int i=0;i<=limit;i++){          
//------------------------------------------------------
      MODE=0;
      z=iMA(NULL,0,1,0,MODE,PRICE_WEIGHTED,i);      
      m1=iMA(NULL,0,p1,0,MODE,PRICE_WEIGHTED,i);
      m2=iMA(NULL,0,p2,0,MODE,PRICE_WEIGHTED,i);
      m3=iMA(NULL,0,p3,0,MODE,PRICE_WEIGHTED,i);
      m4=iMA(NULL,0,p4,0,MODE,PRICE_WEIGHTED,i);      
      mp1=iMA(NULL,0,pp1,0,MODE,PRICE_WEIGHTED,i);
      mp11=iMA(NULL,0,pp1/2,0,MODE,PRICE_WEIGHTED,i);
      mp2=iMA(NULL,0,pp2,0,MODE,PRICE_WEIGHTED,i);
      mp22=iMA(NULL,0,pp2/2,0,MODE,PRICE_WEIGHTED,i);
      mp3=iMA(NULL,0,pp3,0,MODE,PRICE_WEIGHTED,i);
      mp33=iMA(NULL,0,pp3/2,0,MODE,PRICE_WEIGHTED,i);
      //-----------------------------------------                                             
      a1=(m1+m2)/2;
      a2=(mp1+z)/2;           
      a3=a1-mp11;
      a4=a2-mp11;
      a5=a2-a1;
      a6=m1-m2;
      d1=(a3+a4+a5+a6);
//---------      
      a11=(m2+m3)/2;
      a22=(mp2+z)/2;           
      a33=a11-mp22;
      a44=a22-mp22;
      a55=a22-a11;
      a66=m2-m3;
      d11=(a33+a44+a55+a66);
//---------      
      a111=(m3+m4)/2;
      a222=(mp3+z)/2;           
      a333=a111-mp33;
      a444=a222-mp33;
      a555=a222-a111;
      a666=m3-m4;
      d111=(a333+a444+a555+a666);
//---------          
      if (d1>0 && d11<0) ExtMapBuffer1[i]=d1;
      if (d1<0 && d11>0) ExtMapBuffer2[i]=d1;
      
      if (d1>0 && d11>0) ExtMapBuffer2[i]=d1;
      if (d1<0 && d11<0) ExtMapBuffer1[i]=d1;
      
      if (d11>0 && d111>0) ExtMapBuffer3[i]=d1;
      if (d11<0 && d111<0) ExtMapBuffer4[i]=d1;
      
      if (d1>0 && d11>0) ExtMapBuffer2[i]=d1;
      if (d1<0 && d11<0) ExtMapBuffer1[i]=d1;
      
      if (d1>0 && d11<0) ExtMapBuffer1[i]=d1;
      if (d1<0 && d11>0) ExtMapBuffer2[i]=d1;
      
   }
   return(0);
  }
//+--------------------------------+