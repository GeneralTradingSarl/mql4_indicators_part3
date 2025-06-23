//+------------------------------------------------------------------+
//|                                                    Turn Area.mq4 |
//|                                               Yuriy Tokman (YTG) |
//|                                               http://ytg.com.ua/ |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman (YTG)"
#property link      "http://ytg.com.ua/"
#property version   "1.00"
#property strict
#property indicator_separate_window

#property indicator_buffers 1
#property indicator_color1 clrDarkViolet
#property indicator_width1 2
#property indicator_levelcolor clrSilver
#property indicator_levelstyle STYLE_SOLID
#property indicator_level1 0
#property indicator_level2 25
#property indicator_level3 -25
#property indicator_level4 20
#property indicator_level5 -20
#property indicator_level6 15
#property indicator_level7 -15


input int                EMA_Period   = 12;
input ENUM_MA_METHOD     EMA_Method =0;
input ENUM_APPLIED_PRICE EMA_Price =0;
input int                RSI_Period = 21;
input ENUM_APPLIED_PRICE PSI_Price =0;
//---- buffers
double ExtMapBuffer1[];
string name="";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   name = "Turn Area";
   IndicatorShortName(name);
   
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexLabel(0,name);
   SetIndexDrawBegin(0,MathMax(RSI_Period,EMA_Period));    
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
   int limit=rates_total-prev_calculated;
   if(prev_calculated==0)limit--;
   else  limit++;  
   double hi=0, lo=0, ce=0;
   for( int i=0; i<limit && !IsStopped(); i++)
    { 
     ExtMapBuffer1[i] =
     ((iMA(NULL,0,EMA_Period,0,EMA_Method,EMA_Price,i) 
     - (50 - iRSI(NULL, 0, RSI_Period, PSI_Price,i))*Point)
     - iMA(NULL,0,EMA_Period,0,EMA_Method,EMA_Price,i) )
     /Point ;
    }  
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
