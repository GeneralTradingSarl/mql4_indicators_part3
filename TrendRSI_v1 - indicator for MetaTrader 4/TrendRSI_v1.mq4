//+------------------------------------------------------------------+
//|                                                   TrendRSI_v1.mq4 |
//|                           Copyright © 2005, TrendLaboratory Ltd. |
//|                                       E-mail: igorad2004@list.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, TrendLaboratory Ltd."
#property link      "E-mail: igorad2004@list.ru"
//-----
#property indicator_separate_window
#property indicator_minimum 20
#property indicator_maximum 80
#property indicator_buffers 3
#property indicator_color1 Orange
#property indicator_color2 SkyBlue
#property indicator_color3 Magenta
//---- input parameters
extern int PeriodRSI=14;
extern int PeriodMAFast=9;
extern int PeriodMASlow=45;
//---- indicator buffers
double Line1Buffer[];
double Line2Buffer[];
double Line3Buffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
  int init()
  {
   string short_name;
//---- indicator line
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,1);
   SetIndexBuffer(0,Line1Buffer);
   SetIndexBuffer(1,Line2Buffer);
   SetIndexBuffer(2,Line3Buffer);
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
//---- name for DataWindow and indicator subwindow label
   short_name="TrendRSI("+PeriodRSI+","+PeriodMAFast+","+PeriodMASlow+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"RSI");
   SetIndexLabel(1,"MARSI fast");
   SetIndexLabel(2,"MARSI slow");
//----
   SetIndexDrawBegin(0,PeriodRSI);
   SetIndexDrawBegin(1,PeriodMAFast);
   SetIndexDrawBegin(2,PeriodMASlow);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| TrendRSI_v1                                                         |
//+------------------------------------------------------------------+
int start()
  {
   int shift;
//-----
   for(shift=Bars-1;shift>=0;shift--)
     {
      Line1Buffer[shift]=iRSI(NULL,0,PeriodRSI,PRICE_CLOSE,shift);
     }
   for(shift=Bars-PeriodMASlow;shift>=0;shift--)
     {
      Line2Buffer[shift]=iMAOnArray(Line1Buffer,0,PeriodMAFast,0,MODE_SMA,shift);
      Line3Buffer[shift]=iMAOnArray(Line1Buffer,0,PeriodMASlow,0,MODE_EMA,shift);
     }
   return(0);
  }
//+------------------------------------------------------------------+