//===================================================================================================================================================//
#property copyright   "Copyright 2016-2017, Nikolaos Pantzos"
#property link        "https://www.mql5.com/en/users/pannik"
#property version     "1.1"
#property description "RSI on MA"
#property strict
//===================================================================================================================================================//
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 clrDeepSkyBlue
#property indicator_color2 clrRed
#property indicator_color3 clrYellow
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
//===================================================================================================================================================//
input string             MA_Parameters   = "||========== MA Parameters ==========||";
input int                MA_Periods      = 14;
input ENUM_MA_METHOD     MA_Method       = MODE_SMA;
input string             RSI_Parameters  = "||========== RSI Parameters ==========||";
input int                RSI_Periods     = 14;
input ENUM_APPLIED_PRICE RSI_ApliedPrice = PRICE_CLOSE;
input double             RSI_LevelsUP    = 70;
input double             RSI_LevelsDN    = 30;
input string             Show_Parameters = "||========== Show Indicator Parameters ==========||";
extern bool              ReverseSignals  = false;
input int                BarsCount       = 10000;
//===================================================================================================================================================//
double TrendUp[];
double TrendDown[];
double TrendLine[];
double IndicatorLevel[];
double MALevel[];
//===================================================================================================================================================//
int OnInit(void)
  {
//-----------------------------------------------------------------------------------
   IndicatorShortName(WindowExpertName()+"("+DoubleToStr(RSI_Periods,0)+")");
   IndicatorDigits(Digits);
   IndicatorBuffers(5);
//---
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,TrendUp);
   SetIndexLabel(0,"RSI Trend Up");
//---
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,TrendDown);
   SetIndexLabel(1,"RSI Trend Down");
//---
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,TrendLine);
   SetIndexLabel(2,"RSI No Trend");
//---
   SetIndexBuffer(3,IndicatorLevel);
   SetIndexBuffer(4,MALevel);
//-----------------------------------------------------------------------------------
   return(INIT_SUCCEEDED);
//-----------------------------------------------------------------------------------
  }
//===================================================================================================================================================//
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
//-----------------------------------------------------------------------------------
   int i=0;
   int Limit=0;
   int CountedBars=BarsCount;
   if(CountedBars<0) return(-1);
   if(CountedBars>Bars-1) CountedBars=Bars-1;
   if(CountedBars<0) return(-1);
   if(CountedBars>0) CountedBars--;
   Limit=CountedBars;
//-----------------------------------------------------------------------------------
   for(i=Limit; i>=0; i--)
     {
      IndicatorLevel[i]=iRSI(NULL,0,RSI_Periods,RSI_ApliedPrice,i);
      MALevel[i]=iMA(NULL,0,MA_Periods,0,MA_Method,0,i);
      TrendLine[i]=NormalizeDouble(MALevel[i],Digits);
      TrendUp[i]=EMPTY_VALUE;
      TrendDown[i]=EMPTY_VALUE;
      //-----------------------------------------------------------------------------------
      //Normal signals
      if(ReverseSignals==false)
        {
         //-----------------------------------------------------------------------------------
         if(IndicatorLevel[i]>=RSI_LevelsUP)
           {
            TrendLine[i]=EMPTY_VALUE;
            TrendUp[i]=NormalizeDouble(MALevel[i],Digits);
           }
         //-----------------------------------------------------------------------------------
         if(IndicatorLevel[i]<=RSI_LevelsDN)
           {
            TrendLine[i]=EMPTY_VALUE;
            TrendDown[i]=NormalizeDouble(MALevel[i],Digits);
           }
         //-----------------------------------------------------------------------------------
         if((IndicatorLevel[i]>=RSI_LevelsUP) && (IndicatorLevel[i+1]<=RSI_LevelsUP))
           {
            TrendUp[i+1]=NormalizeDouble(MALevel[i+1],Digits);
           }
         //-----------------------------------------------------------------------------------
         if((IndicatorLevel[i]<=RSI_LevelsDN) && (IndicatorLevel[i+1]>=RSI_LevelsDN))
           {
            TrendDown[i+1]=NormalizeDouble(MALevel[i+1],Digits);
           }
        }
      //-----------------------------------------------------------------------------------
      //Reverse signals
      if(ReverseSignals==true)
        {
         //-----------------------------------------------------------------------------------
         if(IndicatorLevel[i]>=RSI_LevelsUP)
           {
            TrendLine[i]=EMPTY_VALUE;
            TrendDown[i]=NormalizeDouble(MALevel[i],Digits);
           }
         //-----------------------------------------------------------------------------------
         if(IndicatorLevel[i]<=RSI_LevelsDN)
           {
            TrendLine[i]=EMPTY_VALUE;
            TrendUp[i]=NormalizeDouble(MALevel[i],Digits);
           }
         //-----------------------------------------------------------------------------------
         if((IndicatorLevel[i]>=RSI_LevelsUP) && (IndicatorLevel[i+1]<=RSI_LevelsUP))
           {
            TrendDown[i+1]=NormalizeDouble(MALevel[i+1],Digits);
           }
         //-----------------------------------------------------------------------------------
         if((IndicatorLevel[i]<=RSI_LevelsDN) && (IndicatorLevel[i+1]>=RSI_LevelsDN))
           {
            TrendUp[i+1]=NormalizeDouble(MALevel[i+1],Digits);
           }
        }
      //-----------------------------------------------------------------------------------
      //Zero signals
      if((IndicatorLevel[i+1]>=RSI_LevelsUP) && (IndicatorLevel[i]<=RSI_LevelsUP))
        {
         TrendLine[i+1]=NormalizeDouble(MALevel[i+1],Digits);
        }
      //-----------------------------------------------------------------------------------
      if((IndicatorLevel[i+1]<=RSI_LevelsDN) && (IndicatorLevel[i]>=RSI_LevelsDN))
        {
         TrendLine[i+1]=NormalizeDouble(MALevel[i+1],Digits);
        }
      //-----------------------------------------------------------------------------------
     }
//-----------------------------------------------------------------------------------
   return(rates_total);
//-----------------------------------------------------------------------------------
  }
//===================================================================================================================================================//
