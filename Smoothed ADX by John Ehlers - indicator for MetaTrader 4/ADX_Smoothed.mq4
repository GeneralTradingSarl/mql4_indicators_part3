//+------------------------------------------------------------------+
//|                                                 ADX Smoothed.mq4 |
//|                      Copyright © 2007, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//----
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 DarkBlue
#property indicator_color2 FireBrick
#property indicator_color3 DarkGreen
#property indicator_level1 25
//---- input parameters
extern int    per = 14;
extern double alpha1 = 0.25;
extern double alpha2 = 0.33;
extern int    PriceType = 0;
//---- buffers
double DiPlusFinal[];
double DiMinusFinal[];
double ADXFinal[];
double DIPlusLead[];
double DIMinusLead[];
double ADXLead[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(6);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, DiPlusFinal);
   SetIndexLabel(0, "Di Plus");
//----   
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, DiMinusFinal);
   SetIndexLabel(1, "Di Minus");
//----
   SetIndexStyle(2, DRAW_LINE);
   SetIndexBuffer(2, ADXFinal);
   SetIndexLabel(2, "ADX");
//----   
   SetIndexBuffer(3, DIPlusLead);
   SetIndexBuffer(4, DIMinusLead);
   SetIndexBuffer(5, ADXLead);
//----   
   IndicatorDigits(2);
   IndicatorShortName("ADX(" + per + ")smothed");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars = IndicatorCounted();
   int i, k, limit;
   double DIPlus, DIMinus, ADX, DIPlus1, DIMinus1, ADX1;
//----
   if(counted_bars == 0) 
       limit = Bars - per - 1;
   if(counted_bars > 0)  
       limit = Bars - counted_bars;
   for(i = limit; i >= 0; i--)
     {
       DIPlus = iADX(NULL, 0, per, PriceType, MODE_PLUSDI, i);
       DIMinus = iADX(NULL, 0, per, PriceType, MODE_MINUSDI, i);
       ADX = iADX(NULL, 0, per, PriceType, MODE_MAIN, i);
       DIPlus1 = iADX(NULL, 0, per, PriceType, MODE_PLUSDI, i + 1);
       DIMinus1 = iADX(NULL, 0, per, PriceType, MODE_MINUSDI, i + 1);
       ADX1 = iADX(NULL, 0, per, PriceType, MODE_MAIN, i + 1);
       //----
       DIPlusLead[i] = 2*DIPlus + (alpha1 - 2) * DIPlus1 + 
                       (1 - alpha1) * DIPlusLead[i+1];
       DIMinusLead[i] = 2*DIMinus + (alpha1 - 2) * DIMinus1 + 
                        (1 - alpha1) * DIMinusLead[i+1];
       ADXLead[i] = 2*ADX + (alpha1 - 2) * ADX1 + (1 - alpha1) * ADXLead[i+1];
     }   
   for(i = limit; i >= 0; i--)
     {
       DiPlusFinal[i] = alpha2*DIPlusLead[i] + (1 - alpha2) * DiPlusFinal[i+1];
       DiMinusFinal[i] = alpha2*DIMinusLead[i] + (1 - alpha2) * DiMinusFinal[i+1];
       ADXFinal[i] = alpha2*ADXLead[i] + (1 - alpha2) * ADXFinal[i+1];
     }   
//----
   return(0);
  }
//+------------------------------------------------------------------+