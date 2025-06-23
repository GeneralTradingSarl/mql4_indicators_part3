//+------------------------------------------------------------------+
//|                                                       RPoint.mq4 |
//|                               Copyright © 2004, Poul_Trade_Forum |
//|                                                         Aborigen |
//|                                          http://forex.kbpauk.ru/ |
//+------------------------------------------------------------------+
#property copyright "Poul Trade Forum"
#property link      "http://forex.kbpauk.ru/"
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red
//---- input parameters
extern int ReversPoint=50;
//---- buffers
double RBuffer[];
int Trend=1,InTrend;
datetime ttime;
double Points,Last_High,Last_Low;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
   Points=MarketInfo(Symbol(),MODE_POINT);
//---- indicator line
   SetIndexStyle(0,DRAW_SECTION,EMPTY,1,Tan);
   SetIndexBuffer(0,RBuffer);
   SetIndexEmptyValue(0,0);
//---- name for DataWindow and indicator subwindow label
   short_name="RPoint";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//----
   SetIndexDrawBegin(0,100);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int shift;
//---- TODO: add your code here
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+1;
//----
   for(shift=limit; shift>=0;shift--)
     {
      if(Time[shift]!=ttime) InTrend=InTrend+1;
      ttime=Time[shift];
      RBuffer[shift]=0;
      if(High[shift+1]>Last_High && Trend==1)  InTrend=1;
      if(Low[shift+1]<Last_Low   && Trend==0)   InTrend=1;
      if(High[shift+1]>Last_High) Last_High=High[shift+1];
      if(Low[shift+1]<Last_Low) Last_Low=Low[shift+1];
      //----
      if(Trend==1 && Low[shift+1]<Last_High-ReversPoint*Points && InTrend>1)
        {
         Trend=0;
         //RBuffer[shift+InTrend]=High[shift+InTrend];
         if(shift+InTrend<ArraySize(RBuffer)) RBuffer[shift+InTrend]=High[shift+InTrend];
         Last_High=Low[shift+1];
         Last_Low=Low[shift+1];
         InTrend=1;
        }
      if(Trend==0 && High[shift+1]>Last_Low+ReversPoint*Points && InTrend>1)
        {
         Trend=1;
         //RBuffer[shift+InTrend]=Low[shift+InTrend];
         if(shift+InTrend<ArraySize(RBuffer)) RBuffer[shift+InTrend]=Low[shift+InTrend];
         Last_Low=High[shift+1];
         Last_High=High[shift+1];
         InTrend=1;
        }
      //----
     }
   return(0);
  }
//+------------------------------------------------------------------+
