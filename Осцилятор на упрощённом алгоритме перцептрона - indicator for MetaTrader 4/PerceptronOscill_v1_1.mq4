//+------------------------------------------------------------------+
//|                                             PerceptronOscill.mq4 |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2010, Tula."
#property  link      "http://detkomb.narod.ru//"

// расчёт по алгоритму: 
//   int w10 = x10 - y;
//   double a1 = Close[i]-Close[i+n];
//   return (w1 * a1  + w2 * a2 + an * wn...)

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 MediumVioletRed
#property indicator_width1 2
//#property indicator_level1 0.0
//#property indicator_levelcolor DimGray
//#property indicator_maximum 3
//#property indicator_minimum -3
//---- input parameters
extern string s0 = "N больше 1  ";
extern int N = 10;//
//---
//---- buffers
double ExtSilverBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- additional buffers are used for counting
   IndicatorBuffers(1);
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtSilverBuffer);
//----
   SetIndexDrawBegin(0,N);
   IndicatorDigits(Digits);
//---- indicator buffers mapping
   SetIndexBuffer(0,ExtSilverBuffer);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("PercOsc_"+N+"N");
//---- 
   if (N<2) N=2;
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Moving Average of Oscillator                                     |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+N;     

   for(int i=0; i<limit; i++)
      ExtSilverBuffer[i]=perc(N,i);
//---- done
   return(0);
  }

//+------------------------------------------------------------------+
double perc(int n,int i) {
   
   double  D = NormalizeDouble((n+1.0)/2,Digits);
//   double  D = (n+1.0)/2;
   double rez = 0.0;
//----
  for (int c = n; c > 0; c--){
    rez = rez + ((c - D) * (Close[i]-Close[i+c]));}
   return (rez);  
}
//+------------------------------------------------------------------+

