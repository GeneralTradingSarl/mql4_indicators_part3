//+------------------------------------------------------------------+
//|                                           correlation_2pairs.mq4 |
//|                                         Copyright © 2006, zolero |
//|                                        http://www.mt ©etatrader.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, zolero"
#property link      "http://www."

#property indicator_separate_window

datetime x;
#property indicator_buffers 3
#property indicator_color1 Red
extern string Pair1="GBPUSD";
extern int    Periood=14;
double Correl1_Buffer[];
double array11[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(3);
//---- indicators
   SetIndexStyle(0,DRAW_LINE,0,1,Red);
   SetIndexBuffer(0,Correl1_Buffer);

   SetIndexBuffer(1,array11);
   SetIndexStyle(1,DRAW_LINE);

   IndicatorDigits(Digits+10);
   SetLevelValue(-1,1);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+Periood;
      
   int shift;
   double sum1,sum2,first,first1,second1,third1,second,third,average1,average2;
//----
   shift=limit;
   while(shift>0)
     {
      first1=0; second1=0; third1=0;
      for(int c=1; c<Periood; c++)
        {
         double v=iClose(Pair1,0,shift+1);
         first1=0;
         if (v!=0) first1=((iClose(Pair1,0,shift)-v)/v)*100;
        }
      array11[shift]=first1;
      shift--;
     }
// Print("percent change:  ",array11[1], "   array   ",iClose(Pair1,0,shift),"  ",iClose(Pair1,0,shift+1));
   ArraySetAsSeries(array11,true);
   shift=limit;
   while(shift>0)
     {
      sum1=0; sum2=0;
      for(int i=1; i<Periood; i++)
        {
         sum1+=iClose(Pair1,0,shift+i);
         sum2+=array11[shift+i];
        }
      average1=sum1/(Periood-1);
      average2=sum2/(Periood-1);
      first=0; second=0; third=0;
      for(c=1; c<Periood; c++)
        {
         first+=(iClose(Pair1,0,shift+c)-average1)*(array11[shift+c]-average2);
         second+=MathPow((iClose(Pair1,0,shift+c)-average1),2.0);
         third+=MathPow((array11[shift+c]-average2),2.0);
        }
      double d2=second*third;     
      //Print(first,"    ",second,"   ",third);
      if (d2!=0)Correl1_Buffer[shift]=first/(MathSqrt(d2));
      shift--;
     }
   x=iTime(NULL,0,0);
//----
   return(0);
  }
//+------------------------------------------------------------------+
