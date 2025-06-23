//+------------------------------------------------------------------+
//|                                                      job_one.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#property indicator_separate_window

#property indicator_color1 Blue
#property indicator_color2 Yellow
#property indicator_color3 Red

extern int MA_one_Period=10;
extern int MA_one_Shift=0;
extern ENUM_MA_METHOD MA_one_Method=0;

extern int MA_two_Period=20;
extern int MA_two_Shift=0;
extern ENUM_MA_METHOD MA_two_Method=0;

extern int period_RSI=14;

//---- buffers
double ExtBuffer0[], ExtBuffer1[],ExtBuffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {

   IndicatorShortName("RSI+MOVING");
   IndicatorBuffers(3);

   SetIndexBuffer(0,ExtBuffer0);
   SetIndexLabel(0,"RSI");
   SetIndexStyle(0,DRAW_LINE);

   SetIndexBuffer(1, ExtBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexLabel(1,"MA_one "+IntegerToString(MA_one_Period));
// SetIndexDrawBegin(1,period_RSI);




   SetIndexBuffer(2,ExtBuffer2);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexLabel(2,"MA_two "+IntegerToString(MA_two_Period));
// SetIndexDrawBegin(2,period_RSI);


  
     

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {

   
  
   for(int i=rates_total-prev_calculated-1; i>=0; i--)
     {

      ExtBuffer0[i] = iRSI(NULL,0,period_RSI,0,i);


      ExtBuffer1[i] = iMAOnArray(ExtBuffer0, Bars, MA_one_Period, MA_one_Shift, MA_one_Method, i);
      ExtBuffer2[i] = iMAOnArray(ExtBuffer0, Bars, MA_two_Period, MA_two_Shift, MA_two_Method, i);
     }
     
  
   return(rates_total);
  }
//+------------------------------------------------------------------+
