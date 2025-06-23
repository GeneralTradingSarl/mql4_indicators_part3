//+------------------------------------------------------------------+
//|                               _HPCS_WPRTrend_MT4_Indi_V01_WE.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property script_show_inputs
#property indicator_buffers 2
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
input int ii_Period = 14;

double gd_Arr_BuySignal[],gd_Arr_SellSignal[];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

   SetIndexBuffer(0,gd_Arr_BuySignal);
   SetIndexStyle(0,DRAW_ARROW,STYLE_SOLID,4,clrGreen);
   SetIndexArrow(0,233);
   SetIndexLabel(0,"Buy Signal");

   SetIndexBuffer(1,gd_Arr_SellSignal);
   SetIndexStyle(1,DRAW_ARROW,STYLE_SOLID,4,clrRed);
   SetIndexArrow(1,234);
   SetIndexLabel(1,"Sell Signal");

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
   if(prev_calculated == 0)
     {
      for(int i = Bars-2 ; i>0 ; i--)
        {
         if(iWPR(_Symbol,PERIOD_CURRENT,ii_Period,i) < -20 && iWPR(_Symbol,PERIOD_CURRENT,ii_Period,i+1) >= -20 && iWPR(_Symbol,PERIOD_CURRENT,ii_Period,i) > -80)
           {
            gd_Arr_SellSignal[i] = High[i] + 2*Point();
           }
         if(iWPR(_Symbol,PERIOD_CURRENT,ii_Period,i) > -80 && iWPR(_Symbol,PERIOD_CURRENT,ii_Period,i+1) <= -80)
           {
            gd_Arr_BuySignal[i] = Low[i] - 2*Point();
           }
        }
     }

   if(iWPR(_Symbol,PERIOD_CURRENT,ii_Period,0) < -20 && iWPR(_Symbol,PERIOD_CURRENT,ii_Period, 1) >= -20 && iWPR(_Symbol,PERIOD_CURRENT,ii_Period,0) > -80)
     {
      gd_Arr_SellSignal[0] = High[0] + 2*Point();
     }
   if(iWPR(_Symbol,PERIOD_CURRENT,ii_Period,0) > -80 && iWPR(_Symbol,PERIOD_CURRENT,ii_Period, 1) <= -80)
     {
      gd_Arr_BuySignal[0] = Low[0] - 2*Point();
     }


//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
