/* Для  работы  индикатора  следует  положить файлы 
T3Series.mqh 
PriceSeries.mqh 
в папку (директорию): MetaTrader\experts\include\
Heiken Ashi#.mq4
в папку (директорию): MetaTrader\indicators\ */
//+------------------------------------------------------------------+  
//|                                          T3.2Bollinger Bands.mq4 | 
//|                        Copyright © 2006,        Nikolay Kositsin | 
//|                              Khabarovsk,   farria@mail.redcom.ru | 
//+------------------------------------------------------------------+  
#property copyright "Copyright © 2006, Nikolay Kositsin"
#property link "farria@mail.redcom.ru"
//---- отрисовка индикатора в главном окне
#property indicator_chart_window
//---- количество индикаторных буферов
#property indicator_buffers 1
//---- цвет индикатора
#property indicator_color1 Red
//---- ВХОДНЫЕ ПАРАМЕТРЫ ИНДИКАТОРА --------------------------------------------------------------------------------------------------+
extern int        T3Period= 14;     // период  усреднения T3Bollinger Bands
extern int           MA_method=0;   // метод усреднения
extern int           MA_Smooth=20;  // глубина сглаживания полученного Moving Avereges
extern int        Bands_Smooth=20;  // глубина сглаживания полученных Bollinger Bands
extern int    Smooth_Curvature=100; // параметр сглаживания, изменяющийся в пределах -100 ... +100, влияет на качество переходного процесса; 
extern int         Bands_Shift=0;   // cдвиг индикатора вдоль оси времени 
extern int Input_Price_Customs=0;   //Выбор цен, по которым производится расчёт индикатора 
//(0-CLOSE, 1-OPEN, 2-HIGH, 3-LOW, 4-MEDIAN, 5-TYPICAL, 6-WEIGHTED, 7-Heiken Ashi Close, 8-SIMPL, 9-TRENDFOLLOW, 10-0.5*TRENDFOLLOW,
//11-Heiken Ashi Low, 12-Heiken Ashi High,  13-Heiken Ashi Open, 14-Heiken Ashi Close.)
//---- -------------------------------------------------------------------------------------------------------------------------------+
//---- индикаторные буферы
double T3MovingBuffer[];
double Series_buffer [];
//+------------------------------------------------------------------+ 
//----+ Введение функции T3Series 
//----+ Введение функции T3SeriesResize 
//----+ Введение функции T3SeriesAlert 
//----+ Введение функции T3_ErrDescr  
#include <T3Series.mqh>
//+------------------------------------------------------------------+ 
//----+ Введение функции PriceSeries
//----+ Введение функции PriceSeriesAlert 
#include <PriceSeries.mqh>
//+------------------------------------------------------------------+  
//| T3.2Bollinger Bands initialization function                      | 
//+------------------------------------------------------------------+  
int init()
  {
//---- определение стиля исполнения графика
   SetIndexStyle(0,DRAW_LINE);
//---- 4 индикаторных буфера использованы для счёта  
   IndicatorBuffers(2);
   SetIndexBuffer(0,T3MovingBuffer);
   SetIndexBuffer(1,Series_buffer);
//---- установка значений индикатора, которые не будут видимы на графике
   SetIndexEmptyValue(0,0);
   SetIndexEmptyValue(1,0);
//---- установка номера бара, начиная с которого будет отрисовываться индикатор 
   int drawbegin=100;
   SetIndexDrawBegin(0,drawbegin);
//---- имя для окон данных и лэйба для субъокон
   IndicatorShortName ("T3 Lnx( Period="+(string)T3Period+")");
   string Moving;
   switch(MA_method)
     {
      case  0: Moving= "T3SMA";break;
      case  1: Moving= "T3EMA";break;
      case  2: Moving="T3SSMA";break;
      case  3: Moving="T3LWMA";break;
      default: Moving="T3SMA";
     }
   SetIndexLabel (1, "T3 Moving Average "+Moving+" ");
//---- Установка формата точности отображения индикатора
   IndicatorDigits(Digits);
//----+ Изменение размеров буферных переменных функции T3Series, nT3.number=3(Три обращения к функции T3Series)
   if (Bands_Smooth<=1){if (T3SeriesResize(1)!=1)return(-1);}else if (T3SeriesResize(3)!=3)return(-1);
//---- установка алертов на недопустимые значения внешних переменных
   T3SeriesAlert(0,"MA_Smooth",MA_Smooth);
   T3SeriesAlert(0,"T3Period",T3Period);
   if((MA_method<0)||(MA_method>3))
     {Alert("Параметр MA_method должен быть от 0 до 3"+" Вы ввели недопустимое "
                                                           +(string)MA_method+ " будет использовано 0");}
   PriceSeriesAlert(Input_Price_Customs);
//---- корекция недопустимого значения параметра T3Period
   if(T3Period<1)T3Period=1;
//---- завершение инициализации
   return(0);
  }
//+------------------------------------------------------------------+  
//| T3.2Bollinger Bands iteration function                           | 
//+------------------------------------------------------------------+  
int start()
  {
//---- проверка количества баров на достаточность для расчёта
   if(Bars-1<=T3Period) return(0);
//---- Введение переменных с плавающей точкой  
   double Temp_Series,Resalt;
//----+ Введение целых переменных и получение уже подсчитанных баров
   int reset,MaxBar,MaxBarBB,bar,counted_bars=IndicatorCounted();
//---- проверка на возможные ошибки
   if (counted_bars<0)return(-1);
//---- последний подсчитанный бар должен быть пересчитан 
//---- (без этого пересчёта для counted_bars функция T3Series будет работать некорректно!!!)
   if (counted_bars>0) counted_bars--;
//---- определение номера самого старого бара, начиная с которого будет произедён пересчёт новых баров
   int limit=Bars-counted_bars-1;MaxBar=Bars-1-T3Period;MaxBarBB=MaxBar-30;
//----+ загрузка входных цен в буфер для расчёта       
   for(bar=limit;bar>=0;bar--)Series_buffer[bar]=PriceSeries(Input_Price_Customs,bar);
//---- проверка бара на достаточность для расчёта Bollinger Bands 
//---- инициализация нуля          
   if (limit>MaxBar)
     {
      for(bar=limit;bar>=MaxBar;bar--)T3MovingBuffer[bar]=0;
      limit=MaxBar;
     }
//----+ цикл расчёта Moving Avereges
   for(bar=limit;bar>=0;bar--)
     {
      //----+ формула для расчёта Moving Avereges
      Temp_Series=iMAOnArray(Series_buffer,0,T3Period,0,MA_method, bar);
      //----+ сглаживание полученного Moving Avereges
      //----+ обращение к функции T3Series за номером 0. Параметрs nT3.Length не меняtтся на каждом баре (nT3.din=0)
      Resalt=T3Series(0,0,MaxBar,limit,Smooth_Curvature,MA_Smooth,Temp_Series,bar,reset);
      //----+ проверка на отсутствие ошибки в предыдущей операции
      if(reset!=0)return(-1);
      T3MovingBuffer[bar]=Resalt;
     }
//---- завершение вычислений значений индикатора
   return(0);
  }
//+---------------------------------------------------------------------------+