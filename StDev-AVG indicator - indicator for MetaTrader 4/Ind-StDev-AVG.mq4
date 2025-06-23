//+------------------------------------------------------------------+
//|                                                Ind-StDev-AVG.mq4 |
//|                                                           GGekko |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "GGekko"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Green
#property indicator_width1 2
//---- indicator parameters
extern int MA_Period=12;
extern int MA_Method=1;
extern int STDEV_Period=12;
extern int STDEV_Method=1;
extern int STDEV_Price=0;
//---- indicator buffers
double ExtMapBuffer[];
//----
int ExtCountedBars=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   int    draw_begin;
   string short_name;
//---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,ExtMapBuffer);
   SetIndexShift(0,0);
   /*
   SetIndexStyle(0,DRAW_LINE);
   SetIndexShift(0,0);
   */
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
   if(MA_Period<2) MA_Period=13;
   draw_begin=MA_Period-1;

   SetIndexDrawBegin(0,draw_begin);
//---- indicator buffers mapping
   SetIndexBuffer(0,ExtMapBuffer);
   
   IndicatorShortName("StDev-AVG ("+MA_Period+","+MA_Method+","+STDEV_Period+","+STDEV_Method+","+STDEV_Price+")");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   if(Bars<=MA_Period) return(0);
   ExtCountedBars=IndicatorCounted();
//---- check for possible errors
   if (ExtCountedBars<0) return(-1);
//---- last counted bar will be recounted
   if (ExtCountedBars>0) ExtCountedBars--;
//----
   
   switch(MA_Method)
     {
      case 0 : sma_stdev();  break;
      case 1 : ema_stdev();  break;
      case 2 : smma_stdev(); break;
      case 3 : lwma_stdev();
     }
   
//---- done
   return(0);
  }
//+------------------------------------------------------------------+
//| Simple MA                                                        |
//+------------------------------------------------------------------+
void sma_stdev()
  {
   double sum=0;
   int    i,pos=Bars-ExtCountedBars-1;
//---- initial accumulation
   if(pos<MA_Period) pos=MA_Period;
   for(i=1;i<MA_Period;i++,pos--)
      {
      sum+=iStdDev(NULL,0,STDEV_Period,0,STDEV_Method,STDEV_Price,pos);
      }
//---- main calculation loop
   while(pos>=0)
     {
      sum+=iStdDev(NULL,0,STDEV_Period,0,STDEV_Method,STDEV_Price,pos);
      ExtMapBuffer[pos]=sum/MA_Period;
	   sum-=iStdDev(NULL,0,STDEV_Period,0,STDEV_Method,STDEV_Price,pos+MA_Period-1);
 	   pos--;
     }
//---- zero initial bars
   if(ExtCountedBars<1)
      for(i=1;i<MA_Period;i++) ExtMapBuffer[Bars-i]=0;
  }
//+------------------------------------------------------------------+
//| Exponential MA                                                   |
//+------------------------------------------------------------------+
void ema_stdev()
  {
   double pr=2.0/(MA_Period+1);
   int    pos=Bars-2;
   if(ExtCountedBars>2) pos=Bars-ExtCountedBars-1;
//---- main calculation loop
   while(pos>=0)
     {
      if(pos==Bars-2) ExtMapBuffer[pos+1]=iStdDev(NULL,0,STDEV_Period,0,STDEV_Method,STDEV_Price,pos+1);
      ExtMapBuffer[pos]=iStdDev(NULL,0,STDEV_Period,0,STDEV_Method,STDEV_Price,pos)*pr+ExtMapBuffer[pos+1]*(1-pr);
 	   pos--;
     }
  }
//+------------------------------------------------------------------+
//| Smoothed MA                                                      |
//+------------------------------------------------------------------+
void smma_stdev()
  {
   double sum=0;
   int    i,k,pos=Bars-ExtCountedBars+1;
//---- main calculation loop
   pos=Bars-MA_Period;
   if(pos>Bars-ExtCountedBars) pos=Bars-ExtCountedBars;
   while(pos>=0)
     {
      if(pos==Bars-MA_Period)
        {
         //---- initial accumulation
         for(i=0,k=pos;i<MA_Period;i++,k++)
           {
            sum+=iStdDev(NULL,0,STDEV_Period,0,STDEV_Method,STDEV_Price,k);
            //---- zero initial bars
            ExtMapBuffer[k]=0;
           }
        }
      else sum=ExtMapBuffer[pos+1]*(MA_Period-1)+iStdDev(NULL,0,STDEV_Period,0,STDEV_Method,STDEV_Price,pos);
      ExtMapBuffer[pos]=sum/MA_Period;
 	   pos--;
     }
  }
//+------------------------------------------------------------------+
//| Linear Weighted MA                                               |
//+------------------------------------------------------------------+
void lwma_stdev()
  {
   double sum=0.0,lsum=0.0;
   double val;
   int    i,weight=0,pos=Bars-ExtCountedBars-1;
//---- initial accumulation
   if(pos<MA_Period) pos=MA_Period;
   for(i=1;i<=MA_Period;i++,pos--)
     {
      val=iStdDev(NULL,0,STDEV_Period,0,STDEV_Method,STDEV_Price,pos);
      sum+=val*i;
      lsum+=val;
      weight+=i;
     }
//---- main calculation loop
   pos++;
   i=pos+MA_Period;
   while(pos>=0)
     {
      ExtMapBuffer[pos]=sum/weight;
      if(pos==0) break;
      pos--;
      i--;
      val=iStdDev(NULL,0,STDEV_Period,0,STDEV_Method,STDEV_Price,pos);
      sum=sum-lsum+val*MA_Period;
      lsum-=iStdDev(NULL,0,STDEV_Period,0,STDEV_Method,STDEV_Price,i);
      lsum+=val;
     }
//---- zero initial bars
   if(ExtCountedBars<1)
      for(i=1;i<MA_Period;i++) ExtMapBuffer[Bars-i]=0;
  }
//+------------------------------------------------------------------+




