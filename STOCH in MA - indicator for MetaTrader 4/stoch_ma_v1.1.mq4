//===================================================================================================================================================//
#property copyright   "Copyright 2016-2017, Nikolaos Pantzos"
#property link        "https://www.mql5.com/en/users/pannik"
#property version     "1.1"
#property description "STOCH in MA"
#property strict
//===================================================================================================================================================//
#property indicator_chart_window
#property indicator_buffers 5
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
#property indicator_width4 2
#property indicator_width5 2
#property indicator_color1 clrDodgerBlue
#property indicator_color2 clrAquamarine
#property indicator_color3 clrRed
#property indicator_color4 clrOrange
#property indicator_color5 clrLimeGreen
//===================================================================================================================================================//
enum Price{Low_High,Close_Close};
//===================================================================================================================================================//
input string         MA_Parameters    = "||========== MA Parameters ==========||";
input int            MA_Periods       = 14;
input ENUM_MA_METHOD MA_Method        = MODE_SMA;
input string         STOCH_Parameters = "||========== STOCH Parameters ==========||";
input int            K_Period         = 12;
input int            D_Period         = 5;
input int            Slowing          = 3;
input ENUM_MA_METHOD STOCH_MA_Method  = MODE_SMA;
input Price          PriceField       = Low_High;
extern double        STOCH_LevelUp    = 80.0;
extern double        STOCH_LevelDn    = 20.0;
input string         Show_Parameters  = "||========== Show Indicator Parameters ==========||";
extern bool          ReverseSignals   = false;
input int            BarsCount        = 10000;
//===================================================================================================================================================//
double TrendUp1[];
double TrendUp2[];
double TrendDown1[];
double TrendDown2[];
double Trendneutral[];
double MALevel[];
double STOCH_Main[];
double STOCH_Signal[];
//===================================================================================================================================================//
int OnInit(void)
  {
//-----------------------------------------------------------------------------------
   IndicatorShortName(WindowExpertName()+"("+DoubleToStr(K_Period,0)+","+DoubleToStr(D_Period,0)+","+DoubleToStr(Slowing,0)+")");
   IndicatorDigits(Digits);
   IndicatorBuffers(8);
//---
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,TrendUp1);
   SetIndexLabel(0,"STOCH Trend Up 1");
//---
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,TrendUp2);
   SetIndexLabel(1,"STOCH Trend Up 2");
//---
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,TrendDown1);
   SetIndexLabel(2,"STOCH Trend Down 1");
//---
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,TrendDown2);
   SetIndexLabel(3,"STOCH Trend Down 2");
//---
   SetIndexStyle(4,DRAW_LINE);
   SetIndexBuffer(4,Trendneutral);
   SetIndexLabel(4,"STOCH Trend Neutral");
//---
   SetIndexBuffer(5,STOCH_Main);
   SetIndexBuffer(6,STOCH_Signal);
   SetIndexBuffer(7,MALevel);
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
   int CountedBars=0;
//-----------------------------------------------------------------------------------
   CountedBars=BarsCount;
   if(CountedBars<0) return(-1);
   if(CountedBars>Bars-1) CountedBars=Bars-1;
   if(CountedBars<0) return(-1);
   if(CountedBars>0) CountedBars--;
   Limit=CountedBars;
//-----------------------------------------------------------------------------------
   for(i=Limit; i>=0; i--)
     {
      STOCH_Main[i]=iStochastic(NULL,0,K_Period,D_Period,Slowing,STOCH_MA_Method,(int)PriceField,MODE_MAIN,i);
      STOCH_Signal[i]=iStochastic(NULL,0,K_Period,D_Period,Slowing,STOCH_MA_Method,(int)PriceField,MODE_SIGNAL,i);
      MALevel[i]=iMA(NULL,0,MA_Periods,0,MA_Method,0,i);
      //-----------------------------------------------------------------------------------
      TrendUp1[i]=EMPTY_VALUE;
      TrendUp2[i]=EMPTY_VALUE;
      TrendDown1[i]=EMPTY_VALUE;
      TrendDown2[i]=EMPTY_VALUE;
      Trendneutral[i]=EMPTY_VALUE;
      //-----------------------------------------------------------------------------------
      //Normal signals
      if(ReverseSignals==false)
        {
         if((STOCH_Main[i]>STOCH_LevelUp)&&(STOCH_Main[i]>STOCH_Signal[i])) TrendUp1[i]=NormalizeDouble(MALevel[i],Digits);
         if((STOCH_Main[i]>STOCH_LevelUp)&&(STOCH_Main[i]<STOCH_Signal[i])) TrendUp2[i]=NormalizeDouble(MALevel[i],Digits);
         //-----------------------------------------------------------------------------------
         if((STOCH_Main[i]<STOCH_LevelDn)&&(STOCH_Main[i]<STOCH_Signal[i])) TrendDown1[i]=NormalizeDouble(MALevel[i],Digits);
         if((STOCH_Main[i]<STOCH_LevelDn)&&(STOCH_Main[i]>STOCH_Signal[i])) TrendDown2[i]=NormalizeDouble(MALevel[i],Digits);
         //-----------------------------------------------------------------------------------
         if((STOCH_Main[i]>STOCH_LevelUp) && (STOCH_Main[i+1]<STOCH_LevelUp)) TrendUp1[i+1]=NormalizeDouble(MALevel[i+1],Digits);
         //-----------------------------------------------------------------------------------
         if((STOCH_Main[i]<STOCH_LevelDn) && (STOCH_Main[i+1]>STOCH_LevelDn)) TrendDown1[i+1]=NormalizeDouble(MALevel[i+1],Digits);
         //-----------------------------------------------------------------------------------
         if((STOCH_Main[i]>STOCH_LevelUp)&&(STOCH_Main[i]<STOCH_Signal[i])&&(STOCH_Main[i+1]>STOCH_Signal[i+1])) TrendUp1[i]=NormalizeDouble(MALevel[i],Digits);
         if((STOCH_Main[i]>STOCH_LevelUp)&&(STOCH_Main[i]>STOCH_Signal[i])&&(STOCH_Main[i+1]<STOCH_Signal[i+1])) TrendUp2[i]=NormalizeDouble(MALevel[i],Digits);
         //-----------------------------------------------------------------------------------
         if((STOCH_Main[i]<STOCH_LevelDn)&&(STOCH_Main[i]>STOCH_Signal[i])&&(STOCH_Main[i+1]<STOCH_Signal[i+1])) TrendDown1[i]=NormalizeDouble(MALevel[i],Digits);
         if((STOCH_Main[i]<STOCH_LevelDn)&&(STOCH_Main[i]<STOCH_Signal[i])&&(STOCH_Main[i+1]>STOCH_Signal[i+1])) TrendDown2[i]=NormalizeDouble(MALevel[i],Digits);
        }
      //-----------------------------------------------------------------------------------
      //Reverse signals
      if(ReverseSignals==true)
        {
         if((STOCH_Main[i]>STOCH_LevelUp)&&(STOCH_Main[i]>STOCH_Signal[i])) TrendDown1[i]=NormalizeDouble(MALevel[i],Digits);
         if((STOCH_Main[i]>STOCH_LevelUp)&&(STOCH_Main[i]<STOCH_Signal[i])) TrendDown2[i]=NormalizeDouble(MALevel[i],Digits);
         //-----------------------------------------------------------------------------------
         if((STOCH_Main[i]<STOCH_LevelDn)&&(STOCH_Main[i]<STOCH_Signal[i])) TrendUp1[i]=NormalizeDouble(MALevel[i],Digits);
         if((STOCH_Main[i]<STOCH_LevelDn)&&(STOCH_Main[i]>STOCH_Signal[i])) TrendUp2[i]=NormalizeDouble(MALevel[i],Digits);
         //-----------------------------------------------------------------------------------
         if((STOCH_Main[i]>STOCH_LevelUp) && (STOCH_Main[i+1]<STOCH_LevelUp)) TrendDown1[i+1]=NormalizeDouble(MALevel[i+1],Digits);
         //-----------------------------------------------------------------------------------
         if((STOCH_Main[i]<STOCH_LevelDn) && (STOCH_Main[i+1]>STOCH_LevelDn)) TrendUp1[i+1]=NormalizeDouble(MALevel[i+1],Digits);
         //-----------------------------------------------------------------------------------
         if((STOCH_Main[i]>STOCH_LevelUp)&&(STOCH_Main[i]<STOCH_Signal[i])&&(STOCH_Main[i+1]>STOCH_Signal[i+1])) TrendDown1[i]=NormalizeDouble(MALevel[i],Digits);
         if((STOCH_Main[i]>STOCH_LevelUp)&&(STOCH_Main[i]>STOCH_Signal[i])&&(STOCH_Main[i+1]<STOCH_Signal[i+1])) TrendDown2[i]=NormalizeDouble(MALevel[i],Digits);
         //-----------------------------------------------------------------------------------
         if((STOCH_Main[i]<STOCH_LevelDn)&&(STOCH_Main[i]>STOCH_Signal[i])&&(STOCH_Main[i+1]<STOCH_Signal[i+1])) TrendUp1[i]=NormalizeDouble(MALevel[i],Digits);
         if((STOCH_Main[i]<STOCH_LevelDn)&&(STOCH_Main[i]<STOCH_Signal[i])&&(STOCH_Main[i+1]>STOCH_Signal[i+1])) TrendUp2[i]=NormalizeDouble(MALevel[i],Digits);
        }
      //-----------------------------------------------------------------------------------
      //Zero signals
      if((STOCH_Main[i]<STOCH_LevelUp) && (STOCH_Main[i]>STOCH_LevelDn)) Trendneutral[i]=NormalizeDouble(MALevel[i],Digits);
      if((STOCH_Main[i]<STOCH_LevelUp)&&(STOCH_Main[i+1]>STOCH_LevelUp)) Trendneutral[i+1]=NormalizeDouble(MALevel[i+1],Digits);
      if((STOCH_Main[i]>STOCH_LevelDn)&&(STOCH_Main[i+1]<STOCH_LevelDn)) Trendneutral[i+1]=NormalizeDouble(MALevel[i+1],Digits);
      //-----------------------------------------------------------------------------------
     }
//-----------------------------------------------------------------------------------
   return(rates_total);
//-----------------------------------------------------------------------------------
  }
//===================================================================================================================================================//
