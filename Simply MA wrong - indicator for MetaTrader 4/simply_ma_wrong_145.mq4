//+------------------------------------------------------------------+
//|                                              Simply MA wrong.mq4 |
//|                                                       MetaQuotes |
//|                 http://forum.alpari-idc.ru/viewtopic.php?t=48186 |
//+------------------------------------------------------------------+
#property copyright "MetaQuotes"
#property link      "http://forum.alpari-idc.ru/viewtopic.php?t=48186"
//----
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red
//---- input parameters
extern int       PeriodMA=21;
extern int       ShiftMA=0;
//---- buffers
double ExtMapBuffer1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
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
   int    counted_bars=IndicatorCounted();
   int limit;   // ограничитель расчетов
   double val;  // временная переменная, для вычисления значений индикатора
//----
   if (counted_bars==0)   limit=Bars-PeriodMA; // посчитанных баров еще нет, будет считать с бара,
   // перед которым есть хотя бы PeriodMA-1 баров. 
   if (counted_bars>0)   limit=Bars-counted_bars-PeriodMA; // вычтем из числа доступных баров количество 
   //посчитанных баров
   Print("Bars=",Bars,"   limit=",limit,"  counted_bars=",counted_bars);
//----
   int i=limit;
   while(i>=0)
     {
      /*
      Необходимые вычисления val
      */
      val=0; // не забудем каждый раз обнулять служебную
      // переменную перед проходом в цикле
      for(int k=0;k<PeriodMA;k++)
        {
         val=val+Close[i+k];
        }
      val=val/PeriodMA;       // сумма после цикла есть, усредняем ее   
      ExtMapBuffer1[i]=val;  // установим эначение 
      //средней на баре с индексом i
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+

