//+------------------------------------------------------------------+
//|                                                           CG.mq4 |
//|                                                                  |
//| CG Oscillator                                                    |
//|                                                                  |
//| Algorithm taken from book                                        |
//|     "Cybernetics Analysis for Stock and Futures"                 |
//| by John F. Ehlers                                                |
//|                                                                  |
//|                                              contact@mqlsoft.com |
//|                                          http://www.mqlsoft.com/ |
//+------------------------------------------------------------------+
#property copyright "Coded by Witold Wozniak"
#property link      "www.mqlsoft.com"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue

#property indicator_level1 0

double CG[];
double Trigger[];

extern int Length=10;
int buffers=0;
int drawBegin=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init() 
  {
   drawBegin=Length;
   initBuffer(CG,"CG",DRAW_LINE);
   initBuffer(Trigger,"Trigger",DRAW_LINE);
   IndicatorBuffers(buffers);
   IndicatorShortName("CG ["+Length+"]");
   return (0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start() 
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+Length;

   int s;
   for(s=limit; s>=0; s--) 
     {
      double Num=0.0;
      double Denom=0.0;
      for(int count=0; count<Length; count++) 
        {
         Num+=(1.0+count)*P(s+count);
         Denom+=P(s+count);
        }
      if(Denom!=0) 
        {
         CG[s] = -Num / Denom + (Length + 1.0) / 2.0;
           } else {
         CG[s]=0;
        }
      Trigger[s]=CG[s+1];
     }
   return (0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double P(int index) 
  {
   return ((High[index] + Low[index]) / 2.0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void initBuffer(double array[],string label="",int type=DRAW_NONE,int arrow=0,int style=EMPTY,int width=EMPTY,color clr=CLR_NONE) 
  {
   SetIndexBuffer(buffers,array);
   SetIndexLabel(buffers,label);
   SetIndexEmptyValue(buffers,EMPTY_VALUE);
   SetIndexDrawBegin(buffers,drawBegin);
   SetIndexShift(buffers,0);
   SetIndexStyle(buffers,type,style,width);
   SetIndexArrow(buffers,arrow);
   buffers++;
  }
//+------------------------------------------------------------------+
