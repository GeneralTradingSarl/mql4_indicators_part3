//+------------------------------------------------------------------+
//|                                                      Raznost.mq4 |
//|                                                     Yuriy Tokman |
//|                                            yuriytokman@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman"
#property link      "yuriytokman@gmail.com"

#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
  double a=Open[0]-Close[1];
    string name;
    string par =DoubleToStr((a/Point),0);
    
       if(Open[0]>Close[1])
      {
       name = "  up = ";
      }
    if(Open[0]<Close[1])
      {
       name = "down = ";
      }
     if(Open[0]==Close[1]) 
      {
       name = "flet = ";
      }
  
    
   // сейчас мы создадим текстовую метку.
   // для этого, как всегда, используем функцию ObjectCreate.
   // координаты указывать не нужно
   ObjectCreate("signal",OBJ_LABEL,0,0,0,0,0);
   ObjectCreate("signal2",OBJ_LABEL,0,0,0,0,0);
 
   // изменяем координату х
   ObjectSet("signal",OBJPROP_XDISTANCE,3);
   ObjectSet("signal2",OBJPROP_XDISTANCE,59);
 
   // изменяем координату у
   ObjectSet("signal",OBJPROP_YDISTANCE,12);
   ObjectSet("signal2",OBJPROP_YDISTANCE,12);
 
   // чтобы указать текст метки, используем эту функцию
   ObjectSetText("signal",name,12,"Tahoma",Red);
   ObjectSetText("signal2",par,12,"Tahoma",Red);
   // "signal" - название объекта
  

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
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+