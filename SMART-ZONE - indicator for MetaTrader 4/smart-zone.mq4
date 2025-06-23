//+------------------------------------------------------------------+
//|                                                  SMART-ZONE.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//---- indicator settings
#property strict 
#property  indicator_chart_window
#property indicator_buffers  6


#property  indicator_color2  LightSeaGreen
#property  indicator_color5  Magenta


//---- input parameters


extern int Band_Period   = 12; // period of MAX and MIN
extern int periodeMA =5; // period of MAMax and MAMin
extern int methodemoyenne = 2; // method of MAMax and MAMin

//---- buffers
double MAX[];
double MIN[];
double MAMax[];
double MAMin[];
double D1[];
double D2[];

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(6);
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE,0,3,clrNONE);
   SetIndexBuffer(0, MAMax);
   SetIndexStyle(1,DRAW_HISTOGRAM,0,5);
   SetIndexBuffer(1, D1);
   SetIndexStyle(2,DRAW_LINE,0,3,clrNONE);
   SetIndexBuffer(2, MAX);
   SetIndexStyle(3,DRAW_LINE,0,3,clrNONE);
   SetIndexBuffer(3, MAMin);
   SetIndexStyle(4,DRAW_HISTOGRAM,0,5);
   SetIndexBuffer(4, D2);
   SetIndexStyle(5,DRAW_LINE,0,3,clrNONE);
   SetIndexBuffer(5, MIN);
   IndicatorDigits(Digits+5);


   IndicatorShortName("SMART-ZONE");

   return(INIT_SUCCEEDED);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getPeriodHigh(int period, int pos)
  {
   int i;
   double buffer = 0;
   for(i=pos; i<=pos+period; i++)
     {
      if(High[i] > buffer)
        {
         buffer = High[i];
        }
     }
   return (buffer);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getPeriodLow(int period, int pos)
  {
   int i;
   double buffer = 100000;
   for(i=pos; i<=pos+period; i++)
     {
      if(Low[i] < buffer)
        {
         buffer = Low[i];
        }
     }
   return (buffer);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime& time[],
                const double& open[],
                const double& high[],
                const double& low[],
                const double& close[],
                const long& tick_volume[],
                const long& volume[],
                const int& spread[])
  {
   int    limit,i;

   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)
      return(0);
   if(counted_bars > 0)
      counted_bars--;
   limit = Bars - counted_bars;
   if(counted_bars==0)
      limit-=1+Band_Period;

   for(i=limit-1; i>=0; i--)
     {

      MAX[i] = getPeriodHigh(Band_Period,i);
      MIN[i] = getPeriodLow(Band_Period,i);
      MAMax[i]=iMAOnArray(MAX,0,periodeMA,0,methodemoyenne,i);
      MAMin[i]=iMAOnArray(MIN,0,periodeMA,0,methodemoyenne,i);
      if(MAX[i]>MAMax[i])
        {D1[i]=MAX[i]; }
      ;
      if(MAMin[i]>MIN[i])
        {D2[i]=MAMin[i];}

     };
   return(0);
  }
//+------------------------------------------------------------------+
