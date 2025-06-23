//+------------------------------------------------------------------+
//|                              Stochastic Chaikin's Volatility.mq4 |
//|                                                           Giaras |
//|                                    giampiero.raschetti@gmail.com |
//+------------------------------------------------------------------+
#property copyright "giaras"
#property link      "giampiero.raschetti@gmail.com"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue

#property indicator_level1 0
#property indicator_level2 80
#property indicator_level3 20
#property indicator_minimum 0
#property indicator_maximum 100

 
//---- input parameters
//extern int iPeriod=5;
extern int maPeriod=10;
extern int StocLength = 5;
extern int WMALength = 5;

//---- buffers
double chakin[];
double StocChakin[];
double Trigger[];
double Value3[];
double hl[];
double emahl[];

int buffers = 0;
int drawBegin = 0;


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   drawBegin = 4;
//---- indicators
   initBuffer(StocChakin, "Stochastic Chaikin", DRAW_LINE);
   initBuffer(Trigger, "Trigger", DRAW_LINE);
   initBuffer(hl);
   initBuffer(emahl);
   initBuffer(chakin);
   initBuffer(Value3);
   IndicatorBuffers(buffers);
   IndicatorShortName("Stochastic Chaikin Volatility[" + maPeriod + ", " + StocLength + ", " + WMALength + "]");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   if (Bars <= drawBegin) return (0);
   
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+StocLength;
   
//----
   for(int c = 0 ;c <= limit ;c++)
     hl[c]=High[c]-Low[c];

   //for(int e = 0 ;e <= limit ;e++) 
   //{
   //   emahl[e]= iMAOnArray(hl,0,maPeriod,0,MODE_EMA,e);
   //}
   
   //for(int i = 0 ;i <= limit-iPeriod ;i++)
   for(int i = 0 ;i <= limit ;i++)
   {      
      //chakin[i] = ( (emahl[i]-emahl[i+iPeriod])/emahl[i+iPeriod] )*100;
      //chakin[i] = ( (emahl[i]-emahl[i+iPeriod]) );
      chakin[i] = iMAOnArray(hl,0,maPeriod,0,MODE_EMA,i);
   }
 
   for (int s = limit; s >= 0; s--) {
        double _chakin = chakin[s];
        double hh = _chakin, ll = _chakin;
        for (i = 0; i < StocLength; i++) {
            double tmp = chakin[s + i];
            hh = MathMax(hh, tmp);
            ll = MathMin(ll, tmp);
        }
        double Value1 = _chakin - ll;
        double Value2 = hh - ll;
        Value3[s] = 0.0;
        if (Value2 != 0.0) {
            Value3[s] = Value1 / Value2;
        }        
    }
    for (s = limit - 1; s >= 0; s--) {
        //StocChakin[s] = 2.0 * (iMAOnArray(Value3, 0, WMALength, 0, MODE_LWMA, s) - 0.5);
        StocChakin[s] = 100 * iMAOnArray(Value3, 0, WMALength, 0, MODE_LWMA, s);
        Trigger[s] = StocChakin[s + 1];
    }   
   return(0);
}



void initBuffer(double array[], string label = "", int type = DRAW_NONE, int arrow = 0, int style = EMPTY, int width = EMPTY, color clr = CLR_NONE) {
    SetIndexBuffer(buffers, array);
    SetIndexLabel(buffers, label);
    SetIndexEmptyValue(buffers, EMPTY_VALUE);
    SetIndexDrawBegin(buffers, drawBegin);
    SetIndexShift(buffers, 0);
    SetIndexStyle(buffers, type, style, width);
    SetIndexArrow(buffers, arrow);
    buffers++;
}