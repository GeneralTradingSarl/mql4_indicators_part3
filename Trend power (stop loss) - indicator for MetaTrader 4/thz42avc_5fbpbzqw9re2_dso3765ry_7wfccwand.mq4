//+------------------------------------------------------------------+
//|                                                                  |
//|                 Copyright © 2000-2007, MetaQuotes Software Corp. |
//|                                         http://www.metaquotes.ru |
//+------------------------------------------------------------------+
// Сила тренда (стоп лосс).mq4
// Описание http://www.kroufr.ru/content/view/697/124/
#property copyright "mandorr@gmail.com"
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_color3 Silver
//----
extern int PeriodStep=10;     // Шаг периода скользящих
//----
double buffer0[];
double buffer1[];
double buffer2[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void init()
  {
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2);
   SetIndexBuffer(0,buffer0);
   SetIndexLabel(0,"Верхняя граница");
   SetIndexDrawBegin(0,0);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,2);
   SetIndexBuffer(1,buffer1);
   SetIndexLabel(1,"Нижняя граница");
   SetIndexDrawBegin(1,0);
   SetIndexStyle(2,DRAW_LINE,STYLE_DOT,1);
   SetIndexBuffer(2,buffer2);
   SetIndexLabel(2,"Медиана");
   SetIndexDrawBegin(2,0);
   IndicatorShortName("Сила тренда (стоп лосс) ("+(string)PeriodStep+")");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void deinit()
  {
   Comment("");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void start()
  {
   int dir=0;
   int step=1; if (PeriodStep>1) step=PeriodStep;
   double h, l, x1, x2, x3, x4, x5, x6;
   int counted_bars=IndicatorCounted();
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=6*step+1;
   for(int i=limit; i>=0; i--)
     {
      x1=iMA(NULL,0,1*step,0,MODE_SMA,PRICE_CLOSE,i);
      x2=iMA(NULL,0,2*step,0,MODE_SMA,PRICE_CLOSE,i);
      x3=iMA(NULL,0,3*step,0,MODE_SMA,PRICE_CLOSE,i);
      x4=iMA(NULL,0,4*step,0,MODE_SMA,PRICE_CLOSE,i);
      x5=iMA(NULL,0,5*step,0,MODE_SMA,PRICE_CLOSE,i);
      x6=iMA(NULL,0,6*step,0,MODE_SMA,PRICE_CLOSE,i);
      h=x1;
      l=x1;
      if (h<x2) h=x2;
      if (h<x3) h=x3;
      if (h<x4) h=x4;
      if (h<x5) h=x5;
      if (h<x6) h=x6;
      if (l>x2) l=x2;
      if (l>x3) l=x3;
      if (l>x4) l=x4;
      if (l>x5) l=x5;
      if (l>x6) l=x6;
      if (High[i]>h) dir= 1;
      if (Low [i]<l) dir=-1;
      if (High[i]>h && Low[i]<l) dir=0;
      buffer0[i]=EMPTY_VALUE;
      buffer1[i]=EMPTY_VALUE;
      if (dir<0) buffer0[i]=h;
      if (dir>0) buffer1[i]=l;
      buffer2[i]=(h+l)/2;
     }
   if (buffer0[0]!=EMPTY_VALUE) Comment("SELL; стоп лосс: "+DoubleToStr(buffer0[0],Digits));
   if (buffer1[0]!=EMPTY_VALUE) Comment("BUY; стоп лосс: "+DoubleToStr(buffer1[0],Digits));
  }
//+------------------------------------------------------------------+