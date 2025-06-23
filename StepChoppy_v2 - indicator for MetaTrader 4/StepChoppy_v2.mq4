//+------------------------------------------------------------------+
//|                                              StepChoppy_v2.mq4 |
//|                                  Copyright © 2007, Forex-TSD.com |
//|                         Written by IgorAD,igorad2003@yahoo.co.uk |   
//|            http://finance.groups.yahoo.com/group/TrendLaboratory |                                      
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, Forex-TSD.com "
#property link      "http://www.forex-tsd.com/"
//----
#property indicator_separate_window
#property indicator_minimum -0.05
#property indicator_maximum 1.05
#property indicator_buffers 8
#property indicator_color1 MediumBlue
#property indicator_color2 Crimson
#property indicator_color3 DodgerBlue
#property indicator_color4 Tomato
#property indicator_color5 LightBlue
#property indicator_color6 Orange
#property indicator_color7 Aqua
#property indicator_color8 Yellow
//----
#property indicator_width1 3
#property indicator_width2 3
#property indicator_width3 3
#property indicator_width4 3
#property indicator_width5 3
#property indicator_width6 3
#property indicator_width7 3
#property indicator_width8 3
//---- input parameters
extern int     Length     =10;
extern double  Kv          =1.0;
extern double  StepSize  =0;
extern int     MA_Mode   =0;
extern bool    HighLow       =false;
extern double  StepSizeFast=  5;
extern double  StepSizeSlow= 15;
//----
int   MAPeriod =1;
int   Price    =0;
int   Mode     =2;
//---- buffers
double UpBuffer1[];
double UpBuffer2[];
double UpBuffer3[];
double UpBuffer4[];
double DnBuffer1[];
double DnBuffer2[];
double DnBuffer3[];
double DnBuffer4[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,UpBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexBuffer(1,DnBuffer1);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexBuffer(2,UpBuffer2);
   SetIndexStyle(3,DRAW_HISTOGRAM);
   SetIndexBuffer(3,DnBuffer2);
   SetIndexStyle(4,DRAW_HISTOGRAM);
   SetIndexBuffer(4,UpBuffer3);
   SetIndexStyle(5,DRAW_HISTOGRAM);
   SetIndexBuffer(5,DnBuffer3);
   SetIndexStyle(6,DRAW_HISTOGRAM);
   SetIndexBuffer(6,UpBuffer4);
   SetIndexStyle(7,DRAW_HISTOGRAM);
   SetIndexBuffer(7,DnBuffer4);
//---- 
   string short_name="StepChoppy_v2";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"Strong UpTrend");
   SetIndexLabel(1,"Retrace UpTrend");
   SetIndexLabel(2,"Choppy UpTrend");
   SetIndexLabel(3,"Be ready to change UpTrend");
   //
   SetIndexLabel(4,"Strong DownTrend");
   SetIndexLabel(5,"Retrace DownTrend");
   SetIndexLabel(6,"Choppy DownTrend");
   SetIndexLabel(7,"Be ready to change DownTrend");
//----
   SetIndexDrawBegin(0,Length);
   SetIndexDrawBegin(1,Length);
   SetIndexDrawBegin(2,Length);
   SetIndexDrawBegin(3,Length);
   SetIndexDrawBegin(4,Length);
   SetIndexDrawBegin(5,Length);
   SetIndexDrawBegin(6,Length);
   SetIndexDrawBegin(7,Length);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| StepChoppy_v1.3                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int  i,counted_bars=IndicatorCounted();
   double RSI, FastRSI, SlowRSI, StepMA, Trend;
//----
   if(Bars<=Length) return(0);
//---- initial zero
   if(counted_bars<1)
      for(i=1;i<=Length;i++)
        {
         UpBuffer1[Bars-i]=0.0;
         UpBuffer2[Bars-i]=0.0;
         UpBuffer3[Bars-i]=0.0;
         UpBuffer4[Bars-i]=0.0;
         //
         DnBuffer1[Bars-i]=0.0;
         DnBuffer2[Bars-i]=0.0;
         DnBuffer3[Bars-i]=0.0;
         DnBuffer4[Bars-i]=0.0;
        }
//----
   if(counted_bars > 0) int limit=Bars-counted_bars;
   if(counted_bars ==0) limit=Bars-Length-1;
//----
   for(i=limit;i>=0;i--)
     {
      Trend =iCustom(NULL,0,"StepMA_v7",Length,Kv,StepSize,MA_Mode,0,0,HighLow,2,0,5,i);
      RSI=iCustom(NULL,0,"StepRSI_v5.2",Length,StepSizeFast,MAPeriod,Price,Mode,0,i);
      FastRSI=iCustom(NULL,0,"StepRSI_v5.2",Length,StepSizeFast,MAPeriod,Price,Mode,1,i);
      SlowRSI=iCustom(NULL,0,"StepRSI_v5.2",Length,StepSizeSlow,MAPeriod,Price,Mode,1,i);
//----
      UpBuffer1[i] =EMPTY;
      UpBuffer2[i] =EMPTY;
      UpBuffer3[i] =EMPTY;
      UpBuffer4[i] =EMPTY;
      //
      DnBuffer1[i] =EMPTY;
      DnBuffer2[i] =EMPTY;
      DnBuffer3[i] =EMPTY;
      DnBuffer4[i] =EMPTY;
//----
      if (FastRSI > SlowRSI && RSI > FastRSI && Trend > 0)
        {UpBuffer1[i]=1.0;UpBuffer2[i]=0.0;UpBuffer3[i]=0.0;UpBuffer4[i]=0.0;
        DnBuffer1[i]=0.0;DnBuffer2[i]=0.0;DnBuffer3[i]=0.0;DnBuffer4[i]=0.0;}
      else if (FastRSI > SlowRSI && RSI < FastRSI && Trend > 0)
           {
            UpBuffer1[i]=0.0;UpBuffer2[i]=1.0;UpBuffer3[i]=0.0;UpBuffer4[i]=0.0;
            DnBuffer1[i]=0.0;DnBuffer2[i]=0.0;DnBuffer3[i]=0.0;DnBuffer4[i]=0.0;
           }
         else if (FastRSI < SlowRSI && RSI > FastRSI && Trend > 0)
              {
               UpBuffer1[i]=0.0;UpBuffer2[i]=0.0;UpBuffer3[i]=1.0;UpBuffer4[i]=0.0;
               DnBuffer1[i]=0.0;DnBuffer2[i]=0.0;DnBuffer3[i]=0.0;DnBuffer4[i]=0.0;
              }
            else if (FastRSI < SlowRSI && RSI < FastRSI && Trend > 0)
                 {
                  UpBuffer1[i]=0.0;UpBuffer2[i]=0.0;UpBuffer3[i]=0.0;UpBuffer4[i]=1.0;
                  DnBuffer1[i]=0.0;DnBuffer2[i]=0.0;DnBuffer3[i]=0.0;DnBuffer4[i]=0.0;
                 }
               else if (FastRSI < SlowRSI && RSI < FastRSI && Trend < 0)
                    {
                     UpBuffer1[i]=0.0;UpBuffer2[i]=0.0;UpBuffer3[i]=0.0;UpBuffer4[i]=0.0;
                     DnBuffer1[i]=1.0;DnBuffer2[i]=0.0;DnBuffer3[i]=0.0;DnBuffer4[i]=0.0;
                    }
                  else if (FastRSI < SlowRSI && RSI > FastRSI && Trend < 0)
                       {
                        UpBuffer1[i]=0.0;UpBuffer2[i]=0.0;UpBuffer3[i]=0.0;UpBuffer4[i]=0.0;
                        DnBuffer1[i]=0.0;DnBuffer2[i]=1.0;DnBuffer3[i]=0.0;DnBuffer4[i]=0.0;
                       }
                     else if (FastRSI > SlowRSI && RSI < FastRSI && Trend < 0)
                          {
                           UpBuffer1[i]=0.0;UpBuffer2[i]=0.0;UpBuffer3[i]=0.0;UpBuffer4[i]=0.0;
                           DnBuffer1[i]=0.0;DnBuffer2[i]=0.0;DnBuffer3[i]=1.0;DnBuffer4[i]=0.0;
                          }
                        else if (FastRSI > SlowRSI && RSI > FastRSI && Trend < 0)
                             {
                              UpBuffer1[i]=0.0;UpBuffer2[i]=0.0;UpBuffer3[i]=0.0;UpBuffer4[i]=0.0;
                              DnBuffer1[i]=0.0;DnBuffer2[i]=0.0;DnBuffer3[i]=0.0;DnBuffer4[i]=1.0;
                             }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+