//KurlFX 2009.01.31
//+------------------------------------------------------------------+
//|	*** MTFPI-sub1 ***															|
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009,Kurl FX"
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color2 Blue

extern int FastEMA = 5;
extern int SlowEMA = 100;
extern int SignalSMA= 3;
extern int K_Period = 5;
extern int D_Period = 3;
extern int Slowing=3;

double BS[];//Buy/no/Sell sign: -1;0;1
double GS[];//Go/Stop price: Entry or LossCutPoint
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0,BS);
   SetIndexBuffer(1,GS);
   SetIndexLabel(0,"sign");
   SetIndexLabel(1,"val");
   SetIndexStyle(0,DRAW_NONE);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   double spread=MarketInfo(Symbol(),MODE_SPREAD);
   int counted_bar=IndicatorCounted();
   int limit=Bars-counted_bar;
   for(int i=limit-1; i>=0; i--)
     {
      double A=iCustom(NULL,0,"MTFPI-sub2",FastEMA,SlowEMA,SignalSMA,0,i);
      double Bb=iCustom(NULL,0,"MTFPI-sub3",K_Period,D_Period,Slowing,0,i);
      double Bs=iCustom(NULL,0,"MTFPI-sub3",K_Period,D_Period,Slowing,1,i);
      double C1=iCustom(NULL,0,"MTFPI-sub4",0,i);
      double C2=iCustom(NULL,0,"MTFPI-sub4",1,i);

      if(A>0 && Bb!=EMPTY_VALUE && C1>Bb && C2>Bb)
        {
         if(Close[i]<Bb)Bb=Bb+spread*Point;
         BS[i]=1.0;
         GS[i]=Bb;
        }
      else if(A<0 && Bs!=EMPTY_VALUE && C1<Bs && C2<Bs)
        {
         if(Close[i]<Bs)Bs=Bs+spread*Point;
         BS[i]=-1.0;
         GS[i]=Bs;
        }
      else
        {
         BS[i]=0.0;
         GS[i]=EMPTY_VALUE;
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+
