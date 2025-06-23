//+------------------------------------------------------------------+
//|                                                   slow-stich.mq4 |
//|                                     Copyright © 2005, Nick Bilak |
//|                                              beluck[at]gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, Nick Bilak"

#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Lime
#property indicator_color2 Aqua
//---- input parameters
extern int PK=14;
extern int PD=5;
extern int PS=5;
//---- buffers
double k[];
double d[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,k);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,d);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   int shift,limit;
   if (counted_bars<0) return(-1);
   if (counted_bars>0) counted_bars--;
   limit=Bars-PK-1;
   if(counted_bars>=PK) limit=Bars-counted_bars-1;

     for(shift=limit;shift>=0;shift--)   {
      d[shift]=(iStochastic(NULL,0,PK,PD,PS,MODE_SMA,1,MODE_SIGNAL,shift)+iStochastic(NULL,0,PK,PD,PS,MODE_SMA,1,MODE_SIGNAL,shift+1)+iStochastic(NULL,0,PK,PD,PS,MODE_SMA,1,MODE_SIGNAL,shift+2))/3.0;
      k[shift]=(iStochastic(NULL,0,PK,PD,PS,MODE_SMA,1,MODE_MAIN,shift)+iStochastic(NULL,0,PK,PD,PS,MODE_SMA,1,MODE_MAIN,shift+1)+iStochastic(NULL,0,PK,PD,PS,MODE_SMA,1,MODE_MAIN,shift+2))/3.0;
     }
   return(0);
  }
//+------------------------------------------------------------------+