//+------------------------------------------------------------------+
//|                                        Price Channel Central.mq4 |
//|                                               Yuriy Tokman (YTG) |
//|                                               http://ytg.com.ua/ |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman (YTG)"
#property link      "http://ytg.com.ua/"
#property version   "1.00"
#property strict
#property indicator_chart_window

#property indicator_buffers 3 
#property indicator_color1 Red 
#property indicator_color2 Green
#property indicator_color3 Blue
#property indicator_width1 2
#property indicator_width2 2
//----
extern int Bars_Count=32;
//---- buffers 
double B0[];
double B1[];
double B2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   int shift_begin=Bars_Count;
   IndicatorShortName("Price Channel Central ("+DoubleToStr(Bars_Count,0)+")");
   SetIndexBuffer(0,B0);
   SetIndexBuffer(1,B1);
   SetIndexBuffer(2,B2);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexDrawBegin(0,shift_begin);
   SetIndexDrawBegin(1,shift_begin);
   SetIndexDrawBegin(2,shift_begin);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ArrowRightPriceDelete(0,"RightPrice1");
   ArrowRightPriceDelete(0,"RightPrice2");
   ArrowRightPriceDelete(0,"RightPrice3");
   ArrowRightPriceDelete(0,"Label");
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
//---
   int limit=rates_total-prev_calculated;
   if(prev_calculated==0)limit--;
   else  limit++;
   double hi=0,lo=0,ce=0;
   for(int i=0; i<limit && !IsStopped(); i++)
     {
      hi = High[iHighest(Symbol(),0,MODE_HIGH,Bars_Count,i+1)];
      lo = Low[iLowest(Symbol(),0,MODE_LOW,Bars_Count,i+1)];
      ce = (hi+lo)/2;
      B0[i]=hi;
      B1[i]=lo;
      B2[i]=ce;
     }
   color colir=clrBlue; string sig="NONE";
   if(Bid>B2[0]){colir=clrGreen; sig = "BUY";}
   if(Ask<B2[0]){colir=clrRed; sig = "SELL";}
//---
   LabelCreate(sig+" SIGNALS",colir);
//---
   ArrowRightPriceCreate(0,"RightPrice1",0,Time[0],B0[0],clrRed,STYLE_SOLID,2);
   ArrowRightPriceCreate(0,"RightPrice2",0,Time[0],B1[0],clrGreen,STYLE_SOLID,2);
   ArrowRightPriceCreate(0,"RightPrice3",0,Time[0],B2[0],clrBlue,STYLE_SOLID,2);
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Создает правую ценовую метку                                     |
//+------------------------------------------------------------------+
bool ArrowRightPriceCreate(long            chart_ID=0,        // ID графика
                           string          name="RightPrice", // имя ценовой метки
                           int             sub_window=0,      // номер подокна
                           datetime        time=0,            // время точки привязки
                           double          price=0,           // цена точки привязки
                           color           clr=clrRed,        // цвет ценовой метки
                           ENUM_LINE_STYLE style=STYLE_SOLID, // стиль окаймляющей линии
                           int             width=1)           // размер ценовой метки
  {
   ArrowRightPriceDelete(chart_ID,name);
//--- сбросим значение ошибки
   ResetLastError();
//--- создадим ценовую метку
   if(!ObjectCreate(chart_ID,name,OBJ_ARROW_RIGHT_PRICE,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": не удалось создать правую ценовую метку! Код ошибки = ",GetLastError());
      return(false);
     }
//--- установим цвет метки
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- установим стиль окаймляющей линии
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- установим размер метки
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- успешное выполнение
   return(true);
  }
//+------------------------------------------------------------------+
//| Удаляет правую ценовую метку с графика                           |
//+------------------------------------------------------------------+
bool ArrowRightPriceDelete(long   chart_ID=0,        // ID графика
                           string name="RightPrice") // имя метки
  {
   if(ObjectFind(chart_ID,name)<0)return(false);
//--- сбросим значение ошибки
   ResetLastError();
//--- удалим метку
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": не удалось удалить правую ценовую метку! Код ошибки = ",GetLastError());
      return(false);
     }
//--- успешное выполнение
   return(true);
  }
//+------------------------------------------------------------------+
//| Создает текстовую метку                                          |
//+------------------------------------------------------------------+
bool LabelCreate(string            text="Label",              // текст
                 color             clr=clrRed,                // цвет
                 long              chart_ID=0,                // ID графика
                 string            name="Label",              // имя метки
                 int               sub_window=0,              // номер подокна
                 int               x=10,                      // координата по оси X
                 int               y=10,                      // координата по оси Y
                 ENUM_BASE_CORNER  corner=CORNER_RIGHT_UPPER, // угол графика для привязки
                 ENUM_ANCHOR_POINT anchor=ANCHOR_RIGHT_UPPER, // способ привязки
                 string            font="Arial",              // шрифт
                 int               font_size=10)              // размер шрифта                                  
  {
   ArrowRightPriceDelete(chart_ID,name);
//--- сбросим значение ошибки
   ResetLastError();
//--- создадим текстовую метку
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": не удалось создать текстовую метку! Код ошибки = ",GetLastError());
      return(false);
     }
//--- установим координаты метки
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- установим угол графика, относительно которого будут определяться координаты точки
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- установим текст
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- установим шрифт текста
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- установим размер шрифта
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- установим способ привязки
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- установим цвет
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- успешное выполнение
   return(true);
  }
//+------------------------------------------------------------------+
