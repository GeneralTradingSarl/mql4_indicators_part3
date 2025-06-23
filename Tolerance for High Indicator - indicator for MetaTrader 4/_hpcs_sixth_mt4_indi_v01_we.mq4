//+------------------------------------------------------------------+
//|                                  _HPCS_Sixth_MT4_Indi_V01_WE.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 2 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
input int igi_Tolerence = 10;
double gd_Arr1_ArrowBuffer[];
double gd_Arr2_ArrowBuffer[];


int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,gd_Arr1_ArrowBuffer);
   SetIndexStyle(0,DRAW_ARROW,STYLE_DASH,2,clrBlue);
   SetIndexArrow(0,241);
   
   SetIndexBuffer(1,gd_Arr2_ArrowBuffer);
   SetIndexStyle(1,DRAW_ARROW,STYLE_DASH,2,clrBlue);
   SetIndexArrow(1,242);
   
   
//---
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
//---

   double Price_Difference = MathAbs(High[0] - High[1])/ Point();
   if(Price_Difference>igi_Tolerence)
   {
   gd_Arr1_ArrowBuffer[0] = High[1];
   }
   else 
   {
   gd_Arr2_ArrowBuffer[1] = Low[1];
   }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
