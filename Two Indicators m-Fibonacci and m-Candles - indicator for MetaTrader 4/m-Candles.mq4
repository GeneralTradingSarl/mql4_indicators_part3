//+------------------------------------------------------------------+
//|                                                    M-Candles.mq4 |
//|         оригинальная идея для H1 и выше - Ким Игорь В. aka KimIV |
//|                                              http://www.kimiv.ru |
//|            Переписал для стандартных таймфреймов - Михаил Житнев |
//|                                                    ICQ 138092006 |
//|         2008.09.05  На любом графике показывает свечи старших ТФ |
//+------------------------------------------------------------------+
#property copyright "Житнев Михаил aka MikeZTN"
#property link      "ICQ 138092006"

#property indicator_chart_window

//------- Внешние параметры ------------------------------------------
extern int TFBar       = 240;           // Период старших свечек
extern int NumberOfBar = 100;           // Количество старших свечек
extern color ColorUp   = 0x003300;      // Цвет восходящей свечи
extern color ColorDown = 0x000033;      // Цвет нисходящей свечи

//------- Глобальные переменные --------------------------------------

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void init() {
  int i;

  for (i=0; i<NumberOfBar; i++) {
    ObjectDelete("BodyTF"+TFBar+"Bar"+i);
    ObjectDelete("ShadowTF"+TFBar+"Bar" + i);
  }
  for (i=0; i<NumberOfBar; i++) {
    ObjectCreate("BodyTF"+TFBar+"Bar"+i, OBJ_RECTANGLE, 0, 0,0, 0,0);
    ObjectCreate("ShadowTF"+TFBar+"Bar"+i, OBJ_TREND, 0, 0,0, 0,0);
  }
  Comment("");
}

//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
void deinit() {
  // Удаление объектов
  for (int i=0; i<NumberOfBar; i++) {
    ObjectDelete("BodyTF"+TFBar+"Bar"+i);
    ObjectDelete("ShadowTF"+TFBar+"Bar" + i);
  }
  Comment("");
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() {
  int shb=0, sh1=1, d;
  double   po, pc;       // Цены открытия и закрытия старших свечек
  double   ph=0, pl=500; // Цены хай и лоу старших свечек
  datetime to, tc, ts;   // Время открытия, закрытия и теней старших свечек

  
  bool OK_Period=false;   
  switch (TFBar)
  {    
    case 1:OK_Period=true;break;
    case 5:OK_Period=true;break;
    case 15:OK_Period=true;break;
    case 30:OK_Period=true;break;
    case 60:OK_Period=true;break;
    case 240:OK_Period=true;break;
    case 1440:OK_Period=true;break;
    case 10080:OK_Period=true;break;
    case 43200:OK_Period=true;break;
  }
  if (OK_Period==false)
     {
       Comment("Вы ввели нестандартную цифру таймфрейма TFBar! Необходимо ввести одну из следующих: 1,5,15,30,60,240,1440 и т.д.");   
       return(0);
     }
  if (Period()>TFBar) 
  {
    Comment("Задаваемый стандартный период должен быть больше текущего! (Текущий равен " + Period() + ")");
    return(0);
  }
    
    shb=0;
    // Бежим по старшим свечкам  
    while (shb<NumberOfBar) 
    {
      to = iTime(Symbol(), TFBar, shb);
      tc = iTime(Symbol(), TFBar, shb) + TFBar*60;
      po = iOpen(Symbol(), TFBar, shb);
      pc = iClose(Symbol(), TFBar, shb);
      ph = iHigh(Symbol(), TFBar, shb); 
      pl = iLow(Symbol(), TFBar, shb); 
      //устанавливаем  ректангелы
      ObjectSet("BodyTF"+TFBar+"Bar"+shb, OBJPROP_TIME1, to);  //время открытия
      ObjectSet("BodyTF"+TFBar+"Bar"+shb, OBJPROP_PRICE1, po); //цена открытия
      ObjectSet("BodyTF"+TFBar+"Bar"+shb, OBJPROP_TIME2, tc);  //время закрытия
      ObjectSet("BodyTF"+TFBar+"Bar"+shb, OBJPROP_PRICE2, pc); //цена закрытия
      ObjectSet("BodyTF"+TFBar+"Bar"+shb, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet("BodyTF"+TFBar+"Bar"+shb, OBJPROP_BACK, True);
      //устанавливаем тени
      ts = to + MathRound((TFBar*60)/2);
      ObjectSet("ShadowTF"+TFBar+"Bar"+shb, OBJPROP_TIME1, ts);
      ObjectSet("ShadowTF"+TFBar+"Bar"+shb, OBJPROP_PRICE1, ph);
      ObjectSet("ShadowTF"+TFBar+"Bar"+shb, OBJPROP_TIME2, ts);
      ObjectSet("ShadowTF"+TFBar+"Bar"+shb, OBJPROP_PRICE2, pl);
      ObjectSet("ShadowTF"+TFBar+"Bar"+shb, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet("ShadowTF"+TFBar+"Bar"+shb, OBJPROP_WIDTH, 3);
      ObjectSet("ShadowTF"+TFBar+"Bar"+shb, OBJPROP_BACK, True);
      ObjectSet("ShadowTF"+TFBar+"Bar"+shb, OBJPROP_RAY, False);            
      //устанавливаем цвета для всех объектов
      if (po<pc) {
          ObjectSet("BodyTF"+TFBar+"Bar"+shb, OBJPROP_COLOR, ColorUp);
          ObjectSet("ShadowTF"+TFBar+"Bar"+shb, OBJPROP_COLOR, ColorUp);
        } else {
          ObjectSet("BodyTF"+TFBar+"Bar"+shb, OBJPROP_COLOR, ColorDown);
          ObjectSet("ShadowTF"+TFBar+"Bar"+shb, OBJPROP_COLOR, ColorDown);
        }
      shb++;
     }       
      
  
  return(0);
}
//+------------------------------------------------------------------+