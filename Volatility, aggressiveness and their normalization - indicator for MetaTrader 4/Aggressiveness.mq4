//+---------------------------------------------------------------------+
//|                                              Aggressiveness.mq4     |
//|                                         Copyright © Trofimov 2009   |
//+---------------------------------------------------------------------+
//| Агрессивность                                                       |
//|                                                                     |
//| Описание: Показывает сколько пунктов проходит инструмент            |
//| в среднем за одну свечу, анализируя последние MyPeriod периодов     |
//| Неважно в каком направлении!                                        |
//|                                                                     |
//| Авторское право принадлежит Трофимову Евгению Витальевичу, 2009     |
//+---------------------------------------------------------------------+


#property copyright "Copyright © Trofimov Evgeniy Vitalyevich, 2009"
#property link      "http://TrofimovVBA.narod.ru/"

//---- Свойства индикатора
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Blue
#property indicator_width1 1

//---- Входящие параметры
extern int MyPeriod=22;
extern double Lot=0; // 0 - в пунктах
                     // >0 - в валюте депозита

bool ReDraw=true; //-если включен, то перерисовывает нулевой бар при каждом новом тике
// если выключен, то нулевой бар содержит фиксированное значение, вычисленное по предыдущим (готовым) барам
double Buff_line1[];
//+------------------------------------------------------------------+
//|                Функция инициализации индикатора                  |
//+------------------------------------------------------------------+
int init()
  {
//---- x дополнительных буфера, используемых для расчета
   IndicatorBuffers(1);
   IndicatorDigits(0); 
//---- параметры рисования (установка начального бара)
   SetIndexDrawBegin(0,MyPeriod);
//---- x распределенных буфера индикатора
   SetIndexBuffer(0,Buff_line1);
//---- имя индикатора и подсказки для линий
   if(Lot==0) {
      IndicatorShortName("Aggressiveness("+MyPeriod+"), (pips) = ");
   } else {
      IndicatorShortName("Aggressiveness("+MyPeriod+"), ("+AccountCurrency()+"·"+DoubleToStr(Lot,2)+") = ");
   }
   return(0);
  }
//+------------------------------------------------------------------+
//|                Функция индикатора                                |
//+------------------------------------------------------------------+
int start() {
   int limit, RD;
   if(ReDraw) RD=1;
   // Пропущенные бары
   int counted_bars=IndicatorCounted();
//---- обходим возможные ошибки
   if(counted_bars<0) return(-1);
//---- новые бары не появились и поэтому ничего рисовать не нужно
   limit=Bars-counted_bars-1+RD;

//---- out of range fix
   if(counted_bars==0) limit-=RD+MyPeriod;
 
//---- основные переменные
   double B;
//---- основной цикл
   for(int t=limit-RD; t>-RD; t--) {
      B=0;
      for(int x=t+MyPeriod-1; x>=t; x--) { 
         if(Close[x]>Open[x]) {
            //белая свеча
            B=B+(Close[x]-Close[x+1]);
            
         }else{
            //чёрная свеча
            B=B+(Close[x+1]-Close[x]);
         }
      }//Next x
      Buff_line1[t]=B/Point/MyPeriod;
      if(Lot>0) Buff_line1[t]=Buff_line1[t]*MarketInfo(Symbol(),MODE_TICKVALUE)*Lot;
      if(!ReDraw && t==1) Buff_line1[0]=Buff_line1[1];
   }//Next t
   return(0);
}
//+------------------------------------------------------------------+

