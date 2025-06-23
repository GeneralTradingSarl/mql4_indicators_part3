//+------------------------------------------------------------------+
//|                                                       RSI_TS.mq4 |
//|                                               Yuriy Tokman (YTG) |
//|                                               http://ytg.com.ua/ |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman (YTG)"
#property link      "http://ytg.com.ua/"
#property version   "1.00"
#property strict
#property indicator_separate_window

#property indicator_minimum    0
#property indicator_maximum    100
#property indicator_buffers    2
#property indicator_color1     DodgerBlue
#property indicator_level1     30.0
#property indicator_level2     70.0
#property indicator_levelcolor clrSilver
#property indicator_levelstyle STYLE_DOT
#property indicator_color2     clrRed
//--- input parameters
input int InpRSIPeriod=14; // RSI Period
input int OverboughtLevels=70;
input int OversoldLevels=30;
//--- buffers
double ExtRSIBuffer[];
double ExtARWBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   string short_name;
//--- 2 additional buffers are used for counting.
   SetIndexBuffer(0,ExtRSIBuffer);
   SetIndexBuffer(1,ExtARWBuffer);
//--- indicator line
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,116);
//--- name for DataWindow and indicator subwindow label
   short_name="RSI_TS("+string(InpRSIPeriod)+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//--- check for input
   if(InpRSIPeriod<2)
     {
      Print("Incorrect value for input variable InpRSIPeriod = ",InpRSIPeriod);
      return(INIT_FAILED);
     }
//---
   SetIndexDrawBegin(0,InpRSIPeriod);
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
   double rsi_0,rsi_1;
   int limit=rates_total-prev_calculated-1;
   if(prev_calculated==0)limit--;
   else  limit++;
   for(int i=limit; i>=0 && !IsStopped(); i--)
     {
      rsi_0 = iRSI(Symbol(),0,InpRSIPeriod,0,i);
      rsi_1 = iRSI(Symbol(),0,InpRSIPeriod,0,i+1);
      ExtRSIBuffer[i]=rsi_0;
      if(rsi_1>OverboughtLevels || rsi_1<OversoldLevels)ExtARWBuffer[i+1]=rsi_1+5;
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
