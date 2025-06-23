//+------------------------------------------------------------------+
//|                                                      T3MAopt.mq4 |
//|                                     Copyright © 2005, Nick Bilak |
//|                                        http://www.forex-tsd.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, Nick Bilak"
#property link      "http://www.forex-tsd.com/"
//---- indicator settings
#property  indicator_chart_window
#property  indicator_buffers 1
#property  indicator_color1  Red
/*
Overview
T3 is an excellent data-fitting technique by Tim Tillson (cf. ``Smoothing Techniques For More Accurate Signals'' in Technical Analysis of Stocks and Commodities - January 1998)
Calculation
N is the Exponential Moving Average Period a is the amplification percentage of the filter's response to price movement (0 < a < 1)
Close1 = N-days EMA of Close Prices 
Close3 = N-days EMA of Close2 
Close3 = N-days EMA of Close2 
Close4 = N-days EMA of Close3 
Close5 = N-days EMA of Close4 
Close6 = N-days EMA of Close5
c1 = (-a)^3 
c2 = 3 * a^2 
c3 = - 6 * a^2 - 3 * a - 3 * a^3 
c4 = 1 + 3 * a + a^3 + 3 * a^2
T3 = c1 * Close6 + c2 * Close5 + c3 * Close4 + c4 * Close3
Parameters
The default values are : N = 5 a = 0.7
Examples
GT::Indicators::T3->new() GT::Indicators::T3->new([5, 0.7])
*/
//---- indicator parameters
extern int FastMA_Period=4;
extern int SlowMA_Period=6;
//----
double Close1,Close2,Close3,Close4,Close5,Close6;
//---- indicator buffers
double FastMABuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(1);
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexDrawBegin(0,FastMA_Period);
   if(!SetIndexBuffer(0,FastMABuffer))
      Print("cannot set indicator buffers!");
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("T3MAopt("+FastMA_Period+")");
   Comment("T3MAopt("+FastMA_Period+")");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Average of Oscillator                                     |
//+------------------------------------------------------------------+
int start()
  {
   int i;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+FastMA_Period+1;
   if (limit<1) return(0);

//---- main loop
   double a=0.8;
   double c1=-a*a*a;
   double c2=3*a*a+3*a*a*a;
   double c3=-6*a*a-3*a-3*a*a*a;
   double c4=1+3*a+a*a*a+3*a*a;
   double pr=2.0/(FastMA_Period+1);
   Close1=Close[limit+1];
   Close2=Close1;
   Close3=Close2;
   Close4=Close3;
   Close5=Close4;
   Close6=Close5;
   for(i=limit; i>=0; i--)
     {
      Close1=Close[i]*pr+Close1*(1-pr);
      Close2=Close1*pr+Close2*(1-pr);
      Close3=Close2*pr+Close3*(1-pr);
      Close4=Close3*pr+Close4*(1-pr);
      Close5=Close4*pr+Close5*(1-pr);
      Close6=Close5*pr+Close6*(1-pr);
      FastMABuffer[i]=c1*Close6+c2*Close5+c3*Close4+c4*Close3;
     }
//---- done
   return(0);
  }
//+------------------------------------------------------------------+
