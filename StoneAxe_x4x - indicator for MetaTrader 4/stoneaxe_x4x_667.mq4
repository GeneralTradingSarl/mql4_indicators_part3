//+------------------------------------------------------------------+
//|                                                 StoneAxe_x4x.mq4 |
//|                                        from MetaStock by   Rosh  |
//|                           http://forexsystems.ru/phpBB/index.php |
//+------------------------------------------------------------------+
#property copyright "Rosh"
#property link      "http://www.investo.ru/forum/viewtopic.php?t=125389&postdays=0&postorder=asc&start=75"
//----
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Red
#property indicator_color2 Lime
#property indicator_color3 Blue
#property indicator_level1 0.0
#property indicator_level2 0.75
#property indicator_level3 -0.75
//---- input parameters
extern int       N1=8;
extern int       N2=24;
extern int       N3=89;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtMapBuffer3);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
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
   int limit,shift;
   int    counted_bars=IndicatorCounted();
   if (counted_bars<0) return(-1);
   if (counted_bars>=0) limit=Bars-counted_bars;
   if (counted_bars==0) limit=Bars-N3;
   limit--;
//---- 
   for(shift=limit;shift>=0;shift--)
     {
      ExtMapBuffer1[shift]=2*(Close[shift]-Low[Lowest(NULL,0,MODE_LOW,N1,shift)])/(High[Highest(NULL,0,MODE_HIGH,N1,shift)]-Low[Lowest(NULL,0,MODE_LOW,N1,shift)])-1.0;
      ExtMapBuffer2[shift]=2*(Close[shift]-Low[Lowest(NULL,0,MODE_LOW,N2,shift)])/(High[Highest(NULL,0,MODE_HIGH,N2,shift)]-Low[Lowest(NULL,0,MODE_LOW,N2,shift)])-1.0;
      ExtMapBuffer3[shift]=2*(Close[shift]-Low[Lowest(NULL,0,MODE_LOW,N3,shift)])/(High[Highest(NULL,0,MODE_HIGH,N3,shift)]-Low[Lowest(NULL,0,MODE_LOW,N3,shift)])-1.0;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+