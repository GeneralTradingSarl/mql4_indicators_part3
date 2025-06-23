//+------------------------------------------------------------------+
//|                                                Specification.mq4 |
//|                      Copyright © 2007, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.ru/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.ru/"

//---- indicator settings
#property  indicator_separate_window


extern color  backColor=White;
extern color  textColor=Black;
extern int fontSize=10;

int Yshift=20;
int Xshift=10;
string objectNameMask="spec";
string shortName;
string accountCompany="";
bool toDeleteObjects=false;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteObjects()
   {
//----
   Print("Удаляем");
   int win = WindowFind(shortName);
   if (win>=0) 
      {
      int deleted=ObjectsDeleteAll(win,OBJ_LABEL);
      if (deleted>0) 
         {
         Print("Удалено ",deleted," объектов");
         toDeleteObjects=false;
         }
      }
//----
   return;
   }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
   {
   shortName=AccountCompany()+": "+Symbol();
   IndicatorShortName(shortName);
   if((color)ChartGetInteger(0,CHART_COLOR_BACKGROUND)==textColor)
      textColor=clrWhite;
   return(INIT_SUCCEEDED);
   }
//+------------------------------------------------------------------+
//| выводит значение в метку                                         |
//+------------------------------------------------------------------+
void SetValue(int line,int column ,string value, int windowHandle)
   {
//----
   string objectName = objectNameMask+"_"+line+"_"+column;
   int objWin = ObjectFind(objectName);
   if (objWin==-1) // такого объекта нет
      {
      ObjectCreate(objectName,OBJ_LABEL,windowHandle,0,0,0);// создаем метку в окне номер windowHandle
      ObjectSet(objectName,OBJPROP_CORNER,0);               // координаты привязываем к левому углу
      ObjectSet(objectName,OBJPROP_XDISTANCE,Xshift+column*200);      // отступ по вертикали в пикселах
      ObjectSet(objectName,OBJPROP_YDISTANCE,Yshift+line*20);   // отступ по горизонтали в пикселах
      ObjectSetText(objectName, value, fontSize, "Arial", textColor) ;

      }
   else  // объект есть, посмотрим в каком он окне
      {
      if (objWin==windowHandle) return;
      else // объект не в том окне, удалим его
         {
         ObjectDelete(objectName);
         }
      }         
//----
   return;
   }
//+------------------------------------------------------------------+
//| готовит массив с информацией                                     |
//+------------------------------------------------------------------+
void PrepareInfo(string & array[][])
   {
//----
   ArrayResize(array,21);
/*
MODE_POINT 11 Размер пункта в валюте котировки. Для текущего инструмента хранится в предопределенной переменной Point 
MODE_DIGITS 12 Количество цифр после десятичного точки в цене инструмента. Для текущего инструмента хранится в предопределенной переменной Digits 
MODE_SPREAD 13 Спрэд в пунктах 
MODE_STOPLEVEL 14 Минимально допустимый уровень стоп-лосса/тейк-профита в пунктах 
MODE_LOTSIZE 15 Размер контракта в базовой валюте инструмента 
MODE_TICKVALUE 16 Размер минимального изменения цены инструмента в валюте депозита 
MODE_TICKSIZE 17 Минимальный шаг изменения цены инструмента в пунктах 
MODE_SWAPLONG 18 Размер свопа для длинных позиций 
MODE_SWAPSHORT 19 Размер свопа для коротких позиций 
MODE_TRADEALLOWED 22 Разрешение торгов по указанному инструменту 
MODE_MINLOT 23 Минимальный размер лота 
MODE_LOTSTEP 24 Шаг изменения размера лота 
MODE_MAXLOT 25 Максимальный размер лота 
MODE_SWAPTYPE 26 Метод вычисления свопов. 0 - в пунктах; 1 - в базовой валюте инструмента; 2 - в процентах; 3 - в валюте залоговых средств. 
MODE_PROFITCALCMODE 27 Способ расчета прибыли. 0 - Forex; 1 - CFD; 2 - Futures 
MODE_MARGINCALCMODE 28 Способ расчета залоговых средств. 0 - Forex; 1 - CFD; 2 - Futures; 3 - CFD на индексы 
MODE_MARGININIT 29 Начальные залоговые требования для 1 лота 
MODE_MARGINMAINTENANCE 30 Размер залоговых средств для поддержки открытых позиций в расчете на 1 лот 
MODE_MARGINHEDGED 31 Маржа, взимаемая с перекрытых позиций в расчете на 1 лот 
MODE_MARGINREQUIRED 32 Размер свободных средств, необходимых для открытия 1 лота на покупку 
MODE_FREEZELEVEL 33 Уровень заморозки ордеров в пунктах. Если цена исполнения находится в пределах, определяемых уровнем заморозки, то ордер не может быть модифицирован, отменен или закрыт. 

*/
   int temp,digits=MarketInfo(Symbol(),MODE_DIGITS);
   
   array[0][0]="MODE_POINT";
   array[0][1]=DoubleToStr(MarketInfo(Symbol(),MODE_POINT),digits);

   array[1][0]="MODE_DIGITS";
   temp=MarketInfo(Symbol(),MODE_DIGITS);
   array[1][1]=temp;

   array[2][0]="MODE_SPREAD";
   temp=MarketInfo(Symbol(),MODE_SPREAD);
   array[2][1]=temp;
   
   array[3][0]="MODE_STOPLEVEL";
   temp=MarketInfo(Symbol(),MODE_STOPLEVEL);
   array[3][1]=temp;

   array[4][0]="MODE_LOTSIZE";
   temp=MarketInfo(Symbol(),MODE_LOTSIZE);
   array[4][1]=temp;

   array[5][0]="MODE_TICKVALUE";
   array[5][1]=DoubleToStr(MarketInfo(Symbol(),MODE_TICKVALUE),digits);

   array[6][0]="MODE_TICKSIZE";
   array[6][1]=MarketInfo(Symbol(),MODE_TICKSIZE);

   array[7][0]="MODE_SWAPLONG";
   array[7][1]=MarketInfo(Symbol(),MODE_SWAPLONG);

   array[8][0]="MODE_SWAPSHORT";
   array[8][1]=MarketInfo(Symbol(),MODE_SWAPSHORT);

   array[9][0]="MODE_TRADEALLOWED";
   temp=MarketInfo(Symbol(),MODE_TRADEALLOWED);
   if (temp==0) array[9][1]="diasbled"; else array[9][1]="allowed";

   array[10][0]="MODE_MINLOT";
   array[10][1]=DoubleToStr(MarketInfo(Symbol(),MODE_MINLOT),digits);

   array[11][0]="MODE_LOTSTEP";
   array[11][1]=DoubleToStr(MarketInfo(Symbol(),MODE_LOTSTEP),digits);

   array[12][0]="MODE_MAXLOT";
   temp=MarketInfo(Symbol(),MODE_MAXLOT);
   array[12][1]=temp;

   array[13][0]="MODE_SWAPTYPE";
   temp=MarketInfo(Symbol(),MODE_SWAPTYPE);
   switch (temp)
      {
      case 0: array[13][1]="points"; break;
      case 1: array[13][1]="base currency"; break;
      case 2: array[13][1]="percent"; break;
      case 3: array[13][1]="margin currency"; break;
      }

   array[14][0]="MODE_PROFITCALCMODE";
   temp=MarketInfo(Symbol(),MODE_PROFITCALCMODE);
   switch (temp)
      {
      case 0: array[14][1]="Forex"; break;
      case 1: array[14][1]="CFD"; break;
      case 2: array[14][1]="Futures"; break;
      }

   array[15][0]="MODE_MARGINCALCMODE";
   temp=MarketInfo(Symbol(),MODE_MARGINCALCMODE);
   switch (temp)
      {
      case 0: array[15][1]="Forex"; break;
      case 1: array[15][1]="CFD"; break;
      case 2: array[15][1]="Futures"; break;
      case 3: array[15][1]="CFD on Index"; break;
      }

   array[16][0]="MODE_MARGININIT";
   array[16][1]=DoubleToStr(MarketInfo(Symbol(),MODE_MARGININIT),2);

   array[17][0]="MODE_MARGINMAINTENANCE";
   array[17][1]=DoubleToStr(MarketInfo(Symbol(),MODE_MARGINMAINTENANCE),2);

   array[18][0]="MODE_MARGINHEDGED";
   array[18][1]=DoubleToStr(MarketInfo(Symbol(),MODE_MARGINHEDGED),2);

   array[19][0]="MODE_MARGINREQUIRED";
   array[19][1]=DoubleToStr(MarketInfo(Symbol(),MODE_MARGINREQUIRED),2);

   array[20][0]="MODE_FREEZELEVEL";
   temp=MarketInfo(Symbol(),MODE_FREEZELEVEL);
   array[20][1]=temp;


//   MarketInfo


//----
   return;   
   }
//+------------------------------------------------------------------+
//|   вывести в окно индикатора                                      |
//+------------------------------------------------------------------+
void Show(string &valueArray[][])
   {
   int win = WindowFind(shortName);
   //Print("win=",win);

   if (win==-1) return;
//----
   
   int i,l,size=ArrayRange(valueArray,0);
   int length=ArrayRange(valueArray,1);
   for (i=0;i<size;i++)
      {
      for (l=0;l<length;l++) SetValue(i,l,valueArray[i][l],win);
      }
//----
   return;
   }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  RefreshAccountInfo()
   {
//----
   static int acc=0;
   if (accountCompany!=AccountCompany()|| acc!=AccountNumber()) 
      {
      //Print("AccountNumber()=",AccountNumber());
      //Print("AccountCompany()=",AccountCompany());
      accountCompany=AccountCompany();
      acc=AccountNumber();
      init();
      DeleteObjects();
      }
//----
   }

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   string specifications[][2];
   RefreshAccountInfo();
   if (toDeleteObjects)
      {
      //Print("toDeleteObjects=",toDeleteObjects);
      toDeleteObjects=false;
      DeleteObjects();
      }
   PrepareInfo(specifications);
   //Print("Размер массива спецификации равен ",ArrayRange(specifications,0));
   Show(specifications);
//----
   return(0);
  }
//+------------------------------------------------------------------+