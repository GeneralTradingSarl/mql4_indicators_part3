//+------------------------------------------------------------------+
//|                                             Hurst Difference.mq4 |
//|                                              Jean-Philippe Poton |
//|                              http://fractalfinance.blogspot.com/ |
//+------------------------------------------------------------------+
#property copyright "Jean-Philippe Poton"
#property link      "http://fractalfinance.blogspot.com/"

#property indicator_separate_window
#property indicator_levelcolor LimeGreen
#property indicator_levelwidth 1
#property indicator_levelstyle STYLE_DASH
#property indicator_buffers 2
#property indicator_color1 Yellow

//************************************************************
// Input parameters
//************************************************************
extern int    f_period    =30;
extern int    type_data   =PRICE_CLOSE;
//************************************************************
// Constant
//************************************************************
string INDICATOR_NAME="Hurst_Difference";
string FILENAME      ="Hurst_Difference.mq4";
double LOG_2;
//************************************************************
// Private vars
//************************************************************
//----input buffer
double InputBuffer[];
//----output buffers
double Hurst_Diff[];
//----
int    g_period_minus_1;
int    zero_line=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   // Check e_period input parameter
   if(f_period < 2 )
     {
      Alert( "[ 10-ERROR  " + FILENAME + " ] input parameter \"f_period\" must be >= 1 (" + f_period + ")" );
      return( -1 );
     }
   if(type_data < PRICE_CLOSE || type_data > PRICE_WEIGHTED )
     {
      Alert( "[ 20-ERROR  " + FILENAME + " ] input parameter \"type_data\" unknown (" + type_data + ")" );
      return( -1 );
     }
//---- drawing settings
   IndicatorBuffers( 1 );
   SetIndexBuffer( 0, Hurst_Diff );
   SetIndexStyle( 0, DRAW_LINE, STYLE_SOLID, 2 );
   SetLevelValue( 0, zero_line ); 
   g_period_minus_1=f_period - 1;
   LOG_2=MathLog( 2.0 );
//----
   return( 0 );
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+MathMax(f_period,g_period_minus_1);

   _computeLastNbBars(limit);
//----
   return( 0 );
  }
//+================================================================================================================+
//+=== FUNCTION : _computeLastNbBars                                                                            ===+
//+===                                                                                                          ===+
//+===                                                                                                          ===+
//+=== This callback is fired by metatrader for each tick                                                       ===+
//+===                                                                                                          ===+
//+=== In :                                                                                                     ===+
//+===    - lastBars : these "n" last bars must be repainted                                                    ===+
//+===                                                                                                          ===+
//+================================================================================================================+
double TmpArray[];
//+------------------------------------------------------------------+
//| FUNCTION : _computeLastNbBars                                    |
//| This callback is fired by metatrader for each tick               |
//| In : - lastBars : these "n" last bars must be repainted          | 
//+------------------------------------------------------------------+
void _computeLastNbBars( int lastBars )
  {
   int pos;
   switch( type_data )
     {   
      case PRICE_CLOSE    : ArrayCopy(TmpArray,Close,0,0,WHOLE_ARRAY); Hurst_Diff( lastBars, TmpArray ); break;
      case PRICE_OPEN     : ArrayCopy(TmpArray,Open,0,0,WHOLE_ARRAY); Hurst_Diff( lastBars, TmpArray ); break;
      case PRICE_HIGH     : ArrayCopy(TmpArray,High,0,0,WHOLE_ARRAY); Hurst_Diff( lastBars, TmpArray ); break;
      case PRICE_LOW      : ArrayCopy(TmpArray,Low,0,0,WHOLE_ARRAY); Hurst_Diff( lastBars, TmpArray ); break; 
      case PRICE_MEDIAN   :
         for( pos=lastBars; pos>=0; pos--)InputBuffer[pos]=(High[pos]+Low[pos])/2.0; Hurst_Diff( lastBars, InputBuffer );
         break;
      case PRICE_TYPICAL  :
         for( pos=lastBars; pos>=0; pos--)InputBuffer[pos]=(High[pos]+Low[pos]+Close[pos])/3.0; Hurst_Diff( lastBars, InputBuffer );
         break;
      case PRICE_WEIGHTED :
         for( pos=lastBars; pos>=0; pos--)InputBuffer[pos]=(High[pos]+Low[pos]+Close[pos]+Close[pos])/4.0; Hurst_Diff( lastBars, InputBuffer );
         break;
      default :
         Alert( "[ 20-ERROR  " + FILENAME + " ] the imput parameter type_data <" + type_data + "> is unknown" );
     }
  }
//+------------------------------------------------------------------+
//| FUNCTION : Hurst_Difference                                      |
//| Compute the differenciation of the Hurst exponent                |
//| In :                                                             |
//|    - lastBars : these "n" last bars are considered for           |
//|      calculating the fractal dimension and the Hurst Exponent    |
//|    - inputData : data array on which the computation is applied  | 
//| For further theoretical explanations, see my blog:               |  
//|    http://fractalfinance.blogspot.com/                           |
//+------------------------------------------------------------------+
void Hurst_Diff( int lastBars, double &inputData[] )
   {
   int    pos, iteration;
   double diff, priorDiff;
   double length;
   double priceMax, priceMin;
   double fdi[];
   
   ArrayResize(fdi,lastBars+2);
//----
   for( pos=lastBars; pos>=0; pos-- )
     {
      priceMax=_highest( f_period, pos, inputData );
      priceMin=_lowest( f_period, pos, inputData );
      length   =0.0;
      priorDiff=0.0;
//----
      for( iteration=0; iteration <= g_period_minus_1; iteration++ )
        {
         if(( priceMax - priceMin)> 0.0 )
           {
            diff =(inputData[pos + iteration] - priceMin )/( priceMax - priceMin );
            if(iteration > 0 )
              {
               length+=MathSqrt( MathPow( diff - priorDiff, 2.0)+(1.0/MathPow( f_period, 2.0)) );
              }
            priorDiff=diff;
           }
        }
      if(length > 0.0 )
        {
         fdi[pos]=1.0 +(MathLog( length)+ LOG_2 )/MathLog( 2 * g_period_minus_1 );
        }
      else
        {
         fdi[pos]=0.0;
        }
     Hurst_Diff[pos]=fdi[pos+1]-fdi[pos];
     } 
   }
//+------------------------------------------------------------------+
//| FUNCTION : _highest                                              |
//| Search for the highest value in an array data                    |
//| In :                                                             |
//|    - n : find the highest on these n data                        |
//|    - pos : begin to search for from this index                   |
//|    - inputData : data array on which the searching for is done   |
//|                                                                  |
//| Return : the highest value                                       |            
//+------------------------------------------------------------------+
double _highest( int n, int pos, double &inputData[] )
  {
   int length=pos + n;
   double highest=0.0;
//----
   for( int i=pos; i < length; i++ )
     {
      if(inputData[i] > highest)highest=inputData[i];
     }
   return( highest );
  }
//+------------------------------------------------------------------+
//| FUNCTION : _lowest                                               |                                                                                                          ===+
//| Search for the lowest value in an array data                     |
//| In :                                                             |
//|    - n : find the hihest on these n data                         |
//|    - pos : begin to search for from this index                   |
//|    - inputData : data array on which the searching for is done   |
//|                                                                  |
//| Return : the highest value                                       |
//+------------------------------------------------------------------+
double _lowest( int n, int pos, double &inputData[] )
  {
   int length=pos + n;
   double lowest=9999999999.0;
//----
   for( int i=pos; i < length; i++ )
     {
      if(inputData[i] < lowest)lowest=inputData[i];
     }
   return( lowest );
  }
//+------------------------------------------------------------------+        