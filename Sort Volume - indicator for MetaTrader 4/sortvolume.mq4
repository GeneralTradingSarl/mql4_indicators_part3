//+------------------------------------------------------------------+
//|                                                         r_Volume |
//|                                         Copyright 2015, riolious |
//|                                             riolious@outlook.com |
//+------------------------------------------------------------------+
#property copyright "Coded by riolious"
#property link "riolious@outlook.com"
#property version "2.0"
#property description "Calculates volume each currency on pair."
#property strict
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_buffers 2
double xVol[],yVol[];
//+------------------------------------------------------------------+
//| Initialization                                                   |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorDigits(0);
   IndicatorBuffers(2);
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,2,clrBlue);
   SetIndexBuffer(0,xVol);
   SetIndexLabel(0,StringSubstr(Symbol(),0,3));
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,2,clrRed);
   SetIndexBuffer(1,yVol);
   SetIndexLabel(1,StringSubstr(Symbol(),3,3));
   IndicatorShortName("Sort Volume");
   return(0);
  }
//+------------------------------------------------------------------+
//| Deitialization                                                   |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Start r_Volume                                                   |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars-1;
   for(int i=limit;i>=0;i--)
     {
      double PipBar=(MathMax(Open[i],Close[i])-MathMin(Open[i],Close[i]))*MathPow(10,Digits);
      double VolumePerPip=0;
      xVol[i]=0;
      yVol[i]=0;
      if(High[i]!=Low[i])
        {
         VolumePerPip=Volume[i]/((High[i]-Low[i])*MathPow(10,Digits));
         if(Open[i]==Close[i])
           {
            xVol[i]=((Close[i]-Low[i])*MathPow(10,Digits))*VolumePerPip;
            yVol[i]=((High[i]-Close[i])*MathPow(10,Digits))*VolumePerPip;
           }
         else
           {
            if(Open[i]<Close[i])
              {
               xVol[i]=PipBar*VolumePerPip;
               yVol[i]=((High[i]-Close[i])*MathPow(10,Digits))*VolumePerPip;
              }
            if(Open[i]>Close[i])
              {
               xVol[i]=((Close[i]-Low[i])*MathPow(10,Digits))*VolumePerPip;
               yVol[i]=PipBar*VolumePerPip;
              }
           }
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+
