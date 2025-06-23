//+------------------------------------------------------------------+
//|                                                         OSMA.mq4 |
//|  9 но€бр€ 2008г.                                    Yuriy Tokman |
//| ICQ#:481-971-287                           yuriytokman@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman"
#property link      "yuriytokman@gmail.com"

#property indicator_separate_window
#property indicator_buffers 2

#property indicator_color1 Lime
#property indicator_color2 Red

extern int  fast_ema_period  =12;
extern int  slow_ema_period  = 26;
extern int  signal_period    = 9;
extern int  applied_price    = 0;
extern int  barsToProcess    =200;     
extern bool wav = true;      

double Buf0[];
double Buf1[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
       SetIndexBuffer(0,Buf0);
       SetIndexBuffer(1,Buf1);
       
       SetIndexStyle(0,DRAW_HISTOGRAM,0,2);
       SetIndexStyle(1,DRAW_HISTOGRAM,0,2);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted(),
//----
   limit;
   int i=0; 
   if(counted_bars>0)counted_bars--;
   limit=Bars-counted_bars;
   if(limit>barsToProcess)limit=barsToProcess;

   while (i<limit)
   {
     double x0 = iOsMA(NULL,60,fast_ema_period,slow_ema_period,signal_period,applied_price,i) ;
     double x1 = iOsMA(NULL,60,fast_ema_period,slow_ema_period,signal_period,applied_price,i+1) ;
     double x2 = iOsMA(NULL,60,fast_ema_period,slow_ema_period,signal_period,applied_price,i+2) ;
     
     if (x0>x1)Buf0[i]=x0;else Buf0[i]=0;
     if (x0<x1)Buf1[i]=x0;else Buf1[i]=0;
     if (wav==true)
       {
        if ( x2>x1 && x1<x0){Alert("Probably Buy\n\" Indicators to order e-mail: yuriytokman@gmail.com \"\nprice= ", Open[i]);}
        if ( x2<x1 && x1>x0){Alert("Probably Sell\n\" Indicators to order ISQ#:481-971-287 \"\nprice= ", Open[i]);}
       }
    i++;
   } 
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+