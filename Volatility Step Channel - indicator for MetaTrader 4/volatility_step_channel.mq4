//+------------------------------------------------------------------+
//|                                      Volatility_Step_Channel.mq4 |
//| Volatility Step Channel v1.01             Copyright 2015, fxborg |
//|                                   http://fxborg-labo.hateblo.jp/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, fxborg"
#property link      "http://fxborg-labo.hateblo.jp/"
#property version   "1.01"
//---
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_type1 DRAW_LINE
#property indicator_type2 DRAW_LINE
#property indicator_type3 DRAW_LINE
//---
#property indicator_color1 DarkGray
#property indicator_color2 DarkGray
#property indicator_color3 DeepPink
//---
#property indicator_label1 "Upper Channel"
#property indicator_label2 "Lower Channel"
#property indicator_label3 "Median Line"
//---
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 2
//---
#property indicator_style1 STYLE_DASH
#property indicator_style2 STYLE_DASH
#property indicator_style3 STYLE_SOLID
//--- input parameters
input double InpScaleFactor=2.0; // Scale factor
input int    InpMaPeriod=3; // Smooth Period
input string Description1="--- For BaseVolatility Indicator ---";
input int    InpFastPeriod=10; //  Fast Period
input int    InpSlowPeriod=70; //  Slow Period
input ENUM_MA_METHOD InpMaMethod=MODE_SMMA; // Ma Method 
input string Description2="--- 1:Simple Mode 2:hybrid Mode ---";
input int    InpMode=2; //  1:Simple Mode 2:hybrid Mode
//---- will be used as indicator buffers
double UpperBuffer[];
double MiddleBuffer[];
double LowerBuffer[];
//---
double UpperMaBuffer[];
double MiddleMaBuffer[];
double LowerMaBuffer[];
//---
double HighBuffer[];
double LowBuffer[];
double CloseBuffer[];
//---- declaration of global variables
int min_rates_total;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//---- Initialization of variables of data calculation starting point
   min_rates_total=1+InpFastPeriod+InpSlowPeriod+InpMaPeriod+InpMaPeriod+1;
//--- indicator buffers mapping
   IndicatorBuffers(9);
//--- indicator buffers
   SetIndexBuffer(0,UpperMaBuffer);
   SetIndexBuffer(1,LowerMaBuffer);
   SetIndexBuffer(2,MiddleMaBuffer);
   SetIndexBuffer(3,UpperBuffer);
   SetIndexBuffer(4,LowerBuffer);
   SetIndexBuffer(5,MiddleBuffer);
   SetIndexBuffer(6,HighBuffer);
   SetIndexBuffer(7,LowBuffer);
   SetIndexBuffer(8,CloseBuffer);
//---
   SetIndexEmptyValue(0,0);
   SetIndexEmptyValue(1,0);
   SetIndexEmptyValue(2,0);
   SetIndexEmptyValue(3,0);
   SetIndexEmptyValue(4,0);
   SetIndexEmptyValue(5,0);
   SetIndexEmptyValue(6,0);
   SetIndexEmptyValue(7,0);
   SetIndexEmptyValue(8,0);
   SetIndexDrawBegin(0,min_rates_total);
   SetIndexDrawBegin(1,min_rates_total);
   SetIndexDrawBegin(2,min_rates_total);
   SetIndexDrawBegin(3,min_rates_total);
   SetIndexDrawBegin(4,min_rates_total);
   SetIndexDrawBegin(5,min_rates_total);
   SetIndexDrawBegin(6,min_rates_total);
   SetIndexDrawBegin(7,min_rates_total);
   SetIndexDrawBegin(8,min_rates_total);
//---
   string short_name="Volatility Step Channel v1.01("
                     +IntegerToString(InpScaleFactor)+","+IntegerToString(InpMaPeriod)+","
                     +IntegerToString(InpSlowPeriod)+","+IntegerToString(InpFastPeriod)+","
                     +IntegerToString(InpMode)+")";
   IndicatorShortName(short_name);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
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
//---
   int i,j,first;
//--- check for bars count
   if(rates_total<=min_rates_total)
      return(0);
//---
   MathSrand(int(TimeLocal()));
//--- indicator buffers
   ArraySetAsSeries(UpperMaBuffer,false);
   ArraySetAsSeries(LowerMaBuffer,false);
   ArraySetAsSeries(MiddleMaBuffer,false);
   ArraySetAsSeries(UpperBuffer,false);
   ArraySetAsSeries(LowerBuffer,false);
   ArraySetAsSeries(MiddleBuffer,false);
   ArraySetAsSeries(HighBuffer,false);
   ArraySetAsSeries(LowBuffer,false);
   ArraySetAsSeries(CloseBuffer,false);
//--- rate data
   ArraySetAsSeries(high,false);
   ArraySetAsSeries(low,false);
   ArraySetAsSeries(close,false);
   ArraySetAsSeries(time,false);
//+----------------------------------------------------+
//|Set High Low Buffeer                                |
//+----------------------------------------------------+
   first=InpMaPeriod+InpMaPeriod+1;
   if(first+1<prev_calculated)
      first=prev_calculated-2;
   else
     {
      for(i=0; i<first; i++)
        {
         MiddleBuffer[i]=close[i];
         HighBuffer[i]=high[i];
         LowBuffer[i]=low[i];
        }
     }
//---
   for(i=first; i<rates_total && !IsStopped(); i++)
     {
      if(!random(20) && rates_total-i>min_rates_total*2 && UpperBuffer[i]!=0) continue;
      double h,l,c,hsum=0.0,lsum=0.0,csum=0.0;
      //---
      for(j=0;j<InpMaPeriod;j++)
        {
         hsum += high[i-j];
         lsum += low[i-j];
         csum += close[i-j];
        }
      h=hsum/InpMaPeriod;
      l=lsum/InpMaPeriod;
      c=csum/InpMaPeriod;
      //---
      double v=iCustom(Symbol(),PERIOD_CURRENT,"BaseVolatility",InpFastPeriod,InpSlowPeriod,InpMaMethod,0,(rates_total-i)+1);
      double base=v*InpScaleFactor;
      //---
      if(2==InpMode)
        {
         //--- Hybrid Mode
         if((h-base)>HighBuffer[i-1]) HighBuffer[i]=h;
         else if(h+base<HighBuffer[i-1]) HighBuffer[i]=h+base;
         else HighBuffer[i]=HighBuffer[i-1];
         //---
         if(l+base<LowBuffer[i-1]) LowBuffer[i]=l;
         else if((l-base)>LowBuffer[i-1]) LowBuffer[i]=l-base;
         else LowBuffer[i]=LowBuffer[i-1];
         //---
         if((c-base/2)>CloseBuffer[i-1]) CloseBuffer[i]=c-base/2;
         else if(c+base/2<CloseBuffer[i-1]) CloseBuffer[i]=c+base/2;
         else CloseBuffer[i]=CloseBuffer[i-1];
         //---
         MiddleBuffer[i]=(HighBuffer[i]+LowBuffer[i]+CloseBuffer[i]*2)/4;
        }
      else
        {
         //--- Simple Mode
         if((h-base)>HighBuffer[i-1]) HighBuffer[i]=h;
         else if(h+base<HighBuffer[i-1]) HighBuffer[i]=h+base;
         else HighBuffer[i]=HighBuffer[i-1];
         //---
         if(l+base<LowBuffer[i-1]) LowBuffer[i]=l;
         else if((l-base)>LowBuffer[i-1]) LowBuffer[i]=l-base;
         else LowBuffer[i]=LowBuffer[i-1];
         //---
         if((c-base)>CloseBuffer[i-1]) CloseBuffer[i]=c-base;
         else if(c+base<CloseBuffer[i-1]) CloseBuffer[i]=c+base;
         else CloseBuffer[i]=CloseBuffer[i-1];
         MiddleBuffer[i]=(HighBuffer[i]+LowBuffer[i]+CloseBuffer[i])/3;
        }
      //---
      UpperBuffer[i]=HighBuffer[i] + base/2;
      LowerBuffer[i]=LowBuffer[i]  - base/2;
      hsum=0.0;
      lsum=0.0;
      csum=0.0;
      for(j=0;j<InpMaPeriod;j++)
        {
         hsum += UpperBuffer[i-j];
         lsum += LowerBuffer[i-j];
         csum += MiddleBuffer[i-j];
        }
      UpperMaBuffer[i]=hsum/InpMaPeriod;
      LowerMaBuffer[i]=lsum/InpMaPeriod;
      MiddleMaBuffer[i]=csum/InpMaPeriod;
     }
//----    
   return(rates_total);
  }
//+----------------------------------------------------+
//| random func                                        |
//+----------------------------------------------------+
bool random(int x)
  {
   int ran=MathRand();
   bool res=(MathMod(ran,x)==0);
   return(res);
  }
//+------------------------------------------------------------------+
