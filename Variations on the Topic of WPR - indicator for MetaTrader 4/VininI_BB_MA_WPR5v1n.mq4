//+------------------------------------------------------------------+
//|                                          VininI_BB_MA_WPR.v1.mq4 |
//|                                                  Victor Nicolaev |
//|                                                    vinin@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright 2008. Victor Nicolaev"
#property link      "vinin@mail.ru"

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Aqua
#property indicator_color2 Green
#property indicator_color3 Yellow
#property indicator_color4 Yellow
#property indicator_level1 0
#property indicator_level2 60
#property indicator_level3 -60

#property indicator_maximum 100
#property indicator_minimum -100
//---- input parameters

extern int WPR_Period= 55;
extern int  MA_Period=3;
extern int  MA_Mode  =0;
extern int BB_Period=89;
extern double BB_Div=1.0;
extern int Limit=1440;

double WPR[];
double WPRMidle[];
double WPRUP[];
double WPRDN[];
double MA[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {
   IndicatorBuffers(5);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexDrawBegin(0,WPR_Period+MA_Period+BB_Period);
   SetIndexBuffer(0,MA);
   SetIndexBuffer(1,WPRMidle);
   SetIndexBuffer(2,WPRUP);
   SetIndexBuffer(3,WPRDN);
   SetIndexBuffer(4,WPR);
   IndicatorShortName("MA_WPR("+WPR_Period+","+MA_Period+")");
   SetIndexLabel(0,"MA(WPR)");

   return(0); }

//+------------------------------------------------------------------+
int start() {
   int limit1, limit2, limit3;
   int counted_bars=IndicatorCounted();
   int i;

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit1=Bars-counted_bars;
   if (limit1>Limit && Limit>0) limit1 = Limit;
   limit2=limit1;
   limit3=limit2;
   if (counted_bars==0) {
      limit3=limit1;
      limit2=limit3+BB_Period;
      limit1=limit2+MA_Period;
   }
   for (i = limit1;i>=0;i--) WPR[i] = (iWPR(Symbol(),Period(),WPR_Period,i)+50.0)*2.0;
   for (i = limit2;i>=0;i--) MA[i] = iMAOnArray(WPR,0,MA_Period,0,MA_Mode,i);
   double tmp, tmp0;
   for (i = limit3;i>=0;i--) {
      tmp=  (iBandsOnArray(WPR,0,BB_Period,1,0,MODE_UPPER,i)-
             iBandsOnArray(WPR,0,BB_Period,1,0,MODE_LOWER,i))/2.0;
      WPRMidle[i]=iMAOnArray(WPR,0,BB_Period,0,MODE_SMA,i);
      WPRUP[i]=WPRMidle[i]+BB_Div*tmp;
      WPRDN[i]=WPRMidle[i]-BB_Div*tmp;
   }
   return(0); 
}// int start()


