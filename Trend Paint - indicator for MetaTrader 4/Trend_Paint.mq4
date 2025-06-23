//***********************************************************************//
//***********************************************************************//
//*                                                     Trend Paint.mq4 *//
//*                                         Copyright © 2009, BACKSPACE *//
//*                                            Updating from 23.01.2010 *//
//***********************************************************************//
//***********************************************************************//
//*                             Торгуй тренды                           *//
//*                            Уменьшай потери                          *//
//*                          Давай прибыли расти                        *//
//*                            Управляй рисками                         *//
//***********************************************************************//
#property copyright "Copyright © 2009, BACKSPACE"                        //
#property link      "Updating from 23.01.2010"                           //
//
#property indicator_chart_window                                         //
#property indicator_buffers 8                                            //
#property indicator_color1 Green                                         //
#property indicator_color2 Red                                           //
#property indicator_color3 Green                                         //
#property indicator_color4 Red                                           //
#property indicator_color5 Lavender                                      //
#property indicator_color6 Lavender                                      //
#property indicator_color7 Lavender                                      //
#property indicator_color8 Lavender                                      //
//******************// Ввод параметров индикатора
extern int    One_Method=1;                                              //   - метод One_MA
extern int    One_Period=15;                                             //   - период One_MA
extern double One_Round=0;                                               //   - коэффициент округления Rounding One
extern int    Two_Method=3;                                              //   - метод Rounding Two
extern int    Two_Period=18;                                             //   - период Rounding Two
extern double Two_Round=0;                                               //   - коэффициент округления Rounding Two
extern double SAR_Max=0.012;                                             //   - максимальное значение Parabolic SAR
extern double SAR_Step=0.004;                                            //   - шаг изменения Parabolic SAR
                                                                         //******************// Составные части индикатора
double Trend_Hi_Color[],                                                 //   - цвет High при тренде
Trend_Lo_Color[],                                                 //   - цвет Low при тренде
Trend_Op_Color[],                                                 //   - цвет Open при тренде
Trend_Cl_Color[],                                                 //   - цвет Close при тренде
Flat_Hi_Color[],                                                  //   - цвет High при флете
Flat_Lo_Color[],                                                  //   - цвет Low при флете
Flat_Op_Color[],                                                  //   - цвет Open при флете
Flat_Cl_Color[],                                                  //   - цвет Close при флете
One_MA[],                                                         //   - Moving Average One
One_Al[],                                                         //   - Алерты One
Rounding_One[],                                                   //   - Rounding One
Two_MA[],                                                         //   - Moving Average Two
Two_Al[],                                                         //   - Алерты Two
Rounding_Two[],                                                   //   - Rounding Two
Parabolic_SAR[],                                                  //   - Parabolic SAR       
SAR_Al[];                                                         //   - Алерты Parabolic SAR
                                                                  //******************// Глобальные переменные
int    One_Met,                                                          //   - метод One
One_Per,                                                          //   - период One
Two_Met,                                                          //   - метод Two
Two_Per,                                                          //   - период Two
Counter;                                                          //   - счётчик баров
double One_Ro,                                                           //   - коэффициент округления One
Two_Ro,                                                           //   - коэффициент округления Two
IndexHL=1,                                                        //   - индекс однонаправленного движения
HHigh,                                                            //   - максимум тела бара
LLow,                                                             //   - минимум тела бара
HHighPP,                                                          //   - Previous Point HHigh
LLowPP,                                                           //   - Previous Point LLow
ExtremumLong,                                                     //   - экстремум High
ExtremumShort;                                                    //   - экстремум Low
string TrendTyp="Flat",                                                  //   - тип тренда  
TransactionTyp="Short";                                           //   - тип сделки
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
                                                                  //***********************************************************************//
//**********************-Indicator Initialization-***********************//
//***********************************************************************//
//
void init()                                                              //
  {                                                  //******************// Настройки графического отображения
   IndicatorBuffers(8);                                                  //
   SetIndexStyle(0,DRAW_HISTOGRAM,0,1);                                  //
   SetIndexBuffer(0,Trend_Hi_Color);                                     //
   SetIndexStyle(1,DRAW_HISTOGRAM,0,1);                                  //
   SetIndexBuffer(1,Trend_Lo_Color);                                     //
   SetIndexStyle(2,DRAW_HISTOGRAM,0,3);                                  //
   SetIndexBuffer(2,Trend_Op_Color);                                     //
   SetIndexStyle(3,DRAW_HISTOGRAM,0,3);                                  //
   SetIndexBuffer(3,Trend_Cl_Color);                                     //
   SetIndexStyle(4,DRAW_HISTOGRAM,0,1);                                  //
   SetIndexBuffer(4,Flat_Hi_Color);                                      //
   SetIndexStyle(5,DRAW_HISTOGRAM,0,1);                                  //
   SetIndexBuffer(5,Flat_Lo_Color);                                      //
   SetIndexStyle(6,DRAW_HISTOGRAM,0,3);                                  //
   SetIndexBuffer(6,Flat_Op_Color);                                      //
   SetIndexStyle(7,DRAW_HISTOGRAM,0,3);                                  //
   SetIndexBuffer(7,Flat_Cl_Color);                                      //
                                                                         //******************// Период One
   if(One_Period>=1 && One_Period<=48)                                   //
      One_Per=One_Period;                                                 //
   else                                                                  //
   One_Per=21;                                                         //
//******************// Величина округления One
   if(One_Round>=0 && One_Round<=48)                                     //
      One_Ro = Point*One_Round;                                           //
   else                                                                  //
   One_Ro = Point*48;                                                  //
//******************// Период Two
   if(Two_Period>=1 && Two_Period<=48)                                   //
      Two_Per=Two_Period;                                                 //
   else                                                                  //
   Two_Per=21;                                                         //
//******************// Величина округления Two
   if(Two_Round>=0 && Two_Round<=48)                                     //
      Two_Ro = Point*Two_Round;                                           //
   else                                                                  //
   Two_Ro = Point*48;                                                  //
//******************// Метод One
   if(One_Method==1)One_Met=MODE_SMA;                              //
   else if(One_Method==2)One_Met=MODE_LWMA;                             //
   else if(One_Method==3)One_Met=MODE_EMA;                              //
   else                   One_Met=MODE_SMMA;                             //
                                                                         //******************// Метод Two
   if(Two_Method==1)Two_Met=MODE_SMA;                              //
   else if(Two_Method==2)Two_Met=MODE_LWMA;                             //
   else if(Two_Method==3)Two_Met=MODE_EMA;                              //
   else                   Two_Met=MODE_SMMA;                             //
                                                                         //*********//
   return(0);                                                            //
  }                                                                      //
//***********************************************************************//
//***********************-Maitreya_Bars_Paint-***************************//
//***********************************************************************//
//
void start()                                                             //
  {                                                                      //
//******************// Проверка работы индикатора
   if(One_Per>Bars||One_Ro>Bars||Two_Per>Bars||Two_Ro>Bars)              //
     {                                                                   //
      Alert("Недостаточно информации для работы индикатора.");           //
      return(0);                                                         //
     }                                                                   //
//Counter=IndicatorCounted();                                           //

   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+3;

   for(int mai=limit; mai>=1; mai--) //
     {                                                                   //
      SetAsIndexBuffer();                            //******************// Эмуляция индексации буфера
      Moving_Average(mai,"One_MA");                  //******************// Moving Average "One_MA"
      Rounding_One(mai);                             //******************// Rounding One
      Moving_Average(mai,"Two_MA");                  //******************// Moving Average "Two_MA"
      Rounding_Two(mai);                             //******************// Rounding Two
      Bars_High_Low_Init(mai);                       //******************// Инициализация High/Low
      Parabolic_Sar(mai);                            //******************// Расчёт Parabolic SAR
      Extremum_Long_Short(mai);                      //******************// Экстремумы Long/Short
      Typ_Of_Trend(mai);                             //******************// Определение типа тренда
      Paint_Bars(mai);                               //******************// Цвет бара в зависимости от тренда
     }                                                                   //
//*********//
   return(0);                                                            //
  }                                                                      //
//***********************************************************************//
//******************************-SubPogramms-****************************//
//***********************************************************************//
//
void SetAsIndexBuffer() //******************// Эмуляция индексации буфера
  {                                                                      //
   int NewSize = Bars;                                                   //
   if(ArraySize(One_MA) < NewSize)                                       //
     {                                                                   //
      ArraySetAsSeries(One_MA,false);                                   //
      ArraySetAsSeries(Rounding_One,false);                             //
      ArraySetAsSeries(One_Al,false);                                   //
      ArraySetAsSeries(Two_MA,false);                                   //
      ArraySetAsSeries(Rounding_Two,false);                             //
      ArraySetAsSeries(Two_Al,false);                                   //
      ArraySetAsSeries(Parabolic_SAR,false);                            //
      ArraySetAsSeries(SAR_Al,false);                                   //
      ArrayResize(One_MA,NewSize);                                      //
      ArrayResize(Rounding_One,NewSize);                                //
      ArrayResize(One_Al,NewSize);                                      //
      ArrayResize(Two_MA,NewSize);                                      //
      ArrayResize(Rounding_Two,NewSize);                                //
      ArrayResize(Two_Al,NewSize);                                      //
      ArrayResize(Parabolic_SAR,NewSize);                               //
      ArrayResize(SAR_Al,NewSize);                                      //
      ArraySetAsSeries(One_MA,true);                                    //
      ArraySetAsSeries(Rounding_One,true);                              //
      ArraySetAsSeries(One_Al,true);                                    //
      ArraySetAsSeries(Two_MA,true);                                    //
      ArraySetAsSeries(Rounding_Two,true);                              //
      ArraySetAsSeries(Two_Al,true);                                    //
      ArraySetAsSeries(Parabolic_SAR,true);                             //
      ArraySetAsSeries(SAR_Al,true);                                    //
     }                                                                   //
//*********//
   return(0);                                                            //
  }                                                                      //
//***********************************// Moving Average
double Moving_Average(int ma,string ma_name)                             //
  {                                                                      //
//******************// Moving Average "One_MA"
   if(ma_name=="One_MA")                                                 //
      One_MA[ma]=                                                         //
                 NormalizeDouble(iMA(NULL,0,One_Per,0,One_Met,PRICE_CLOSE,ma),4);    //
//******************// Moving Average "Two_MA"
   if(ma_name=="Two_MA")                                                 //
      Two_MA[ma]=                                                         //
                 NormalizeDouble(iMA(NULL,0,Two_Per,0,Two_Met,PRICE_CLOSE,ma),4);    //
//*********//
   return(0);                                                            //
  }                                                                      //
//***********************************// Rounding One
double Rounding_One(int ro)                                              //
  {                                                                      //
   if(One_MA[ro]>One_MA[ro+1]+One_Ro ||                               //
      One_MA[ro]<One_MA[ro+1]-One_Ro ||                               //
      One_MA[ro]>Rounding_One[ro+1]+One_Ro ||                         //
      One_MA[ro]<Rounding_One[ro+1]-One_Ro ||                         //
      (One_MA[ro]>Rounding_One[ro+1] && One_Al[ro+1]==1) ||            //
      (One_MA[ro]<Rounding_One[ro+1] && One_Al[ro+1]==-1))             //
      Rounding_One[ro] =One_MA[ro];                                   //
   else                                                              //
   Rounding_One[ro]=Rounding_One[ro+1];                            //
   if(Rounding_One[ro]<Rounding_One[ro+1]) One_Al[ro] =-1;            //
   if(Rounding_One[ro]>Rounding_One[ro+1]) One_Al[ro] =1;             //
   if(Rounding_One[ro]==Rounding_One[ro+1])One_Al[ro] =One_Al[ro+1];  //
                                                                      //*********//
   return(0);                                                            //
  }                                                                      //
//***********************************// Rounding Two
double Rounding_Two(int rt)                                              //
  {                                                                      //
   if(Two_MA[rt]>Two_MA[rt+1]+Two_Ro ||                               //
      Two_MA[rt]<Two_MA[rt+1]-Two_Ro ||                               //
      Two_MA[rt]>Rounding_Two[rt+1]+Two_Ro ||                         //
      Two_MA[rt]<Rounding_Two[rt+1]-Two_Ro ||                         //
      (Two_MA[rt]>Rounding_Two[rt+1] && Two_Al[rt+1]==1) ||            //
      (Two_MA[rt]<Rounding_Two[rt+1] && Two_Al[rt+1]==-1))             //
      Rounding_Two[rt] =Two_MA[rt];                                   //
   else                                                              //
   Rounding_Two[rt]=Rounding_Two[rt+1];                            //
   if(Rounding_Two[rt]<Rounding_Two[rt+1]) Two_Al[rt] =-1;            //
   if(Rounding_Two[rt]>Rounding_Two[rt+1]) Two_Al[rt] =1;             //
   if(Rounding_Two[rt]==Rounding_Two[rt+1])Two_Al[rt] =Two_Al[rt+1];  //
                                                                      //*********//
   return(0);                                                            //
  }                                                                      //
//***********************************// Инициализация High/Low 
double Bars_High_Low_Init(int bhli)                                      //
  {                                                                      //
   if(iOpen(NULL,0,bhli)>iClose(NULL,0,bhli))                            //
     {                                                                   //
      HHigh =iOpen(NULL,0,bhli);                                         //
      LLow  =iClose(NULL,0,bhli);                                        //
     }                                                                   //
   else if(iOpen(NULL,0,bhli)<iClose(NULL,0,bhli))                       //
     {                                                                   //
      HHigh =iClose(NULL,0,bhli);                                        //
      LLow  =iOpen(NULL,0,bhli);                                         //
     }                                                                   //
   else                                                                  //
     {                                                                   //
      HHigh =iClose(NULL,0,bhli);                                        //
      LLow  =iOpen(NULL,0,bhli);                                         //
     }                                                                   //
//*********//
   return(0);                                                            //
  }                                                                      //
//***********************************// Parabolic SAR
double Parabolic_Sar(int ps)                                             //
  {                                                                      //
   if(TransactionTyp=="Long")                                            //
     {                                                                   //
      //******************//   - условия разворота Short
      if(LLow<=Parabolic_SAR[ps+1])                                      //
        {                                                                //
         TransactionTyp="Short";                                         //
         Parabolic_SAR[ps]=ExtremumLong;                                 //
         ExtremumShort=LLow;                                             //
         IndexHL=1;                                                      //
         SAR_Al[ps]=-1;                                                  //
         return(0);                                                      //
        }                                                                //
      //******************//   - открытая позиция Long
      else                                                               //
        {                                                                //
         Parabolic_SAR[ps]=Parabolic_SAR[ps+1]+                          //
                           (SAR_Max+IndexHL*SAR_Step)*(HHighPP-Parabolic_SAR[ps+1]);        //
         if(HHigh>ExtremumLong)                                          //   - индекс однонаправленного движения
            IndexHL++;                                                    //
         HHighPP=HHigh;                                                  //
         SAR_Al[ps]=SAR_Al[ps+1];                                        //
         return(0);                                                      //
        }                                                                //
     }                                                                   //
   if(TransactionTyp=="Short")                                           //
     {                                                                   //
      //******************//   - условия разворота Long
      if(HHigh>=Parabolic_SAR[ps+1])                                     //
        {                                                                //
         TransactionTyp="Long";                                          //
         Parabolic_SAR[ps]=ExtremumShort;                                //
         ExtremumLong=HHigh;                                             //
         IndexHL=1;                                                      //
         SAR_Al[ps]=1;                                                   //
         return(0);                                                      //
        }                                                                   //
      //******************//   - открытая позиция Short
      else                                                               //
        {                                                                //
         Parabolic_SAR[ps]=Parabolic_SAR[ps+1]-                          //
                           (SAR_Max+IndexHL*SAR_Step)*(Parabolic_SAR[ps+1]-LLowPP);         //
         if(LLow<ExtremumShort)                                          //   - индекс однонаправленного движения
            IndexHL++;                                                    //
         LLowPP=LLow;                                                    //
         SAR_Al[ps]=SAR_Al[ps+1];                                        //
         return(0);                                                      //
        }                                                                //
     }                                                                   //
//*********//
   return(0);                                                            //
  }                                                                      //
//***********************************// Экстремумы Long/Short
double Extremum_Long_Short(int ehl)                                      //
  {                                                                      //
//******************//   - экстремум Long
   if(HHigh>ExtremumLong)                                                //
      ExtremumLong=HHigh;                                                 //
//******************//   - экстремум Short
   if(LLow<ExtremumShort)                                                //
      ExtremumShort=LLow;                                                 //
//*********//
   return(0);                                                            //
  }                                                                      //
//***********************************// Определение типа тренда 
void Typ_Of_Trend(int bp)                                                //
  {                                                                      //
   if(Rounding_Two[bp+1]<Rounding_One[bp+1] &&                           //
      Rounding_Two[bp+2]>=Rounding_One[bp+2] &&                          //
      Rounding_Two[bp+3]>Rounding_One[bp+3])                             //
     {                                                                   //
      TrendTyp="Buy";                                                    //
     }                                                                   //
   if(Rounding_Two[bp+1]>Rounding_One[bp+1] &&                           //
      Rounding_Two[bp+2]<=Rounding_One[bp+2] &&                          //
      Rounding_Two[bp+3]<Rounding_One[bp+3])                             //
     {                                                                   //
      TrendTyp="Sell";                                                   //
     }                                                                   //
   if((TrendTyp=="Buy" && Rounding_Two[bp+1]>Rounding_One[bp+1])||       //
      (TrendTyp=="Sell" && Rounding_Two[bp+1]<Rounding_One[bp+1])||      //
      (TrendTyp!="Buy" && TrendTyp!="Sell"))                             //
     {                                                                   //
      TrendTyp="Flat";                                                   //
     }                                                                   //
//*********//
   return(0);                                                            //
  }                                                                      //
//***********************************//  Цвет бара в зависимости от тренда
void Paint_Bars(int pb)                                                  //
  {                                                                      //
//******************//   - покрасить бары в Зелёный
   if(TrendTyp=="Buy")                                                   //
     {                                                                   //
      Trend_Hi_Color[pb] = High[pb];                                     //
      Trend_Lo_Color[pb] = Low[pb];                                      //
      Trend_Op_Color[pb] = MathMax(Open[pb], Close[pb]);                 //
      Trend_Cl_Color[pb] = MathMin(Open[pb], Close[pb]);                 //
     }                                                                   //
//******************//   - покрасить бары в Красный
   if(TrendTyp=="Sell")                                                  //
     {                                                                   //
      Trend_Hi_Color[pb] = Low[pb];                                      //
      Trend_Lo_Color[pb] = High[pb];                                     //
      Trend_Op_Color[pb] = MathMin(Open[pb], Close[pb]);                 //
      Trend_Cl_Color[pb] = MathMax(Open[pb], Close[pb]);                 //
     }                                                                   //
//******************//   - покрасить бары в Серый
   if(TrendTyp=="Flat")                                                  //
     {                                                                   //
      Flat_Hi_Color[pb] = Low[pb];                                       //
      Flat_Lo_Color[pb] = High[pb];                                      //
      Flat_Op_Color[pb] = MathMin(Open[pb], Close[pb]);                  //
      Flat_Cl_Color[pb] = MathMax(Open[pb], Close[pb]);                  //
     }                                                                   //
//*********//
   return(0);                                                            //
  }                                                                      //
//***********************************************************************//
//********************************************************************BS*//
//***********************************************************************//
