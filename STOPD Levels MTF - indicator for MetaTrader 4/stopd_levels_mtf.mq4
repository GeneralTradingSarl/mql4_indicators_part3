//+------------------------------------------------------------------+
//|                                             STOPD Levels MTF.mq4 |
//|                                    Copyright 2013, Lawrence Chan |
//|                                    http://www.daytradingbias.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, Lawrence Chan"
#property link      "http://www.daytradingbias.com"

#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 Blue
#property indicator_color2 Blue
#property indicator_color3 Blue
#property indicator_color4 Orange
#property indicator_color5 Orange
#property indicator_color6 Red
#property indicator_color7 Red
//--- input parameters
extern string    Timeframe="D";
extern double    L1=100.0;
extern double    L2=50.0;
extern double    L3=0.0;
extern double    L4=150.0;
extern double    L5=-50.0;
extern double    L6=200.0;
extern double    L7=-100.0;
//--- buffers
double L1Buffer[];
double L2Buffer[];
double L3Buffer[];
double L4Buffer[];
double L5Buffer[];
double L6Buffer[];
double L7Buffer[];
//-- local vars
double L1v,L2v,L3v,L4v,L5v,L6v,L7v;
double LastHigh,LastLow,R;
bool PeriodBreak,Ready;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,L1Buffer);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,L2Buffer);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,L3Buffer);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,L4Buffer);
   SetIndexStyle(4,DRAW_LINE);
   SetIndexBuffer(4,L5Buffer);
   SetIndexStyle(5,DRAW_LINE);
   SetIndexBuffer(5,L6Buffer);
   SetIndexStyle(6,DRAW_LINE);
   SetIndexBuffer(6,L7Buffer);
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
   int counted_bars=IndicatorCounted();
   int limit,i;

   if(counted_bars < 0)   return(-1);

   limit=Bars-counted_bars-1;
   if(counted_bars==0) limit-=2;

   if(counted_bars==0) 
     {
      LastHigh= High [limit+1];
      LastLow = Low [limit+1];
      Ready=false;
     }

   for(i=limit; i>=0; i--)
     {
      if(High[i+1]>LastHigh)
         LastHigh=High[i+1];

      if(Low[i+1]<LastLow)
         LastLow=Low[i+1];

      if(Timeframe=="D") 
        {
         PeriodBreak=TimeDay(Time[i])!=TimeDay(Time[i+1]);
           } else if(Timeframe=="W") {
         PeriodBreak=TimeDayOfWeek(Time[i])<TimeDayOfWeek(Time[i+1]);
           } else if(Timeframe=="M") {
         PeriodBreak=TimeMonth(Time[i])!=TimeMonth(Time[i+1]);
           } else if(Timeframe=="Q") {
         PeriodBreak=MathFloor((TimeMonth(Time[i])-1)/3)!=MathFloor((TimeMonth(Time[i+1])-1)/3);
           } else if(Timeframe=="Y") {
         PeriodBreak=TimeYear(Time[i])!=TimeYear(Time[i+1]);
           } else {
         PeriodBreak=false;
        }

      if(PeriodBreak)
        {
         R=LastHigh-LastLow;
         L1v = LastLow + R * L1 / 100;
         L2v = LastLow + R * L2 / 100;
         L3v = LastLow + R * L3 / 100;
         L4v = LastLow + R * L4 / 100;
         L5v = LastLow + R * L5 / 100;
         L6v = LastLow + R * L6 / 100;
         L7v = LastLow + R * L7 / 100;

         LastHigh= High [i];
         LastLow = Low [i];

         Ready=true;
        }

      if(Ready) 
        {
         L1Buffer[i] = L1v;
         L2Buffer[i] = L2v;
         L3Buffer[i] = L3v;
         L4Buffer[i] = L4v;
         L5Buffer[i] = L5v;
         L6Buffer[i] = L6v;
         L7Buffer[i] = L7v;
        }
     }

   return(0);
  }

//+------------------------------------------------------------------+
