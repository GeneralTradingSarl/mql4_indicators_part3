//+------------------------------------------------------------------+
//|                                                  TicksVolume.mq4 |
//|                                         Copyright 2013, Viktorov |
//|                                                   v4forex@qip.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, Viktorov"
#property link      "v4forex@qip.ru"

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Navy
#property indicator_color2 LawnGreen
#property indicator_color3 FireBrick
#property indicator_color4 Yellow
#property indicator_width1 4
#property indicator_width2 2
#property indicator_width3 4
#property indicator_width4 2
#property indicator_level1 0
#property indicator_levelcolor Olive
#property indicator_levelstyle STYLE_DOT

double   UpBuffer[];
double   DnBuffer[];
double   UpTick[];
double   DnTick[];
double   _Bid,_Ask,PriceUp,PriceDn,TickUp,TickDn;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   IndicatorShortName("TicksVolume");
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexStyle(3,DRAW_HISTOGRAM);
   SetIndexBuffer(0,UpBuffer);
   SetIndexBuffer(1,UpTick);
   SetIndexBuffer(2,DnBuffer);
   SetIndexBuffer(3,DnTick);
   SetIndexLabel(0,"Pips up");
   SetIndexLabel(1,"Tick up");
   SetIndexLabel(2,"Pips down");
   SetIndexLabel(3,"Tick down");
   IndicatorDigits(Digits);
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
   static datetime LastBar=0;
   datetime CurBar=time[0];
// ѕри по€влении нового бара обнул€ем переменные
   if(LastBar!=CurBar)
     {
      TickUp=0;
      TickDn=0;
      PriceUp= 0;
      PriceDn= 0;
      LastBar=CurBar;
     }
   if(_Bid == 0) _Bid = Bid;  // ѕри по€влении нового бара или при первом запуске присваиваем переменным соответствующие значени€ Bid
   if(_Ask == 0) _Ask = Ask;  // и Ask
//---
   if(Bid>_Bid || (_Bid==Bid && _Ask>Ask)) // ≈сли произошло увеличение цены 
     {
      PriceUp += Bid - _Bid;                        // ”величим количество пунктов вверх
      UpBuffer[0] = PriceUp/_Point;                 // заполним буфер соответствующим значением пунктов
      TickUp++;                                     // ”величим значение Volume вверх
      UpTick[0] = TickUp;                           // заполним буфер соответствующим значением Volume
     }
   if(Bid<_Bid || (_Bid==Bid && _Ask<Ask)) // ≈сли произошло уменьшение цены 
     {
      PriceDn += Bid - _Bid;                        // ”величим количество пунктов вниз
      DnBuffer[0] = PriceDn/_Point;                 // заполним буфер соответствующим значением пунктов
      TickDn--;                                     // ”величим значение Volume вниз
      DnTick[0] = TickDn;                           // заполним буфер соответствующим значением Volume
     }
   _Bid = Bid;
   _Ask = Ask;
   return(rates_total);
  }
//+------------------------------------------------------------------+
