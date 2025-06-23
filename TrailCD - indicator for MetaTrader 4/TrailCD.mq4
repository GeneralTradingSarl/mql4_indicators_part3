//+------------------------------------------------------------------+
//|                                                                  |
//|                        TrailCD.mq4                               |
//|Индикатор                                                         |
//|Схождение/расхождение быстрого и медленного тралов                |
//+------------------------------------------------------------------+
#property copyright "mandorr@gmail.com"
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 clrRoyalBlue
#property indicator_maximum 0.0005
#property indicator_minimum -0.0005
//----
extern int TrailFast=25;     // Быстрый трал
extern int TrailSlow=65;     // Медленный трал
extern int CountBars=1000;   // Количество отображаемых баров
//----
double buffer[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void init()
  {
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,1);
   SetIndexBuffer(0,buffer);
   SetIndexLabel(0,"Value");
   SetIndexDrawBegin(0,0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void start()
  {
   ArrayInitialize(buffer,0);
   double price=MathRound(Close[CountBars-1]/Point);
   double value_fast=price;
   double value_slow=price;
   for(int i=CountBars-1;i>=0;i--)
     {
      price=(int)MathRound(Close[i]/Point);
      if(value_fast<price-TrailFast) value_fast=price-TrailFast;
      if(value_fast>price+TrailFast) value_fast=price+TrailFast;
      if(value_slow<price-TrailSlow) value_slow=price-TrailSlow;
      if(value_slow>price+TrailSlow) value_slow=price+TrailSlow;
      buffer[i]=(value_fast-value_slow)*Point;
     }
  }
//+------------------------------------------------------------------+
