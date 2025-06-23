//+------------------------------------------------------------------+
//|                                                      TimeOut.mq4 |
//|                              Доброжелатель, thanks to: komposter |
//|                                      mailto:komposterius@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Доброжелатель, thanks to: komposter"
#property link      "mailto:komposterius@mail.ru"


#property indicator_separate_window
#property indicator_minimum -1
#property  indicator_buffers 2
#property  indicator_color1  clrRed
#property  indicator_color2  clrLime

string name= "TimeOut";
bool first = true;
long Max_TimeOut;
datetime Max_TimeOut_Time;
double buf0[];
double buf1[];
long SummTimeOut,Average_TimeOut;
int Counted;

// Часовой пояс ( для Москвы  GMT_shift = 3 )
extern int GMT_shift=3;
// Кол-во отрисовываемых баров индикатора
extern int DrawBars=333;

extern color OKColor            = Lime;
extern color StandartColor      = White;
extern color AttentionColor=Yellow;
extern color WarningColor=Red;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorShortName(name);
   IndicatorDigits(3);
   SetIndexBuffer(0,buf0);
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexLabel(0,"TimeOut");
   SetIndexBuffer(1,buf1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexLabel(1,"Average TimeOut");
   SetIndexEmptyValue(1,0);
   first=true;
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   if(DrawBars>Bars && Bars>0) { DrawBars=Bars-2; }
// инициализация переменных
// цвет выводимой информации при значении индикатора <= 2
   color _color=OKColor;
// размер шрифта выводимой информации при значении индикатора <= 2
   int size=13;

//при первом запуске в окне индикатора создаём "текстовые метки", в которые будут выводиться результаты.
   if(first==true)
     {
      //поиск окна индикатора по имени
      int window=WindowFind(name);
      //если окно не найдено - "текстовые метки" будут созданы в окне графика
      if(window<0) { window=0; }
      ObjectCreate(name+"_1",OBJ_LABEL,window,0,0,0,0,0,0);
      ObjectSet(name+"_1",OBJPROP_CORNER,0);
      ObjectSet(name+"_1",OBJPROP_XDISTANCE,0);
      ObjectSet(name+"_1",OBJPROP_YDISTANCE,20);
      ObjectSetText(name+"_1","Last tick: ",13,"Arial",StandartColor);

      ObjectCreate(name+"_2",OBJ_LABEL,window,0,0,0,0,0,0);
      ObjectSet(name+"_2",OBJPROP_XDISTANCE,0);
      ObjectSet(name+"_2",OBJPROP_YDISTANCE,40);
      ObjectSetText(name+"_2","Last TimeOut: ",13,"Arial",StandartColor);

      ObjectCreate(name+"_3",OBJ_LABEL,window,0,0,0,0,0,0);
      ObjectSet(name+"_3",OBJPROP_XDISTANCE,0);
      ObjectSet(name+"_3",OBJPROP_YDISTANCE,60);
      ObjectSetText(name+"_3","Max TimeOut: ",13,"Arial",StandartColor);

      ObjectCreate(name+"_4",OBJ_LABEL,window,0,0,0,0,0,0);
      ObjectSet(name+"_4",OBJPROP_XDISTANCE,0);
      ObjectSet(name+"_4",OBJPROP_YDISTANCE,80);
      ObjectSetText(name+"_4","Ave TimeOut: ",13,"Arial",StandartColor);

      ObjectCreate(name+"_1_1",OBJ_LABEL,window,0,0,0,0,0,0);
      ObjectSet(name+"_1_1",OBJPROP_XDISTANCE,100);
      ObjectSet(name+"_1_1",OBJPROP_YDISTANCE,20);
      ObjectSetText(name+"_1_1","",13,"Arial",WarningColor);

      ObjectCreate(name+"_2_1",OBJ_LABEL,window,0,0,0,0,0,0);
      ObjectSet(name+"_2_1",OBJPROP_XDISTANCE,100);
      ObjectSet(name+"_2_1",OBJPROP_YDISTANCE,40);
      ObjectSetText(name+"_2_1","",size,"Arial",_color);

      ObjectCreate(name+"_3_1",OBJ_LABEL,window,0,0,0,0,0,0);
      ObjectSet(name+"_3_1",OBJPROP_XDISTANCE,100);
      ObjectSet(name+"_3_1",OBJPROP_YDISTANCE,60);
      ObjectSetText(name+"_3_1","",13,"Arial",WarningColor);

      ObjectCreate(name+"_4_1",OBJ_LABEL,window,0,0,0,0,0,0);
      ObjectSet(name+"_4_1",OBJPROP_XDISTANCE,100);
      ObjectSet(name+"_4_1",OBJPROP_YDISTANCE,80);
      ObjectSetText(name+"_4_1","",13,"Arial",WarningColor);
      for(int u =Bars-1; u>=0; u -- )
        { buf0[u]=0;  buf1[u]=0; }

      first=false;
      return(0);
     }
//производим подсчёты
// - задержка котировки
   long luft=(long)(LocalTime()-GMT_shift*3600) -(CurTime()-3600);
// - время и значение максимальной задержки
   if(Max_TimeOut<=luft || Max_TimeOut==0) { Max_TimeOut=luft; Max_TimeOut_Time=CurTime(); }
// - общая задержка
   SummTimeOut+=luft;
// - кол-во тиков
   Counted++;
// - средняя задержка
   Average_TimeOut=SummTimeOut/Counted;
   if(luft>2)
     {
      if(luft<5)
         // цвет и размер шрифта выводимой информации при значении индикатора от 2 до 5
        { _color=AttentionColor; /*size = 15;*/ }
      else
      // цвет и размер шрифта выводимой информации при значении индикатора >= 5
        { _color=WarningColor; /*size = 20;*/ }
     }
// изображение на графике - одна свеча соответствует одному тику
// хранятся последние DrawBars тиков
   for(int i=DrawBars; i>=0; i --)
     { buf0[i+1]=buf0[i]; buf1[i+1]=buf1[i]; }
   buf0[0] = luft;
   buf1[0] = Average_TimeOut;

// вывод информации в "текстовые метки"
   ObjectSetText(name+"_1_1",TimeToStr(CurTime(),TIME_SECONDS),13,"Arial",OKColor);
   ObjectSetText(name+"_2_1",luft+" сек",size,"Arial",_color);
   ObjectSetText(name+"_3_1",Max_TimeOut+" сек"+"  ( "+TimeToStr(Max_TimeOut_Time,TIME_SECONDS)+" )",13,"Arial",OKColor);
   ObjectSetText(name+"_4_1",DoubleToStr(Average_TimeOut,3)+" сек"+"  ( за "+Counted+" тик(-а, -ов)  )",13,"Arial",OKColor);

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
// при деинициализации - удаляем созданные "текстовые метки"
   ObjectDelete(name);
   ObjectDelete(name+"_1");
   ObjectDelete(name+"_2");
   ObjectDelete(name+"_3");
   ObjectDelete(name+"_4");
   ObjectDelete(name+"_1_1");
   ObjectDelete(name+"_2_1");
   ObjectDelete(name+"_3_1");
   ObjectDelete(name+"_4_1");
   return(0);
  }
//+------------------------------------------------------------------+
