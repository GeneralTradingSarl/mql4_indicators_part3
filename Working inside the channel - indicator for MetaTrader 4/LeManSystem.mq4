//+------------------------------------------------------------------+
//|                                                        LeMan.mq4 |
//|                                         Copyright © 2009, LeMan. |
//|                                                 b-market@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, LeMan."
#property link      "b-market@mail.ru"
//----
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_color3 Green
#property indicator_color4 Red
#property indicator_width1 3
#property indicator_width2 3
//----
extern int    N=12;
//----
double OpenUp[];
double OpenDown[];
double StopUp[];
double StopDn[];
//+------------------------------------------------------------------+
int init() 
  {
//----
   IndicatorDigits(Digits);
   IndicatorBuffers(4);
//----      
   SetIndexBuffer(0,OpenUp);
   SetIndexBuffer(1,OpenDown);
   SetIndexBuffer(2,StopUp);
   SetIndexBuffer(3,StopDn);

   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,159);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,159);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexStyle(3,DRAW_LINE);
//----      
   return(0);
  }
//+------------------------------------------------------------------+
int start() 
  {
   int i,limit;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+2;

   for(i=0; i<limit; i++) 
     {
      OpenUp[i]=0;
      OpenDown[i]= 0;
      double hl1 = iLow(NULL,0,iHighest(NULL,0,MODE_LOW,N,i+1));
      double hl2 = iLow(NULL,0,iHighest(NULL,0,MODE_LOW,N,i+2));
      double lh1 = iHigh(NULL,0,iLowest(NULL,0,MODE_HIGH,N,i+1));
      double lh2 = iHigh(NULL,0,iLowest(NULL,0,MODE_HIGH,N,i+2));
      if(Low[i+2]<=lh2 && Low[i+1]>lh1) 
        {
         OpenUp[i]= High[i+1]+Point;
        }
      if(High[i+2]>=hl2 && High[i+1]<hl1) 
        {
         OpenDown[i]=Low[i+1]-Point;
        }
      StopUp[i] = iLow(NULL,0,iLowest(NULL,0,MODE_LOW,N,i+1));
      StopDn[i] = iHigh(NULL,0,iHighest(NULL,0,MODE_HIGH,N,i+1));
     }

//----
   return(0);
  }
//+------------------------------------------------------------------+
