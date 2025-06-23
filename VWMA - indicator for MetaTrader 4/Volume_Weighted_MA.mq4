//+------------------------------------------------------------------+
//|                                           Volume_Weighted_MA.mq4 |
//|                                                      StatBars TO |
//|                                      http://ridecrufter.narod.ru |
//+------------------------------------------------------------------+
#property copyright "StatBars TO"
#property link      "http://ridecrufter.narod.ru"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 DeepPink

extern int  Period_MA=21;
extern int  Price_MA=PRICE_MEDIAN;

double MABuffer[];
double Vol[1];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(1);
   SetIndexDrawBegin(0,Period_MA);
   SetIndexBuffer(0,MABuffer);
   SetIndexStyle(0,DRAW_LINE);
   IndicatorDigits(Digits+1);

   ArrayResize(Vol,Period_MA);

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int j,i;
   double sum;
   double Price;

   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   if(counted_bars==0) limit-=Period_MA;

   for(i=0; i<limit; i++)
     {
      sum=0;
      Price=0;
      for(j=i;j<i+Period_MA;j++){Vol[j-i]=Volume[j];sum+=Vol[j-i];}
      for(j=0;j<Period_MA;j++)Vol[j]/=sum;
      for(j=i;j<i+Period_MA;j++)
        {
         Price+=get_price(j,Price_MA)*Vol[j-i];
        }
      MABuffer[i]=Price;
     }

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double get_price(int num,int applied_price)
  {
   switch(applied_price)
     {
      case  PRICE_CLOSE    :  return(Close[num]);
      case  PRICE_OPEN     :  return(Open[num]);
      case  PRICE_HIGH     :  return(High[num]);
      case  PRICE_LOW      :  return(Low[num]);
      case  PRICE_MEDIAN   :  return((High[num]+Low[num])/2);
      case  PRICE_TYPICAL  :  return((High[num]+Low[num]+Close[num])/3);
      case  PRICE_WEIGHTED :  return((High[num]+Low[num]+Close[num]+Close[num])/4);
      default              :  return((High[num]+Low[num])/2);
     }
  }
//+------------------------------------------------------------------+
