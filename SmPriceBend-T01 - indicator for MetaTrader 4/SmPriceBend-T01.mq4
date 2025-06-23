//+------------------------------------------------------------------+
//| MQL to MQ4 by Maloma                         SmPriceBend-T01.mq4 |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, HomeSoft-Tartan Corp."
#property  link     "spiky@sinet.spb.ru"
//----
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Gold
#property indicator_color2 Red
//---- indicator parameters
extern int mBar=3000;
extern int per=21;
extern int t3_period=6;
extern double b=0.7;
extern double up=1;
extern double um=-1;
//---- indicator buffers
double Buffer1[];
double Buffer2[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
//---- indicator buffers mapping  
   SetIndexBuffer(0,Buffer1);
   SetIndexBuffer(1,Buffer2);
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE,EMPTY,2);
   SetIndexArrow(0,217);
   SetIndexStyle(1,DRAW_LINE,EMPTY,2);
   SetIndexArrow(1,218);
//----
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
//---- name for DataWindow
   SetIndexLabel(0,"1st");
   SetIndexLabel(1,"2nd");
//---- initialization done   
   IndicatorShortName("PriceBend-T01");
   return(0);
  }
double e1,e2,e3,e4,e5,e6,c1,c2,c3,c4,n,w1,w2,b2,b3;
double matwo,manul,bend,trig=0.0001,t3_21,t3_120;
int shift;
bool ft=true;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   if (ft)
     {
      b2=b*b;
      b3=b2*b;
      c1=-b3;
      c2=(3*(b2+b3));
      c3=-3*(2*b2+b+b3);
      c4=(1+3*b+b3+3*b2);
      n=t3_period;
//-----
      if (n<1) n=1;
      n=1 + 0.5*(n-1);
      w1=2/(n + 1);
      w2=1 - w1;
      ft=false;
     }
//----
   for(shift=mBar;shift>=0;shift--)
     {
      matwo=iMA(Symbol(),0,per,0,MODE_SMA,PRICE_CLOSE,shift+2);
      manul=iMA(Symbol(),0,per,0,MODE_SMA,PRICE_CLOSE,shift);
//----
      bend=(manul-matwo)/Point;
//----
      e1=w1*bend + w2*e1;
      e2=w1*e1 + w2*e2;
      e3=w1*e2 + w2*e3;
      e4=w1*e3 + w2*e4;
      e5=w1*e4 + w2*e5;
      e6=w1*e5 + w2*e6;
//----
      t3_21=c1*e6 + c2*e5 + c3*e4 + c4*e3;
//----
      if (t3_21==0) t3_21=0.0001;
      Buffer1[shift]=t3_21;
      //n120=(n120nul-n120two)/point;
      //if n120=0 then n120=0.0001;
      if (t3_21>0) {trig=up;} else {trig=um;}
      Buffer2[shift]=trig;
     }
  }
//+------------------------------------------------------------------+