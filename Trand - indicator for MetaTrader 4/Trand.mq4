//+------------------------------------------------------------------+
//|                                                        Trand.mq4 |
//|                               Copyright © 2006, Виктор Чеботарёв |
//|                                    http://www.chebotariov.co.ua/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, Виктор Чеботарёв"
#property link      "http://www.chebotariov.co.ua/"

extern int LONG = 80;
extern int SHORT = 21;

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Green
#property indicator_color2 Red
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorShortName("Trand("+IntegerToString(LONG)+","+IntegerToString(SHORT)+")");
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);

//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                     Trand                                        |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
//----
   i=Bars-counted_bars-1;

   while(i>=0)
     {
      double MALONG = iMA(NULL,0,LONG,0,MODE_EMA,PRICE_CLOSE,i);
      double MALONG2 = iMA(NULL,0,LONG,0,MODE_EMA,PRICE_CLOSE,i+SHORT-1);
      double MASHORT = iMA(NULL,0,SHORT,0,MODE_EMA,PRICE_CLOSE,i);
      double MASHORT2 = iMA(NULL,0,SHORT,0,MODE_EMA,PRICE_CLOSE,i+SHORT-1);
      double RAZNICA = MathAbs(MathAbs(MALONG-MASHORT)-MathAbs(MALONG-MASHORT2));
      double RAZNICA2 = MathAbs(MALONG-MASHORT)+MathAbs(MALONG2-MASHORT2)/2;
      double PERCENT = RAZNICA*100*((MALONG+MALONG2)/2)*RAZNICA2;
      if(MathAbs(MALONG-MASHORT)-MathAbs(MALONG-MASHORT2)<0){int ZNAK=-1;}else{ZNAK=1;}
      ExtMapBuffer1[i]=PERCENT*ZNAK;
      ExtMapBuffer2[i]=(MASHORT-MALONG)+(MALONG-MALONG2);
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+