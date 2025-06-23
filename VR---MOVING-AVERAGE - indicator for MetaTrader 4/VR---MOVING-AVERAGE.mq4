//===========================================================================================================================//
// Author VOLDEMAR227 site WWW.TRADING-GO.RU      SKYPE: TRADING-GO          e-mail: TRADING-GO@List.ru
//===========================================================================================================================//
#property copyright "Copyright © 2012, WWW.TRADING-GO.RU ."
#property link      "http://WWW.TRADING-GO.RU"
//===========================================================================================================================//
 
#property indicator_chart_window
 
#property indicator_buffers 3
extern string VR = "http://WWW.TRADING-GO.RU";
extern string Moving_Average  = "Settings";
extern int    Time_  = 1440;
extern bool   MA1 = true;
extern int    Ma1_period = 8     ;
extern int    Ma1_price  = 2     ;
extern int    Ma1_metod  = 1     ;
extern color  Ma1_color  = Red   ;
 
extern bool   MA2 = true;
extern int    Ma2_period = 30    ;
extern int    Ma2_price  = 1     ;
extern int    Ma2_metod  = 1     ;
extern color  Ma2_color  = Green ;
 
extern bool   MA3 = true;
extern int    Ma3_period = 66    ;
extern int    Ma3_price  = 3     ;
extern int    Ma3_metod  = 1     ;
extern color  Ma3_color  = Black ;
 
double     ExtBuffer0[];
double     ExtBuffer1[];
double     ExtBuffer2[];
 
int start()
  {
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
   ObjectCreate ("R", OBJ_LABEL, 0, 0, 0  );             
   ObjectSet    ("R", OBJPROP_CORNER,2    );          
   ObjectSet    ("R", OBJPROP_XDISTANCE,10);              
   ObjectSet    ("R", OBJPROP_YDISTANCE,10);              
   ObjectSetText("R", "WWW.TRADING-GO.RU",10, "Arial", Red);
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
SetIndexStyle (0,DRAW_LINE,1,2,Ma1_color);
SetIndexBuffer(0, ExtBuffer0 ); 
SetIndexLabel (0,"ExtBuffer0");
 
SetIndexStyle (1,DRAW_LINE,1,2,Ma2_color);
SetIndexBuffer(1, ExtBuffer1 ); 
SetIndexLabel (1,"ExtBuffer1");
 
SetIndexStyle (2,DRAW_LINE,1,2,Ma3_color);
SetIndexBuffer(2, ExtBuffer2 ); 
SetIndexLabel (2,"ExtBuffer2");
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
int t=0;
int c=0;
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
if (WindowExpertName()=="VR---MOVING-AVERAGE")
   {
   int counted_bars=IndicatorCounted();
   if(counted_bars > 0) {counted_bars--;}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
   int limit = Bars - counted_bars - 1;
   for(int x = limit; x >= 0; x--) 
   {
if (Period()==10080){t=Period()  ; c=Time_/10080;}
if (Period()==1440 ){t=Period()  ; c=Time_/1440 ;}
if (Period()==240  ){t=Period()  ; c=Time_/240  ;}
if (Period()==60   ){t=Period()  ; c=Time_/60   ;}
if (Period()==30   ){t=Period()  ; c=Time_/30   ;}
if (Period()==15   ){t=Period()  ; c=Time_/15   ;}
if (Period()==5    ){t=Period()  ; c=Time_/5    ;}
if (Period()==1    ){t=Period()  ; c=Time_/1    ;}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
if (MA1 == true){ExtBuffer0[x]=iMA(NULL,t,Ma1_period*c,0,Ma1_metod,Ma1_price,x);}
if (MA2 == true){ExtBuffer1[x]=iMA(NULL,t,Ma2_period*c,0,Ma1_metod,Ma2_price,x);}
if (MA3 == true){ExtBuffer2[x]=iMA(NULL,t,Ma3_period*c,0,Ma1_metod,Ma3_price,x);}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
}
}
else
{
Comment("Wrong name of the indicator");
}
 
}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
     }

}
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
