//+------------------------------------------------------------------+
//|                                                  Daniel Frieling |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Daniel Frieling"
#property link      "http://meinMetatrader.de"

#property indicator_separate_window
#property indicator_buffers 3

#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_color3 White
#property indicator_width1 4
#property indicator_width2 4
#property indicator_width3 4

#property indicator_levelcolor White
#property indicator_level1 9
#property indicator_level2 -9
#property indicator_levelwidth 1

/*#property indicator_maximum 30
#property indicator_minimum -1*/

extern string HaIndicatorName = "Heiken_Ashi";

double GreenHAs[], RedHAs[];
bool StopNow = false;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   IndicatorBuffers(2);
  //---- 2 allocated indicator buffers
   SetIndexBuffer(0, GreenHAs);
   SetIndexBuffer(1, RedHAs);
  //---- drawing parameters setting
   SetIndexStyle(0, DRAW_HISTOGRAM);
   SetIndexStyle(1, DRAW_HISTOGRAM);
   /*SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE);*/
  //---- 0 value will not be displayed
   SetIndexEmptyValue(0, 0.0);
   SetIndexEmptyValue(1, 0.0);
  //---- displaying in DataWindow
   SetIndexLabel(0, "Green HeikenAshi Candles");
   SetIndexLabel(1, "Red HeikenAshi Candles");
   
   double haOpen = iCustom(Symbol(), Period(), HaIndicatorName, 2, 0);
   
   if(haOpen <= 0)
   {
      Alert("Please install the Heiken Ashi Indicator and set the fileName in inputs.");
      StopNow = true;
   }
   else
      StopNow = false;
    
//---- initialization done
   return(0);
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
   if(!IsNewBar() || StopNow)
      return;

   int limit;
   int counted_bars = IndicatorCounted();
   
 //check for possible errors
   if(counted_bars<0)
      return(-1);
   
 //the last counted bar will be recounted
   if(counted_bars>0)
      counted_bars--;
   
   limit = Bars - counted_bars;
   
  //---- main loop
   //for(int i=0; i < limit; i++)
   for(int i = limit-1; i >= 0; i--)
   //for(int i = 4; i >= 0; i--)
   {
      int prevDir = GetBarsHaDirForShift(i+1, Period());
      
      if(prevDir == OP_BUY)
      {
         GreenHAs[i] = GreenHAs[i+1]+1;
         
         RedHAs[i] = 0;
      }
      else if(prevDir == OP_SELL)
      {
         RedHAs[i] = RedHAs[i+1]-1;
         GreenHAs[i] = 0;
      }
   }
   
   return(0);
}

bool IsNewBar()
{
   static datetime lastBar = 0;
   datetime curBar = Time[0];
   
   if(lastBar != curBar)
   {
      lastBar = curBar;
      
      return(true);
   }
   else
   {
      return(false);
   }
}  

int GetBarsHaDirForShift(int shift, int period)
{
   if(period == -1)
      period = Period();
      
   int dir = -1;
   
   double haOpen = iCustom(Symbol(), period, HaIndicatorName, 2, shift);
   double haClose = iCustom(Symbol(), period, HaIndicatorName, 3, shift);
   
   if(haOpen < haClose)
      dir = OP_BUY;
   else if(haOpen > haClose)
      dir = OP_SELL;
      
   return(dir);
}

//+------------------------------------------------------------------+