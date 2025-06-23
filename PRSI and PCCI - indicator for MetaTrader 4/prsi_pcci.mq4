//+------------------------------------------------------------------+
//|                                                  PRSI & PCCI.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright   "2005-2014, MetaQuotes Software Corp."
#property link        "http://www.mql4.com"
#property description "PRSI & PCCI by pipPod"
#property strict
//--- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 4
#property  indicator_color1  clrLimeGreen
#property  indicator_color2  clrFireBrick
#property  indicator_color3  clrRoyalBlue

#property  indicator_width1  2
#property  indicator_width2  2
#property  indicator_width3  1
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum indicators
  {
   INDICATOR_RSI,  //Relative Strength Index
   INDICATOR_CCI,  //Commodity Channel Index
   INDICATOR_PRSI, //Percent Range of RSI
   INDICATOR_PCCI, //Percent Range of CCI
   INDICATOR_NONE  //No Indicator 
  };

input indicators Indicator_1=INDICATOR_CCI;
input indicators Indicator_2=INDICATOR_PRSI;
//--- indicator parameters
input int RSIPeriod=14; // RSI Period
input ENUM_APPLIED_PRICE RSIPrice=PRICE_CLOSE; // RSI Price

input int CCIPeriod=14; // CCI Period
input ENUM_APPLIED_PRICE CCIPrice=PRICE_CLOSE; // CCI Price

input int PRSIPeriod=14; // PRSI Period
input ENUM_APPLIED_PRICE PRSIPrice=PRICE_CLOSE; // PRSI Price

input int PCCIPeriod=14; // PCCI Period
input ENUM_APPLIED_PRICE PCCIPrice=PRICE_CLOSE; // PCCI Price

input ENUM_TIMEFRAMES TimeFrame_1=0;
input ENUM_TIMEFRAMES TimeFrame_2=0;
//--- indicator buffers
double   IndexBuffer__1[];
double   IndexBuffer_1A[];
double   IndexBuffer_1B[];
double   IndexBuffer__2[];
double   Index_1,
         Index_1A,
         Index_1B,
         Index_2;
//--- right input parameters flag
bool     ExtParameters=false;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {
   IndicatorDigits(1);
//--- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexStyle(3,INDICATOR_DATA,EMPTY,EMPTY,clrNONE);
//--- indicator buffers mapping
   SetIndexBuffer(0,IndexBuffer_1A);
   SetIndexBuffer(1,IndexBuffer_1B);
   SetIndexBuffer(2,IndexBuffer__2);
   SetIndexBuffer(3,IndexBuffer__1);

   SetIndexDrawBegin(0,RSIPeriod);
   SetIndexDrawBegin(1,RSIPeriod);
   SetIndexDrawBegin(2,RSIPeriod);
   SetIndexDrawBegin(3,RSIPeriod);
   
   string   timeFrame_1,
            timeFrame_2;
   
   switch(TimeFrame_1)
     {
      case PERIOD_MN1: timeFrame_1 = "MN1 ";break;
      case PERIOD_W1:  timeFrame_1 = "W1 "; break;
      case PERIOD_D1:  timeFrame_1 = "D1 "; break;
      case PERIOD_H4:  timeFrame_1 = "H4 "; break;
      case PERIOD_H1:  timeFrame_1 = "H1 "; break;
      case PERIOD_M30: timeFrame_1 = "M30 ";break;
      case PERIOD_M15: timeFrame_1 = "M15 ";break;
      case PERIOD_M5:  timeFrame_1 = "M5 "; break;
      case PERIOD_M1:  timeFrame_1 = "M1 "; break;
      default:         timeFrame_1 = " ";    break;
     }
   switch(TimeFrame_2)
     {
      case PERIOD_MN1: timeFrame_2 = "MN1 ";break;
      case PERIOD_W1:  timeFrame_2 = "W1 "; break;
      case PERIOD_D1:  timeFrame_2 = "D1 "; break;
      case PERIOD_H4:  timeFrame_2 = "H4 "; break;
      case PERIOD_H1:  timeFrame_2 = "H1 "; break;
      case PERIOD_M30: timeFrame_2 = "M30 ";break;
      case PERIOD_M15: timeFrame_2 = "M15 ";break;
      case PERIOD_M5:  timeFrame_2 = "M5 "; break;
      case PERIOD_M1:  timeFrame_2 = "M1 "; break;
      default:         timeFrame_2 = " ";    break;
     }
   string   shortname_1,
            shortname_2,
            label_1,
            label_2,
            label_3;
   switch(Indicator_1)
     {
      case INDICATOR_RSI: 
         shortname_1="RSI "+timeFrame_1+"("+
         IntegerToString(RSIPeriod)+")";
         label_1="RSI "+timeFrame_1;
         label_2="RSI "+timeFrame_1;   
         break;
      case INDICATOR_CCI: 
         shortname_1="CCI "+timeFrame_1+"("+
         IntegerToString(CCIPeriod)+")";
         label_1="CCI "+timeFrame_1;
         label_2="CCI "+timeFrame_1;   
         break;
      case INDICATOR_PRSI: 
         shortname_1="PRSI "+timeFrame_1+"("+
         IntegerToString(PRSIPeriod)+")";
         label_1="PRSI "+timeFrame_1;
         label_2="PRSI "+timeFrame_1;  
         break;
      case INDICATOR_PCCI: 
         shortname_1="PCCI "+timeFrame_1+"("+
         IntegerToString(PCCIPeriod)+")";
         label_1="PCCI "+timeFrame_1;
         label_2="PCCI "+timeFrame_1;  
         break;
      case INDICATOR_NONE:                                            
         break;
     }
   switch(Indicator_2)
     {
      case INDICATOR_RSI: 
         shortname_2="RSI "+timeFrame_2+"("+
         IntegerToString(RSIPeriod)+")";
         label_3="RSI "+timeFrame_2;   
         break;
      case INDICATOR_CCI: 
         shortname_2="CCI "+timeFrame_2+"("+
         IntegerToString(CCIPeriod)+")";
         label_3="CCI "+timeFrame_2;   
         break;
      case INDICATOR_PRSI: 
         shortname_2="PRSI "+timeFrame_2+"("+
         IntegerToString(PRSIPeriod)+")";
         label_3="PRSI "+timeFrame_2;  
         break;
      case INDICATOR_PCCI: 
         shortname_2="PCCI "+timeFrame_2+"("+
         IntegerToString(PCCIPeriod)+")";
         label_3="PCCI "+timeFrame_2;  
         break;
      case INDICATOR_NONE:                                            
         break;
     }
//--- name for DataWindow and indicator subwindow label
   IndicatorShortName(shortname_1+" "+shortname_2);
   SetIndexLabel(0,label_1);
   SetIndexLabel(1,label_2);
   SetIndexLabel(2,label_3);
//--- check for input parameters
   if(RSIPeriod<=1 || CCIPeriod<=1 || PRSIPeriod<=1 || PCCIPeriod<=1)
     {
      Print("Wrong input parameters");
      ExtParameters=false;
      return(INIT_FAILED);
     }
   else
      ExtParameters=true;
//--- initialization done
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
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
   int i,limit,shift_1,shift_2;
//---
   if(rates_total<=100 || !ExtParameters)
      return(0);
//---
   bool newBar=prev_calculated==0 || NewBar(time[0]);
   limit=rates_total-prev_calculated;

   if(prev_calculated==0)
      limit=rates_total-50;

   for(i=limit; i>=0; i--)
     {
      shift_1=iBarShift(_Symbol,TimeFrame_1,time[i]);
      switch(Indicator_1)
        {
         case INDICATOR_RSI:
            Index_1=iRSI(_Symbol,TimeFrame_1,RSIPeriod,RSIPrice,MODE_MAIN,newBar,shift_1);
            break;
         case INDICATOR_CCI:
            Index_1=iCCI(_Symbol,TimeFrame_1,CCIPeriod,CCIPrice,MODE_MAIN,newBar,shift_1);
            break;
         case INDICATOR_PRSI:
            Index_1=iRSI(_Symbol,TimeFrame_1,PRSIPeriod,PRSIPrice,MODE_SIGNAL,newBar,shift_1);
            break;
         case INDICATOR_PCCI:
            Index_1=iCCI(_Symbol,TimeFrame_1,PCCIPeriod,PCCIPrice,MODE_SIGNAL,newBar,shift_1);
            break;        
         case INDICATOR_NONE: 
            break;
        }

      shift_2=iBarShift(_Symbol,TimeFrame_2,time[i]);
      switch(Indicator_2)
        {
         case INDICATOR_RSI:
            Index_2=iRSI(_Symbol,TimeFrame_2,RSIPeriod,RSIPrice,MODE_MAIN,newBar,shift_2); 
            break;
         case INDICATOR_CCI:
            Index_2=iCCI(_Symbol,TimeFrame_2,CCIPeriod,CCIPrice,MODE_MAIN,newBar,shift_2); 
            break;
         case INDICATOR_PRSI:
            Index_2=iRSI(_Symbol,TimeFrame_2,PRSIPeriod,PRSIPrice,MODE_SIGNAL,newBar,shift_2); 
            break;
         case INDICATOR_PCCI:
            Index_2=iCCI(_Symbol,TimeFrame_2,PCCIPeriod,PCCIPrice,MODE_SIGNAL,newBar,shift_2); 
            break;
         case INDICATOR_NONE: 
            break;
        }

      IndexBuffer__1[i] = Index_1;

      if(IndexBuffer__1[i]>=IndexBuffer__1[i+1])
        {
         IndexBuffer_1A[i] = IndexBuffer__1[i];
         IndexBuffer_1B[i] = EMPTY_VALUE;
        }
      else
        {
         IndexBuffer_1B[i] = IndexBuffer__1[i];
         IndexBuffer_1A[i] = EMPTY_VALUE;
        }
      
      if(Indicator_2==INDICATOR_NONE)  
         IndexBuffer__2[i] = EMPTY_VALUE;
      else                
         IndexBuffer__2[i] = Index_2;
     }
   //--- done
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool NewBar(const datetime& time)
  {
   static datetime   time_prev;
   if(time!=time_prev)
     {
      time_prev=time;
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
const double iRSI(const string symbol,
                  const ENUM_TIMEFRAMES timeframe,
                  const int period,
                  const ENUM_APPLIED_PRICE price,
                  const int mode,
                  const bool new_bar,
                  const int idx)
  {
   int i,count;
   double prsi;
   if(mode==MODE_SIGNAL)
     {
      static double rsi[1];
      if(ArraySize(rsi)!=period)
         ArrayResize(rsi,period);
      if(!new_bar)
         count=1;
      else
         count=period;
      for(i=0;i<count;i++)
        {
         rsi[i]=iRSI(symbol,timeframe,period,price,idx+i);
        }
      prsi=iPRIOnArray(rsi,period,idx)-50;
     }
   else
      prsi=iRSI(symbol,timeframe,period,price,idx)-50;
   return(prsi);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
const double iCCI(const string symbol,
                  const ENUM_TIMEFRAMES timeframe,
                  const int period,
                  const ENUM_APPLIED_PRICE price,
                  const int mode,
                  const bool new_bar,
                  const int idx)
  {
   int i,count;
   double pcci;
   double mul=1.5/period;
   if(mode==MODE_SIGNAL)
     {
      static double cci[1];
      if(ArraySize(cci)!=period)
         ArrayResize(cci,period);
      if(!new_bar)
         count=1;
      else
         count=period;
      for(i=0;i<count;i++)
        {
         cci[i]=iCCI(symbol,timeframe,period,price,idx+i);
        }
      pcci=iPRIOnArray(cci,period,idx)-50;
     }
   else
      pcci=iCCI(symbol,timeframe,period,price,idx)*mul;
   return(pcci);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
const double iPRIOnArray(const double &array[],
                         const int period,
                         const int idx)
  {
   double pri;
   double low;
   double high;
   double range;
   double price=array[0];
   
   int count=period;
   int arraySize=ArraySize(array);
   if(arraySize<period)   
      count=WHOLE_ARRAY;
   if(arraySize<2)   
      return(50);
   low=array[ArrayMinimum(array,count,0)];
   high=array[ArrayMaximum(array,count,0)];
   range=high-low;
   if(!range)  
      pri=50;
   else        
      pri=100*(price-low)/range;
   
   return(pri);
  }
//+------------------------------------------------------------------+
