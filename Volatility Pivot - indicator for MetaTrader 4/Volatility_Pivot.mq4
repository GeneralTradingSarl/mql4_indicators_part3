//+------------------------------------------------------------------+
//|                                             Volatility.Pivot.mq4 |
//+------------------------------------------------------------------+
#property copyright "thanks to S.B.T. (Japan)"
#property link      "http://sufx.core.t3-ism.net/" //<<< convert this from VT, thanks mate !!!
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
//---- input parameters
extern double     atr_range=100;
extern double     ima_range=10;
extern double     atr_factor=3;
extern int        Mode=0;
extern double     DeltaPrice=30;
//---- buffers
double TrStop[];
double ATR[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1);
   SetIndexBuffer(0,TrStop);
   SetIndexStyle(1,DRAW_NONE);
   SetIndexBuffer(1,ATR);
//----
   string short_name="!! RisenbergVolatilityCapture";
   IndicatorShortName(short_name);
   SetIndexLabel(1,"range base");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
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
   int i;
//----
   double DeltaStop;
//----
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+1;

   for(i=0; i<limit; i++)
     {
      ATR[i]=iATR(NULL,0,atr_range,i);
     }
   for(i=limit-1; i>=0; i --)
     {
      if(Mode==0)
        {
         DeltaStop=iMAOnArray(ATR,0,ima_range,0,MODE_EMA,i)*atr_factor;
         //DeltaStop = iATR(NULL,0,atr_range,i) * atr_factor;
        }
      else
        {
         DeltaStop=DeltaPrice*Point;
        }
      if(Close[i]==TrStop[i+1])
        {
         TrStop[i]=TrStop[i+1];
        }
      else
        {
         if(Close[i+1]<TrStop[i+1] && Close[i]<TrStop[i+1])
           {
            TrStop[i]=MathMin(TrStop[i+1],Close[i]+DeltaStop);
           }
         else
           {
            if(Close[i+1]>TrStop[i+1] && Close[i]>TrStop[i+1])
              {
               TrStop[i]=MathMax(TrStop[i+1],Close[i]-DeltaStop);
              }
            else
              {
               if(Close[i]>TrStop[i+1]) TrStop[i]=Close[i]-DeltaStop; else TrStop[i]=Close[i]+DeltaStop;
              }
           }
        }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
