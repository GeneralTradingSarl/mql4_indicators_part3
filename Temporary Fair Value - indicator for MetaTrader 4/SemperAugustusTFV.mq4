//+------------------------------------------------------------------+
//|                                            SemperAugustusTFV.mq4 |
//|                                                  Semper Augustus |
//|                                             http://forexninja.nl |
//+------------------------------------------------------------------+
#property copyright "Semper Augustus"
#property link      "http://forexninja.nl"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 White

extern int Exponential = 2;
extern int WingDing = 108;

//--- buffers
double tfv[];

bool start = true;
int askTiks;
int bidTiks;
double askCum;
double bidCum;
double dezeBar;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{

   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,WingDing);
   SetIndexBuffer(0,tfv);
   SetIndexEmptyValue(0,0.0);

   dezeBar = Bars;
   askTiks = 0;
   bidTiks = 0;
   askCum = 0;
   bidCum = 0;   

   return(0);
}

int deinit()
{


   return(0);
}


int start()
{
   int counted_bars=IndicatorCounted();
   
   if( start )
   {
      // ouwe koeien
      for( int i = 0; i <= Bars; i++ )
      {
         tfv[i] = OuweKoeien(i);
      }
      askCum = Bid;
      askTiks = 1;
      start = false;
      return(0);
   }
   
   if( dezeBar == Bars )
   {
      // huidige bar
      askCum = ( ( askCum * askTiks ) + ( Bid * Exponential ) ) / ( Exponential + askTiks );
      askTiks++;
      tfv[0] = askCum;
   }
   else
   {  
      askTiks = 1;
      dezeBar = Bars;
   }
   return(0);
}

double OuweKoeien(int index)
{
   if( Period() == PERIOD_M1 )
      return( ( iHigh(NULL, 0, index) + iLow(NULL, 0, index) ) / 2.0 );
   else
   {
      datetime begin = iTime(NULL, 0, index);
      datetime eind = iTime(NULL, 0, index-1);
      
      int beginindex = iBarShift(NULL, PERIOD_M1, begin, false);
      int eindindex = iBarShift(NULL, PERIOD_M1, eind, false);
      
      double waarde = 0;
      int teller = 1; 
      for(int i = eindindex+1; i<= beginindex; i++ )
      {
         waarde = ( (waarde * teller) + ( (( iHigh(NULL, PERIOD_M1, i) + iLow(NULL, PERIOD_M1, i) ) / 2) * Exponential ) ) / ( teller + Exponential );
      }
      return( waarde );
   }
}