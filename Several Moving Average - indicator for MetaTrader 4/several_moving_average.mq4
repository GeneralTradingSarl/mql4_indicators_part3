//+------------------------------------------------------------------+
//|                                       Several Moving Average.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                       https://www.mql5.com/ru/users/dlim0n4ik.dk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, DLim0n4IK.DK"
#property link      "https://www.mql5.com/ru/users/dlim0n4ik.dk"
#property version   "1.00"
#property description "Рисует на графике пять Moving Average (MA). Также возможно изменение типа MA."
#property strict
#property indicator_chart_window
#property indicator_buffers 5
#property indicator_plots   5
//--- plot Label1
#property indicator_label1  "SMA-1"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrYellow
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot Label2
#property indicator_label2  "SMA-2"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrBlue
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot Label3
#property indicator_label3  "SMA-3"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrRed
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- plot Label4
#property indicator_label4  "SMA-4"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrRed
#property indicator_style4  STYLE_SOLID
#property indicator_width4  1
//--- plot Label5
#property indicator_label5  "SMA-5"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrGreen
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1
//+------------------------------------------------------------------+
//| Вводные параметры Moving Average                                 |
//+------------------------------------------------------------------+
//--- Параметры Moving Average 1 -------------------------------------
input string                  MA1_Info="Параметры Moving Average 1";
//string                      MA1_Symbol           = 0;                // имя символа 
input ENUM_TIMEFRAMES         MA1_TFPeriod         = 0;                // период 
input int                     MA1_Period           = 5;                // период усреднения
input int                     MA1_Shift            = 0;                // смещение индикатора по горизонтали 
input ENUM_MA_METHOD          MA1_Method           = MODE_LWMA;        // тип сглаживания 
input ENUM_APPLIED_PRICE      MA1_Applied_Price    = PRICE_CLOSE;      // тип цены или handle 
//--- Параметры Moving Average 2 -------------------------------------
input string                  MA2_Info="Параметры Moving Average 2";
//string                      MA2_Symbol           = 0;                // имя символа 
input ENUM_TIMEFRAMES         MA2_TFPeriod         = 0;                // период 
input int                     MA2_Period           = 12;               // период усреднения
input int                     MA2_Shift            = 0;                // смещение индикатора по горизонтали 
input ENUM_MA_METHOD          MA2_Method           = MODE_LWMA;        // тип сглаживания 
input ENUM_APPLIED_PRICE      MA2_Applied_Price    = PRICE_CLOSE;      // тип цены или handle 
//--- Параметры Moving Average 3 -------------------------------------
input string                  MA3_Info="Параметры Moving Average 3";
//string                      MA3_Symbol           = 0;                // имя символа 
input ENUM_TIMEFRAMES         MA3_TFPeriod         = 0;                // период 
input int                     MA3_Period           = 18;               // период усреднения
input int                     MA3_Shift            = 0;                // смещение индикатора по горизонтали 
input ENUM_MA_METHOD          MA3_Method           = MODE_EMA;         // тип сглаживания 
input ENUM_APPLIED_PRICE      MA3_Applied_Price    = PRICE_CLOSE;      // тип цены или handle 
//--- Параметры Moving Average 4 -------------------------------------
input string                  MA4_Info="Параметры Moving Average 4";
//string                      MA4_Symbol           = 0;                // имя символа 
input ENUM_TIMEFRAMES         MA4_TFPeriod         = 0;                // период 
input int                     MA4_Period           = 28;               // период усреднения
input int                     MA4_Shift            = 0;                // смещение индикатора по горизонтали 
input ENUM_MA_METHOD          MA4_Method           = MODE_EMA;         // тип сглаживания 
input ENUM_APPLIED_PRICE      MA4_Applied_Price    = PRICE_CLOSE;      // тип цены или handle 
//--- Параметры Moving Average 5 -------------------------------------
input string                  MA5_Info="Параметры Moving Average 5";
//string                      MA5_Symbol           = 0;                // имя символа 
input ENUM_TIMEFRAMES         MA5_TFPeriod         = 0;                // период 
input int                     MA5_Period           = 50;               // период усреднения
input int                     MA5_Shift            = 0;                // смещение индикатора по горизонтали 
input ENUM_MA_METHOD          MA5_Method           = MODE_SMA;         // тип сглаживания 
input ENUM_APPLIED_PRICE      MA5_Applied_Price    = PRICE_CLOSE;      // тип цены или handle 

//--- indicator buffers
double         MA1Buffer[];
double         MA2Buffer[];
double         MA3Buffer[];
double         MA4Buffer[];
double         MA5Buffer[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnInit(void)
  {
   int    draw_begin1 = MA1_Period-1;
   int    draw_begin2 = MA2_Period-1;
   int    draw_begin3 = MA3_Period-1;
   int    draw_begin4 = MA4_Period-1;
   int    draw_begin5 = MA5_Period-1;
//---
   SetIndexBuffer(0,MA1Buffer);
   SetIndexBuffer(1,MA2Buffer);
   SetIndexBuffer(2,MA3Buffer);
   SetIndexBuffer(3,MA4Buffer);
   SetIndexBuffer(4,MA5Buffer);
//---
   for(int i=0; i<=6; i++)
      SetIndexShift(i,0);
//---
   SetIndexDrawBegin(0,draw_begin1);
   SetIndexDrawBegin(1,draw_begin2);
   SetIndexDrawBegin(2,draw_begin3);
   SetIndexDrawBegin(3,draw_begin4);
   SetIndexDrawBegin(4,draw_begin5);
//---
   SetIndexLabel(0,"MA "+IntegerToString(MA1_Period));
   SetIndexLabel(1,"MA "+IntegerToString(MA2_Period));
   SetIndexLabel(2,"MA "+IntegerToString(MA3_Period));
   SetIndexLabel(3,"MA "+IntegerToString(MA4_Period));
   SetIndexLabel(4,"MA "+IntegerToString(MA5_Period));
//---
   IndicatorDigits(Digits);
  }
//+------------------------------------------------------------------+
//|                                                                  |
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
   int limit=rates_total-prev_calculated;
//---
   for(int i=0; i<limit; i++)
     {
      if(MA1_Period!=0)
         MA1Buffer[i]=iMA(NULL,MA1_TFPeriod,MA1_Period,MA1_Shift,MA1_Method,MA1_Applied_Price,i);
      if(MA2_Period!=0)
         MA2Buffer[i]=iMA(NULL,MA2_TFPeriod,MA2_Period,MA2_Shift,MA2_Method,MA2_Applied_Price,i);
      if(MA3_Period!=0)
         MA3Buffer[i]=iMA(NULL,MA3_TFPeriod,MA3_Period,MA3_Shift,MA3_Method,MA3_Applied_Price,i);
      if(MA4_Period!=0)
         MA4Buffer[i]=iMA(NULL,MA4_TFPeriod,MA4_Period,MA4_Shift,MA4_Method,MA4_Applied_Price,i);
      if(MA5_Period!=0)
         MA5Buffer[i]=iMA(NULL,MA5_TFPeriod,MA5_Period,MA5_Shift,MA5_Method,MA5_Applied_Price,i);
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
