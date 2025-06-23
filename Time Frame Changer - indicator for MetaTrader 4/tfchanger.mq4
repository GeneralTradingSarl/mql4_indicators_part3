//+------------------------------------------------------------------+
//|                                                    TFChanger.mq4 |
//|                                 Copyright 2020, Philippe RAVIART |
//|                                      philipperaviart@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Philippe RAVIART"
#property link      "philipperaviart@hotmail.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
      long chartIds[];
      long chartId;
      if (GetChartIds(chartIds))
      {
         for(int i = ArraySize(chartIds) - 1; i >= 0; i--)
         {
            chartId = chartIds[i];
            if (ChartSetSymbolPeriod(chartId, ChartSymbol(chartId), Period()))
               ChartRedraw(chartId);
         }
      }

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetChartIds(long &chartIds[])
{
   int i = 0;
   long chartId = ChartFirst();
   while (chartId >= 0)
   {
      if (ArrayResize(chartIds, i+1) < 0) return(false);
      chartIds[i] = chartId;
      chartId = ChartNext(chartId);
      i++;
   }
   if (ArraySize(chartIds) > 0)
   {
      return true;
   }
   return false;
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
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
