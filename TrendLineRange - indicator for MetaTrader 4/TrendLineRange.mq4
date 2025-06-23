//+------------------------------------------------------------------+
//|                                               TrendLineRange.mq4 |
//|                                               Сократилин Алексей |
//|                                        sokratilin@brocompany.com |
//+------------------------------------------------------------------+
#property copyright "Сократилин Алексей"
#property link      "sokratilin@brocompany.com"

#property indicator_chart_window
//---- input parameters
extern int       PointsRange1=20;            //1-ое расстояние до трендовой линии  
extern int       PointsRange2=10;            //2-ое расстояние до трендовой линии
extern int       PointsRange3=5;             //3-ее расстояние до трендовой линии
extern string    IndexTrendLine;             //Индекс трендовой линии в списке объектов
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators

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
   static int S1,S2,S3;                               //Счетчики сигналов
   string TrendLine="Trendline "+IndexTrendLine;      //Добавление индекса тендовой линии к "Trendline"
   double Price=Bid;                                  //Текущая цена
   double TrendLineValue=NormalizeDouble(ObjectGetValueByShift(TrendLine,0),Digits);       //Текущее значение трендовой линии
   
   int Range=MathAbs((NormalizeDouble(Price,Digits)-TrendLineValue)*MathPow(10,Digits));
                                                       //Вычисление расстояния между текущей ценой и трендовой линией
   
   Comment("Range=",Range);
      
   if (Range<=PointsRange1 && Range>PointsRange2 && S1==0)     //Если текущее рассстояние <= расстояния1 и > расстояния2
      {                                                        //сигнал на этом промежутке не подавался, то подаем один сигнал.
         Alert("Range=",Range," Price=",Price," TrendLine=",TrendLineValue);
         S1=1; S2=0; S3=0;                                     //Обнуление счетчиков
      }   
   else
   if (Range<=PointsRange2 && Range>PointsRange3 && S2==0)     //Если текущее рассстояние <= расстояния2 и > расстояния3
      {                                                        //сигнал на этом промежутке не подавался, то подаем один сигнал.
         Alert("Range=", Range, " Price=", Price, " TrendLine=",TrendLineValue);
         S1=0; S2=1; S3=0;                                     //Обнуление счетчиков
      }   
   else
   if (Range<=PointsRange3 && S3==0)                           //Если текущее рассстояние <= расстояния3
      {                                                        //сигнал на этом промежутке не подавался, то подаем один сигнал.
         Alert("Range=", Range, " Price=", Price, " TrendLine=",TrendLineValue);
         S1=0; S2=0; S3=1;                                     //Обнуление счетчиков
      }   
  
   return(0);
  }
//+------------------------------------------------------------------+