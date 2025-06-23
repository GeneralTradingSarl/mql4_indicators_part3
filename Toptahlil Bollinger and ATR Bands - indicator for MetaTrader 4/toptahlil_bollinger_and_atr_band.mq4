//+------------------------------------------------------------------+
//|                            toptahlil Bollinger and ATR Band .mq4 |
//+------------------------------------------------------------------+
//|                            toptahlil Bollinger and ATR Band .mq4 |
//|                          Copyright 2014, Toptahlil Software Corp |
//|                                      Emial : Toptahlil@yahoo.com |
//+------------------------------------------------------------------+
#property description "feedbacks: https://login.mql5.com/en/users/toptahlil/feedbacks"
#property copyright  "post a job for me: http://www.mql5.com/en/job/new?prefered=toptahlil"
#property link      "Emial : Toptahlil@yahoo.com"
#property description      "Skype ID : Toptahlil"
#property description      "MQL5  ID : Toptahlil"
#property version   "1.01"
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Red
#property indicator_color2 Red
#property indicator_color3 Blue
#property indicator_color4 Blue
#property indicator_style1  STYLE_SOLID
#property indicator_style2  STYLE_SOLID
#property indicator_style3  STYLE_DOT
#property indicator_style4  STYLE_DOT
#include <stdlib.mqh>
//+------------------------------------------------------------------+
//| Common External variables                                        |
//+------------------------------------------------------------------+
extern double ATRMult=2;
extern int ATR_Period=10;
extern int Band_Period=20;
extern double  Band_Diviations=3;
extern int Band_Shift=0;
extern ENUM_APPLIED_PRICE Band_ApplyPrice=PRICE_MEDIAN;

//+------------------------------------------------------------------+
//| Special Convertion Functions                                     |
//+------------------------------------------------------------------+
int LastTradeTime;
double ExtHistoBuffer[];
double ExtHistoBuffer2[];
double ExtHistoBuffer3[];
double ExtHistoBuffer4[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetLoopCount(int loops)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetIndexValue(int shift,double value)
  {
   ExtHistoBuffer[shift]=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetIndexValue2(int shift,double value)
  {
   ExtHistoBuffer2[shift]=value;
  }
//+------------------------------------------------------------------+
//| End                                                              |
//+------------------------------------------------------------------+
void SetIndexValue3(int shift,double value)
  {
   ExtHistoBuffer3[shift]=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetIndexValue4(int shift,double value)
  {
   ExtHistoBuffer4[shift]=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0,DRAW_LINE,indicator_style1,1,indicator_color1);
   SetIndexBuffer(0,ExtHistoBuffer);
   SetIndexStyle(1,DRAW_LINE,indicator_style2,1,indicator_color2);
   SetIndexBuffer(1,ExtHistoBuffer2);

   SetIndexStyle(2,DRAW_LINE,indicator_style3,1,indicator_color3);
   SetIndexBuffer(2,ExtHistoBuffer3);
   SetIndexStyle(3,DRAW_LINE,indicator_style4,1,indicator_color4);
   SetIndexBuffer(3,ExtHistoBuffer4);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
//+------------------------------------------------------------------+
//| Local variables                                                  |
//+------------------------------------------------------------------+
   int shift=0;
   double Band_Up,Band_Dwon,ATR;
   double KU=0;
   double KL=0;
/*[[
    Name := Keltner ATR Bands
    Author := Copyright © 2005, MetaQuotes Software Corp.
    Link := http://www.metaquotes.net/
    Separate Window := No
    First Color := White
    First Draw Type := Line
    First Symbol := 217
    Use Second Data := Yes
    Second Color := White
    Second Draw Type := Line
    Second Symbol := 218
]]*/
   SetLoopCount(0);
// loop from first bar to current bar (with shift=0)
   for(shift=Bars-1;shift>=0;shift--)
     {
      Band_Up   = iBands(Symbol(),Period(),Band_Period,Band_Diviations,Band_Shift,Band_ApplyPrice,MODE_UPPER,shift);
      Band_Dwon = iBands(Symbol(),Period(),Band_Period,Band_Diviations,Band_Shift,Band_ApplyPrice,MODE_LOWER,shift);

      ATR=iATR(Symbol(),Period(),ATR_Period,shift);

      KU=Band_Up + ATRMult*ATR;
      KL=Band_Dwon - ATRMult*ATR;
      SetIndexValue(shift,KU);
      SetIndexValue2(shift,KL);
      SetIndexValue3(shift,Band_Up);
      SetIndexValue4(shift,Band_Dwon);

     }
   return(0);
  }
//+------------------------------------------------------------------+
