//+------------------------------------------------------------------+
//|                                                  RJT Matches.mq4 |
//|                            Copyright 2015, Rafael Jimenez Tocino |
//|               http://www.tradingrafa.com/indicadores/rjt_matches |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, Rafael Jimenez Tocino"
#property link      "http://www.tradingrafa.com/indicadores/rjt_matches"
#property description "We recommend adjust the body and head size of the matches for better visualization."
#property version   "2.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 5
//--- drawing objects properties
#property indicator_label1  "match1"
#property indicator_label2  "match2"
#property indicator_label3  "match3"
#property indicator_label4  "headred"
#property indicator_label5  "headgreen"
#property indicator_type1   DRAW_LINE
#property indicator_type2   DRAW_LINE
#property indicator_type3   DRAW_LINE
#property indicator_type4   DRAW_ARROW
#property indicator_type5   DRAW_ARROW
#property indicator_color1  clrWhite
#property indicator_color2  clrWhite
#property indicator_color3  clrWhite
#property indicator_color4  clrRed
#property indicator_color5  clrLime
#property indicator_style1  STYLE_SOLID
#property indicator_style2  STYLE_SOLID
#property indicator_style3  STYLE_SOLID
#property indicator_style4  EMPTY
#property indicator_style5  EMPTY
#property indicator_width1  2
#property indicator_width2  2
#property indicator_width3  2
#property indicator_width4  1
#property indicator_width5  1
//--- buffers
double         LineBuffer0[];
double         LineBuffer1[];
double         LineBuffer2[];
double         LineBuffer3[];
double         LineBuffer4[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   string short_name;
//---
   short_name="RJT Matches v.2";
   IndicatorShortName(short_name);
//--- indicator buffers mapping
   SetIndexBuffer(0,LineBuffer0); // body of match 1
   SetIndexBuffer(1,LineBuffer1); // body of match 2
   SetIndexBuffer(2,LineBuffer2); // body of match 3
   SetIndexBuffer(3,LineBuffer3); // matchstick heads in red
   SetIndexBuffer(4,LineBuffer4); // matchstick heads in green
//--- head of matches adjusts
   SetIndexArrow(3,159);
   SetIndexArrow(4,159);
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
   int i,c=0,p=0;
   for(i=0; i<rates_total-1; i++)
     {
      //--- the color of matchstick heads
      if(close[i]>open[i+1])
        {
         LineBuffer3[i]=EMPTY_VALUE;
         LineBuffer4[i]=close[i];
           } else {
         LineBuffer3[i]=close[i];
         LineBuffer4[i]=EMPTY_VALUE;
        }
      //--- the body of matches
      if(p==0)
        {
         LineBuffer0[i]=EMPTY_VALUE;
         LineBuffer1[i]=close[i];
         LineBuffer2[i]=open[i];
           } else if(p==1){
         LineBuffer0[i]=close[i];
         LineBuffer1[i]=open[i];
         LineBuffer2[i]=EMPTY_VALUE;
           } else {
         LineBuffer0[i]=open[i];
         LineBuffer1[i]=EMPTY_VALUE;
         LineBuffer2[i]=close[i];
        }
      p++; p=p==3?0:p;
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
