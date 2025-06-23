// Редактирование и исправления 22.09.2008 Николай Косицин
//+X================================================================X+
//|                                                ZerolagStochs.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+X================================================================X+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "perky_z@yahoo.com"
//---- отрисовка индикатора в отдельом окне
#property indicator_separate_window
//---- количество индикаторных буферов
#property indicator_buffers 2
//---- цвета индикатора
#property indicator_color1 Blue
#property indicator_color2 Red
//---- Объявление  индикаторных буферов
double FastTrendBuffer[];
double LowTrendBuffer[];
//---- Объявление целых констант
int StartBar;
//---- Объявление констант с плавающей точкой
double smoothConst, smoothing;
//+X================================================================X+
//| ZerolagStochs indicator initialization function                  |
//+X================================================================X+
int init()
  {
//---+
   //---- 2 индикаторных буфера использованы для счёта  
   SetIndexBuffer(0, FastTrendBuffer);
   SetIndexBuffer(1, LowTrendBuffer );
   //---- определение стиля исполнения графика
   SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE);
   //---- Установка формата точности отображения индикатора
   IndicatorDigits(Digits);
   //---- Имя индикатора в субъокне
   IndicatorShortName("Zero Lag Stocs");
   //---- Лэйбы для индикаторных линий
   SetIndexLabel(0, "FastTrendLine");
   SetIndexLabel(1, "LowTrendLine");
   //---- Инициализация констант
   smoothing = 15;
   StartBar = 89 + 21 + 1;
   smoothConst = (smoothing - 1.0) / smoothing;
   //---- установка номера бара, 
           //начиная с которого будет отрисовываться индикатор 
   SetIndexDrawBegin(0, StartBar - 1);
   SetIndexDrawBegin(1, StartBar);
   //---- Завершение инициализации
   return(0);
//---+
  }
//+X================================================================X+
//| ZerolagStochs indicator start function                           |
//+X================================================================X+
int start()
  {
//---+
   //---- проверка количества баров на достаточность для расчёта
   if (Bars < StartBar)
                 return(0);
   //---- Объявление статических переменных              
   static bool TrueStart;
   //---- Объявление переменных с плавающей точкой
   double FastTrend, LowTrend;
   double Stoch1, Stoch2, Stoch3, Stoch4, Stoch5;
   //----+ Объявление целых переменных и получение уже посчитанных баров
   int limit, MaxBar, bar, counted_bars = IndicatorCounted();
   //---- проверка на возможные ошибки
   if (counted_bars < 0)
                return(-1);
   //---- последний посчитанный бар должен быть пересчитан 
   if (counted_bars > 0)
               counted_bars--;
   //---- определение номера самого старого бара, 
               //начиная с которого будет произедён пересчёт всех баров
   MaxBar = Bars - 1 - StartBar;
   //---- определение номера самого старого бара, 
          //начиная с которого будет произедён пересчёт только новых баров
   limit = (Bars - 1 - counted_bars);
   
   //---- инициализация нуля
   if (limit >= MaxBar || !TrueStart)
    {
     limit = MaxBar;
     TrueStart = true;
     //----
     for (bar = Bars - 1; bar > MaxBar; bar--)
      { 
       FastTrendBuffer[bar] = 0.0;
       LowTrendBuffer [bar] = 0.0;
      }
     LowTrendBuffer[MaxBar + 1] = 0.0; //???
    } 
    
   //---+ ОСНОВНОЙ ЦИКЛ РАСЧЁТА ИНДИКАТОРА
   for (bar = limit; bar>= 0; bar--)
	 {
     Stoch1 = 0.05 * iStochastic(NULL, 0,  8,  3, 3, MODE_SMA, NULL, MODE_MAIN, bar);
     Stoch2 = 0.10 * iStochastic(NULL, 0, 21,  5, 3, MODE_SMA, NULL, MODE_MAIN, bar);
     Stoch3 = 0.16 * iStochastic(NULL, 0, 34,  8, 3, MODE_SMA, NULL, MODE_MAIN, bar);
     Stoch4 = 0.26 * iStochastic(NULL, 0, 55, 13, 3, MODE_SMA, NULL, MODE_MAIN, bar);
     Stoch5 = 0.43 * iStochastic(NULL, 0, 89, 21, 3, MODE_SMA, NULL, MODE_MAIN, bar); // StartBar = 89 + 21 + 1;!!!  
     //----
     FastTrend = Stoch1 + Stoch2 + Stoch3 + Stoch4 + Stoch5;
     //----
     LowTrend = FastTrend / smoothing + LowTrendBuffer[bar + 1] * smoothConst;
     //----
     FastTrendBuffer[bar] = FastTrend;
	  LowTrendBuffer [bar] = LowTrend;   
	 }
	//---+
	return(0);
//---+
  }
//+X----------------------------------------------------------------X+er [bar] = 0.0;
      }
      
     FastTrend = ZerolagStochs(Symbol(), 0, MODE_SMA, MODE_MAIN, 3, MaxBar + 1);
     LowTrendBuffer[MaxBar + 1] = FastTrend / smoothing;
    } 
    
   //---+ ОСНОВНОЙ ЦИКЛ РАСЧЁТА ИНДИКАТОРА
   for (bar = limit; bar>= 0; bar--)
	 {
     FastTrend = ZerolagStochs(Symbol(), 0, MODE_SMA, MODE_MAIN, 3, bar);
     //----
     LowTrend = FastTrend / smoothing + LowTrendBuffer[bar + 1] * smoothConst;
     //----
     FastTrendBuffer[bar] = FastTrend;
	  LowTrendBuffer [bar] = LowTrend;   
	 }
	//---+
	return(0);
//---+
  }
//+X----------------------------------------------------------------X+