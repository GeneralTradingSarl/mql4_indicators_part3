//+------------------------------------------------------------------+
//|                                                  SMA_Channel.mq4 |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Lungile."
#property version   "1.00"
#property strict

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 clrGold
#property  indicator_width1  2
#property indicator_color2 clrBlue
#property  indicator_width2  2

extern int InpMaPeriod   = 10; //Period
extern int InpPlotStyle  = 2; //Indicator Plot Style(1= Line, 2=Bars)

//Indicator Buffers
double BufferDn[];//Buffer for down trend
double BufferUP[];//Buffer for down trend
double BufferHl[];//Buffer for distance between Up and Dn: This buffer has empty plot

#define Indicator       0
#define Indicator1      1
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//Check for incorrect parameters for indicator...
//This is only used to govern user not to input value out side the range by dev expectations
   if(InpPlotStyle > 2 || InpPlotStyle < 1)
     {
      Alert("Plot is greater than 2 or less than 1: Use only 1 or 2");
      return INIT_PARAMETERS_INCORRECT;
     }
//--- indicator buffers mapping
   SetIndexStyle(Indicator,InpPlotStyle);
   SetIndexBuffer(0, BufferDn);
   SetIndexStyle(Indicator1,InpPlotStyle);
   SetIndexBuffer(1, BufferUP);
//---------------------------------
   SetIndexBuffer(2, BufferHl);
//---------------------------------
   SetIndexLabel(0, "Downward");
   SetIndexLabel(1, "Upward");
   SetIndexLabel(2, NULL);
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
   if(rates_total<=InpMaPeriod)
      return 0;
   int count = (prev_calculated==0)? (rates_total-InpMaPeriod-1): (rates_total-prev_calculated+1);
   for(int i=count; i>=0; i--)
     {
      double smaHigh = iMA(Symbol(), Period(), InpMaPeriod, 0,MODE_SMA, PRICE_HIGH, i);
      double smaLow = iMA(Symbol(), Period(), InpMaPeriod, 0,MODE_SMA, PRICE_LOW, i);

      BufferHl[i] = close[i] > smaHigh ? 1 : close[i] < smaLow ? -1 : BufferHl[i+1];
      BufferDn[i] = BufferHl[i] < 0 ? smaHigh : smaLow;
      BufferUP[i] = BufferHl[i] < 0 ? smaLow : smaHigh;
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
