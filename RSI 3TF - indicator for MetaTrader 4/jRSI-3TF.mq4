//+------------------------------------------------------------------+
//|                                                     #RSI-3TF.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//|                                                                  |
//|                   29.10.2005 Модернизация Ким Игорь В. aka KimIV |
//|                                              http://www.kimiv.ru |
//|code change by Alex.Piech.FinGeR                                  |
//|http://www.forex-tsd.com                                          |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"
//----
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_buffers 3
#property indicator_color1 DodgerBlue
#property indicator_color2 Yellow
#property indicator_color3 Red
#property indicator_level1 70
#property indicator_level2 30
#property indicator_level3 50
//------- Внешние параметры индикатора -------------------------------
extern int TF_1       =0;
extern int RSI_Period_1=14;
extern int TF_2        =30;
extern int RSI_Period_2=14;
extern int TF_3        =60;
extern int RSI_Period_3=14;
extern int NumberOfBars=1000;  // Количество баров обсчёта (0-все)
//------- Буферы индикатора ------------------------------------------
double RSIBuffer1[];
double RSIBuffer2[];
double RSIBuffer3[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
  void init() 
  {
   string short_name;
//---- indicator line
   SetIndexStyle (0, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexBuffer(0, RSIBuffer1);
   SetIndexStyle (1, DRAW_LINE, STYLE_SOLID, 3);
   SetIndexBuffer(1, RSIBuffer2);
   SetIndexStyle (2, DRAW_LINE, STYLE_SOLID, 3);
   SetIndexBuffer(2, RSIBuffer3);
//---- name for DataWindow and indicator subwindow label
   short_name="RSI("+RSI_Period_1+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
   short_name="RSI("+RSI_Period_2+")";
   SetIndexLabel(1,short_name);
   short_name="RSI("+RSI_Period_3+")";
   SetIndexLabel(2,short_name);
   SetIndexDrawBegin(0,RSI_Period_1);
   SetIndexDrawBegin(1,RSI_Period_2);
   SetIndexDrawBegin(2,RSI_Period_3);
  }
//+------------------------------------------------------------------+
//| Relative Strength Index                                          |
//+------------------------------------------------------------------+
  void start() 
  {
   int LoopBegin, sh, nsb,nsb2,nsb3;
   if (NumberOfBars==0) LoopBegin=Bars-1;
   else LoopBegin=NumberOfBars-1;
//----
     for(sh=LoopBegin; sh>=0; sh--) 
     {
      nsb3=iBarShift(NULL, TF_1, Time[sh], False);
      nsb=iBarShift(NULL, TF_2, Time[sh], False);
      nsb2=iBarShift(NULL, TF_3, Time[sh], False);
      RSIBuffer1[sh]=iRSI(NULL, TF_1, RSI_Period_1, PRICE_CLOSE, nsb3);
      RSIBuffer2[sh]=iRSI(NULL, TF_2, RSI_Period_2, PRICE_CLOSE, nsb);
      RSIBuffer3[sh]=iRSI(NULL, TF_3, RSI_Period_3, PRICE_CLOSE, nsb2);
     }
  }
//+------------------------------------------------------------------+