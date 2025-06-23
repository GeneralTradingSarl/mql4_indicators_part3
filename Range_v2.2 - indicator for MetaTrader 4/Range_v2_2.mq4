//+------------------------------------------------------------------+
//|                                                     Range_v2.mq4 |
//|                                  Copyright © 2006, Forex-TSD.com |
//|                         Written by IgorAD,igorad2003@yahoo.co.uk |   
//|            http://finance.groups.yahoo.com/group/TrendLaboratory |                                      
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, Forex-TSD.com "
#property link      "http://www.forex-tsd.com/"
//----
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 DodgerBlue
#property indicator_color2 Tomato
#property indicator_color3 Orange
#property indicator_color4 Lime
//----
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 2
#property indicator_width4 2
#property indicator_style1 2
#property indicator_style2 2
//----
extern string  TimeFrame="D1";
extern int     Shift  =0;
extern int     AjShift=0;
extern string TimeFrames="1,5,15,30;H1(60);H4;D1;W1;MN";
//----
double UpBuffer[];
double DnBuffer[];
double OpenBuffer[];
double CloseBuffer[];
int TF;
string error="Wrong TimeFrame!";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
//IndicatorBuffers(4);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,UpBuffer);
   SetIndexLabel(0,"High");
   SetIndexDrawBegin(0,0);
//
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,DnBuffer);
   SetIndexLabel(1,"Low");
   SetIndexDrawBegin(1,0);
//
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,OpenBuffer);
   SetIndexLabel(2,"Open");
   SetIndexDrawBegin(2,0);
//
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,CloseBuffer);
   SetIndexLabel(3,"Close");
   SetIndexDrawBegin(3,0);
//
   short_name="Range_v2.2("+TimeFrame+")";
   IndicatorShortName(short_name);
//----
   if(TimeFrame=="M1" || TimeFrame=="1") TF=PERIOD_M1;
   else
      if(TimeFrame=="M5" || TimeFrame=="5") TF=PERIOD_M5;
   else
      if(TimeFrame=="M15" || TimeFrame=="15")TF=PERIOD_M15;
   else
      if(TimeFrame=="M30" || TimeFrame=="30")TF=PERIOD_M30;
   else
      if(TimeFrame=="H1" || TimeFrame=="60") TF=PERIOD_H1;
   else
      if(TimeFrame=="H4" || TimeFrame=="240") TF=PERIOD_H4;
   else
      if(TimeFrame=="D1" || TimeFrame=="1440") TF=PERIOD_D1;
   else
      if(TimeFrame=="W1" || TimeFrame=="10080") TF=PERIOD_W1;
   else
      if(TimeFrame=="MN" || TimeFrame=="43200") TF=PERIOD_MN1;
   else
      if(TimeFrame=="0") TF=Period();
   else {Comment(error); TF=Period(); return(0);}
//----
   SetIndexShift(0,AjShift+Shift*TF/Period());
   SetIndexShift(1,AjShift+Shift*TF/Period());
   SetIndexShift(2,AjShift+Shift*TF/Period());
   SetIndexShift(3,AjShift+Shift*TF/Period());
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   datetime TimeArray[];
   int i=0,y=0,prevy=0;
   double LowArray[],HighArray[],OpenArray[],CloseArray[];
//----
   if(TF<Period())
     {
      //SetIndexDrawBegin(0,Bars);
      //SetIndexDrawBegin(1,Bars);
      Comment("Incorrect TimeFrame");
      return(0);
     }
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+TF/Period();;
//----
   ArrayCopySeries(TimeArray,MODE_TIME,Symbol(),TF);
   ArrayCopySeries(LowArray,MODE_LOW,Symbol(),TF);
   ArrayCopySeries(HighArray,MODE_HIGH,Symbol(),TF);
   ArrayCopySeries(OpenArray,MODE_OPEN,Symbol(),TF);
   ArrayCopySeries(CloseArray,MODE_CLOSE,Symbol(),TF);
//----
   for(i=0,y=0;i<limit;i++)
     {
      prevy=y;
      if(y<ArraySize(TimeArray)) {if(Time[i]<TimeArray[y]) y++;}
      if(y<ArraySize(HighArray)) UpBuffer[i]=HighArray[y];
      if(y<ArraySize(LowArray)) DnBuffer[i]=LowArray[y];
      if(y<ArraySize(OpenArray)) OpenBuffer[i]=OpenArray[y];
      //----

      if(y!=prevy)
        {
         if(y<ArraySize(CloseArray)) CloseBuffer[i]=CloseArray[y];
        }
      else
        {
         if(prevy<ArraySize(CloseArray)) CloseBuffer[i]=CloseArray[prevy];
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+
