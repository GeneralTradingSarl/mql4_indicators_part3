//+------------------------------------------------------------------+
//|                                                  PRICE_Alert.mq4 |
//|                                      Copyright © 2008, AlexGomel |
//|                                          mailto:alexgomel@tut.by |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, AlexGomel"
#property link      "mailto:alexgomel@tut.by"
//----
#property indicator_chart_window
#property indicator_buffers 0
//---- input parameters
extern string    NamePrice="Price_1";
extern string    SoundFileName="alarm.wav";
extern bool      ActiveSignal=true;
extern bool      ActiveAlert=true;
extern color     LineColor=Gold;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   if (ObjectFind(NamePrice)==-1)
     {
      ObjectCreate(NamePrice,OBJ_HLINE,0,0,Close[0]);
      ObjectSet(NamePrice,OBJPROP_COLOR,LineColor);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete(NamePrice);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//----
   if (ObjectFind(NamePrice)==-1) return(0);
   double   _price=ObjectGet(NamePrice,OBJPROP_PRICE1);
   double _min=MathMin(High[1],Low[0]);
   double _max=MathMax(Low[1],High[0]);
//----
   if (ActiveSignal && _price>=_min  && _price<=_max)
     {
      if (ActiveAlert) Alert (Symbol()," ",Period()," Цена достигла ", NormalizeDouble(_price,Digits), " !"); // Предупреждение на экран
      if(SoundFileName!="" )
         PlaySound( SoundFileName ); // Звуковой сигнал
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+

