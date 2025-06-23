//+------------------------------------------------------------------+
//|                                                                  |
//|               Psychological Indicator (Ported from FXAccucharts) |
//|                                                      Version 1.0 |
//|                     Copyright © 2007, Bruce Hellstrom (brucehvn) |
//|                                              bhweb@speakeasy.net |
//|                                         http://www.metaquotes.ru |
//+------------------------------------------------------------------+
//+--------------------------------------------------------------------------------+
//|  This indicator is ported from the FXAccuCharts platform to MT4. The formula   |
//|  used here has been tested on FXAccuCharts to insure it displays the same as   |
//|  their default psychological indicator.                                        |
//|                                                                                |
//| Input Parameters:                                                              |
//|  PsychPeriod - Lookback periods for the indicator (25 default)                 |
//|                                                                                |
//| Revision History                                                               |
//|    Version 1.0                                                                 |
//|    * Initial Revision                                                          |
//+--------------------------------------------------------------------------------+
#property copyright "Copyright © 2007, Bruce Hellstrom (brucehvn)"
#property link      "http: //www.metaquotes.net/"
//----
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 DodgerBlue
#property indicator_style1 STYLE_SOLID
//----
#property indicator_level1 50.0
#property indicator_level2 75.0
#property indicator_level3 25.0
#property indicator_levelcolor Silver
#property indicator_levelwidth 1
#property indicator_levelstyle STYLE_DOT
#define INDICATOR_VERSION "v1.0"
// Input Parameters
extern int PsychPeriod=25;
// Buffers
double PsychBuffer[];
// Other Variables
string ShortName;
int CountBuf[];
// Custom indicator initialization function
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(1);
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,1);
   SetIndexBuffer(0,PsychBuffer);
   SetIndexDrawBegin(0,PsychPeriod);
   ArraySetAsSeries(CountBuf,true);
   ShortName="Psychological-"+INDICATOR_VERSION+"("+PsychPeriod+")";
   IndicatorShortName(ShortName);
   SetIndexLabel(0,ShortName);
   Print(ShortName);
   Print("Copyright (c) 2007 - Bruce Hellstrom, bhweb@speakeasy.net");
//----
   return(0);
  }
// Custom indicator deinitialization function
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
// Indicator Logic run on every tick
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(Bars<PsychPeriod)
     {
      Print("not enough bars");
      return(0);
     }
   if(counted_bars==0) limit-=(1+PsychPeriod+1);

// Resize the non-buffer array if necessary
   if(ArraySize(CountBuf)!=ArraySize(PsychBuffer))
     {
      ArraySetAsSeries(CountBuf,false);
      ArrayResize(CountBuf,ArraySize(PsychBuffer));
      ArraySetAsSeries(CountBuf,true);
     }

   for(int ictr=0; ictr<limit; ictr++)
     {
      int Count=0;
      int endctr=ictr+1+PsychPeriod;
      for(int jctr=ictr+1; jctr<endctr; jctr++)
        {
         if(Close[jctr]>Close[jctr+1])
           {
            Count++;
           }
        }
      if(Close[ictr]>Close[ictr+1])
        {
         Count++;
        }
      if(Close[ictr+PsychPeriod]>Close[ictr+PsychPeriod+1])
        {
         Count--;
        }
      double dCount=Count;
      PsychBuffer[ictr]=(dCount/PsychPeriod) *100.0;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
