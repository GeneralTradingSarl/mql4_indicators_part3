//+------------------------------------------------------------------+
//|                                     ytg_Change_Price_Percent.mq4 |
//|                                   Copyright © 2009, Yuriy Tokman |
//|                                            yuriytokman@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Yuriy Tokman"
#property link      "yuriytokman@gmail.com"

#property indicator_chart_window


extern string    Symbol1       = "EURUSD";
extern string    Symbol2       = "USDCHF";
extern string    Symbol3       = "GBPUSD";
extern string    Symbol4       = "USDJPY";

extern int       Размер_шрифта = 10;
extern int       Угол_привязки = 1;
extern color     color_up      = Lime;
extern color     color_down    = Red;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   ObjectCreate("Symbol1",OBJ_LABEL,0,0,0,0,0);
   ObjectCreate("Symbol2",OBJ_LABEL,0,0,0,0,0);   
   ObjectCreate("Symbol3",OBJ_LABEL,0,0,0,0,0);   
   ObjectCreate("Symbol4",OBJ_LABEL,0,0,0,0,0);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ObjectDelete ("Symbol1");
   ObjectDelete ("Symbol2");   
   ObjectDelete ("Symbol3");   
   ObjectDelete ("Symbol4");   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//----
     double sym_1 =(MarketInfo(Symbol1,MODE_BID) - iClose(Symbol1,PERIOD_D1,1))*100/iClose(Symbol1,PERIOD_D1,1);
     double sym_2 =(MarketInfo(Symbol2,MODE_BID) - iClose(Symbol2,PERIOD_D1,1))*100/iClose(Symbol2,PERIOD_D1,1);
     double sym_3 =(MarketInfo(Symbol3,MODE_BID) - iClose(Symbol3,PERIOD_D1,1))*100/iClose(Symbol3,PERIOD_D1,1);
     double sym_4 =(MarketInfo(Symbol4,MODE_BID) - iClose(Symbol4,PERIOD_D1,1))*100/iClose(Symbol4,PERIOD_D1,1);
//----
     color color_1 = 0, color_2 = 0, color_3 = 0, color_4 = 0;
     
     if(sym_1>0)color_1=color_up; else color_1=color_down;
     if(sym_2>0)color_2=color_up; else color_2=color_down;     
     if(sym_3>0)color_3=color_up; else color_3=color_down;     
     if(sym_4>0)color_4=color_up; else color_4=color_down;     
//----
     string Symbol_1 =" = "+DoubleToStr(sym_1, 4)+" %";
     string Symbol_2 =" = "+DoubleToStr(sym_2, 4)+" %";
     string Symbol_3 =" = "+DoubleToStr(sym_3, 4)+" %";     
     string Symbol_4 =" = "+DoubleToStr(sym_4, 4)+" %";
//----
     ObjectSetText("Symbol1",Symbol1+Symbol_1,Размер_шрифта,"Arial Black",Lime);
     ObjectSet("Symbol1",OBJPROP_XDISTANCE,3);     
     ObjectSet("Symbol1",OBJPROP_YDISTANCE,30);
     ObjectSet("Symbol1",OBJPROP_COLOR,color_1);
     ObjectSet("Symbol1",OBJPROP_CORNER,Угол_привязки);
     
     ObjectSetText("Symbol2",Symbol2+Symbol_2,Размер_шрифта,"Arial Black",Lime);
     ObjectSet("Symbol2",OBJPROP_XDISTANCE,3);     
     ObjectSet("Symbol2",OBJPROP_YDISTANCE,50);
     ObjectSet("Symbol2",OBJPROP_COLOR,color_2);
     ObjectSet("Symbol2",OBJPROP_CORNER,Угол_привязки);     
     
     ObjectSetText("Symbol3",Symbol3+Symbol_3,Размер_шрифта,"Arial Black",Lime);
     ObjectSet("Symbol3",OBJPROP_XDISTANCE,3);     
     ObjectSet("Symbol3",OBJPROP_YDISTANCE,70);
     ObjectSet("Symbol3",OBJPROP_COLOR,color_3);
     ObjectSet("Symbol3",OBJPROP_CORNER,Угол_привязки);     
     
     ObjectSetText("Symbol4",Symbol4+Symbol_4,Размер_шрифта,"Arial Black",Lime);
     ObjectSet("Symbol4",OBJPROP_XDISTANCE,3);     
     ObjectSet("Symbol4",OBJPROP_YDISTANCE,90);
     ObjectSet("Symbol4",OBJPROP_COLOR,color_4);    
     ObjectSet("Symbol4",OBJPROP_CORNER,Угол_привязки);
   
//----
   return(0);
  }
//+------------------------------------------------------------------+--------------------------------------------------+
