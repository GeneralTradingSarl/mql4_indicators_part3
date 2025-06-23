//+------------------------------------------------------------------+
//|                                              Turn Area Chart.mq4 |
//|                                               Yuriy Tokman (YTG) |
//|                                               http://ytg.com.ua/ |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman (YTG)"
#property link      "http://ytg.com.ua/"
#property version   "1.00"
#property strict
#property indicator_chart_window

#property indicator_buffers 4
#property indicator_color1 clrDarkViolet
#property indicator_color2 clrRed
#property indicator_color3 clrSilver
#property indicator_color4 clrSilver
#property indicator_style3 STYLE_DOT
#property indicator_style4 STYLE_DOT

input int                EMA_Period   = 12;
input ENUM_MA_METHOD     EMA_Method   = 0;
input ENUM_APPLIED_PRICE EMA_Price    = 0;
input int                RSI_Period   = 21;
input ENUM_APPLIED_PRICE PSI_Price    = 0;
input int                Level_RSI_UP = 70;
input int                Level_RSI_DN = 30;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
string name="";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   name = "Turn Area Chart";
   IndicatorShortName(name);
   
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexLabel(0,name);
   SetIndexDrawBegin(0,MathMax(RSI_Period,EMA_Period));
   
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexLabel(1,"MA");
   SetIndexDrawBegin(1,MathMax(RSI_Period,EMA_Period)); 

   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexLabel(2,"Level RSI UP");
   SetIndexDrawBegin(2,MathMax(RSI_Period,EMA_Period)); 
   
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexLabel(3,"Level RSI DN");
   SetIndexDrawBegin(3,MathMax(RSI_Period,EMA_Period));       
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
   double ma=0;
   for( int i=0; i<limit && !IsStopped(); i++)
    {
     ma = iMA(NULL,0,EMA_Period,0,EMA_Method,EMA_Price,i); 
     ExtMapBuffer1[i] = ma - (50 - iRSI(NULL, 0, RSI_Period, PSI_Price,i))*Point;    
     ExtMapBuffer2[i] = ma;
     ExtMapBuffer3[i] = ma + (Level_RSI_UP - 50)*Point;     
     ExtMapBuffer4[i] = ma - (50 - Level_RSI_DN)*Point;     
    }    
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
