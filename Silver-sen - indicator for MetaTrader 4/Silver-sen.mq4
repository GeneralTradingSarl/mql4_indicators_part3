//+------------------------------------------------------------------+
//|                                                    Kijun-sen.mq4 |
//|                                     Copyright © 2004, AlexSilver |
//|                                                  http://viac.ru/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, AlexSilver"
#property link      "http://viac.ru/"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 DeepSkyBlue
//---- input parameters
extern int SSP=26;
extern int ShiftP=6;
extern double SSK=73.4;
//---- buffers
double SSP_Buffer[];
//----
int a_begin;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//----
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,SSP_Buffer);
   SetIndexDrawBegin(0,SSP+ShiftP-1);
   SetIndexShift(0,ShiftP);   
   SetIndexLabel(0,"Silver-Sen");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Silver-sen                                                       |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k;
   int    counted_bars=IndicatorCounted();
   double high,low,price;
//----
   if(Bars<=SSP) return(0);
//---- initial zero
   if(counted_bars<1)
     {
      for(i=1;i<=SSP;i++)     SSP_Buffer[Bars-i]=0;
     }
//---- Silver Sen
   i=Bars-SSP;
   if(counted_bars>SSP) i=Bars-counted_bars-1;
   while(i>=0)
     {
      high=High[i]; low=Low[i]; k=i-1+SSP;
      while(k>=i)
        {
         price=High[k];
         if(high<price) high=price;
         price=Low[k];
         if(low>price)  low=price;
         k--;
        }
      SSP_Buffer[i+ShiftP]=low+(high-low)*SSK/100;
      i--;
     } i=ShiftP-1;
   while(i>=0)
     {
      high=High[0]; low=Low[0]; k=SSP-ShiftP+i;
      while(k>=0)
        {
         price=High[k];
         if(high<price) high=price;
         price=Low[k];
         if(low>price)  low=price;
         k--;
        }
      SSP_Buffer[i]=low+(high-low)*SSK/100;
      i--;
     }
   }
//+------------------------------------------------------------------+