//+------------------------------------------------------------------+
//|                                                        RPr-E.mq4 |
//|                      Copyright © 2006, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property strict
#property copyright "Copyright © 2006, HomeSoft-Tartan Corp."
#property link      "spiky@yranskeino.ru"
//----
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 clrRed
//----
input int t3_period=21;
double b=0.7;
input int mBar=300;
//---- buffers
double ExtMapBuffer1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   double e1=0, e2=0, e3=0, e4=0, e5=0, e6=0;
   double c1, c2, c3, c4, n, w1, w2, b2, b3;
   double dpo, t3;
//----
   b2=b*b;
   b3=b2*b;
   c1=-b3;
   c2=(3*(b2+b3));
   c3=-3*(2*b2+b+b3);
   c4=(1+3*b+b3+3*b2);
   n=t3_period;
//----
   if (n<1) n=1;
   n=1 + 0.5*(n-1);
   w1=2/(n + 1);
   w2=1 - w1;
   int limit=mBar;
   if(limit>Bars) limit=Bars-1;
   for(int i=limit; i>=0; i--)
     {
      dpo=Close[i];
//----
      e1=w1*dpo + w2*e1;
      e2=w1*e1 + w2*e2;
      e3=w1*e2 + w2*e3;
      e4=w1*e3 + w2*e4;
      e5=w1*e4 + w2*e5;
      e6=w1*e5 + w2*e6;
      t3=c1*e6 + c2*e5 + c3*e4 + c4*e3;
      ExtMapBuffer1[i]=t3;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+