//+------------------------------------------------------------------+
//|                                                           Vo.mq4 |
//|                                                           Krokus |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Krokus"
#property link      ""
//----
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red
//----
extern int       N=20; // период канала 
//---- buffers
double ExtMapBuffer1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
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
   int    counted_bars=IndicatorCounted();
   int limit;
   double upPrice,downPrice;
//---- 
   if (counted_bars==0) limit=Bars-N;
   if (counted_bars>=0) limit=Bars-counted_bars;
   limit--;
   for(int i=limit;i>=0;i--)
     {
      upPrice=High[iHighest(Symbol(),0,MODE_HIGH,N,i)];//максимум за N баров 
      downPrice=Low[iLowest(Symbol(),0,MODE_LOW,N,i)]; //минимум за N баров 
      ExtMapBuffer1[i]=(upPrice-downPrice)/Point;

     }
//---- 
   return(0);
  }
//+------------------------------------------------------------------+

