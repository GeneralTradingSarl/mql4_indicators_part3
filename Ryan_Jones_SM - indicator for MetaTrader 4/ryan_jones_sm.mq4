//+------------------------------------------------------------------+
//|                                                ryan_jones_sm.mq4 |
//|                                         Copyright © 2007, Sergan |
//|                                                                  |
//+------------------------------------------------------------------+
// Версия 1.0 03.11.07
// правила:
/* Метод, который дает эти цифры, удивительно прост. Правила таковы:
Покупка:
1.	Среднее по закрытию, рассчитанное по "X"- дневному периоду, должно быть выше, чем аналогичное среднее "Y" дней тому назад.
2.	Цена при закрытии должна быть меньше, чем аналогичная цена "Y" дней тому назад.
3.	Цена при закрытии должна быть выше, чем цена на закрытие "Y+X" дней тому назад.
Если соблюдены все три условия, то нужно осуществлять покупку при открытии на следующий день

Продажа:
1.	Среднее по закрытию, рассчитанное по "X"- дневному периоду должно быть меньше, чем аналогичное среднее "Y" дней тому назад.
2.	Цена при закрытии должна быть больше, чем аналогичная цена "У дней тому назад.
3.	Цена при закрытии должна быть меньше, чем цена на закрытие "Y+X" дней тому назад.

Например, если "Х"= 20 и "Y"=3
*/
#define LOW 0
#define HIGH 1
#define OP_NONE -1  //тип ордера - нет ордера OP_BUY, OP_SELL и т.п. используются из мт
#define OP_CLOSEORDER -2 //тип сигнала - закрыть ордер
#define UP 1
#define DOWN -1
//----
#define MAGICMA  031107
#include <stdlib.mqh>
#include <WinUser32.mqh>
//----
#property copyright "Copyright © 2007, Sergan"
#property link      "SerganMT@hotbox.ru"
//----
#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 Red
#property indicator_color2 Gold
#property indicator_color3 DarkBlue
#property indicator_color4 Black
#property indicator_color5 Blue
#property indicator_color6 Blue
//----
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 1
#property indicator_width4 1
#property indicator_width5 3
#property indicator_width6 3
//---- input parameters
extern int       ParY=3;  //параметр "Y"
extern int       ParX=20; // параметр "X"
//---- buffers
double ExtMapBuffer1[];  // ма период параметр "X"
double ExtMapBuffer2[];  // ма период  "X" смещение "Y"
double ExtMapBuffer3[];  //цена закрытия "Y" дней назад
double ExtMapBuffer4[];  //цена закрытия "Y+X" дней тому назад
//----
double BuyBuffer[];     //буфер сигналы бай
double SellBuffer[];    //буяер сигналы селл
double BufferSignalType[]; // буфер типов сигналов, необходимо для передачи в советник
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexLabel(0, "ma("+ParX+")" );
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexLabel(1, "ma("+ParX+","+ParY+")" );
   //----
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexLabel(2, "close("+ParY+")" );
   //----
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexLabel(3, "close("+(ParY+ParX)+")" );
   //----
   SetIndexStyle( 4, DRAW_ARROW, EMPTY );
   SetIndexArrow( 4, 233 );
   SetIndexStyle( 5, DRAW_ARROW, EMPTY );
   SetIndexArrow( 5, 234 );
   //----
   SetIndexBuffer( 4, BuyBuffer   );
   SetIndexEmptyValue(4,0);
   SetIndexBuffer( 5, SellBuffer   );
   SetIndexEmptyValue(5,0);
   ArrayInitialize(BuyBuffer, 0 );
   ArrayInitialize(SellBuffer, 0 );
//----
   int drawtype=DRAW_ARROW ;
   SetIndexBuffer(6,BufferSignalType );
   SetIndexStyle( 6, DRAW_NONE);
   SetIndexEmptyValue(6,0);
   //----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
  bool ShowSignals(int i  )
  {
   BuyBuffer[i]=0; SellBuffer[i]=0; BufferSignalType[i]=OP_NONE;
   int cmd=OP_NONE;
   if(i>Bars-100)return(false);
/*
double ExtMapBuffer1[];  // ма период параметр "X"
double ExtMapBuffer2[];  // ма период  "X" смещение "Y"
double ExtMapBuffer3[];  //цена закрытия "Y" дней назад
double ExtMapBuffer4[];  //цена закрытия "Y+X" дней тому назад

Продажа:
1.	Среднее по закрытию, рассчитанное по "X"- дневному периоду должно быть меньше, чем аналогичное среднее "Y" дней тому назад.
2.	Цена при закрытии должна быть больше, чем аналогичная цена "У дней тому назад.
3.	Цена при закрытии должна быть меньше, чем цена на закрытие "Y+X" дней тому назад.

Покупка:
1.	Среднее по закрытию, рассчитанное по "X"- дневному периоду, должно быть выше, чем аналогичное среднее "Y" дней тому назад.
2.	Цена при закрытии должна быть меньше, чем аналогичная цена "Y" дней тому назад.
3.	Цена при закрытии должна быть выше, чем цена на закрытие "Y+X" дней тому назад.
Если соблюдены все три условия, то нужно осуществлять покупку при открытии на следующий день
*/
     if(ExtMapBuffer1[i]<ExtMapBuffer2[i])
     {
        if(Close[i]>ExtMapBuffer3[i] && Close[i] <  ExtMapBuffer4[i])
        {
         cmd=OP_SELL;
         SellBuffer[i]= Close[i];
        }
     }
     if(ExtMapBuffer1[i]>ExtMapBuffer2[i])
     {
        if(Close[i]<ExtMapBuffer3[i] && Close[i] >  ExtMapBuffer4[i])
        {
         cmd=OP_BUY;
         BuyBuffer[i]= Close[i];
        }
     }
   BufferSignalType[i]=cmd;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  int start()
  {
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+ParY+ParX;
   
     for( int i=limit; i>0; i -- )
     {
      ExtMapBuffer1[i]=iMA(NULL,0,ParX,0,MODE_SMA,PRICE_CLOSE,i);
      ExtMapBuffer2[i]=iMA(NULL,0,ParX,ParY,MODE_SMA,PRICE_CLOSE,i);
      ExtMapBuffer3[i]=Close[ParY+i]; //цена закрытия Y дней назад
      ExtMapBuffer4[i]=Close[ParY+ParX+i];//цена закрытия "Y+X" дней тому назад
      ShowSignals(i);
     }
   return(0);
  }
//+------------------------------------------------------------------+