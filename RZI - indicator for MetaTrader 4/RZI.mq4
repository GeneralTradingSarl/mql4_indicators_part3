//+------------------------------------------------------------------+
//|                                                        RZI:).mq4 |
//|                                   Copyright © 1895, Prosto_Daun. |
//|                                              http://www.p_sec.eu |
//+------------------------------------------------------------------+
#property  copyright "Vasya_Daun © Corp"
#property  link      "http://www.p_sec.eu"
//---- indicator settings
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red

//---- buffers
double ExtMapBuffer1[];

//----
int ExtCountedBars=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE,0,1,indicator_color1);
   SetIndexBuffer(0,ExtMapBuffer1);
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   if(Bars<=10) return(0);

   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+1;

   if(counted_bars==0)
     {
      ArrayInitialize(ExtMapBuffer1,0.0);
     }

   int bar=limit;
   while(bar>=0)
     {
      if(High[bar]>High[bar+1] && Low[bar]>Low[bar+1])// 1
        {
         ExtMapBuffer1[bar]=1+ExtMapBuffer1[bar+1];
        }
      else
        {
         if(High[bar]<High[bar+1] && Low[bar]<Low[bar+1])// -1
           {
            ExtMapBuffer1[bar]=ExtMapBuffer1[bar+1]-1;
           }
         else
           {
            ExtMapBuffer1[bar]=ExtMapBuffer1[bar+1];
           }
        }
      bar--;
     }

   return(0);
  }
//+------------------------------------------------------------------+
