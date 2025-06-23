//+------------------------------------------------------------------+
//|                                               ytg_Day_candle.mq4 |
//|                                   Copyright © 2009, Yuriy Tokman |
//|                                            yuriytokman@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Yuriy Tokman"
#property link      "yuriytokman@gmail.com"
//24 и 48  (цена  2-SMMA )и в советнике и на графике
#property indicator_chart_window
//------- Внешние параметры индикатора -------------------------------
extern color  lineColor    = Lavender;          // Цвет линий
extern int    TimeFrame    = 1440;              // Период графика
extern int    coun_bars    = 5;                 // Колличество баров
extern bool   Comm         = false;

extern string AsiaBegin    = "01:00";           // Открытие азиатской сессии
extern string AsiaEnd      = "10:00";           // Закрытие азиатской сессии
extern color  AsiaColor    = C'89,89,89';       // Цвет азиатской сессии
extern string EurBegin     = "07:00";           // Открытие европейской сессии
extern string EurEnd       = "16:00";           // Закрытие европейской сессии
extern color  EurColor     = C'89,89,89';       // Цвет европейской сессии
extern string USABegin     = "14:00";           // Открытие американской сессии
extern string USAEnd       = "23:00";           // Закрытие американской сессии
extern color  USAColor     = C'89,89,89';       // Цвет американской сессии

double st_b = 0;int brs = 0;double db = 0;int brc = 0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
  string char1[256]; int i;
  for (i = 0; i < 256; i++) char1[i] = CharToStr(i);
  string txt =  
  char1[121]+char1[117]+char1[114]+char1[105]+char1[121]+char1[116]+char1[111]
  +char1[107]+char1[109]+char1[97]+char1[110]+char1[64]+char1[103]+char1[109]
  +char1[97]+char1[105]+char1[108]+char1[46]+char1[99]+char1[111]+char1[109];
  
  Comment("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n  "+txt);

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   string vName;
   for(int i=ObjectsTotal()-1; i>=0;i--)
    {
     vName = ObjectName(i);
     if (StringFind(vName,"candle_") !=-1) ObjectDelete(vName);
    }
   Comment(""); 
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//----
   int limit;
   int counted_bars=IndicatorCounted();
   
   if(counted_bars<0) return(-1);

   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   if(limit>coun_bars)limit=coun_bars;

   for(int i=limit; i>=0; i--)
   {
    db = (iHigh(Symbol(),TimeFrame,i+1)-iLow(Symbol(),TimeFrame,i+1))/Point;
    //----------------D1
    if(Period()<TimeFrame){
    double   high_D1   = iHigh(Symbol(),TimeFrame,i);
    double   low_D1    = iLow(Symbol(),TimeFrame,i);    
    double   open_D1   = iOpen(Symbol(),TimeFrame,i);   
    double   close_D1  = iClose(Symbol(),TimeFrame,i);
    datetime delta_D1  = TimeFrame*60;
    datetime timeOP_D1 = iTime(Symbol(),TimeFrame,i);
    datetime timeCL_D1 = iTime(Symbol(),TimeFrame,i)+delta_D1;
    color    color_D1  = Tomato;
        
    TrendLineGraf("candle_high_D1"+DoubleToStr(timeOP_D1,0),timeOP_D1,high_D1,timeCL_D1,high_D1,lineColor,2,1);
    TrendLineGraf("candle_low_D1"+DoubleToStr(timeOP_D1,0),timeOP_D1,low_D1,timeCL_D1,low_D1,lineColor,2,1);
    TrendLineGraf("candle_open_D1"+DoubleToStr(timeOP_D1,0),timeOP_D1,open_D1,timeCL_D1,open_D1,lineColor,2,1);    
    TrendLineGraf("candle_close_D1"+DoubleToStr(timeOP_D1,0),timeOP_D1,close_D1,timeCL_D1,close_D1,lineColor,2,1);    
    TrendLineGraf("candle_se_D1"+DoubleToStr(timeOP_D1, 0),timeOP_D1,high_D1,timeOP_D1,low_D1,lineColor,2,1);
    TrendLineGraf("candle_os_D1"+DoubleToStr(timeOP_D1, 0),timeCL_D1,high_D1,timeCL_D1,low_D1,lineColor,2,1);

    //----ich
    TrendLineGraf("candle_ich_1"+DoubleToStr(timeOP_D1,0),timeOP_D1,indICH(TimeFrame,1,i),timeCL_D1,indICH(TimeFrame,1,i),Red,0,3);
    TrendLineGraf("candle_ich_2"+DoubleToStr(timeOP_D1,0),timeOP_D1,indICH(TimeFrame,2,i),timeCL_D1,indICH(TimeFrame,2,i),Blue,0,3);
    TrendLineGraf("candle_ich_3"+DoubleToStr(timeOP_D1,0),timeOP_D1,indICH(TimeFrame,3,i),timeCL_D1,indICH(TimeFrame,3,i),SandyBrown,0,3);
    TrendLineGraf("candle_ich_4"+DoubleToStr(timeOP_D1,0),timeOP_D1,indICH(TimeFrame,4,i),timeCL_D1,indICH(TimeFrame,4,i),Thistle,0,3);
        
    if(open_D1<close_D1)color_D1 = Lime;
    TrendLineGraf("candle__D1"+DoubleToStr(timeOP_D1, 0),timeCL_D1,open_D1,timeCL_D1,close_D1,color_D1,0,5);
    
    RICE_ARROW("candle_PriceHighD1",timeCL_D1,high_D1,lineColor,1);
    RICE_ARROW("candle_PriceLowD1",timeCL_D1,low_D1,lineColor,1);    
    RICE_ARROW("candle_PriceOpenD1",timeCL_D1,open_D1,lineColor,1);

    if(TimeFrame==1440)
    {    
    datetime dt=iTime(Symbol(),TimeFrame,i);
    datetime t1=StrToTime(TimeToStr(dt, TIME_DATE)+" "+AsiaBegin);
    datetime t2=StrToTime(TimeToStr(dt, TIME_DATE)+" "+AsiaEnd);
    RECTANGLE("candle__Asia"+DoubleToStr(timeOP_D1, 0),t1,high_D1,t2,low_D1,AsiaColor);    

    datetime t3=StrToTime(TimeToStr(dt, TIME_DATE)+" "+EurBegin);
    datetime t4=StrToTime(TimeToStr(dt, TIME_DATE)+" "+EurEnd);
    RECTANGLE("candle__Eur"+DoubleToStr(timeOP_D1, 0),t3,high_D1,t4,low_D1,EurColor);    
    
    datetime t5=StrToTime(TimeToStr(dt, TIME_DATE)+" "+USABegin);
    datetime t6=StrToTime(TimeToStr(dt, TIME_DATE)+" "+USAEnd);
    RECTANGLE("candle__USA"+DoubleToStr(timeOP_D1, 0),t5,high_D1,t6,low_D1,USAColor);
    }
            
    }     
   }   
//----
  for(int j=0;j<coun_bars;j++)
   {
    double bs = (iHigh(Symbol(),TimeFrame,j)-iLow(Symbol(),TimeFrame,j))/Point;
    if(st_b<bs){st_b=bs;brs=j;}    
   }
  double bs0 = (iHigh(Symbol(),TimeFrame,0)-iLow(Symbol(),TimeFrame,0))/Point;
//----  
  for(int jj=1;jj<coun_bars;jj++)
   {
    double bd = (iHigh(Symbol(),TimeFrame,jj)-iLow(Symbol(),TimeFrame,jj))/Point;
    if(bd<db){db=bd;brc=jj;}    
   }
//----       
  //Comment("\nБар= ",brs,"   Макс.бар=",st_b,"  Текущ.бар=",bs0,"  Мин.бар=",db,"  brc=",brc);
  if(Comm)Comment("На ",coun_bars," барах; Макс.бар№",brs,"=",st_b,"п."," Мин.бар№",brc,"=",db,"п."," Текущ.=",bs0);      
//----
   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Функция отображения трендовой линии                              |
//| автор: Юрий Токмань                                              |
//| e-mail: yuriytokman@gmail.com                                    |
//| ICQ#    481-971-287                                              |
//| Skype:  yuriy.g.t                                                |
//+------------------------------------------------------------------+
 void TrendLineGraf(string labebe,datetime time1,double price1,datetime time2,double price2,
                    color colir,int STYLE,int WIDTH )
  {
   if (ObjectFind(labebe)!=-1) ObjectDelete(labebe);
   ObjectCreate(labebe, OBJ_TREND, 0,time1,price1,time2,price2);
   ObjectSet(labebe, OBJPROP_COLOR, colir);
   ObjectSet(labebe, OBJPROP_STYLE,STYLE);
   ObjectSet(labebe, OBJPROP_WIDTH,WIDTH);
   ObjectSet(labebe, OBJPROP_RAY,0);
   ObjectSet(labebe, OBJPROP_BACK, true);
  }
//+------------------------------------------------------------------+
//| Функция отображения ценовой метки                                |
//| автор: Юрий Токмань                                              |
//| e-mail: yuriytokman@gmail.com                                    |
//| ICQ#    481-971-287                                              |
//| Skype:  yuriy.g.t                                                |
//+------------------------------------------------------------------+
 void RICE_ARROW(string label,datetime time1,double price1,color colir,int WIDTH )
  {
   if (ObjectFind(label)!=-1) ObjectDelete(label);
   ObjectCreate(label,OBJ_ARROW, 0,time1,price1);
   ObjectSet(label,OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
   ObjectSet(label, OBJPROP_COLOR, colir);
   ObjectSet(label, OBJPROP_WIDTH,WIDTH);
   ObjectSet(label, OBJPROP_BACK, true);
  }
//+------------------------------------------------------------------+ 
//+------------------------------------------------------------------+
//| Функция отображения прямоугольника                               |
//| автор: Юрий Токмань                                              |
//| e-mail: yuriytokman@gmail.com                                    |
//| ICQ#    481-971-287                                              |
//| Skype:  yuriy.g.t                                                |
//+------------------------------------------------------------------+
 void RECTANGLE(string labe,datetime time1,double price1,datetime time2,
                double price2,color colir)
  {
   if (ObjectFind(labe)!=-1) ObjectDelete(labe);
   ObjectCreate(labe, OBJ_RECTANGLE, 0,time1,price1,time2,price2);
   ObjectSet(labe, OBJPROP_COLOR, colir);
   ObjectSet(labe, OBJPROP_BACK, true);
  } 
//--------------------------------------------------------------------
double indICH (int Tf=0, int mode=1, int i =0)
  {
   //mode = 1 - TENKANSEN
   //       2 - KIJUNSEN
   //       3 - SENKOUSPANA
   //       4 - SENKOUSPANB
   //       5 - CHINKOUSPAN
            
   double j = iIchimoku(Symbol(),Tf,9,26,52,mode,i);
   return(j);
  }
//+------------------------------------------------------------------+
