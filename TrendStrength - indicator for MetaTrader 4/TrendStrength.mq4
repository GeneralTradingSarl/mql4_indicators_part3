//+------------------------------------------------------------------+ 
//|                                                TrendStrength.mq4 | 
//|                                                        Xaoc 2006 | 
//|                                             http://forex.xcd.ru/ | 
//+------------------------------------------------------------------+ 
#property copyright "][aoc 2006"
#property link      "http://forex.xcd.ru/"
//----
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Red
#property indicator_level1 0
//#property indicator_maximum 0.02
//#property indicator_minimum -0.02
double TS[];
//+------------------------------------------------------------------+ 
//| Custom indicator initialization function                         | 
//+------------------------------------------------------------------+ 
int init()
  {
   IndicatorBuffers(1);
   IndicatorShortName("TrendStrength");
   SetIndexBuffer(0,TS);
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 1, Orange);
   SetIndexDrawBegin(0,2);
   SetIndexLabel(0,"TS");
//---- indicators 
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
   int    mode, shift,counted_bars=IndicatorCounted();
   //double ma40dbl; 
   double ma0, ma1, ma2, ma3, ma4, ma5, ma6, ma7, ma8, ma9, ma10, tmp;
//---- TODO: add your code here 
//---- check for possible errors 
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted 
   if(counted_bars>0) counted_bars--;
   //limit=Bars-counted_bars; 
//---- main loop 
//---- main calculation loop 
   shift=Bars-1;
   while(shift>=0)
     {
      mode=MODE_EMA;
      tmp=iMA(NULL,0,5,0,mode,PRICE_WEIGHTED,shift);
      ma1=tmp-iMA(NULL,0,10,0,mode,PRICE_WEIGHTED,shift);
      ma2=tmp-iMA(NULL,0,20,0,mode,PRICE_WEIGHTED,shift);
      ma3=tmp-iMA(NULL,0,30,0,mode,PRICE_WEIGHTED,shift);
      ma4=tmp-iMA(NULL,0,40,0,mode,PRICE_WEIGHTED,shift);
      ma5=tmp-iMA(NULL,0,50,0,mode,PRICE_WEIGHTED,shift);
      ma6=tmp-iMA(NULL,0,60,0,mode,PRICE_WEIGHTED,shift);
      ma7=tmp-iMA(NULL,0,70,0,mode,PRICE_WEIGHTED,shift);
      ma8=tmp-iMA(NULL,0,80,0,mode,PRICE_WEIGHTED,shift);
      ma9=tmp-iMA(NULL,0,90,0,mode,PRICE_WEIGHTED,shift);
      ma10=tmp-iMA(NULL,0,100,0,mode,PRICE_WEIGHTED,shift);
//----
      TS[shift]=ma1+ma2+ma3+ma4+ma5+ma6+ma7+ma8+ma9+ma10;
      shift--;// 
     }
//---- 
   return(0);
  }
//+------------------------------------------------------------------+ 

