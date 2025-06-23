//+------------------------------------------------------------------+ 
//| Serg153xo                                                        |  
//+------------------------------------------------------------------+ 
#property copyright "Copyright © 2006, Serg153"
#property indicator_chart_window
//---- input parameters 
extern int RazmBox=20;
//----
int i,p,Lt,Lt1,Tb;
double RazmBoXO, Cnac;
int VsegoBarov;
//----
extern color ColorUp  =Red;      // Цвет восходящей свечи
extern color ColorDown=Yellow;   // Цвет нисходящей свечи
//+------------------------------------------------------------------+ 
//| Custom indicator initialization function                         | 
//+------------------------------------------------------------------+ 
  int deinit() 
  {
     for(i=0; i<99999; i++) 
     {
      ObjectDelete("BodyXO"+i);
      ObjectDelete("BodyX"+i);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+ 
//| Крестики Нолики                                                  | 
//+------------------------------------------------------------------+ 
int start()
  {
   RazmBoXO=RazmBox*Point;
   VsegoBarov=Bars - 1;
   Lt=0;
   Cnac=Open[VsegoBarov];
   Tb=0;
   p=0;
   // 1 прогон подсчёт всех баров
     for(i=VsegoBarov; i>=1; i--)
     { 
        p=0;
        while(High[i]>=Cnac + RazmBoXO) 
        {
         if (Tb==0) Lt++;
         Cnac+=RazmBoXO; p++; Tb=1;
        }
      if (p > 0) continue;
        while(Low[i]<=Cnac - RazmBoXO) 
        {
         if (Tb==1) Lt++;
         Cnac-=RazmBoXO; Tb=0;
        }
     }
   Lt=10 + Lt*2;
   // сдвигаем все бары вправо
   // 2 прогон разрисовка баров
   Cnac=Open[VsegoBarov];
   Lt1=0;
     for(i=VsegoBarov; i>=1; i--)
     {
       p=0;
        while(High[i]>=Cnac + RazmBoXO) 
        {
         if (Tb==0) Lt-=2;
         Lt1++;
         ObjectCreate("BodyXO" + Lt1, OBJ_RECTANGLE, 0, 0,0, 0,0);
         ObjectSet("BodyXO" + Lt1, OBJPROP_TIME1, Time[Lt] );
         ObjectSet("BodyXO" + Lt1, OBJPROP_PRICE1, Cnac);
         ObjectSet("BodyXO" + Lt1, OBJPROP_TIME2, Time[Lt-2]);
         ObjectSet("BodyXO" + Lt1, OBJPROP_PRICE2, Cnac+RazmBoXO);
         ObjectSet("BodyXO" + Lt1, OBJPROP_STYLE, STYLE_SOLID);
         ObjectSet("BodyXO" + Lt1, OBJPROP_BACK, True);
         ObjectSet("BodyXO" + Lt1, OBJPROP_COLOR, ColorUp);
         ObjectCreate("BodyX" + Lt1, OBJ_RECTANGLE, 0, 0,0, 0,0);
         ObjectSet("BodyX" + Lt1, OBJPROP_TIME1, Time[Lt] );
         ObjectSet("BodyX" + Lt1, OBJPROP_PRICE1, Cnac);
         ObjectSet("BodyX" + Lt1, OBJPROP_TIME2, Time[Lt-2]);
         ObjectSet("BodyX" + Lt1, OBJPROP_PRICE2, Cnac+RazmBoXO);
         ObjectSet("BodyX" + Lt1, OBJPROP_STYLE, STYLE_SOLID);
         ObjectSet("BodyX" + Lt1, OBJPROP_BACK, False);
         ObjectSet("BodyX" + Lt1, OBJPROP_COLOR, Blue);
         Cnac+=RazmBoXO;
         Tb=1; p++;
        }
      //*************************************************************** 
      if (p > 0) continue;
        while(Low[i]<=Cnac - RazmBoXO) 
        {
         if (Tb==1) Lt-=2;
         Lt1++;
         ObjectCreate("BodyXO" + Lt1, OBJ_RECTANGLE, 0, 0,0, 0,0);
         ObjectSet("BodyXO" + Lt1, OBJPROP_TIME1, Time[Lt]);
         ObjectSet("BodyXO" + Lt1, OBJPROP_PRICE1, Cnac);
         ObjectSet("BodyXO" + Lt1, OBJPROP_TIME2, Time[Lt-2]);
         ObjectSet("BodyXO" + Lt1, OBJPROP_PRICE2, Cnac-RazmBoXO);
         ObjectSet("BodyXO" + Lt1, OBJPROP_STYLE, STYLE_SOLID);
         ObjectSet("BodyXO" + Lt1, OBJPROP_BACK, True);
         ObjectSet("BodyXO" + Lt1, OBJPROP_COLOR, ColorDown);
         ObjectCreate("BodyX" + Lt1, OBJ_RECTANGLE, 0, 0,0, 0,0);
         ObjectSet("BodyX" + Lt1, OBJPROP_TIME1, Time[Lt] );
         ObjectSet("BodyX" + Lt1, OBJPROP_PRICE1, Cnac);
         ObjectSet("BodyX" + Lt1, OBJPROP_TIME2, Time[Lt-2]);
         ObjectSet("BodyX" + Lt1, OBJPROP_PRICE2, Cnac-RazmBoXO);
         ObjectSet("BodyX" + Lt1, OBJPROP_STYLE, STYLE_SOLID);
         ObjectSet("BodyX" + Lt1, OBJPROP_BACK, False);
         ObjectSet("BodyX" + Lt1, OBJPROP_COLOR, Blue);
         Cnac-=RazmBoXO; Tb=0;
        }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+