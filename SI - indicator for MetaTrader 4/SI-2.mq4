//+------------------------------------------------------------------+
//|                                                           SI.mq4 |
//|                                                             Raff |
//|                                                   raff1410@o2.pl |
//+------------------------------------------------------------------+
#property copyright "Raff"
#property link      "just_raff1410@yahoo.com"
//----
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red
//---- input parameters
extern double    T          =1;
extern int       CountBars  =10000;
//---- buffers
double ASI[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(1);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ASI);
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
   int    i, counted_bars=IndicatorCounted();
//----
   double pHigh, pLow, pOpen, pClose;
   double pHigh_1, pLow_1, pOpen_1, pClose_1;
   double K, R, R_1, R_2, R_3, R_4, X, SI ;
//----
   if (CountBars>Bars) CountBars=Bars-10;
   i=CountBars-10;
   ASI[i+1]=0;
   while(i>=0)
     {
      pHigh   =High[i];
      pLow    =Low[i];
      pOpen   =Open[i];
      pClose  =Close[i];
      //
      pHigh_1 =High[i+1];
      pLow_1  =Low[i+1];
      pOpen_1 =Open[i+1];
      pClose_1=Close[i+1];
      //
      R_1     =MathAbs(pHigh-pClose_1);
      R_2     =MathAbs(pLow-pClose_1);
      R_3     =MathAbs(pHigh-pLow);
      R_4     =MathAbs(pClose_1-pOpen_1);
      K       =MathMax(R_1,R_2);
//----      
      if (R_1>=MathMax(R_2,R_3))
        {
         R   =R_1 - R_2/2 + R_4/4;
        }
      else
         if (R_2>=MathMax(R_1,R_3))
           {
            R   =R_2 - R_1/2 + R_4/4;
           }
         else
           {
            R   =R_3 + R_4/4;
           }
      if (R==0) SI=0;
      else
        {
         X   =(pClose_1-pClose)+(pClose_1-pOpen_1)/2+(pClose-pOpen)/4;
         SI  =50 * (X/R) * (K/T);
        }
      ASI[i]=ASI[i+1]-SI;
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+

