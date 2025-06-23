//+------------------------------------------------------------------+
//|                                                         iVAR.mq4 |
//|                                        (C)opyright © 2008, Ilnur |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+

//   Индикатор отображает индекс вариации ценового ряда, вычисленного
// на минимальном предшествующем интервале длины 2^n. Индекс вариации
// показывает, что преобладает во временном ряду – трендовая или флетовая
// составляющая, или же ряд ведет себя случайно.

// М.М. Дубовиков и др. - Размерность минимального покрытия и локальный
// анализ фрактальных временных рядов.

#property copyright "(C)opyright © 2008, Ilnur"
#property link      "http://www.metaquotes.net"
//---- настройки индикатора
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red
#property indicator_level1 0.5
//---- входные параметры
extern int n = 5;
extern int nBars = 1000;
//---- буфер индикатора
double ibuffer[];
//+------------------------------------------------------------------+
//| Функция инициализации индикатора                                 |
//+------------------------------------------------------------------+
int init()
{
//---- настройка параметров отрисовки
   SetIndexBuffer(0,ibuffer);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexDrawBegin(0,Bars-nBars);
   SetIndexLabel(0,"iVAR");
//---- "короткое имя" отображаемое в окне индикатора
   IndicatorShortName("iVAR("+n+")");
   return(0);
}
//+------------------------------------------------------------------+
//| Основная функция индикатора                                      |
//+------------------------------------------------------------------+
int start()
{
   int i, j, k, nTotal, nCountedBars = IndicatorCounted();
   int ihigh, ilow, nInterval;
   double Delta, Xс, Yс, Sx, Sy, Sxx, Sxy;
//---- последний посчитанный бар будет пересчитан
   if(nCountedBars==0) nTotal = nBars;
   if(nCountedBars>0) nTotal = Bars-nCountedBars-1;
//---- основной цикл индикатора
   for(j=nTotal; j>=0; j--)
   {
      Sx = 0; Sy = 0; Sxx = 0; Sxy = 0;
      for(i=0; i<=n; i++)
      {
         nInterval = MathPow(2,n-i);
      //---- суммируем разницы максимальной и минимальной цен на интервале
         for(Delta=0, k=0; k<MathPow(2,i); k++)
         {
            ihigh = iHighest(Symbol(),0,MODE_HIGH,nInterval,nInterval*k+j);
            ilow = iLowest(Symbol(),0,MODE_LOW,nInterval,nInterval*k+j);
            Delta += High[ihigh]-Low[ilow];
         }
      //---- вычисляем координаты вариации в двойном логарифмическом масштабе
         Xс = (n-i)*MathLog(2.0);
         Yс = MathLog(Delta);
      //---- накапливаем данные для нахождения коэффициентов линии регрессии с помощью МНК
         Sx += Xс; 
         Sy += Yс;
         Sxx += Xс*Xс; 
         Sxy += Xс*Yс;
      }
   //---- вычисляем индекс вариации (коэффициент наклона линии регрессии)
      ibuffer[j] = -(Sx*Sy-(n+1)*Sxy)/(Sx*Sx-(n+1)*Sxx);
   }
   return(0);
}