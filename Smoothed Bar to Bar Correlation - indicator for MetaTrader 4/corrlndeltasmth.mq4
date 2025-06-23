//+------------------------------------------------------------------+
//|                                                   CorrlnSmth.mq4 |
//|                                         Copyright 2020, R Poster |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright   "2020, R Poster"
#property link        "http://www.mql4.com"
#property description "Smoothed Bar to Bar Correlation"
#property strict

//--- indicator settings
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1  DodgerBlue
//
//--- input parameters
input int SmthPeriod =  7;  // Smooth Period
input int CorrPeriod =  7;  // Corelation Period (>1)
//--- buffers
double ExtCorBuffer[];
double ExtDBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {
   string short_name;
//--- 1 additional buffer used for counting.
   IndicatorBuffers(2);
   IndicatorDigits(Digits);
//--- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtCorBuffer);
   SetIndexBuffer(1,ExtDBuffer);
//--- name for DataWindow and indicator subwindow label
   short_name="Corrl("+IntegerToString(CorrPeriod)+ ")"+", Smooth("+ IntegerToString(SmthPeriod)+ ")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//--- check for input parameter
   if(CorrPeriod<=0 || SmthPeriod <1)
     {
      Print("Wrong input parameter Corr Period= ",CorrPeriod," Smooth Period= ",SmthPeriod);
      return(INIT_FAILED);
     }
//---
   SetIndexDrawBegin(0,CorrPeriod+SmthPeriod+1);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Average True Range                                               |
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
   int i,limit,jj;
   double firstValue;
   double A1[],A2[];
//--- check for bars count and input parameter
   if(rates_total<=CorrPeriod || CorrPeriod<=0)
      return(0);
//--- counting from 0 to rates_total
   ArraySetAsSeries(ExtCorBuffer,false);
   ArraySetAsSeries(ExtDBuffer,false);
   ArraySetAsSeries(open,false);
   ArraySetAsSeries(high,false);
   ArraySetAsSeries(low,false);
   ArraySetAsSeries(close,false);
   ArrayResize(A1,CorrPeriod);
   ArrayResize(A2,CorrPeriod); //   correlation arrays (A2 offset by 1)
//--- preliminary calculations
   if(prev_calculated==0)
    {
     ExtDBuffer[0] = 0.;
     ExtCorBuffer[0] = 0.;
     firstValue = 0.;
  //--- filling out the array of values for each period
     for(i=SmthPeriod+CorrPeriod+1; i<rates_total-1; i++)
      {
       for (jj=0; jj<CorrPeriod;jj++)
        {
         A1[jj] = close[i-jj]-open[i-jj];
         A2[jj] = close[i-jj-1]-open[i-jj-1];
        }
       ExtDBuffer[i] = DataCorr(CorrPeriod,A1,A2);
      }
    //
     for(i=0; i<=CorrPeriod+SmthPeriod; i++)
      {
       ExtCorBuffer[i] = 0.;
      }
  //--- calculating the first value of the indicator
     firstValue = ExtDBuffer[SmthPeriod+CorrPeriod+1];
     ExtCorBuffer[SmthPeriod+CorrPeriod]=firstValue;
     limit=SmthPeriod+CorrPeriod+1;
    } // ---- prev calculated = 0 -------------------
   else
     limit=prev_calculated-1;
//--- the main loop of calculations
   for(i=limit; i<rates_total; i++)
    {
     for (jj=0; jj<CorrPeriod;jj++)
      {
       A1[jj] = close[i-jj]-open[i-jj];
       A2[jj] = close[i-jj-1]-open[i-jj-1];
      }
     ExtDBuffer[i] = DataCorr(CorrPeriod,A1,A2);
     ExtCorBuffer[i]=((SmthPeriod-1)*ExtCorBuffer[i-1]+ ExtDBuffer[i])/SmthPeriod;
    }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
  double DataCorr( int NSize, double &A[], double &B[] )
//+------------------------------------------------------------------+
//|   Compute Correlation of two arrays                              |
//|   Return Corr Value (-1 to +1)                                   |
//+------------------------------------------------------------------+
   {
    double SCorr, AMean, BMean, AVar, BVar, ABCov;
    int jj;
    SCorr = 0.;
    AMean = 0.;
    BMean = 0.;
    AVar =  0.;
    BVar =  0.;
    ABCov = 0.;
    SCorr = 0.;
    if( NSize < 2) return(SCorr);
// Compue mean of each array   
    for (jj= 0; jj< NSize; jj++ )
     {
      AMean += A[jj];
      BMean += B[jj];    
     }
     AMean = AMean/NSize;
     BMean = BMean/NSize;
// Compute variance of each array
     for (jj= 0; jj< NSize; jj++ )
      {
       AVar += (A[jj]-AMean)*(A[jj]-AMean);
       BVar += (B[jj]-BMean)*(B[jj]-BMean);
      }   
      AVar = AVar/(NSize-1); 
      BVar = BVar/(NSize-1); 
// Comoputae Covariance
      for (jj= 0; jj< NSize; jj++ )
      {
       ABCov += (A[jj]-AMean)*(B[jj]-BMean); 
      }
      ABCov = ABCov/(NSize-1);  
// Compute Correlation
     if( AVar>0. && BVar>0.) SCorr = ABCov/(MathSqrt(AVar*BVar));      
    return (SCorr);
   }   

//------------------------------------------------------------------------ 