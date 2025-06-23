//+------------------------------------------------------------------+
//|                                                       Stream.mq4 |
//|                                               Yuriy Tokman (YTG) |
//|                                               http://ytg.com.ua/ |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman (YTG)"
#property link      "http://ytg.com.ua/"
#property version   "1.00"
#property strict
#property indicator_chart_window

#property indicator_buffers 2
#property indicator_color1 Red 
#property indicator_color2 Green
#property indicator_width1 4
#property indicator_width2 4

extern int Bars_Size = 50;

//---- buffers 
double B0[];
double B1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,B0);
   SetIndexBuffer(1,B1);
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(0,242); 
   SetIndexArrow(1,241);   
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

   for( int i=1; i<limit && !IsStopped(); i++)
    {
     if(Open[i]-Close[i]>=Bars_Size*Point)B0[i]=High[i]+iATR(Symbol(),0,21,i)/2;
     if(Close[i]-Open[i]>=Bars_Size*Point)B1[i]=High[i]+iATR(Symbol(),0,21,i)/2;
    }   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
