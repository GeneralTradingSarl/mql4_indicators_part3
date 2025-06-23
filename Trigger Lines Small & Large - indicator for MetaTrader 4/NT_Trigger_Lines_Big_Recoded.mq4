//+------------------------------------------------------------------+
//|                                     NT Trigger Lines Recoded.mq4 |
//|                      Copyright 2013, William Kreider (Madhatt30) |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, William Kreider (Madhatt30)"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Green
#property indicator_color2 Green
#property indicator_color3 Red
#property indicator_color4 Red
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
#property indicator_width4 2
//--- input parameters
extern int       length=80;
extern int       trigAvg=20;
//--- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double c;
//---- additional calculating buffers
double LRBuffer[],EMABuffer[];
bool bTrigWasRising=false;
bool firstrun=true;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(6);
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,ExtMapBuffer4);
//---- Counting buffers same as DataSeries in NinjaTrader
   SetIndexBuffer(4,LRBuffer);
   SetIndexBuffer(5,EMABuffer);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i;
   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+length;
//----
   if(firstrun)
     {
      for(i=limit;i>=0;i--)
        {
         LRBuffer[i]=linreg(length,i);
        }
      for(i=limit;i>=0;i--)
        {
         EMABuffer[i]=iMAOnArray(LRBuffer,0,trigAvg,0,MODE_EMA,i);
        }
      firstrun=false;
     }
   RefreshRates();
   WindowRedraw();
   for(i=0;i<=limit;i++)
     {
      LRBuffer[i]=linreg(length,i);
      EMABuffer[i]=iMAOnArray(LRBuffer,0,trigAvg,0,MODE_EMA,i);
      if(EMABuffer[i]>=LRBuffer[i])
        {
         if(bTrigWasRising)
           {
            ExtMapBuffer1[i]=LRBuffer[i];
            ExtMapBuffer2[i]=EMABuffer[i];
            ExtMapBuffer3[i]=EMPTY_VALUE;
            ExtMapBuffer4[i]=EMPTY_VALUE;
           }
         else
           {
            ExtMapBuffer3[i]=LRBuffer[i];
            ExtMapBuffer4[i]=EMABuffer[i];
            ExtMapBuffer1[i]=LRBuffer[i];
            ExtMapBuffer2[i]=EMABuffer[i];
           }
         bTrigWasRising=false;
        }
      else
        {
         if(!bTrigWasRising)
           {
            ExtMapBuffer3[i]=LRBuffer[i];
            ExtMapBuffer4[i]=EMABuffer[i];
            ExtMapBuffer1[i]=LRBuffer[i];
            ExtMapBuffer2[i]=EMABuffer[i];
           }
         else
           {
            ExtMapBuffer1[i]=LRBuffer[i];
            ExtMapBuffer2[i]=EMABuffer[i];
            ExtMapBuffer3[i]=EMPTY_VALUE;
            ExtMapBuffer4[i]=EMPTY_VALUE;
           }
         bTrigWasRising=true;
        }
     }
//----
   RefreshRates();
   WindowRedraw();
   return(0);
  }
//+------------------------------------------------------------------+
//| linreg                                                           |
//+------------------------------------------------------------------+
double linreg(int p,int i)
  {
   double SumY=0;
   double Sum1=0;
   double Slope=0;
//double c;

   for(int x=0; x<=p-1;x++)
     {
      c=Close[x+i];
      SumY+=c;
      Sum1+=x*c;
     }
   double SumBars=p*(p-1)*0.5;
   double SumSqrBars=(p-1)*p*(2*p-1)/6;
   double Sum2=SumBars*SumY;
   double Num1=p*Sum1-Sum2;
   double Num2=SumBars*SumBars-p*SumSqrBars;
   if(Num2!=0) Slope=Num1/Num2;
   else Slope=0;
   double Intercept=(SumY-Slope*SumBars)/p;
   double linregval=Intercept+Slope*(p-1);
   return(linregval);
  }
//+------------------------------------------------------------------+
