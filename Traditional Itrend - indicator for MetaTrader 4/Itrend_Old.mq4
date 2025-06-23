//+------------------------------------------------------------------+
//|                                           Traditional Itrend.mq4 |
//|                                             TREND INDICATOR      |
//|                                                                  |
//|                                           Conversion: Dr. Gaines |
//|                                  dr_richard_gaines@yahoo.com     |
//|                                                                  |
//+------------------------------------------------------------------+
/*
Name := iTrend 1.01 
Author := Andrew 
Link := http://anri.aney.ru/forex/ 
Notes := TREND INDICATOR 
Separate Window := YES 
First Color := blue 
First Draw Type := histogram 
First Symbol := 217 
Use Second Data := Yes 
Second Color := red 
Second Draw Type := histogram 
Second Symbol := 218 
*/
#property copyright " Andrew "
#property link      " http://anri.aney.ru/forex/ "
//----
#property indicator_separate_window
#property indicator_color1 Blue
#property indicator_buffers 2
#property indicator_color2 Red
#include <stdlib.mqh>
//+------------------------------------------------------------------+
//| Common External variables                                        |
//+------------------------------------------------------------------+
extern double iBands_Mode_0_2=0;
extern double iPower_Price_0_6=0;
extern double iPrice_Type_0_3=0;
extern double iBands_Period=20;
extern double iBands_Deviation=2;
extern double iPower_Period=14;
//+------------------------------------------------------------------+
//| Special Convertion Functions                                     |
//+------------------------------------------------------------------+
int LastTradeTime;
double ExtHistoBuffer[];
double ExtHistoBuffer2[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetLoopCount(int loops)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetIndexValue(int shift,double value)
  {
   ExtHistoBuffer[shift]=value;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetIndexValue2(int shift,double value)
  {
   ExtHistoBuffer2[shift]=value;
  }
//+------------------------------------------------------------------+
//| End                                                              |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID);
   SetIndexBuffer(0,ExtHistoBuffer);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID);
   SetIndexBuffer(1,ExtHistoBuffer2);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
//+------------------------------------------------------------------+
//| Local variables                                                  |
//+------------------------------------------------------------------+
   double value=0;
   double value2=0;
   int CurrentBar=0;
   double Bands_Mode=0;
   double Power_Price=0;
   double CurrentPrice=0;
//----
   SetLoopCount(0);
   if(iBands_Mode_0_2==1)Bands_Mode=MODE_LOW
      ;else if(iBands_Mode_0_2==2)Bands_Mode=MODE_HIGH
   ;else Bands_Mode=MODE_MAIN;
//----         
   if(iPower_Price_0_6==1)Power_Price=PRICE_OPEN
      ;else if(iPower_Price_0_6==2)Power_Price=PRICE_HIGH
   ;else if(iPower_Price_0_6==3)Power_Price=PRICE_LOW
   ;else if(iPower_Price_0_6==4)Power_Price=PRICE_MEDIAN
   ;else if(iPower_Price_0_6==5)Power_Price=PRICE_TYPICAL
   ;else if(iPower_Price_0_6==6)Power_Price=PRICE_WEIGHTED
   ;else Power_Price=PRICE_CLOSE;
//----
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit--;
   
   for(CurrentBar=limit;CurrentBar>=0;CurrentBar--)
     {
      if(iPrice_Type_0_3==1)CurrentPrice=Open[CurrentBar]
         ;else if(iPrice_Type_0_3==2)CurrentPrice=High[CurrentBar]
      ;else if(iPrice_Type_0_3==3)CurrentPrice=Low[CurrentBar]
      ;else CurrentPrice=Close[CurrentBar];
      value=CurrentPrice-iBands(NULL,0,iBands_Period,iBands_Deviation,0,PRICE_CLOSE,Bands_Mode,CurrentBar);
      if(value < 0)value=0;
      if(value > 0)value=1;
      SetIndexValue(CurrentBar,value);
      value2=-(iBearsPower(NULL,0,iPower_Period,Power_Price,CurrentBar)+iBullsPower(NULL,0,iPower_Period,Power_Price,CurrentBar));
      if(value2 < 0)value2=0;
      if(value2 > 0)value2=-1;
      SetIndexValue2(CurrentBar,value2);
      if(value==1)GlobalVariableSet("MEDV",value);
      if(value2==-1)GlobalVariableSet("MEDV",value);
      if(value2==-1 && value==1)GlobalVariableSet("MEDV",0);
      //SetGlobalVariable("BUK",value); 
     }
   return(0);
  }
//+------------------------------------------------------------------+
