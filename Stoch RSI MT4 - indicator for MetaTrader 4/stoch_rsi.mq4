//+------------------------------------------------------------------+
//|                                                    Stoch RSI.mq4 |
//|                                    Copyright 2020, Hossein Nouri |
//|                           https://www.mql5.com/en/users/hsnnouri |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Hossein Nouri"
#property description "Fully Coded By Hossein Nouri"
#property description "Email : hsn.nouri@gmail.com"
#property description "Skype : hsn.nouri"
#property description "Telegram : @hypernova1990"
#property description "Website : http://www.metatraderprogrammer.ir"
#property description "MQL5 Profile : https://www.mql5.com/en/users/hsnnouri"
#property description " "
#property description "Feel free to contact me for MQL4/MQL5 coding."
#property link      "https://www.mql5.com/en/users/hsnnouri"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_buffers 2
#property indicator_plots   2
#property indicator_level1     20.0
#property indicator_level2     80.0
#property indicator_levelcolor clrSilver
#property indicator_levelstyle STYLE_DOT

//--- plot Main
#property indicator_label1  "K"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrDodgerBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot Signal
#property indicator_label2  "D"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrOrangeRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

input int                     InpStockKPeriod               = 3;                                   // K
input int                     InpStockDPeriod               = 3;                                   // D
input int                     InpRSIPeriod                  = 14;                                  // RSI Period
input int                     InpStochastikPeriod           = 14;                                  // Stochastic Period
input ENUM_APPLIED_PRICE      InpRSIAppliedPrice            = PRICE_CLOSE;                         // RSI Applied Price

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
double         KBuffer[];
double         DBuffer[];
double         RSIBuffer[];
double         StochBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   IndicatorBuffers(4);
   IndicatorDigits(_Digits);
//--- indicator buffers mapping
   SetIndexBuffer(0,KBuffer);
   SetIndexBuffer(1,DBuffer);
   SetIndexBuffer(2,RSIBuffer);
   SetIndexBuffer(3,StochBuffer);

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
   int limit=prev_calculated==0?rates_total-(InpRSIPeriod+1):rates_total-prev_calculated+1;

   for(int i=limit; i>=0; i--)
   {
      RSIBuffer[i]=iRSI(_Symbol,_Period,InpRSIPeriod,InpRSIAppliedPrice,i);
      if(i<rates_total-(InpRSIPeriod+2))                 StochBuffer[i]=Stoch(RSIBuffer, RSIBuffer, RSIBuffer, InpStochastikPeriod,i,rates_total);
      if(StochBuffer[i+InpStockKPeriod-1]!=EMPTY_VALUE)  KBuffer[i]=SimpleMA(i,InpStockKPeriod,StochBuffer,rates_total);
      if(KBuffer[i+InpStockDPeriod-1]!=EMPTY_VALUE)      DBuffer[i]=SimpleMA(i,InpStockDPeriod,KBuffer,rates_total);
   }
//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+
//| calculating stochastic                                           |
//+------------------------------------------------------------------+
double Stoch(const double &source[], double &high[], double &low[], int length, int shift, const int &rates_total)
{
   if(shift+length>=rates_total)           return EMPTY_VALUE;

   double Highest = Highest(high,length,shift);
   double Lowest = Lowest(low,length,shift);
   if(Highest-Lowest==0)         return EMPTY_VALUE;
   return 100 * (source[shift] - Lowest) / (Highest-Lowest);
}
//+------------------------------------------------------------------+
//| find lowest value in prev. X periods                             |
//+------------------------------------------------------------------+
double Lowest(double &low[], int length, int shift)
{
   double Result=0;
   for(int i=shift; i<=shift+length; i++)
   {
      if(Result==0 || (low[i]<Result && low[i]!=EMPTY_VALUE))
      {
         Result=low[i];
      }
   }

   return Result;
}
//+------------------------------------------------------------------+
//| find highest value in prev. X periods                            |
//+------------------------------------------------------------------+
double Highest(double &high[], int length, int shift)
{
   double Result=0;
   for(int i=shift; i<=shift+length; i++)
   {
      if(Result==0 || (high[i]>Result && high[i]!=EMPTY_VALUE))
      {
         Result=high[i];
      }
   }

   return Result;
}
//+------------------------------------------------------------------+
//| calculating simple moving average of an array                    |
//+------------------------------------------------------------------+
double SimpleMA(const int position,const int period,const double &price[], const int &rates_total)
{
//---
   double result=0.0;
   if(position<=rates_total-period && period>0)
   {
      for(int i=0; i<period; i++)
      {
         if(price[position+i]!=EMPTY_VALUE)
         {
            result+=price[position+i];
         }
      }
      result/=period;
   }
   return(result);
}
//+------------------------------------------------------------------+
