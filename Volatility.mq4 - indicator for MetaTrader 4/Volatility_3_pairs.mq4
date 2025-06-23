//+------------------------------------------------------------------+
//|                                           Complex_Volatility.mq4 |
//|                                                briz18@rambler.ru |
//+------------------------------------------------------------------+
#property copyright "briz18@rambler.ru"

#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Teal
#property indicator_color2 SlateBlue
#property indicator_color3 MediumVioletRed
//---- buffers
double GBPUSD[];
double USDJPY[];
double GBPJPY[];
//---- input parameters
extern int VolatilityPeriod=5;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorShortName("Volantility+GU;UJ;GJ");
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,GBPUSD);
   SetIndexLabel(0, "GBPUSD"); 
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,USDJPY);
   SetIndexLabel(1, "USDJPY"); 
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,GBPJPY);
   SetIndexLabel(2, "GBPJPY"); 
   SetLevelValue(0,50);
   SetLevelStyle(0,1,DimGray);
   SetLevelValue(1,100);
   SetLevelStyle(0,0,DimGray);
   SetLevelValue(2,200);
   SetLevelStyle(0,0,DimGray);
   SetLevelValue(3,300);
   SetLevelStyle(0,0,DimGray);
   SetLevelValue(4,400);
   SetLevelStyle(0,0,DimGray);

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
     int limit;
     int counted_bars=IndicatorCounted();
  //---- проверка на возможные ошибки
     if(counted_bars<0) return(-1);
  //---- последний посчитанный бар будет пересчитан
     if(counted_bars>0) counted_bars-=10;
     limit=Bars-counted_bars;
  //---- основной цикл
      int Mode=0;
      int Price1=2;
      int Price2=3;
      int per=VolatilityPeriod;      
     for(int i=0; i<limit; i++)
       {
        GBPUSD[i]=(iMA("GBPUSD",0,per,0,Mode,Price1,i)-iMA("GBPUSD",0,per,0,Mode,Price2,i))*10000;
        USDJPY[i]=(iMA("USDJPY",0,per,0,Mode,Price1,i)-iMA("USDJPY",0,per,0,Mode,Price2,i))*100;
        GBPJPY[i]=(iMA("GBPJPY",0,per,0,Mode,Price1,i)-iMA("GBPJPY",0,per,0,Mode,Price2,i))*100;
       }
  //----
    return(0);
  }
//+------------------------------------------------------------------+