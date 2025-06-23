//+------------------------------------------------------------------+
//|                                                    TimeLines.mq4 |
//|                                                      Denis Orlov |
//|                                    http://denis-or-love.narod.ru |
/*
Автоматическая разлиновка графика по времени и таймер. 
Подробно:
http://codebase.mql4.com/ru/6093

Automatic marking of the chart by the time and the timer. 
In detail:
http://codebase.mql4.com/6095

***
Все мои индикаторы:
http://codebase.mql4.com/ru/author/denis_orlov
***
ПОЛЬЗУЙТЕСЬ И ПРОЦВЕТАЙТЕ!
***
All my indicators:

http://codebase.mql4.com/author/denis_orlov
***
USE AND PROSPER!

*/
//+------------------------------------------------------------------+
#property copyright "Denis Orlov"
#property link      "http://denis-or-love.narod.ru"

#property indicator_chart_window

#define Pr "TimeLines "

extern int period=15;
extern color LineColor=Blue;
extern int LineWidth=1;
extern int LineStyle=2;
extern int History=100;
extern bool TimeAlert=false;
extern bool Back=true;//Рисовать ка фон

int per;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   /*if(period<=Period()|| period<5)
     Alert(
     "Индикатор TimeLines не будет работать на этом ТФ"+"\n"+
     "со значением \"period\"="+period+"\n"+
     "Измените это значение, пожалуйста."+"\n"+
     "Indicator TimeLines will not work on this TF"+"\n"+
     "with the value of the \"period\"="+period+"\n"+
     "Change this value, please.");*/
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   Delete_My_Obj(Pr+PeriodToStr(period));
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
  if(period<=Period()|| period<5) return(0);
   
   int   Counted_bars=IndicatorCounted();
   
   if(Counted_bars>0)
      {
         if (per == Time[0]) return;
            per = Time[0];
          CheckAndDraw(Time[0]);
          return;
      }
   
   int      i=Bars-Counted_bars-1;           // Индекс первого непосчитанного  
     if (History>0&&i>History-1)                 // Если много баров то ..      
       i=History-1; 
       
      while(i>=0)                      // Цикл по непосчитанным барам     
      {
      CheckAndDraw(Time[i]);  
       
      i--;
      }
         
//----
   return(0);
  }
//+------------------------------------------------------------------+
void CheckAndDraw(datetime t)
{   
    int TM=TimeMinute(t), TH=TimeHour(t) ;
    bool draw=false;
    
      if(period==5)
          {  
            if( TM==0 || TM==5 ||TM==10 ||TM==15 ||TM==20||TM==25 ||TM==30 
            ||TM==35 ||TM==40 ||TM==45||TM==50||TM==55) 
            draw=true;
          }  
      if(period==15)
          {
          if( TM==0 || TM==15 ||TM==30 ||TM==45) 
            draw=true;
          }      
      if(period==30)
          {
          if( TM==0 || TM==30) 
            draw=true;
          }      
      if(period==60)
          {
           if( TM==0) 
            draw=true;
          }      
      if(period==240)
          {
            if(TM==0 && (TH==0 ||TH==4||TH==8||TH==12||TH==16||TH==20||TH==24) ) 
            draw=true;
          }      
      if(period==1440)
          {
            if(TH==0 && TM==0) 
            draw=true;
          }       
      if(period==10080)
          {
            if(TH==0 && TM==0 && TimeDayOfWeek(t)==1 ) 
            draw=true;
          } 
      if(period==43200)
          {
            if(TH==0 && TM==0 && TimeDay(t)==1 ) 
            draw=true;
          }      
              
      string LName=Pr+PeriodToStr(period)+" "+TimeToStr(t,TIME_DATE|TIME_MINUTES);
      if(draw && ObjectFind(LName)<0)
         {   
                  ObjectCreate( LName,OBJ_VLINE,0,t,0);
                  ObjectSet( LName, OBJPROP_COLOR , LineColor);
                  ObjectSet( LName, OBJPROP_WIDTH , LineWidth);
                  if(Back==true)ObjectSet( LName, OBJPROP_BACK, Back);
                  if(LineWidth<2)
                  ObjectSet( LName, OBJPROP_STYLE , LineStyle);
                 // ObjectSetText( LName, DoubleToStr(TM,0));
                 
                 
         }
     string AlStr=Symbol()+" "+PeriodToStr(Period())+" : "+LName;
       
     int nt=t+period*60; 
      LName=Pr+PeriodToStr(period)+" "+TimeToStr(nt,TIME_DATE|TIME_MINUTES);
      if(draw && ObjectFind(LName)<0)
         {   
            if(TimeAlert && Time[0]==t) Alert(AlStr);
                 
                  ObjectCreate( LName,OBJ_VLINE,0,nt,0);
                  ObjectSet( LName, OBJPROP_COLOR , LineColor);
                  ObjectSet( LName, OBJPROP_WIDTH , LineWidth);
                  if(Back==true)ObjectSet( LName, OBJPROP_BACK, Back);
                  if(LineWidth<2)
                  ObjectSet( LName, OBJPROP_STYLE , LineStyle);
                 // ObjectSetText( LName, DoubleToStr(TM,0));
         }   
}
//----------------------
void Delete_My_Obj(string Prefix)
   {//Alert(ObjectsTotal());
   for(int k=ObjectsTotal()-1; k>=0; k--)  // По количеству всех объектов 
     {
      string Obj_Name=ObjectName(k);   // Запрашиваем имя объекта
      string Head=StringSubstr(Obj_Name,0,StringLen(Prefix));// Извлекаем первые сим

      if (Head==Prefix)// Найден объект, ..
         {
         ObjectDelete(Obj_Name);
         //Alert(Head+";"+Prefix);
         }                
        
     }
   }
//-------------------------------
string PeriodToStr(int Per)
   {
      switch(Per)                 // Расчёт  для..     
      {                              // .. различных ТФ     
      case     1: return("M1"); break;// Таймфрейм М1      
      case     5: return("M5"); break;// Таймфрейм М5      
      case    15: return("M15"); break;// Таймфрейм М15      
      case    30: return("M30"); break;// Таймфрейм М30      
      case    60: return("H1"); break;// Таймфрейм H1      
      case   240: return("H4"); break;// Таймфрейм H4      
      case  1440: return("D1"); break;// Таймфрейм D1      
      case 10080: return("W1"); break;// Таймфрейм W1      
      case 43200: return("МN"); break;// Таймфрейм МN     
      }
   }