//+------------------------------------------------------------------+
//|                                  _HPCS_Tenth_MT4_Indi_V01_WE.mq4 |
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

double gd_Arr_SellSignal[], gd_Arr_BuySignal[]/*gd_Arr_NeutralSignal[]*/;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

   SetIndexBuffer(0,gd_Arr_SellSignal);
   SetIndexStyle(0,DRAW_ARROW,STYLE_SOLID,3,clrRed);
   SetIndexArrow(0,253);

   SetIndexBuffer(1,gd_Arr_BuySignal);
   SetIndexStyle(1,DRAW_ARROW,STYLE_SOLID,3,clrGreen);
   SetIndexArrow(1,254);
   /*
   SetIndexBuffer(1,gd_Arr_NeutralSignal);
   SetIndexStyle(1,DRAW_ARROW,STYLE_SOLID,3,clrWhite);
   SetIndexArrow(1,168);
   */
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
   for(int i = Bars-2 ; i>=0 ; i--)
     {
      if(iStochastic(Symbol(),PERIOD_CURRENT,5,3,3,MODE_SMA,0,MODE_MAIN,i)>iStochastic(Symbol(),PERIOD_CURRENT,5,3,3,MODE_SMA,0,MODE_SIGNAL,i))
     {
      gd_Arr_BuySignal[i] = Low[i]-Point()*5;
     }
      if(iStochastic(Symbol(),PERIOD_CURRENT,5,3,3,MODE_SMA,0,MODE_MAIN,i)<iStochastic(Symbol(),PERIOD_CURRENT,5,3,3,MODE_SMA,0,MODE_SIGNAL,i))
     {
      gd_Arr_SellSignal[i]= High[i]+Point()*5;
     }
     /* if(iStochastic(Symbol(),PERIOD_CURRENT,5,3,3,MODE_SMA,0,MODE_MAIN,i) == iStochastic(Symbol(),PERIOD_CURRENT,5,3,3,MODE_SMA,0,MODE_SIGNAL,i))
     {
         gd_Arr_NeutralSignal[i] = Open[i];
     }*/
     }
}
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
