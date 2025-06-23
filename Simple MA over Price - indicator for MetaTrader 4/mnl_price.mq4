//+------------------------------------------------------------------+
//|                                                    mnl_price.mq4 |
//|                                    Copyright © 2011, EADeveloper |
//|                                                                  |
//+------------------------------------------------------------------+



#property copyright "Copyright © 2011, EADeveloper"
#property link      ""

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Gold

extern int Alpha=3;
extern int MAPeriodeFast=3;
extern int MAPeriode=25;


//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
IndicatorBuffers(3);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer2);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer3);
   SetIndexBuffer(2,ExtMapBuffer1);
   IndicatorShortName("mnl_price"); 

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
   double v0=0;double v1=0;
   double a1;
   int limit;
   
     int counted_bars=IndicatorCounted();
     if(counted_bars<0) return(-1);
     if(counted_bars>0) counted_bars--;
     limit=Bars-counted_bars;
   for(int i=0; i<limit; i++)
   {
   v0=Close[i];
   v1=Close[i+Alpha];   
   if (v0>0&&v1>0)
   {
   a1=(v0/(v1/100));
   ExtMapBuffer1[i]=(a1-100);
   }
   }
   for(int z=0; z<limit; z++)
   {
   ExtMapBuffer2[z]=iMAOnArray(ExtMapBuffer1,0,MAPeriodeFast,0,MODE_SMA,z) ; 
   }
   for(z=0; z<limit; z++)
   {
   ExtMapBuffer3[z]=iMAOnArray(ExtMapBuffer1,0,MAPeriode,0,MODE_EMA,z) ; 
   }
   return(0);
  }
//+------------------------------------------------------------------+