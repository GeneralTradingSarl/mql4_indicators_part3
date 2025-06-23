//+------------------------------------------------------------------+
//|                                        Relative volume trend.mq4 |
//|                                       Copyright 2020, PuguForex. |
//|                          https://www.mql5.com/en/users/puguforex |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, PuguForex."
#property link      "https://www.mql5.com/en/users/puguforex"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers    1
#property indicator_label1     "Relative volume trend"
#property indicator_type1      DRAW_LINE
#property indicator_color1     clrDodgerBlue
#property indicator_width1     2

double rvt[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
      SetIndexBuffer(0,rvt);
//---
   IndicatorSetString(INDICATOR_SHORTNAME,"Relative volume trend");
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
    int i,limit=fmin(rates_total-prev_calculated+1,rates_total-1);
//---
    for (i=limit;i>=0 && !_StopFlag; i--)
    {
     double raw = (i<rates_total-1) ? close[i]>close[i+1] ? (int)tick_volume[i] : -(int)tick_volume[i]: 0;
     rvt[i]     = (i<rates_total-1) ? rvt[i+1]+raw : 0;  
    }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
