//+------------------------------------------------------------------+
//|                                                       Stodiv.mq4 |
//|                      Copyright © 2007, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005-2006, RickD"
#property link      "http://e2e-fx.net"
//----
#property indicator_chart_window
#property indicator_buffers 2
//----
#property indicator_color1 Crimson
#property indicator_color2 DodgerBlue
//----
extern int MaxBars=300;
extern int dx=30;
extern int dy=20;
extern int KPeriod=5;
extern int DPeriod=3;
extern int Slowing=3;
//----
double buf1[];
double buf2[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  void init() 
  {
   SetIndexBuffer(0, buf1);
   SetIndexBuffer(1, buf2);
   //
   SetIndexStyle(0, DRAW_ARROW, EMPTY, 2);
   SetIndexArrow(0, 234);
   //
   SetIndexStyle(1, DRAW_ARROW, EMPTY, 2);
   SetIndexArrow(1, 233);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  void start() 
  {
   double fr0, fr1;
   double sto0, sto1;
//----
   int counted=IndicatorCounted();
   if (counted < 0) return(-1);
   if (counted > 0) counted--;
   int limit=Bars-counted;
   limit=MathMin(limit, Bars-dx);
   limit=MathMin(limit, MaxBars);
     for(int i=0; i < limit; i++) 
     {
      buf1[i]=0;
      fr0=iFractals(NULL, 0, MODE_UPPER, i+2);
      if (fr0==0) continue;
        for(int j=i+1; j < i+dx; j++) 
        {
         fr1=iFractals(NULL, 0, MODE_UPPER, j+2);
         if (fr1==0) continue;
           if (fr0 > fr1+dy*Point) 
           {
            sto0=iStochastic(NULL, 0, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, i+2);
            sto1=iStochastic(NULL, 0, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, j+2);
              if (sto0 < sto1) 
              {
               buf1[i]=High[i] + 20*Point;
               break;
              }
           }
        }
     }
     for(i=0; i < limit; i++) 
     {
      buf2[i]=0;
      fr0=iFractals(NULL, 0, MODE_LOWER, i+2);
      if (fr0==0) continue;
        for(j=i+1; j < i+dx; j++) 
        {
         fr1=iFractals(NULL, 0, MODE_LOWER, j+2);
         if (fr1==0) continue;
           if (fr0 < fr1-dy*Point) 
           {
            sto0=iStochastic(NULL, 0, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, i+2);
            sto1=iStochastic(NULL, 0, KPeriod, DPeriod, Slowing, MODE_SMA, 0, MODE_MAIN, j+2);
              if (sto0 > sto1) 
              {
               buf2[i]=Low[i] - 20*Point;
               break;
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+