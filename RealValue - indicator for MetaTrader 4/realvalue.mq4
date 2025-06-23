//+------------------------------------------------------------------+
//| Copyright (C) Grzegorz Szczerba                                  |
//| grzegorz.szczerba@gmail.com                                      |
//+------------------------------------------------------------------+
#property copyright "Grzegorz Szczerba"
#property link      "grzegorz.szczerba@gmail.com"
//---
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red
//---
extern double Alpha=1;
extern double Variation=3.0;
extern int Period=20;
//---
double buffer[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(1);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,buffer);
//---
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=2;
//---
   for(int i=limit;i>=0;i--)
     {
      double h0 = iHigh(NULL, 0, i);
      double l0 = iLow(NULL, 0, i);
      double h1 = iHigh(NULL, 0, i + 1);
      double l1 = iLow(NULL, 0, i + 1);
      double var= 0;
      for(int j = 1; j<= Period; j++)
        {
         double hv1 = iHigh(NULL, 0, i + j);
         double lv1 = iLow(NULL, 0, i + j);
         double hv2 = iHigh(NULL, 0, i + j + 1);
         double lv2 = iLow(NULL, 0, i + j + 1);
         //---
         var+=MathAbs((hv1-lv1) -(hv2-lv2));
        }
      var/=(double)Period;
      //---
      double val=(h0+l0)/2.0;
      //---
      if(buffer[i+1]>1000000 || buffer[i+2]>1000000)
        {
         //FIRST VALUES
         buffer[i]=val;
         continue;
        }
      else
        {
         double diffB= buffer[i+1]-buffer[i+2];
         double diff = val -(h1+l1)/2.0;
         if(diffB>Alpha*var)
           {
            diffB=Alpha*var;
           }
         if(diffB<-Alpha*var)
           {
            diffB=-Alpha*var;
           }
         //---
         double c=var/Variation;
         if(val>buffer[i+1])
           {
            if(diff<0)
              {
               c=0;
               diffB=0;
              }
            buffer[i]=buffer[i+1]+diffB+c;
           }
         else
           {
            if(diff>0)
              {
               c=0;
               diffB=0;
              }
            buffer[i]=buffer[i+1]+diffB-c;
           }
        }
      buffer[i]=(buffer[i]+buffer[i+1])/2.0;
     }
   return(0);
  }
//+------------------------------------------------------------------+
