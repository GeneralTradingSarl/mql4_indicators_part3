//+------------------------------------------------------------------+
//|                                                 ZeroLag MACD.mq4 |
//|                                                               RD |
//|                                                 marynarz15@wp.pl |
//| Colored by SVK © 2009.                                           |
//+------------------------------------------------------------------+
#property copyright "RD"
#property link      "marynarz15@wp.pl"
//----
#property indicator_separate_window
#property  indicator_buffers 7
#property indicator_color1 Black
#property indicator_color2 Blue
#property indicator_color3 Black
#property indicator_color4 Black
#property indicator_color5 Black
#property indicator_color6 Lime
#property indicator_color7 Red

//---- input parameters
extern int FastEMA = 12;
extern int SlowEMA = 26;
extern int SignalEMA = 9;

//---- buffers
double MACDBuffer[];
double SignalBuffer[];
double FastEMABuffer[];
double SlowEMABuffer[];
double SignalEMABuffer[];

double Buffer1[];
double Buffer2[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(7);
   SetIndexBuffer(0, MACDBuffer);
   SetIndexBuffer(1, SignalBuffer);
   SetIndexBuffer(2, FastEMABuffer);
   SetIndexBuffer(3, SlowEMABuffer);
   SetIndexBuffer(4, SignalEMABuffer);
   SetIndexBuffer(5, Buffer1);
   SetIndexBuffer(6, Buffer2);
   SetIndexStyle(0, DRAW_NONE);
   SetIndexStyle(1, DRAW_LINE,EMPTY);
   SetIndexStyle(2, DRAW_NONE);
   SetIndexStyle(3, DRAW_NONE);
   SetIndexStyle(4, DRAW_NONE);
   SetIndexStyle(5, DRAW_HISTOGRAM);
   SetIndexStyle(6, DRAW_HISTOGRAM);
   SetIndexDrawBegin(0, SlowEMA);
   SetIndexDrawBegin(1, SlowEMA);
   IndicatorShortName("ZeroLag MACD Colored(" + FastEMA + "," + SlowEMA + "," + SignalEMA + ")");
   SetIndexLabel(0, "MACD");
   SetIndexLabel(1, "Signal");
   SetIndexLabel(5, "MACD");
   SetIndexLabel(6, "MACD");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
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
   int limit;
   double prev,current;
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0) 
       return(-1);
   if(counted_bars > 0) 
       counted_bars--;
   limit = Bars - counted_bars;
   if(counted_bars==0) limit-=2;
   
   double EMA, ZeroLagEMAp, ZeroLagEMAq;
   for(int i = 0; i < limit; i++)
     {
       FastEMABuffer[i] = 100.0*iMA(NULL, 0, FastEMA, 0, MODE_EMA, PRICE_CLOSE, i);
       SlowEMABuffer[i] = 100.0*iMA(NULL, 0, SlowEMA, 0, MODE_EMA, PRICE_CLOSE, i);
     }
   for(i = 0; i < limit; i++)
     {
        EMA = iMAOnArray(FastEMABuffer, Bars, FastEMA, 0, MODE_EMA, i);
        ZeroLagEMAp = FastEMABuffer[i] + FastEMABuffer[i] - EMA;
        EMA = iMAOnArray(SlowEMABuffer, Bars, SlowEMA, 0, MODE_EMA, i);
        ZeroLagEMAq = SlowEMABuffer[i] + SlowEMABuffer[i] - EMA;
        MACDBuffer[i] = ZeroLagEMAp - ZeroLagEMAq;
        FastEMABuffer[i] = 0.0;
        SlowEMABuffer[i] = 0.0;
     }
   for(i = 0; i < limit; i++)
       SignalEMABuffer[i] = iMAOnArray(MACDBuffer, Bars, SignalEMA, 0, MODE_EMA, i);
   for(i = 0; i < limit; i++)
     {
       EMA = iMAOnArray(SignalEMABuffer, Bars, SignalEMA, 0, MODE_EMA, i);
       SignalBuffer[i] = SignalEMABuffer[i] + SignalEMABuffer[i] - EMA;
       SignalEMABuffer[i] = 0.0;
     }
//---- dispatch values between 2 buffers
   bool up=true;
   for(i=limit-1; i>=0; i--)
     {
      current=MACDBuffer[i];
      prev=MACDBuffer[i+1];
      if(current>prev) up=true;
      if(current<prev) up=false;
      if(!up)
        {
         Buffer2[i]=current;
         Buffer1[i]=0.0;
        }
      else
        {
         Buffer1[i]=current;
         Buffer2[i]=0.0;
        }
     }     
   return(0);
  }
//+------------------------------------------------------------------+