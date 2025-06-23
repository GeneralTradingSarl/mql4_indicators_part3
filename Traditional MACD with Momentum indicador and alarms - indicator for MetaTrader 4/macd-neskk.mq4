//+------------------------------------------------------------------+
//|                                                   MACD-neskk.mq4 |
//|                                          neskk.com 2015 Portugal |
//+------------------------------------------------------------------+
#property copyright   "2015, neskk.com"
#property link        "http://www.neskk.com"
#property version     "1.200"
#property description "Moving Averages Convergence/Divergence with a momentum indicator"
//#property strict // compiler directive for strict compilation mode 

//--- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 5
// MACD line
#property indicator_color1 DodgerBlue
#property indicator_width1 1
#property indicator_style1 STYLE_SOLID
// Signal line
#property indicator_color2 FireBrick
#property indicator_width2 1
#property indicator_style2 STYLE_SOLID
// MACD histogram
#property indicator_color3 Silver
#property indicator_width3 2
#property indicator_style1 STYLE_SOLID
// Momentum
#property indicator_color4 LightYellow
#property indicator_width4 1
#property indicator_style4 STYLE_DOT
// Smooth Momentum
#property indicator_color5 Gold
#property indicator_width5 1 
#property indicator_style5 STYLE_DASH

//--- indicator parameters
input int BarsToProcess=1000;
input ENUM_APPLIED_PRICE AppliedPrice=PRICE_CLOSE;
input int PeriodFastEMA=12;
input int PeriodSlowEMA=26;
input int PeriodSignal=9;
input ENUM_MA_METHOD SignalMA=MODE_EMA;
input int DeltaMomentum=10;
input int PeriodMomentum=3;
input ENUM_MA_METHOD MomentumMA=MODE_SMA;
input bool AlarmZeroCrossover=true;
input bool AlarmMomentumReverse=true;

#property indicator_level1 0.0
#property indicator_levelcolor Silver
#property indicator_levelwidth 1
#property indicator_levelstyle STYLE_DOT

//--- indicator buffers
double _bufferMACD[];
double _bufferSignal[];
double _bufferHistogram[];
double _bufferMomentum[];
double _bufferSmoothMomentum[];
//--- right input parameters flag
bool _flagParameters=false;
//---- store last bar time and the last alert direction
static int _prevSignal=0,_prevTime=0;
//---- bar number the alert to be searched by
#define SIGNAL_BAR 1
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {
//--- set the precision
   IndicatorDigits(Digits+1);
//--- drawing settings
   SetIndexStyle(0,DRAW_LINE);               // MACD
   SetIndexStyle(1,DRAW_LINE);               // Signal
   SetIndexStyle(2,DRAW_HISTOGRAM);          // MACD Histogram
   SetIndexStyle(3,DRAW_LINE,STYLE_DOT);     // Momentum        
   SetIndexStyle(4,DRAW_LINE,STYLE_SOLID);   // SmoothMomentum
//--- drawing offset
   SetIndexDrawBegin(0,PeriodFastEMA+PeriodSlowEMA);
   SetIndexDrawBegin(1,PeriodFastEMA+PeriodSlowEMA);
   SetIndexDrawBegin(3,PeriodMomentum);
   SetIndexDrawBegin(4,PeriodMomentum);
//--- indicator buffers mapping
   SetIndexBuffer(0,_bufferMACD);
   SetIndexBuffer(1,_bufferSignal);
   SetIndexBuffer(2,_bufferHistogram);
   SetIndexBuffer(3,_bufferMomentum);
   SetIndexBuffer(4,_bufferSmoothMomentum);
//--- name for DataWindow and indicator subwindow label
   IndicatorShortName("MACD("+IntegerToString(PeriodFastEMA)+","+IntegerToString(PeriodSlowEMA)+","+IntegerToString(PeriodSignal)+")");

   SetIndexLabel(0,"MACD");
   SetIndexLabel(1,"Signal");
   SetIndexLabel(2,"MACD histogram");
   SetIndexLabel(3,"Momentum");
   SetIndexLabel(4,"Smooth Momentum");
//--- check input parameters
   if(PeriodFastEMA<=1 || PeriodSlowEMA<=1 || PeriodSignal<=1 || PeriodFastEMA>=PeriodSlowEMA || PeriodMomentum<=0)
     {
      Print("Wrong input parameters");
      _flagParameters=false;
      return(INIT_PARAMETERS_INCORRECT);
     }
   else
     {
      _flagParameters=true;
     }
//--- initialization done
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Moving Averages Convergence/Divergence                           |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   int i,limit;
//---
   if(rates_total<=PeriodSignal || !_flagParameters) return(0);
//--- last counted bar will be recounted
   limit=rates_total-prev_calculated;

   if(prev_calculated==0)
      limit=rates_total-BarsToProcess;
   if(prev_calculated>0)
      limit--;
//--- MACD
   for(i=limit; i>=0; i--)
      _bufferMACD[i]=iMA(NULL,0,PeriodFastEMA,0,MODE_EMA,AppliedPrice,i)-iMA(NULL,0,PeriodSlowEMA,0,MODE_EMA,AppliedPrice,i);
//--- Signal
   for(i=limit; i>=0; i--)
     {
      _bufferSignal[i]=iMAOnArray(_bufferMACD,0,PeriodSignal,0,SignalMA,i);
      _bufferHistogram[i]=_bufferMACD[i]-_bufferSignal[i];
     }
//--- Momentum
   for(i=limit; i>=0; i--)
     {
      _bufferMomentum[i]=_bufferMACD[i]-_bufferMACD[i+DeltaMomentum];
     }
   for(i=limit; i>=0; i--)
      _bufferSmoothMomentum[i]=iMAOnArray(_bufferMomentum,0,PeriodMomentum,0,MomentumMA,i);

//---- Alarms
//---- avoid analyze the same bar multiple times
   if(SIGNAL_BAR>0 && Time[0]<=_prevTime)
      return(rates_total);
//---- mark that this bar was checked
   _prevTime=Time[0];

   double currentPrice=NormalizeDouble((open[SIGNAL_BAR]+close[SIGNAL_BAR])/2,Digits);
//---- preceding alert was SELL or this is the first launch (PrevSignal=0)
   if(_prevSignal<=0)
     {
      if(AlarmZeroCrossover && 
         _bufferMACD[SIGNAL_BAR]-_bufferSignal[SIGNAL_BAR]>0 && 
         _bufferSignal[SIGNAL_BAR+1]-_bufferMACD[SIGNAL_BAR+1]>=0)
        {
         _prevSignal=1;
         //Alert("[BUY] MACD (", Symbol(), ", ", Period(), ", ", currentPrice, ")");
         Print("[BUY] MACD (",Symbol(),", ",Period(),", ",currentPrice,")");
         //Comment("[BUY] MACD (", Symbol(), ", ", Period(), ", ", currentPrice, ")");
         //PlaySound("Alert2.wav");
        }
      if(AlarmMomentumReverse && 
         _bufferSmoothMomentum[SIGNAL_BAR]-_bufferSmoothMomentum[SIGNAL_BAR+1]>0 && 
         _bufferSmoothMomentum[SIGNAL_BAR+2]-_bufferSmoothMomentum[SIGNAL_BAR+1]>0)
        {
         _prevSignal=1;
         Print("[BUY] MACD Momentum (",Symbol(),", ",Period(),", ",currentPrice,")");
        }
     }
//---- preceding alert was BUY or this is the first launch (PrevSignal=0)
   if(_prevSignal>=0)
     {
      if(AlarmZeroCrossover && 
         _bufferSignal[SIGNAL_BAR]-_bufferMACD[SIGNAL_BAR]>0 && 
         _bufferMACD[SIGNAL_BAR+1]-_bufferSignal[SIGNAL_BAR+1]>=0)
        {
         _prevSignal=-1;
         //Alert("[SELL] MACD (", Symbol(), ", ", Period(), ", ", currentPrice, ")");
         Print("[SELL] MACD (",Symbol(),", ",Period(),", ",currentPrice,")");
         //Comment("[SELL] MACD (", Symbol(), ", ", Period(), ", ", currentPrice, ")");
         //PlaySound("Alert.wav");
        }
      if(AlarmMomentumReverse && 
         _bufferSmoothMomentum[SIGNAL_BAR+1]-_bufferSmoothMomentum[SIGNAL_BAR]>0 && 
         _bufferSmoothMomentum[SIGNAL_BAR+1]-_bufferSmoothMomentum[SIGNAL_BAR+2]>0)
        {
         _prevSignal=-1;
         Print("[SELL] MACD Momentum (",Symbol(),", ",Period(),", ",currentPrice,")");
        }
     }
//--- done
   return(rates_total);
  }
//+------------------------------------------------------------------+
