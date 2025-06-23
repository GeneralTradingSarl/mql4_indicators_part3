//+------------------------------------------------------------------+
//|                                                          Xma.mq4 |
//|                 Copyright © 2009, XrustSolution. Toys from Vinin.|
//|              http://www.xrust.ucoz.net  http://www.vinin.ucoz.ru |
//|                  xrust@land.ru  xrust@gmail.com  xrust@mksat.net |
//|      Хоть данная программа и является свободно распространяемой, |
//|           публикация ее без указания на первоисточник запрещена  |   
//-------------------------------------------------------------------+
#property copyright "#Copyright © 2008, XrustSolution.#"
#property link      "#http://www.xrust.ucoz.net#"
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Blue

extern int period=12;
extern int porog =3;
extern int metod =1;
extern int metod2=1;
extern int prise =0;
//---- buffers
double Signal[];
//+------------------------------------------------------------------+
void init()
  {
   SetIndexStyle(0,DRAW_LINE);
   SetIndexDrawBegin(0,0);
   SetIndexBuffer(0,Signal);
   IndicatorShortName("Xma"+period+porog);
   return;
  }
//+------------------------------------------------------------------+
int start() 
  {
   double tmp1,tmp2;
   int i;

   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit--;

   for(i=limit;i>=0;i--)
     {
      tmp1=iMA(Symbol(),0,period,0,metod,prise,i);
      tmp2=iMA(Symbol(),0,period,1,metod2,prise,i);
      if(MathAbs(tmp1-tmp2)>=porog*Point)
        {
         Signal[i]=tmp2;
           }else{
         Signal[i]=Signal[i+1];
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+   
