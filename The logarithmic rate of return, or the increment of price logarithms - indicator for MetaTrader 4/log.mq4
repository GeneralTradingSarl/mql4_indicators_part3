//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "genino.belaev@yandex.ru"
#property link      "https://www.mql5.com/ru/users/genino"
#property version   "1.00"
#property indicator_separate_window   
#property indicator_buffers 4
#property indicator_color1 Lime       //задаем цвет 1-го инструмента
#property indicator_color2 DodgerBlue //задаем  цвет 2-го инструмента
#property indicator_color3 White
#property indicator_color4 Yellow
//---
extern string  Symbol_1 = "EURUSD";   //первый инструмент
extern string  Symbol_2 = "GBPUSD";   //второй инструмент
extern string  Symbol_3 = "AUDUSD";
extern string  Symbol_4 = "NZDUSD";
double Symbol1[]; double Symbol2[];double Symbol3[];double Symbol4[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,Symbol1);
   SetIndexLabel(0,Symbol_1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,Symbol2);
   SetIndexLabel(1,Symbol_2);
//---
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,Symbol3);
   SetIndexLabel(2,Symbol_3);
//---
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,Symbol4);
   SetIndexLabel(3,Symbol_4);
//---
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars-=10;
//---
   int limit=Bars-IndicatorCounted();
   int k;
   for(k=0; k<limit-1; k++)
     {
      //--- задаем отрисовку линии первого инструмента
      Symbol1[k]=MathLog(iClose(Symbol_1,0,iBarShift(Symbol_1,0,Time[k],false)))-MathLog(iClose(Symbol_1,0,iBarShift(Symbol_1,0,Time[k+1],false)));
      //--- задаем отрисовку линии первого инструмента
      Symbol2[k]=MathLog(iClose(Symbol_2,0,iBarShift(Symbol_2,0,Time[k],false)))-MathLog(iClose(Symbol_2,0,iBarShift(Symbol_2,0,Time[k+1],false)));
      //--- задаем отрисовку линии первого инструмента
      Symbol3[k]=MathLog(iClose(Symbol_3,0,iBarShift(Symbol_3,0,Time[k],false)))-MathLog(iClose(Symbol_3,0,iBarShift(Symbol_3,0,Time[k+1],false)));
      //--- задаем отрисовку линии первого инструмента
      Symbol4[k]=MathLog(iClose(Symbol_4,0,iBarShift(Symbol_4,0,Time[k],false)))-MathLog(iClose(Symbol_4,0,iBarShift(Symbol_4,0,Time[k+1],false)));
     }
//---
   return(0);
  }
//+------------------------------------------------------------------+
