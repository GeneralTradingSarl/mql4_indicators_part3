//+------------------------------------------------------------------+
//|                                       Relative Strength Levy.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com/en/users/hairi"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers    1
#property indicator_levelcolor clrSilver
#property indicator_levelstyle STYLE_DOT
#property indicator_label1    "RSL"
#property indicator_level1    1.0
#property indicator_color1    DodgerBlue
#property indicator_type1     DRAW_LINE

// --- Input Variable ------------------------------------------------------------------
input int InpMAPeriod               = 14;          // MA Period
input ENUM_MA_METHOD InpMAMethod    = MODE_SMA;    // MA Method
input ENUM_APPLIED_PRICE InpMAPrice = PRICE_CLOSE; // MA Applied Price

// --- Indicator Buffer ----------------------------------------------------------------
double Buffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,Buffer);
   string sShortName="RSL("+IntegerToString(InpMAPeriod)+")";
   IndicatorShortName(sShortName);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Relative Strength Levy indicator                                 |
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
   if(!VerifyHistory()) return(prev_calculated);
   int bars = rates_total-1;
   if(prev_calculated>0) bars = rates_total - prev_calculated;
   for(int i=0; i<bars; i++) Buffer[i] = Close[i]/iMA(_Symbol,0,InpMAPeriod,0,InpMAMethod,InpMAPrice,i);

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

bool VerifyHistory(string symbol = NULL) {
   if(symbol==NULL) symbol=_Symbol;
   bool x = true;
   datetime ArrayTime[];
   ArraySetAsSeries(ArrayTime,true);
   int copied = CopyTime(symbol,PERIOD_M1,0,2,ArrayTime);
   if(copied<0) x = false;
   return x;
}