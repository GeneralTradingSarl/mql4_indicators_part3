//+------------------------------------------------------------------+
//|                                                    The_Heavy.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
//|                Written by Totom Sukopratomo - tomsuk001/MQL5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_plots   4
//--- plot Last
#property indicator_label1  "Last"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrLimeGreen
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2
//--- plot Previous
#property indicator_label2  "Previous"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrDarkGreen
#property indicator_style2  STYLE_SOLID
#property indicator_width2  2
//--- plot Up
#property indicator_label3  "Up"
#property indicator_type3   DRAW_HISTOGRAM
#property indicator_color3  clrBlue
#property indicator_style3  STYLE_SOLID
#property indicator_width3  3
//--- plot Down
#property indicator_label4  "Down"
#property indicator_type4   DRAW_HISTOGRAM
#property indicator_color4  clrRed
#property indicator_style4  STYLE_SOLID
#property indicator_width4  3
//--- input parameters
/* Period for last x-bars range counted from current bar */
input int      LastPeriod=35;
/* Period for previous x-bars range counted from LastPeriod bar */
input int      PreviousPeriod=35;
//--- indicator buffers
double         LastBuffer[];
double         PreviousBuffer[];
double         UpBuffer[];
double         DownBuffer[];
double         iACBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- count of buffers
   IndicatorBuffers(5);
//--- indicator buffers mapping
   SetIndexBuffer(0,LastBuffer);
   SetIndexBuffer(1,PreviousBuffer);
   SetIndexBuffer(2,UpBuffer);
   SetIndexBuffer(3,DownBuffer);
   SetIndexBuffer(4,iACBuffer);
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
//--- set arrays as timeseries
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(open,true);
   ArraySetAsSeries(close,true);
   ArraySetAsSeries(LastBuffer,true);
   ArraySetAsSeries(PreviousBuffer,true);
   ArraySetAsSeries(UpBuffer,true);
   ArraySetAsSeries(DownBuffer,true);
   ArraySetAsSeries(iACBuffer,true);
//--- get limit's number of bars to calculate
   int limit;
   if(prev_calculated<=0)
     {
      //--- bars to calculate right after initialization of indicator succeded
      limit=rates_total-LastPeriod-PreviousPeriod;
     }
   else
     {
      //--- last bar will be recounted
      limit=rates_total-prev_calculated;
     }
//--- main calculation
   for(int i=0;i<limit;i++)
     {
      //--- save value of iAC into buffer
      iACBuffer[i]=iAC(NULL,0,i);
      //--- calculate last 'LastPeriod' bars range
      LastBuffer[i]=high[ArrayMaximum(high,LastPeriod,i)]-low[ArrayMinimum(low,LastPeriod,i)];
      //--- calculate previous 'PreviousPeriod' bars range
      PreviousBuffer[i]=high[ArrayMaximum(high,PreviousPeriod,i+LastPeriod)]-low[ArrayMinimum(low,PreviousPeriod,i+LastPeriod)];
     }
//--- set values of Up and Down buffer using values of iAC buffer
   for(int i=0;i<limit;i++)
     {
      //--- if value of current iAC is greater then value of previous iAC set value of UpBuffer with value of current iAC
      if(iACBuffer[i]>iACBuffer[i+1])
        {
         UpBuffer[i]=iACBuffer[i];
        }
      //--- else set value of DownBuffer with value of current iAC
      else
        {
         DownBuffer[i]=iACBuffer[i];
        }
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
