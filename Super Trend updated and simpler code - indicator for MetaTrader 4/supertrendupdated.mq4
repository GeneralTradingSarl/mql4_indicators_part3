//+------------------------------------------------------------------+
//|                                            SuperTrendUpdated.mq4 |
//|                                                    Keith Watford |
//+------------------------------------------------------------------+
#property copyright "Keith Watford"
#property link      "none"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_chart_window
#property indicator_color1 Lime
#property indicator_color2 Red
#property indicator_width1 1
#property indicator_width2 1
#property indicator_buffers 2
input int Nbr_Periods=10;//Nbr Periods
input double Multiplier=3.0;//Multiplier

double TrendUp[],TrendDown[];
int changeOfTrend;
double Upper[],Lower[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   IndicatorBuffers(4);
   SetIndexBuffer(0,TrendUp);
   SetIndexStyle(0,DRAW_ARROW,STYLE_SOLID,1);
   SetIndexArrow(0,159);
   SetIndexLabel(0,"Trend Up");
   SetIndexBuffer(1,TrendDown);
   SetIndexStyle(1,DRAW_ARROW,STYLE_SOLID,1);
   SetIndexArrow(1,159);
   SetIndexLabel(1,"Trend Down");
   SetIndexBuffer(2,Upper);
   SetIndexBuffer(3,Lower);

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
   int limit,i;
   double medianPrice,atr;
   limit=rates_total-prev_calculated;
   if(prev_calculated==0)
     {
      i=rates_total-1;
      limit=rates_total-2;
      atr=iATR(NULL,0,Nbr_Periods,i);
      medianPrice=(High[i]+Low[i])/2;
      TrendUp[i]=medianPrice+(Multiplier*atr);
      TrendDown[i]=medianPrice-(Multiplier*atr);
     }

//----
   for(i=limit; i>=0; i--)
     {
      TrendUp[i]=TrendUp[i+1];
      TrendDown[i]=TrendDown[i+1];
      atr=iATR(NULL,0,Nbr_Periods,i);
      medianPrice=(High[i]+Low[i])/2;
      Upper[i]=medianPrice+(Multiplier*atr);
      Lower[i]=medianPrice-(Multiplier*atr);

      if(TrendDown[i+1]!=EMPTY_VALUE)
        {
         if(Close[i]>TrendDown[i+1])
           {
            TrendDown[i]=EMPTY_VALUE;
            TrendUp[i]=Lower[i];
           }
         if(Upper[i]<TrendDown[i+1])
           {
            TrendDown[i]=Upper[i];
           }
        }
      else
      if(TrendUp[i+1]!=EMPTY_VALUE)
        {
         if(Close[i]<TrendUp[i+1])
           {
            TrendUp[i]=EMPTY_VALUE;
            TrendDown[i]=Upper[i];
           }
         if(Lower[i]>TrendUp[i+1])
           {
            TrendUp[i]=Lower[i];
           }
        }
     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
