//+------------------------------------------------------------------+
//|                                      Created for MT4 by Ravish A |
//|                                                 Ravish Anandaram |
//|                                  mailto: aravishstocks@gmail.com |
//+------------------------------------------------------------------+
// ===========================================================================================================
// This indicator is based on a strategy mentioned in John Carter's book, Mastering the Trade. 
// It is also a fully improvised version of Squeeze_Break indicator by DesO'Regan.
// You can find that implementation here: 
// https://www.mql5.com/en/code/8840?utm_campaign=MetaTrader+4+Terminal&utm_medium=special&utm_source=mt4terminal+codebase
// The main improvements include plotting squeeze values (some BB/KC calculation changes) on the zero-line and then to smoothen the momentum values as rising/falling positive/negative histograms
// to match the ones sold on commercial websites. This is easy on the eye.
// Uses some of the Linear Regression code from Victor Nicolaev aka Vinin's V_LRMA.mq4 for smoothening the histograms
// This version DOES NOT have any alerts functionality and also does not have inputs to change.
// The reason is - this is V1 and generally no body changes the BB and KC values. Feel free to enhance on your own.
// And if you like this indicator pa$$ :-) on to -->  Ravish Anandaram (aravishstocks@gmail.com)
// ===========================================================================================================
#property copyright "Ravish Anandaram (aravishstocks@gmail.com)"
#property link      "mailto: aravishstocks@gmail.com"
//+------------------------------------------------------------------+
//| indicator properties                                             |
//+------------------------------------------------------------------+
#property indicator_separate_window
#property indicator_buffers 6
#property indicator_color1 MediumBlue
#property indicator_color2 Tomato
#property indicator_color3 DodgerBlue
#property indicator_color4 Orange
#property indicator_color5 ForestGreen
#property indicator_color6 Red
//+------------------------------------------------------------------+
//| Buffer Array Declarations                                        |
//+------------------------------------------------------------------+
double Squeeze_Off[];  // Green Dots on the zero line
double Squeeze_On[];   // Red Dots on the zero line
double SqzFiredLong_Strong[];   // Rising Positive Histograms 
double SqzFiredShort_Strong[];  // Falling Negative Histograms 
double SqzFiredLong_Weak[];     // Falling Positive Histograms 
double SqzFiredShort_Weak[];    // Rising Negative Histograms
//+------------------------------------------------------------------+
//| Internal Global Variables                                        |
//+------------------------------------------------------------------+
int       Bollinger_Period=20;
double    Bollinger_Deviation=2.0;
int       Keltner_Period=20;
double    Keltner_ATR=1.5;
int       Bollinger_MaMode=MODE_SMA;
int       Keltner_MaMode=MODE_SMA;
int       BarsToGoBack=1000;
int       Smooth_Factor=10;
double      LSmoothX=1.0;
double      LSmoothY=1.0;
double      LSmoothFactor_1=3.0;
double      LSmoothFactor_2=3.0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorDigits(4);  // indicator value precision
//--- Indicator Setup
   SetIndexStyle(0,DRAW_HISTOGRAM,EMPTY,3);
   SetIndexBuffer(0,SqzFiredLong_Strong);
   SetIndexStyle(1,DRAW_HISTOGRAM,EMPTY,3);
   SetIndexBuffer(1,SqzFiredShort_Strong);
   SetIndexStyle(2,DRAW_HISTOGRAM,EMPTY,3);
   SetIndexBuffer(2,SqzFiredLong_Weak);
   SetIndexStyle(3,DRAW_HISTOGRAM,EMPTY,3);
   SetIndexBuffer(3,SqzFiredShort_Weak);
   SetIndexStyle(4,DRAW_HISTOGRAM,EMPTY,3);
   SetIndexBuffer(4,Squeeze_Off);
   SetIndexStyle(5,DRAW_HISTOGRAM,EMPTY,3);
   SetIndexBuffer(5,Squeeze_On);
//--- Indicator Labels
   IndicatorShortName("Squeeze RA V1");
//---
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectsDeleteAll();
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetSmoothenedValuesForHistograms(int nShift,int nLength)
  {
   double LSmooth1,LSmooth2,LSmoothVal;
   LSmooth1=LSmoothX*iMA(Symbol(),0,nLength,0,MODE_SMA,PRICE_CLOSE,nShift);
   LSmooth2=iMA(Symbol(),0,nLength,0,MODE_LWMA,PRICE_CLOSE,nShift)/LSmoothY;
   LSmoothVal=LSmoothFactor_1*LSmooth2-LSmoothFactor_2*LSmooth1;
   return LSmoothVal*Smooth_Factor;
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//--- Indicator Optimization
   int Counted_Bars=IndicatorCounted();
   if(Counted_Bars < 0) return -1;
   if(Counted_Bars>0) Counted_Bars=Counted_Bars-Keltner_Period;
   int limit=Bars-Counted_Bars;
   int limit2=0;
//---
   if(_Period==PERIOD_MN1)
      Smooth_Factor= 4;
   else if(_Period == PERIOD_W1)
      Smooth_Factor= 4;
   else if(_Period == PERIOD_D1)
      Smooth_Factor= 6;
   else if(_Period == PERIOD_H4)
      Smooth_Factor= 8;
   else if(_Period == PERIOD_H1)
      Smooth_Factor= 30;
   else if(_Period == PERIOD_M30)
      Smooth_Factor= 50;
   else if(_Period == PERIOD_M15)
      Smooth_Factor= 50;
   else if(_Period == PERIOD_M5)
      Smooth_Factor= 100;
   else if(_Period == PERIOD_M1)
      Smooth_Factor= 300;
//--- Main Indicator Loop
   for(int i=limit-2; i>=limit2; i--) //main indicator FOR loop
     {
      //--- Indicator Calculations
      double Kelt_Mid_Band=iMA(Symbol(),0,Keltner_Period,0,Keltner_MaMode,PRICE_CLOSE,i);
      double Kelt_Upper_Band = Kelt_Mid_Band + (iATR(Symbol(),0,Keltner_Period,i)*Keltner_ATR);
      double Kelt_Lower_Band = Kelt_Mid_Band - (iATR(Symbol(),0,Keltner_Period,i)*Keltner_ATR);
      //---
      double StdDev=iStdDev(Symbol(),0,Bollinger_Period,0,Bollinger_MaMode,PRICE_CLOSE,i);
      double Ma=iMA(Symbol(),0,Bollinger_Period,0,Bollinger_MaMode,PRICE_CLOSE,i);
      double Boll_Upper_Band = Ma + (StdDev*Bollinger_Deviation);
      double Boll_Lower_Band = Ma - (StdDev*Bollinger_Deviation);
      //---
      double dLSmoothVal=0;
      //--- Buffer Calculations
      //--- Smoothen the histogram bars using linear reg methods
      dLSmoothVal=GetSmoothenedValuesForHistograms(i,Keltner_Period);
      if(dLSmoothVal>0)
        {
         if((SqzFiredLong_Strong[i+1]!=0 && dLSmoothVal>SqzFiredLong_Strong[i+1]) || (SqzFiredLong_Weak[i+1]!=0 && dLSmoothVal>SqzFiredLong_Weak[i+1]))
           {
            SqzFiredLong_Strong[i]=dLSmoothVal;
            SqzFiredLong_Weak[i]=0;
           }
         else
           {
            SqzFiredLong_Weak[i]=dLSmoothVal;
            SqzFiredLong_Strong[i]=0;
           }
         SqzFiredShort_Strong[i]=0;
         SqzFiredShort_Weak[i]=0;
        }
      else
        {
         if((SqzFiredShort_Strong[i+1]!=0 && dLSmoothVal<SqzFiredShort_Strong[i+1]) || (SqzFiredShort_Weak[i+1]!=0 && dLSmoothVal<SqzFiredShort_Weak[i+1]))
           {
            SqzFiredShort_Strong[i]=dLSmoothVal;
            SqzFiredShort_Weak[i]=0;
           }
         else
           {
            SqzFiredShort_Weak[i]=dLSmoothVal;
            SqzFiredShort_Strong[i]=0;
           }
         SqzFiredLong_Strong[i]=0;
         SqzFiredLong_Weak[i]=0;
        }
      //---
      if(Boll_Upper_Band<Kelt_Upper_Band && Boll_Lower_Band>Kelt_Lower_Band)
        {
         Squeeze_On[i]=0.01;
         Squeeze_Off[i]=0;
        }
      else
        {
         Squeeze_Off[i]= 0.01;
         Squeeze_On[i] = 0;
        }
     } // end of main indicator FOR loop
//---
   return(0);
  }
//+------------------------------------------------------------------+
