//+------------------------------------------------------------------+
//|                                                X_O_serg153xo.mq4 |
//|                                        Copyright © 2005, Serg153 |
//|                                                               "" |
//|  переделка 04_2008 ver1 Aleksandr Pak, Alma-Ata, 03.2008         |
//|                                            ekr-ap@mail.ru        |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, Serg153" 
#property link      ""
//----
#property indicator_chart_window

#property indicator_buffers 2
#property indicator_color1 Aqua
#property indicator_color2 Red

extern color ColorUp   = Aqua;      // Цвет "крестика"
extern color ColorDown = DarkGoldenrod;   // Цвет "нолика" 
//---- input parameters 
extern int RazmBox = 20;
extern int count_Alert=3; //число повторений Алерт


//----
int i, p, Lt, Lt1, Tb; 
double RazmBoXO, Cnac; 
int VsegoBarov; 
double up[],down[];
int first=0,count_a=0;
double ftime;
string s;
//+------------------------------------------------------------------+ 
//| Custom indicator deinitialization function                       | 
//+------------------------------------------------------------------+ 
int init()
{
  
  SetIndexBuffer(0,up);          
  SetIndexStyle(0,DRAW_ARROW);
  SetIndexArrow(0,217);     
  SetIndexBuffer(1,down);          
  SetIndexStyle(1,DRAW_ARROW);   
  SetIndexArrow(1,218);
   int tf=Period();
   if(tf>30) s=Symbol()+" H"+tf/60; else s=Symbol()+" M"+tf;
  return (0);
}

int deinit() 
  { 
   for(i = 0; i <= Lt1; i++) 
     {
       ObjectDelete("BodyXO" + i);
       ObjectDelete("BodyX" + i);
     }
//----
   return(0); 
  } 
//+------------------------------------------------------------------+ 
//| Крестики Нолики                                                  | 
//+------------------------------------------------------------------+ 
int start() 
  { 
   if(ftime!=Time[0]) count_a=0;
   RazmBoXO = RazmBox*Point; 
   VsegoBarov = Bars - 1 ;  
   Lt = 0; 
   Cnac = Open[VsegoBarov]; 
   Tb = 0; 
   p = 0; 
// 1 прогон подсчёт всех баров
   for(i = VsegoBarov; i >= 1; i--)
     { 
       p = 0; 
       while(High[i] >= Cnac + RazmBoXO) 
         { 
           if(Tb == 0) 
               Lt++; 
           Cnac += RazmBoXO; 
           p++; 
           Tb = 1; 
         } 
       if(p > 0) 
           continue; 
       while(Low[i] <= Cnac - RazmBoXO) 
         { 
           if(Tb == 1) 
               Lt++; 
           Cnac -= RazmBoXO; Tb=0;  
         } 
     } 
   Lt = 10 + Lt*2;
// сдвигаем все бары вправо
// 2 прогон разрисовка графика
   Cnac = Open[VsegoBarov]; 
   Lt1 = 0;
   for(i = VsegoBarov; i >= 1; i--)
     { 
       p = 0; 
       while (High[i] >= Cnac + RazmBoXO) 
         { 
           if(Tb == 0) 
               Lt -= 2; 
           Lt1++; 
         if(Lt-2>=0 && Lt<Bars)
           {
           ObjectCreate("BodyXO" + Lt1, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
           ObjectSet("BodyXO" + Lt1, OBJPROP_TIME1, Time[Lt]);
           ObjectSet("BodyXO" + Lt1, OBJPROP_PRICE1, Cnac);
           ObjectSet("BodyXO" + Lt1, OBJPROP_TIME2, Time[Lt-2]);
           ObjectSet("BodyXO" + Lt1, OBJPROP_PRICE2, Cnac + RazmBoXO);
           ObjectSet("BodyXO" + Lt1, OBJPROP_STYLE, STYLE_SOLID);
           ObjectSet("BodyXO" + Lt1, OBJPROP_BACK, False);
           ObjectSet("BodyXO" + Lt1, OBJPROP_COLOR, ColorUp);
           ObjectCreate("BodyX" + Lt1, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
           ObjectSet("BodyX" + Lt1, OBJPROP_TIME1, Time[Lt]);
           ObjectSet("BodyX" + Lt1, OBJPROP_PRICE1, Cnac);
           ObjectSet("BodyX" + Lt1, OBJPROP_TIME2, Time[Lt-2]);
           ObjectSet("BodyX" + Lt1, OBJPROP_PRICE2, Cnac + RazmBoXO);
           ObjectSet("BodyX" + Lt1, OBJPROP_STYLE, STYLE_SOLID);
           ObjectSet("BodyX" + Lt1, OBJPROP_BACK, False);
           ObjectSet("BodyX" + Lt1, OBJPROP_COLOR, Blue);
           }
           Cnac += RazmBoXO; 
           Tb = 1; 
           p++; 
         } 
       if(p > 0) 
           continue; 
        
       while(Low[i] <= Cnac - RazmBoXO) 
         { 
           if(Tb == 1) 
               Lt -= 2; 
           Lt1++;
         if(Lt-2>=0 && Lt<Bars)
           {
           ObjectCreate("BodyXO" + Lt1, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
           ObjectSet("BodyXO" + Lt1, OBJPROP_TIME1, Time[Lt]);
           ObjectSet("BodyXO" + Lt1, OBJPROP_PRICE1, Cnac);
           ObjectSet("BodyXO" + Lt1, OBJPROP_TIME2, Time[Lt-2]);
           ObjectSet("BodyXO" + Lt1, OBJPROP_PRICE2, Cnac - RazmBoXO);
           ObjectSet("BodyXO" + Lt1, OBJPROP_STYLE, STYLE_SOLID);
           ObjectSet("BodyXO" + Lt1, OBJPROP_BACK, True);
           ObjectSet("BodyXO" + Lt1, OBJPROP_COLOR, ColorDown);
           ObjectCreate("BodyX" + Lt1, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
           ObjectSet("BodyX" + Lt1, OBJPROP_TIME1, Time[Lt]);
           ObjectSet("BodyX" + Lt1, OBJPROP_PRICE1, Cnac);
           ObjectSet("BodyX" + Lt1, OBJPROP_TIME2, Time[Lt-2]);
           ObjectSet("BodyX" + Lt1, OBJPROP_PRICE2, Cnac - RazmBoXO);
           ObjectSet("BodyX" + Lt1, OBJPROP_STYLE, STYLE_SOLID);
           ObjectSet("BodyX" + Lt1, OBJPROP_BACK, False);
            ObjectSet("BodyX"+Lt1,OBJPROP_COLOR,Yellow);
           }
           Cnac -= RazmBoXO; 
           Tb = 0; 
         } 
    }
   
   //*******************************Определение торговых сигналов********************************************
        int Lbd=Lt1;  //last restanle
        double last=ObjectGet("BodyX" + Lbd, OBJPROP_TIME2);
        
        for(i=Lt1; i>0;i--)
        {if(last!=ObjectGet("BodyX" + i, OBJPROP_TIME2)) break;
        }
        int Lbd2=i+1;
        int Pbd=i;
        last=ObjectGet("BodyX" + Pbd, OBJPROP_TIME2);
        for(i=Pbd; i>0;i--)
        {if(last!=ObjectGet("BodyX" + i, OBJPROP_TIME2)) break;
        }
        int Pbd2=i+1;
        int ik2=iBarShift(NULL,0,ObjectGet("BodyX" + Lbd,OBJPROP_TIME2),FALSE);
        
        double price_L0=ObjectGet("BodyX" + Lbd, OBJPROP_PRICE2);
        double price_L1=ObjectGet("BodyX" + Lbd2, OBJPROP_PRICE1);
        double price_P0=ObjectGet("BodyX" + Pbd, OBJPROP_PRICE2);
        double price_P1=ObjectGet("BodyX" + Pbd2, OBJPROP_PRICE1);
        int cL,cP;
        if(price_L0>price_L1) cL=0; else cL=1;
        if(price_P0>price_P1) cP=0; else cP=1;
        
         if(cL==1&&cP==1){down[0]=High[0]+ 25*Point; c_alert(1);}
         if(cL==1&&cP==0&&price_L0<price_P1){down[0]=High[0]+ 25*Point;c_alert(1);}
         
         if(cL==0&&cP==0){up[0]=Low[0]- 25*Point; c_alert(0);}
         if(cL==0&&cP==1&&price_L0>price_P1){up[0]=Low[0]- 25*Point; c_alert(0);}
         
   return(0); 
  }
//+------------------------------------------------------------------+ 

 void c_alert(int w)
 {
 ftime=Time[0];
 if(count_a<count_Alert)
 {count_a+=1;
 if(w==0)  Alert(s,"    Х-О BUY"); else Alert( s,"    X-O SELL");
 }
 }