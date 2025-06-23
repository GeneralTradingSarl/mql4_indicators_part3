//+---------------------------------------------------------------+
//|                               Time Segmented Volume - TSV.mq4 |
//|                                                               |
//| www.tradingview.com/script/6GR4ht9X-Time-Segmented-Volume/    |
//+---------------------------------------------------------------+
#property description "Code by Max Michael 2022"
#property indicator_separate_window
#property indicator_buffers 5
#property indicator_color1  clrRed
#property indicator_width1  3
#property indicator_color2  clrGreen
#property indicator_width2  3
#property indicator_color5  clrGold
#property indicator_width5  2
#property strict

extern int                     Length = 13;
extern int                  Smoothing = 7;
input ENUM_MA_METHOD       SmoothMode = MODE_SMA;   
input  int                    MaxBars = 500; 

double    MA1[],MA2[],B1[],B2[],B3[];

int OnInit()
{
   if(Length<=0)    Length=13;
   if(Smoothing<=0) Smoothing=1;
   SetIndexBuffer(0,MA1); SetIndexStyle(0,DRAW_HISTOGRAM); SetIndexLabel(0,"TSV Down");
   SetIndexBuffer(1,MA2); SetIndexStyle(1,DRAW_HISTOGRAM); SetIndexLabel(1,"TSV Up"); 
   SetIndexBuffer(2,B1);  SetIndexStyle(2,DRAW_NONE); SetIndexEmptyValue(2,0.0); SetIndexLabel(2,"");
   SetIndexBuffer(3,B2);  SetIndexStyle(3,DRAW_NONE); SetIndexEmptyValue(3,0.0); SetIndexLabel(3,"");
   SetIndexBuffer(4,B3);  SetIndexStyle(4,DRAW_LINE);
	IndicatorShortName("TSV "+"("+(string)Length+","+(string)Smoothing+")");
   IndicatorDigits(4);
   return(INIT_SUCCEEDED);
}

int start() 
{
   int counted = IndicatorCounted();
   if (counted < 0) return(-1);
   int limit = Bars-counted-1;
   if (limit > MaxBars) limit=MathMin(MaxBars,Bars-1);
   
   // Volume selective averaging
   for (int i=limit; i>=0; i--)
   {
      double sum=0.0;
      for (int j=i; j<(Length+i); j++) sum += Close[i]>Close[i+1] ? Volume[i]*(Close[i]-Close[i+1]) : Close[i]<Close[i+1] ? Volume[i]*(Close[i]-Close[i+1]) : 0; 
      B1[i]=sum;
   }
   // Smoothing
   for (int i=limit; i>=0; i--)
   {
      B2[i]=iMAOnArray(B1,0,Smoothing,0,SmoothMode,i);
      B3[i]=iMAOnArray(B2,0,Smoothing,0,MODE_SMA,i);
   }
   // Histogram
   for (int i=limit; i>=0; i--)
   {
        if(B2[i]<0) MA1[i]=B2[i];
        else        MA2[i]=B2[i];
   }
   return(0);
}
