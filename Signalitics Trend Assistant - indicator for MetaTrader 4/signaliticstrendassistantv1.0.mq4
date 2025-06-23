//+------------------------------------------------------------------+
//|                           Signalitics - Trend Assistant V1.0.mq4 |
//|                                   Copyright © 2016, Signalitics. |
//|                                            signalitics@gmail.com |
//|                                        Written by Maxime Labelle |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2016, Maxime Labelle @ Signalitics"
#property link      "signalitics@gmail.com"
//----
#property indicator_separate_window
#property indicator_minimum 1.0
#property indicator_maximum 11.0
#property indicator_buffers 18
#property indicator_color1  Lime
#property indicator_color2  Red
#property indicator_color3  Lime
#property indicator_color4  Red
#property indicator_color5  Lime
#property indicator_color6  Red
#property indicator_color7  Lime
#property indicator_color8  Red
#property indicator_color9  Lime
#property indicator_color10  Red
#property indicator_color11  Lime
#property indicator_color12  Red
#property indicator_color13  Lime
#property indicator_color14  Red
#property indicator_color15  Lime
#property indicator_color16  Red
#property indicator_color17  Lime
#property indicator_color18  Red
//----
extern int                 MA_PERIOD     = 5;             // Averaging period.
extern ENUM_MA_METHOD      MA_MODE       = MODE_SMA;      // Averaging method.
extern ENUM_APPLIED_PRICE  MA_PRICE      = PRICE_CLOSE;   // The type of the price used for calculaton of Moving Average.
//----
double MA1_UP_Buffer[];
double MA1_DN_Buffer[];
double MA2_UP_Buffer[];
double MA2_DN_Buffer[];
double MA3_UP_Buffer[];
double MA3_DN_Buffer[];
double MA4_UP_Buffer[];
double MA4_DN_Buffer[];
double MA5_UP_Buffer[];
double MA5_DN_Buffer[];
double MA6_UP_Buffer[];
double MA6_DN_Buffer[];
double MA7_UP_Buffer[];
double MA7_DN_Buffer[];
double MA8_UP_Buffer[];
double MA8_DN_Buffer[];
double MA9_UP_Buffer[];
double MA9_DN_Buffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init() {
   //---- indicators
   SetIndexStyle (0, DRAW_ARROW, STYLE_SOLID, 0, Lime);
   SetIndexArrow (0, 167);
   SetIndexBuffer(0, MA1_UP_Buffer);
   SetIndexEmptyValue(0, 0.0);
   SetIndexStyle (1, DRAW_ARROW, STYLE_SOLID, 0, Red);
   SetIndexArrow (1, 167);
   SetIndexBuffer(1, MA1_DN_Buffer);
   SetIndexEmptyValue(1, 0.0);
   
   SetIndexStyle (2, DRAW_ARROW, STYLE_SOLID, 0, Lime);
   SetIndexArrow (2, 167);
   SetIndexBuffer(2, MA2_UP_Buffer);
   SetIndexEmptyValue(2, 0.0);
   SetIndexStyle (3, DRAW_ARROW, STYLE_SOLID, 0, Red);
   SetIndexArrow (3, 167);
   SetIndexBuffer(3, MA2_DN_Buffer);
   SetIndexEmptyValue(3, 0.0);
   
   SetIndexStyle (4, DRAW_ARROW, STYLE_SOLID, 0, Lime);
   SetIndexArrow (4, 167);
   SetIndexBuffer(4, MA3_UP_Buffer);
   SetIndexEmptyValue(4, 0.0);
   SetIndexStyle (5, DRAW_ARROW, STYLE_SOLID, 0, Red);
   SetIndexArrow (5, 167);
   SetIndexBuffer(5, MA3_DN_Buffer);
   SetIndexEmptyValue(5, 0.0);
   
   SetIndexStyle (6, DRAW_ARROW, STYLE_SOLID, 0, Lime);
   SetIndexArrow (6, 167);
   SetIndexBuffer(6, MA4_UP_Buffer);
   SetIndexEmptyValue(6, 0.0);
   SetIndexStyle (7, DRAW_ARROW, STYLE_SOLID, 0, Red);
   SetIndexArrow (7, 167);
   SetIndexBuffer(7, MA4_DN_Buffer);
   SetIndexEmptyValue(7, 0.0);
   
   SetIndexStyle (8, DRAW_ARROW, STYLE_SOLID, 0, Lime);
   SetIndexArrow (8, 167);
   SetIndexBuffer(8, MA5_UP_Buffer);
   SetIndexEmptyValue(8, 0.0);
   SetIndexStyle (9, DRAW_ARROW, STYLE_SOLID, 0, Red);
   SetIndexArrow (9, 167);
   SetIndexBuffer(9, MA5_DN_Buffer);
   SetIndexEmptyValue(9, 0.0);
   
   SetIndexStyle (10, DRAW_ARROW, STYLE_SOLID, 0, Lime);
   SetIndexArrow (10, 167);
   SetIndexBuffer(10, MA6_UP_Buffer);
   SetIndexEmptyValue(10, 0.0);
   SetIndexStyle (11, DRAW_ARROW, STYLE_SOLID, 0, Red);
   SetIndexArrow (11, 167);
   SetIndexBuffer(11, MA6_DN_Buffer);
   SetIndexEmptyValue(11, 0.0);
   
   SetIndexStyle (12, DRAW_ARROW, STYLE_SOLID, 0, Lime);
   SetIndexArrow (12, 167);
   SetIndexBuffer(12, MA7_UP_Buffer);
   SetIndexEmptyValue(12, 0.0);
   SetIndexStyle (13, DRAW_ARROW, STYLE_SOLID, 0, Red);
   SetIndexArrow (13, 167);
   SetIndexBuffer(13, MA7_DN_Buffer);
   SetIndexEmptyValue(13, 0.0);
   
   SetIndexStyle (14, DRAW_ARROW, STYLE_SOLID, 0, Lime);
   SetIndexArrow (14, 167);
   SetIndexBuffer(14, MA8_UP_Buffer);
   SetIndexEmptyValue(14, 0.0);
   SetIndexStyle (15, DRAW_ARROW, STYLE_SOLID, 0, Red);
   SetIndexArrow (15, 167);
   SetIndexBuffer(15, MA8_DN_Buffer);
   SetIndexEmptyValue(15, 0.0);
   
   SetIndexStyle (16, DRAW_ARROW, STYLE_SOLID, 0, Lime);
   SetIndexArrow (16, 167);
   SetIndexBuffer(16, MA9_UP_Buffer);
   SetIndexEmptyValue(16, 0.0);
   SetIndexStyle (17, DRAW_ARROW, STYLE_SOLID, 0, Red);
   SetIndexArrow (17, 167);
   SetIndexBuffer(17, MA9_DN_Buffer);
   SetIndexEmptyValue(17, 0.0);
   
   SetIndexLabel(0, "1_Buffer_UP");
   SetIndexLabel(1, "1_Buffer_DN");
   SetIndexLabel(2, "2_Buffer_UP");
   SetIndexLabel(3, "2_Buffer_DN");
   SetIndexLabel(4, "3_Buffer_UP");
   SetIndexLabel(5, "3_Buffer_DN");
   SetIndexLabel(6, "4_Buffer_UP");
   SetIndexLabel(7, "4_Buffer_DN");
   SetIndexLabel(8, "5_Buffer_UP");
   SetIndexLabel(9, "5_Buffer_DN");
   SetIndexLabel(10, "6_Buffer_UP");
   SetIndexLabel(11, "6_Buffer_DN");
   SetIndexLabel(12, "7_Buffer_UP");
   SetIndexLabel(13, "7_Buffer_DN");
   SetIndexLabel(14, "8_Buffer_UP");
   SetIndexLabel(15, "8_Buffer_DN");
   SetIndexLabel(16, "9_Buffer_UP");
   SetIndexLabel(17, "9_Buffer_DN");
   
   IndicatorDigits(0);
   
   IndicatorShortName("Signalitics - Trend Assistant");


   string ObjName = "";
   string ObjText = "";
   
   ObjName = "STA_TEXT_M1"; ObjText = "M1";
   ObjectCreate (ObjName, OBJ_LABEL, ChartWindowFind(NULL, "Signalitics - Trend Assistant"), 0, 0, 0);
   ObjectSet(ObjName,OBJPROP_CORNER,1);
   ObjectSetText(ObjName, ObjText, 10, "Tahoma", Aqua);
   ObjectSet(ObjName, OBJPROP_XDISTANCE, 15);//left to right
   ObjectSet(ObjName, OBJPROP_YDISTANCE, 170);//top to bottom
   
   ObjName = "STA_TEXT_M5"; ObjText = "M5";
   ObjectCreate (ObjName, OBJ_LABEL, ChartWindowFind(NULL, "Signalitics - Trend Assistant"), 0, 0, 0);
   ObjectSet(ObjName,OBJPROP_CORNER,1);
   ObjectSetText(ObjName, ObjText, 10, "Tahoma", Aqua);
   ObjectSet(ObjName, OBJPROP_XDISTANCE, 15);//left to right
   ObjectSet(ObjName, OBJPROP_YDISTANCE, 150);//top to bottom
   
   ObjName = "STA_TEXT_M15"; ObjText = "M15";
   ObjectCreate (ObjName, OBJ_LABEL, ChartWindowFind(NULL, "Signalitics - Trend Assistant"), 0, 0, 0);
   ObjectSet(ObjName,OBJPROP_CORNER,1);
   ObjectSetText(ObjName, ObjText, 10, "Tahoma", Aqua);
   ObjectSet(ObjName, OBJPROP_XDISTANCE, 15);//left to right
   ObjectSet(ObjName, OBJPROP_YDISTANCE, 130);//top to bottom
   
   ObjName = "STA_TEXT_M30"; ObjText = "M30";
   ObjectCreate (ObjName, OBJ_LABEL, ChartWindowFind(NULL, "Signalitics - Trend Assistant"), 0, 0, 0);
   ObjectSet(ObjName,OBJPROP_CORNER,1);
   ObjectSetText(ObjName, ObjText, 10, "Tahoma", Aqua);
   ObjectSet(ObjName, OBJPROP_XDISTANCE, 15);//left to right
   ObjectSet(ObjName, OBJPROP_YDISTANCE, 110);//top to bottom
   
   ObjName = "STA_TEXT_H1"; ObjText = "H1";
   ObjectCreate (ObjName, OBJ_LABEL, ChartWindowFind(NULL, "Signalitics - Trend Assistant"), 0, 0, 0);
   ObjectSet(ObjName,OBJPROP_CORNER,1);
   ObjectSetText(ObjName, ObjText, 10, "Tahoma", Aqua);
   ObjectSet(ObjName, OBJPROP_XDISTANCE, 15);//left to right
   ObjectSet(ObjName, OBJPROP_YDISTANCE, 90);//top to bottom
   
   ObjName = "STA_TEXT_H4"; ObjText = "H4";
   ObjectCreate (ObjName, OBJ_LABEL, ChartWindowFind(NULL, "Signalitics - Trend Assistant"), 0, 0, 0);
   ObjectSet(ObjName,OBJPROP_CORNER,1);
   ObjectSetText(ObjName, ObjText, 10, "Tahoma", Aqua);
   ObjectSet(ObjName, OBJPROP_XDISTANCE, 15);//left to right
   ObjectSet(ObjName, OBJPROP_YDISTANCE, 70);//top to bottom
   
   ObjName = "STA_TEXT_D1"; ObjText = "D1";
   ObjectCreate (ObjName, OBJ_LABEL, ChartWindowFind(NULL, "Signalitics - Trend Assistant"), 0, 0, 0);
   ObjectSet(ObjName,OBJPROP_CORNER,1);
   ObjectSetText(ObjName, ObjText, 10, "Tahoma", Aqua);
   ObjectSet(ObjName, OBJPROP_XDISTANCE, 15);//left to right
   ObjectSet(ObjName, OBJPROP_YDISTANCE, 50);//top to bottom
   
   ObjName = "STA_TEXT_W1"; ObjText = "W1";
   ObjectCreate (ObjName, OBJ_LABEL, ChartWindowFind(NULL, "Signalitics - Trend Assistant"), 0, 0, 0);
   ObjectSet(ObjName,OBJPROP_CORNER,1);
   ObjectSetText(ObjName, ObjText, 10, "Tahoma", Aqua);
   ObjectSet(ObjName, OBJPROP_XDISTANCE, 15);//left to right
   ObjectSet(ObjName, OBJPROP_YDISTANCE, 30);//top to bottom
   
   ObjName = "STA_TEXT_MN1"; ObjText = "MN1";
   ObjectCreate (ObjName, OBJ_LABEL, ChartWindowFind(NULL, "Signalitics - Trend Assistant"), 0, 0, 0);
   ObjectSet(ObjName,OBJPROP_CORNER,1);
   ObjectSetText(ObjName, ObjText, 10, "Tahoma", Aqua);
   ObjectSet(ObjName, OBJPROP_XDISTANCE, 15);//left to right
   ObjectSet(ObjName, OBJPROP_YDISTANCE, 10);//top to bottom
   
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit() {
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {
   int Counted_Bars = IndicatorCounted(), i;
   if(Counted_Bars<0) return(-1);
   if(Counted_Bars>0) Counted_Bars--;
   int Limit = Bars - Counted_Bars;
   if(Counted_Bars==0) Limit--;

   for(i=Limit; i>=0; i--) {
      int SHIFT;
      
      SHIFT = iBarShift(Symbol(), PERIOD_M1, Time[i]);      
      double MA0_M1 = iMA(NULL, PERIOD_M1, MA_PERIOD, 0, MA_MODE, MA_PRICE, SHIFT);
      double MA1_M1 = iMA(NULL, PERIOD_M1, MA_PERIOD, 0, MA_MODE, MA_PRICE, SHIFT+1);
      
      SHIFT = iBarShift(Symbol(), PERIOD_M5, Time[i]);
      double MA0_M5 = iMA(NULL, PERIOD_M5, MA_PERIOD, 0, MA_MODE, MA_PRICE, SHIFT);
      double MA1_M5 = iMA(NULL, PERIOD_M5, MA_PERIOD, 0, MA_MODE, MA_PRICE, SHIFT+1);
      
      SHIFT = iBarShift(Symbol(), PERIOD_M15, Time[i]);
      double MA0_M15 = iMA(NULL, PERIOD_M15, MA_PERIOD, 0, MA_MODE, MA_PRICE, SHIFT);
      double MA1_M15 = iMA(NULL, PERIOD_M15, MA_PERIOD, 0, MA_MODE, MA_PRICE, SHIFT+1);
      
      SHIFT = iBarShift(Symbol(), PERIOD_M30, Time[i]);
      double MA0_M30 = iMA(NULL, PERIOD_M30, MA_PERIOD, 0, MA_MODE, MA_PRICE, SHIFT);
      double MA1_M30 = iMA(NULL, PERIOD_M30, MA_PERIOD, 0, MA_MODE, MA_PRICE, SHIFT+1);
      
      SHIFT = iBarShift(Symbol(), PERIOD_H1, Time[i]);
      double MA0_H1 = iMA(NULL, PERIOD_H1, MA_PERIOD, 0, MA_MODE, MA_PRICE, SHIFT);
      double MA1_H1 = iMA(NULL, PERIOD_H1, MA_PERIOD, 0, MA_MODE, MA_PRICE, SHIFT+1);
      
      SHIFT = iBarShift(Symbol(), PERIOD_H4, Time[i]);
      double MA0_H4 = iMA(NULL, PERIOD_H4, MA_PERIOD, 0, MA_MODE, MA_PRICE, SHIFT);
      double MA1_H4 = iMA(NULL, PERIOD_H4, MA_PERIOD, 0, MA_MODE, MA_PRICE, SHIFT+1);
      
      SHIFT = iBarShift(Symbol(), PERIOD_D1, Time[i]);
      double MA0_D1 = iMA(NULL, PERIOD_D1, MA_PERIOD, 0, MA_MODE, MA_PRICE, SHIFT);
      double MA1_D1 = iMA(NULL, PERIOD_D1, MA_PERIOD, 0, MA_MODE, MA_PRICE, SHIFT+1);
      
      SHIFT = iBarShift(Symbol(), PERIOD_W1, Time[i]);
      double MA0_W1 = iMA(NULL, PERIOD_W1, MA_PERIOD, 0, MA_MODE, MA_PRICE, SHIFT);
      double MA1_W1 = iMA(NULL, PERIOD_W1, MA_PERIOD, 0, MA_MODE, MA_PRICE, SHIFT+1);
      
      SHIFT = iBarShift(Symbol(), PERIOD_MN1, Time[i]);
      double MA0_MN1 = iMA(NULL, PERIOD_MN1, MA_PERIOD, 0, MA_MODE, MA_PRICE, SHIFT);
      double MA1_MN1 = iMA(NULL, PERIOD_MN1, MA_PERIOD, 0, MA_MODE, MA_PRICE, SHIFT+1);
      
      MA1_UP_Buffer[i] = 0;
      MA1_DN_Buffer[i] = 0;
      
      if(MA0_M1 > MA1_M1) {
         MA1_UP_Buffer[i] = 2;
      } else {
         MA1_DN_Buffer[i] = 2;
      }

      MA2_UP_Buffer[i] = 0;
      MA2_DN_Buffer[i] = 0;
      
      if(MA0_M5 > MA1_M5) {
         MA2_UP_Buffer[i] = 3;
      } else {
         MA2_DN_Buffer[i] = 3;
      }

      MA3_UP_Buffer[i] = 0;
      MA3_DN_Buffer[i] = 0;
      
      if(MA0_M15 > MA1_M15) {
         MA3_UP_Buffer[i] = 4;
      } else {
         MA3_DN_Buffer[i] = 4;
      }

      MA4_UP_Buffer[i] = 0;
      MA4_DN_Buffer[i] = 0;
      
      if(MA0_M30 > MA1_M30) {
         MA4_UP_Buffer[i] = 5;
      } else {
         MA4_DN_Buffer[i] = 5;
      }

      MA5_UP_Buffer[i] = 0;
      MA5_DN_Buffer[i] = 0;
      
      if(MA0_H1 > MA1_H1) {
         MA5_UP_Buffer[i] = 6;
      } else {
         MA5_DN_Buffer[i] = 6;
      }

      MA6_UP_Buffer[i] = 0;
      MA6_DN_Buffer[i] = 0;
      
      if(MA0_H4 > MA1_H4) {
         MA6_UP_Buffer[i] = 7;
      } else {
         MA6_DN_Buffer[i] = 7;
      }

      MA7_UP_Buffer[i] = 0;
      MA7_DN_Buffer[i] = 0;
      
      if(MA0_D1 > MA1_D1) {
         MA7_UP_Buffer[i] = 8;
      } else {
         MA7_DN_Buffer[i] = 8;
      }

      MA8_UP_Buffer[i] = 0;
      MA8_DN_Buffer[i] = 0;
      
      if(MA0_W1 > MA1_W1) {
         MA8_UP_Buffer[i] = 9;
      } else {
         MA8_DN_Buffer[i] = 9;
      }

      MA9_UP_Buffer[i] = 0;
      MA9_DN_Buffer[i] = 0;
      
      if(MA0_MN1 > MA1_MN1) {
         MA9_UP_Buffer[i] = 10;
      } else {
         MA9_DN_Buffer[i] = 10;
      }

   }   
   
   return(0);
}
