/*------------------------------------------------------------------+
 |                                            Trinity-Impulse.mq4   |
 |                                           basisforex@gmail.com   |
 +------------------------------------------------------------------*/ 
#property copyright "Copyright © 2010, basisforex@gmail.com"
//----
#property indicator_separate_window
//----
#property indicator_buffers 1
#property indicator_color1 Blue
//----
extern int nPeriod = 5;
extern int nLevel  = 34;
//----
double c[];
double f[];
double iCF[];
//+------------------------------------------------------------------+
int init()
 {
   string short_name;
   IndicatorBuffers(3);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, iCF);
   SetIndexBuffer(1, c);
   SetIndexBuffer(2, f);
   short_name = "Trinity-Impulse("+nPeriod+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0, short_name);
   SetIndexDrawBegin(0, nPeriod);
   return(0);
 }
//+------------------------------------------------------------------+
int start()
 {
   int counted_bars = IndicatorCounted();
   int j;
   j = Bars - nPeriod - 1;
   if(counted_bars >= nPeriod) j = Bars - counted_bars - 1;
   while(j >= 0)
    {      
       c[j] = iCCI(NULL, 0, nPeriod, PRICE_WEIGHTED, j);     
       f[j] = iForce(NULL, 0, nPeriod, MODE_LWMA, PRICE_WEIGHTED, j);
       //----- 
       if(c[j] * f[j] >= nLevel)
        {
          if(c[j] > 0 &&  f[j] > 0)
           {
             iCF[j] = 1;
           }
          if(c[j] < 0 &&  f[j] < 0)
           {
             iCF[j] = -1;
           }
        }           
       else iCF[j] = 0;
       j--;
    }
   return(0);
 }
//+------------------------------------------------------------------+