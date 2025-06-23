//+------------------------------------------------------------------+
//|                                                       Urovni.mq4 |
//|                                  forextimes, MojoFX - Conversion |
//|                                                        fxtest.ru |
//+------------------------------------------------------------------+
#property copyright "forextimes, MojoFX - Conversion"
#property link      "fxtest.ru"
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 GreenYellow
//----
extern int per=60;
extern int delta=10;
extern int korr=0;
//---- buffers
double Buffer1[];
double Buffer2[];
double TB[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(3);
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1,indicator_color1);
   SetIndexBuffer(0,Buffer1);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,1,indicator_color2);
   SetIndexBuffer(1,Buffer2);
   SetIndexBuffer(2,TB);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if (counted_bars<0) return(-1);
   if (counted_bars>0) counted_bars--;
//----   
   int limit=Bars-per-counted_bars;
//---- 
   for(int i=limit; i>=0; i--)
     {
      Buffer1[i]=iMA(NULL,0,per,0,MODE_EMA,PRICE_HIGH,i) + delta*Point + korr*Point;
      Buffer2[i]=iMA(NULL,0,per,0,MODE_EMA,PRICE_LOW,i) - delta*Point + korr*Point;
      Comment(limit," ",Close[0]," ",TB[0]," ",delta*Point," ",korr*Point);
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+