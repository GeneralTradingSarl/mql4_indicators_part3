//+------------------------------------------------------------------+
//| Рисует диаграммы Х0 по ценам закрытия                            |
//| Входные параметры: BoxSize - размер бокса в пунктах              |
//|                    ReversalBox - кол-во боксов для разворота     |
//|                    Candles = кол-во свечей для подсчета          |
//|                                                                  |
//|  Измените параметр indicator_color3 цветом вашей цветовой схемы  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, 4e"
#property link      "4ebur@mail.ru"
//----
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_color3 White
//----
extern double BoxSize=100;
extern int ReversalBox=3;
extern int Candles=3000;
//----
double PointArray[];
double FigureArray[];
double ZeroArray[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexBuffer(0,PointArray);
   SetIndexBuffer(1,FigureArray);
   SetIndexBuffer(2,ZeroArray);
//
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexStyle(2,DRAW_HISTOGRAM);
//
   SetIndexEmptyValue(0,0);
   SetIndexEmptyValue(1,0);
   SetIndexEmptyValue(2,0);
//----
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
   if(Bars<Candles) return;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+Candles;
   if(limit<0) return;

//----
   double BoxPointSize=BoxSize*Point; //Размер бокса в пунтах
   double ReversalSize=BoxPointSize*ReversalBox; // Размер разворота в пунктах
                                                 // Инициализация массивов
   for(int i=limit;i>0;i--)
     {
      PointArray[i]=0;
      FigureArray[i]=0;
      ZeroArray[i]=0;
     }
   int  beginPoint;    // Точка отсчета
   int  CurPoint;      //Текущая точка
   bool Direction;     // 1  - вверх, типа Х, 0-вниз, типа 0
   int LocalMin;       // Локальный минимум
   int LocalMax;       // Локальный максимум
   double beginIndex;  // индех начала отсчета
                       // Алгоритм расчета таков: Как только произошел разворот, рисуем прошлую диаграмму, и ждем следующего разворота
// Начальное направление идентифицируется по первой свече(белая - значир вверх, черная - вниз)
   Direction=(Close[Candles]-Open[Candles])>0;// Задаем начальное направление
   beginPoint=Candles; // Начальная точка отсчета
   CurPoint=Candles;   // Начальная текущая точка
   LocalMax=Candles;   // Начальный максимум
   LocalMin=Candles;   // Начальный минимум
   beginIndex=Close[beginPoint]; // Начальный индекс
//----
   for(i=Candles-1;i>0;i--)
     {
      CurPoint=i; // Сдвиг текущей точки
      LocalMax=Highest(NULL,0,MODE_CLOSE,beginPoint-CurPoint,CurPoint);
      LocalMin=Lowest(NULL,0,MODE_CLOSE,beginPoint-CurPoint,CurPoint);
      if(Direction) // Вверх
        {
         if(Close[LocalMax]-Close[CurPoint]>=ReversalSize) // Разворот вниз
           {
            int boxes=MathFloor(((Close[LocalMax]-Close[beginPoint])/(BoxSize*Point))); // вычисляем кол-во боксов
            for(int j=beginPoint;j>LocalMax-1;j--)
              {
               PointArray[j]=beginIndex+BoxSize*boxes*Point; //Рисуем иксы
               ZeroArray[j]=beginIndex;  // Пробелы
              }
            beginPoint=LocalMax-1; // Сдвигаем начальную точку на бывший максимум
            beginIndex=beginIndex+BoxSize*(boxes-1)*Point; // Сдвигаем индекс на один бокс вниз
            LocalMin=CurPoint;
            Direction=0; // Указываем что началось движение вниз  
           }
        }
      else  // Вниз
        {
         if(Close[CurPoint]-Close[LocalMin]>=ReversalSize) // Разворот вверх
           {
            boxes=MathFloor(((Close[beginPoint]-Close[LocalMin])/(BoxSize*Point)));// вычисляем кол-во боксов
            //----
            for(j=beginPoint;j>LocalMin-1;j--)
              {
               FigureArray[j]=beginIndex; //Рисуем нули
               ZeroArray[j]=beginIndex-BoxSize*boxes*Point;   // Пробелы
              }
            beginPoint=LocalMin-1; // Сдвигаем начальную точку на бывший максимум
            Direction=1; // Указываем что началось движение вниз  
            LocalMax=CurPoint;
            beginIndex=beginIndex-BoxSize*(boxes-1)*Point; // Сдвигаем индекс на один бокс вверх
           }
        }
     }
// Рисуем текущий разворот
   if(Direction)
     {
      LocalMax=Highest(NULL,0,MODE_CLOSE,beginPoint-CurPoint,CurPoint);
      boxes=MathFloor(((Close[LocalMax]-Close[beginPoint])/(BoxSize*Point))); // вычисляем кол-во боксов
      //----
      for(j=beginPoint;j>0;j--)
        {
         PointArray[j]=beginIndex+BoxSize*boxes*Point; //Рисуем иксы
         ZeroArray[j]=beginIndex;  // Пробелы
        }
     }
   else
     {
      LocalMin=Lowest(NULL,0,MODE_CLOSE,beginPoint-CurPoint,CurPoint);
      boxes=MathFloor(((Close[beginPoint]-Close[LocalMin])/(BoxSize*Point)));// вычисляем кол-во боксов

      for(j=beginPoint;j>0;j--)
        {
         FigureArray[j]=beginIndex;//Рисуем нули
         ZeroArray[j]=beginIndex-BoxSize*boxes*Point;  // Пробелы
        }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
