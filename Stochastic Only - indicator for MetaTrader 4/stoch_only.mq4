//+------------------------------------------------------------------+
//|                                                   Stoch_Only.mq4 |
//|                   Copyright © 2015-2016, assurkov, Alexey Surkov |
//|                                          http://www.assurkov.ru/ |
//+------------------------------------------------------------------+
#property strict
#property copyright "Copyright © 2015-2016, www.assurkov.ru, Alexey Surkov"
#property link      "http://www.assurkov.ru/"
#property version     "1.00"
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_width1 1
#property indicator_width2 1

input int ST_Period1    =700;
input int ST_Period2    =120;
input int ST_Period3    =30;
input int ST_Zone1    =10;
input int ST_Zone2    =10;
input int ST_Zone3    =5;

double BuyBuffer[],SellBuffer[];

bool counter=false;
string TimeFrame;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorShortName("Stoch_Only");

   SetIndexBuffer(0,BuyBuffer);
   SetIndexLabel(0,"Buy");
   SetIndexStyle(0,DRAW_ARROW,STYLE_SOLID,1);
   SetIndexArrow(0,241);

   SetIndexBuffer(1,SellBuffer);
   SetIndexLabel(1,"Sell");
   SetIndexStyle(1,DRAW_ARROW,STYLE_SOLID,1);
   SetIndexArrow(1,242);

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
//----
   if(counted_bars<0)
     {
      Print("Indicator Error (Counted bars < 0)!");
      return(-1);
     }
//----
   if(Bars<17)
     {
      Print("Indicator Error (Bars < 12)!");
      return(-1);
     }
   int limit=Bars-17;
//----
   if(counted_bars>17)
     {
      limit=Bars-counted_bars;
     }
//----
   for(int i=limit; i>=0; i --)
     {
      BuyBuffer[i]=EMPTY_VALUE;
      SellBuffer[i]=EMPTY_VALUE;

      double ST1=iStochastic(Symbol(),Period(),ST_Period1,3,3,MODE_SMA,1,MODE_MAIN,i);
      double ST2=iStochastic(Symbol(),Period(),ST_Period2,3,3,MODE_SMA,1,MODE_MAIN,i);
      double ST3=iStochastic(Symbol(),Period(),ST_Period3,3,3,MODE_SMA,1,MODE_MAIN,i);

      if(ST1<ST_Zone1 && ST2<ST_Zone2 && ST3<ST_Zone3)
        {
         BuyBuffer[i]=Low[i]-iATR(NULL,0,14,i);
        }
      if(ST1>(100-ST_Zone1) && ST2>(100-ST_Zone2) && ST3>(100-ST_Zone3))
        {
         SellBuffer[i]=High[i]+iATR(NULL,0,14,i);
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+
