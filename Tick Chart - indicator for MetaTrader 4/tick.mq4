//+------------------------------------------------------------------+
//|                                                        Tick.mq4 |
//|                                                         Greshnik |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Greshnik"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_type1   DRAW_LINE
#property indicator_style1  STYLE_SOLID
#property indicator_color1 clrSilver
#property indicator_type2   DRAW_LINE
#property indicator_style2  STYLE_SOLID
#property indicator_color2  clrRed
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum eSh
  {
   IPRICE=0,//Цена
   IVOLUME=1,//Объём
   ISPREAD=2,//Спред
   ITIME=3,//Время
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum eTprice
  {
   TBIDASK=0,//Bid,Ask
   TBID=1,//Bid
   TASK=2,//Ask
   TMEAN=3,//(Bid+Ask)/2
  };

//--- input parameters
extern int  count_tickper=360;//Количество отображаемых тиков
extern eSh  show=IPRICE;//Что отображается
extern eTprice tprice=TBIDASK;//Тип цены
input bool  save_to_file=false;//Сохранять в файл

//--- indicator buffers
double         TickBuffer0[];
double         TickBuffer1[];
double         ticks[][2];

#include <stderror.mqh>
#include <stdlib.mqh>

long  last_vol;
long  last_ticks_count;

int hand_f;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   int i1;
   string s1,s2;
   string symbol=Symbol();

   SetIndexBuffer(0,TickBuffer0);
   SetIndexBuffer(1,TickBuffer1);
   SetIndexEmptyValue(0,-1);
   SetIndexEmptyValue(1,-1);
   switch(show)
     {
      case IPRICE:
        {
         switch(tprice)
           {
            case TBIDASK:
              {
               SetIndexLabel(0,"Цена(Bid,Bid)");
               IndicatorShortName("Price(Bid,Ask))");
               SetIndexLabel(1,"Цена(Ask)");
               break;
              }
            case TBID:
              {
               SetIndexLabel(0,"Цена(Bid)");
               IndicatorShortName("Price(Bid))");
               break;
              }
            case TASK:
              {
               SetIndexLabel(0,"Цена(Ask)");
               IndicatorShortName("Price(Ask))");
               break;
              }
            case TMEAN:
              {
               SetIndexLabel(0,"Цена(Mean)");
               IndicatorShortName("Price(Mean))");
               break;
              }
           }
         SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1,clrSilver);
         SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,1,clrRed);
         if(tprice!=TMEAN)
           {
            IndicatorSetInteger(INDICATOR_DIGITS,Digits);
           }
         else
           {
            IndicatorSetInteger(INDICATOR_DIGITS,Digits+1);
           }
         break;
        }
      case IVOLUME:
        {
         SetIndexLabel(0,"Объём");
         IndicatorShortName("Volume");
         SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2,clrGreen);
         IndicatorSetInteger(INDICATOR_DIGITS,0);
         IndicatorSetDouble(INDICATOR_MINIMUM,0.0);
         break;
        }
      case ISPREAD:
        {
         SetIndexLabel(0,"Спред");
         IndicatorShortName("Spread");
         SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2,clrBlue);
         IndicatorSetInteger(INDICATOR_DIGITS,0);
         IndicatorSetDouble(INDICATOR_MINIMUM,0.0);
         break;
        }
      case ITIME:
        {
         SetIndexLabel(0,"Время");
         IndicatorShortName("Time");
         SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2,clrYellow);
         IndicatorSetInteger(INDICATOR_DIGITS,3);
         IndicatorSetDouble(INDICATOR_MINIMUM,0.0);
         break;
        }
     }

   ArrayResize(ticks,count_tickper);
   for(i1=0;i1<count_tickper;i1++)
     {
      ticks[i1][0]=-1;
      ticks[i1][1]=-1;
     }

   hand_f=-1;
   if(save_to_file)
     {
      s1=symbol+"_tick.txt";

      s2="";
      if(!FileIsExist(s1))
        {
         s2="Time"+CharToStr(9)+"Bid"+CharToStr(9)+"Ask"+CharToStr(9)+"TimeTickSeconds"+CharToStr(9)+"Volume"+CharToStr(13)+CharToStr(10);
        }

      hand_f=FileOpen(s1,FILE_WRITE|FILE_BIN|FILE_READ|FILE_SHARE_READ);
      if(hand_f==INVALID_HANDLE)
        {
         Print("Ошибка при создании файла(",GetLastError(),")");
         hand_f=-1;
        }
      else
        {
         FileWriteString(hand_f,s2);
         if(StringLen(s2)==0)
           {
            FileSeek(hand_f,0,SEEK_END);
           }
        }
     }
   last_vol=Volume[0];
   last_ticks_count=GetTickCount();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(hand_f>=0)
     {
      FileClose(hand_f);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   int i1;
   string s1,s2;
   string symbol=Symbol();
   int bars;
   double price=0,price1=0;
   long ticks_current;
   long ticks_a;
   MqlTick last_tick;
   SymbolInfoTick(Symbol(),last_tick);
   price=last_tick.bid;
   price1=last_tick.ask;

   long vol=Volume[0]-last_vol;
   if(vol<0)
     {
      vol=Volume[0];
     }
   if(vol==0)
     {
      return rates_total;
     }
   ticks_current=GetTickCount();
   ticks_a=ticks_current-last_ticks_count;
   last_ticks_count=ticks_current;

   for(i1=count_tickper-2;i1>=0;i1--)
     {
      ticks[i1+1][0]=ticks[i1][0];
      ticks[i1+1][1]=ticks[i1][1];
     }
   switch(show)
     {
      case IPRICE:
        {
         ticks[0][0]=price;
         ticks[0][1]=price1;
         break;
        }
      case IVOLUME:
        {
         ticks[0][0]=(double)vol;
         break;
        }
      case ISPREAD:
        {
         ticks[0][0]=(price1-price)/Point();
         break;
        }
      case ITIME:
        {
         ticks[0][0]=ticks_a/1000.0;
         break;
        }
     }
   bars=Bars;
   if(count_tickper+1<bars)
     {
      bars=count_tickper;
     }
   for(i1=0;i1<bars;i1++)
     {
      switch(show)
        {
         case IPRICE:
           {
            switch(tprice)
              {
               case TBIDASK:
                 {
                  TickBuffer0[i1]=ticks[i1][0];
                  TickBuffer1[i1]=ticks[i1][1];
                  break;
                 }
               case TMEAN:
                 {
                  TickBuffer0[i1]=(ticks[i1][0]+ticks[i1][0])/2.0;
                  break;
                 }
               default:
                 {
                  TickBuffer0[i1]=ticks[i1][0];
                 }
              }
            break;
           }
         default:
           {
            TickBuffer0[i1]=ticks[i1][0];
           }
        }
     }
   if(bars<Bars)
     {
      TickBuffer0[bars]=-1;
      TickBuffer1[bars]=-1;
     }
   if(hand_f>=0)
     {
      s2=DoubleToStr(last_tick.bid,Digits)+CharToStr(9)+DoubleToStr(last_tick.ask,Digits)+CharToStr(9)+DoubleToStr(ticks_a/1000.0,3);
      s1=TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS)+CharToStr(9)+s2+CharToStr(9)+DoubleToStr(vol,0)+CharToStr(13)+CharToStr(10);
      FileWriteString(hand_f,s1);
      //FileFlush(hand_f);
     }
   last_vol=Volume[0];
   return(rates_total);
  }
//+------------------------------------------------------------------+
