//+------------------------------------------------------------------+
//|                                           Ticks Volume Indicator |
//|                                         Copyright © William Blau |
//|                                    Coded/Verified by Profitrader |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, Profitrader."
#property link      "profitrader@inbox.ru"
//-----
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red
//---- input parameters
extern int r=12;
extern int s=12;
extern int u=5;
//---- buffers
double TVI[];
double UpTicks[];
double DownTicks[];
double EMA_UpTicks[];
double EMA_DownTicks[];
double DEMA_UpTicks[];
double DEMA_DownTicks[];
double TVI_calculate[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorShortName("TVI("+r+","+s+","+u+")");
   IndicatorBuffers(8);
   SetIndexBuffer(0,TVI);
   SetIndexBuffer(1,UpTicks);
   SetIndexBuffer(2,DownTicks);
   SetIndexBuffer(3,EMA_UpTicks);
   SetIndexBuffer(4,EMA_DownTicks);
   SetIndexBuffer(5,DEMA_UpTicks);
   SetIndexBuffer(6,DEMA_DownTicks);
   SetIndexBuffer(7,TVI_calculate);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexLabel(0,"TVI");
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
//| Ticks Volume Indicator                                           |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
//----
   for(i=0; i<limit; i++)
     {
      UpTicks[i]=(Volume[i]+(Close[i]-Open[i])/Point)/2;
      DownTicks[i]=Volume[i]-UpTicks[i];
     }
   for(i=limit-1; i>=0; i--)
     {
      EMA_UpTicks[i]=iMAOnArray(UpTicks,0,r,0,MODE_EMA,i);
      EMA_DownTicks[i]=iMAOnArray(DownTicks,0,r,0,MODE_EMA,i);
     }
   for(i=limit-1; i>=0; i--)
     {
      DEMA_UpTicks[i]=iMAOnArray(EMA_UpTicks,0,s,0,MODE_EMA,i);
      DEMA_DownTicks[i]=iMAOnArray(EMA_DownTicks,0,s,0,MODE_EMA,i);
     }
   for(i=0; i<limit; i++)
      TVI_calculate[i]=100.0*(DEMA_UpTicks[i]-DEMA_DownTicks[i])/(DEMA_UpTicks[i]+DEMA_DownTicks[i]);
   for(i=limit-1; i>=0; i--)
      TVI[i]=iMAOnArray(TVI_calculate,0,u,0,MODE_EMA,i);
//----
   return(0);
  }
//+------------------------------------------------------------------+