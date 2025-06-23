//+------------------------------------------------------------------+
//|                                                 Xma_Coloured.mq4 |
//|                 Copyright © 2009, XrustSolution. Toys from Vinin.|
//|              http://www.xrust.ucoz.net  http://www.vinin.ucoz.ru |
//|                  xrust@land.ru  xrust@gmail.com  xrust@mksat.net |
//|      Хоть данная программа и является свободно распространяемой, |
//|           публикация ее без указания на первоисточник запрещена  |   
//-------------------------------------------------------------------+
#property copyright "#Copyright © 2008, XrustSolution.#"
#property link      "#http://www.xrust.ucoz.net#"
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color2 Yellow
#property indicator_color3 Blue
#property indicator_color4 Red
extern int period=12;
extern int porog =3;
extern int metod =1;
extern int metod2=1;
extern int prise =0;
//---- buffers
double Signal[];
double Up[];
double Dn[];
double Fl[];
//+------------------------------------------------------------------+
void init()
  {
   SetIndexStyle(0,DRAW_NONE);
   SetIndexDrawBegin(0,0);
   SetIndexBuffer(0,Signal);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexDrawBegin(1,0);
   SetIndexBuffer(1,Fl);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexDrawBegin(2,0);
   SetIndexBuffer(2,Up);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexDrawBegin(3,0);
   SetIndexBuffer(3,Dn);
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
         if(i>0)
           {
            if(Close[i]<=Signal[i]){Dn[i]=Signal[i];}else{Fl[i]=Signal[i];}
            if(Close[i]>=Signal[i]){Up[i]=Signal[i];}else{Fl[i]=Signal[i];}
              }else{Fl[i]=Signal[i];
           }
           }else{
         Signal[i]=Signal[i+1];
         Fl[i]=Signal[i];
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+   
