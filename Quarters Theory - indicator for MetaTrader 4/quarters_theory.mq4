//+------------------------------------------------------------------+
//|                                              Quarters theory.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 17
#property indicator_plots   17
#property strict
//--- plot WL
#property indicator_label1  "WL"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrWhite
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2
//--- plot QL
#property indicator_label2  "QL"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrLimeGreen
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot HL
#property indicator_label3  "HL"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrYellow
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1,5
//--- plot QL
#property indicator_label4  "SQL"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrLimeGreen
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- plot WL
#property indicator_label5  "WL"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrWhite
#property indicator_style5  STYLE_SOLID
#property indicator_width5  2
//--- plot QL
#property indicator_label6  "QL"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrLimeGreen
#property indicator_style6  STYLE_SOLID
#property indicator_width6  1
//--- plot HL
#property indicator_label7  "HL"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrYellow
#property indicator_style7  STYLE_SOLID
#property indicator_width7  1,5
//--- plot QL
#property indicator_label8  "SQL"
#property indicator_type8   DRAW_LINE
#property indicator_color8  clrLimeGreen
#property indicator_style8  STYLE_SOLID
#property indicator_width8  1
//--- plot WL
#property indicator_label9  "WL"
#property indicator_type9   DRAW_LINE
#property indicator_color9  clrWhite
#property indicator_style9  STYLE_SOLID
#property indicator_width9  2
//--- plot QL
#property indicator_label10  "QL"
#property indicator_type10   DRAW_LINE
#property indicator_color10  clrLimeGreen
#property indicator_style10  STYLE_SOLID
#property indicator_width10  STYLE_SOLID
//--- plot HL
#property indicator_label11  "HL"
#property indicator_type11   DRAW_LINE
#property indicator_color11  clrYellow
#property indicator_style11  STYLE_SOLID
#property indicator_width11  1,5
//--- plot QL
#property indicator_label12  "SQL"
#property indicator_type12   DRAW_LINE
#property indicator_color12  clrLimeGreen
#property indicator_style12  STYLE_SOLID
#property indicator_width12  1
//--- plot WL
#property indicator_label13  "WL"
#property indicator_type13   DRAW_LINE
#property indicator_color13  clrWhite
#property indicator_style13  STYLE_SOLID
#property indicator_width13  2
//--- plot QL
#property indicator_label14  "QL"
#property indicator_type14   DRAW_LINE
#property indicator_color14  clrLimeGreen
#property indicator_style14  STYLE_SOLID
#property indicator_width14  1
//--- plot HL
#property indicator_label15  "HL"
#property indicator_type15   DRAW_LINE
#property indicator_color15  clrYellow
#property indicator_style15  STYLE_SOLID
#property indicator_width15  1,5
//--- plot QL
#property indicator_label16  "SQL"
#property indicator_type16   DRAW_LINE
#property indicator_color16  clrLimeGreen
#property indicator_style16  STYLE_SOLID
#property indicator_width16  1
//--- plot WL
#property indicator_label17  "WL"
#property indicator_type17   DRAW_LINE
#property indicator_color17  clrWhite
#property indicator_style17  STYLE_SOLID
#property indicator_width17  2
//--- input parameters
enum levels
  {
   ten=10,//10 Pips
   hundred=100,//100 Pips
   thousand=1000,//1000 Pips
   tenThousand=10000,//10 000 Pips
   hundredThousand=100000//100 000 Pips
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum styles
  {
   Line,
   Dash,
   Dot,
   dashdot,//Dash Dot
   dashdotdot//Dash Dot Dot
  };
input levels   wholeLevel        =100;    // Distance between majors
input int      startFromBar      =1;      // Start from bar
input int      howManyBars       =500;    // How many bars
input bool     disableQuarters   =false;  // Disable quarters
input styles   QuarterLevelStyle =0;      // Quarters style
int startBar;

//--- indicator buffers
double         WLBuffer1[];
double         QLBuffer1[];
double         HLBuffer1[];
double         SQLBuffer1[];
double         WLBuffer2[];
double         QLBuffer2[];
double         HLBuffer2[];
double         SQLBuffer2[];
double         WLBuffer3[];
double         QLBuffer3[];
double         HLBuffer3[];
double         SQLBuffer3[];
double         WLBuffer4[];
double         QLBuffer4[];
double         HLBuffer4[];
double         SQLBuffer4[];
double         WLBuffer5[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping

   SetIndexBuffer(0,WLBuffer1);
   SetIndexBuffer(1,QLBuffer1);
   SetIndexBuffer(2,HLBuffer1);
   SetIndexBuffer(3,SQLBuffer1);
   SetIndexBuffer(4,WLBuffer2);
   SetIndexBuffer(5,QLBuffer2);
   SetIndexBuffer(6,HLBuffer2);
   SetIndexBuffer(7,SQLBuffer2);
   SetIndexBuffer(8,WLBuffer3);
   SetIndexBuffer(9,QLBuffer3);
   SetIndexBuffer(10,HLBuffer3);
   SetIndexBuffer(11,SQLBuffer3);
   SetIndexBuffer(12,WLBuffer4);
   SetIndexBuffer(13,QLBuffer4);
   SetIndexBuffer(14,HLBuffer4);
   SetIndexBuffer(15,SQLBuffer4);
   SetIndexBuffer(16,WLBuffer5);

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
  if (howManyBars<startFromBar) startBar=startFromBar-howManyBars;
  else startBar=0;
   for(int i=startBar; i<howManyBars+startFromBar; i++)
     {
      double multiplier=(1/Point/1000)*1/wholeLevel*100;
      double firstLevel=(MathRound(Open[startFromBar]*multiplier)/multiplier);
      double gap=wholeLevel*10*Point/4;
      WLBuffer1[i]=firstLevel+8*gap;
      QLBuffer1[i]=firstLevel+7*gap;
      HLBuffer1[i]=firstLevel+6*gap;
      SQLBuffer1[i]=firstLevel+5*gap;
      WLBuffer2[i]=firstLevel+4*gap;
      QLBuffer2[i]=firstLevel+3*gap;
      HLBuffer2[i]=firstLevel+2*gap;
      SQLBuffer2[i]=firstLevel+gap;
      WLBuffer3[i]=firstLevel;
      QLBuffer3[i]=firstLevel-gap;
      HLBuffer3[i]=firstLevel-2*gap;
      SQLBuffer3[i]=firstLevel-3*gap;
      WLBuffer4[i]=firstLevel-4*gap;
      QLBuffer4[i]=firstLevel-5*gap;
      HLBuffer4[i]=firstLevel-6*gap;
      SQLBuffer4[i]=firstLevel-7*gap;
      WLBuffer5[i]=firstLevel-8*gap;
     }
   if(disableQuarters==true)
     {
      for(int j=1;j<16;j=j+2)
        {
         SetIndexStyle(j,12,QuarterLevelStyle,1,clrLimeGreen);
        }
     }
   else
     {
      for(int k=1;k<16;k=k+2)
        {
         SetIndexStyle(k,0,QuarterLevelStyle,1,clrLimeGreen);
        }
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
