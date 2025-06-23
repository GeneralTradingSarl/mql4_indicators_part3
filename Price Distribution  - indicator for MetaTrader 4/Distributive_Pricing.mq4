
#property copyright "Copyright © 2009, Kevin Kurka"
#property link      "http://www.kurkafund.com; kurkafund@yahoo.com"

extern int Hours = 4;
extern int Munites = 0;

#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
  ObjectsDeleteAll();
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
   int    counted_bars=IndicatorCounted();
//----
   GetBars();
//----
   return(0);
  }


void GetBars(){

int BarsToCheck = Hours * 60 + Munites;
double HighPoint = High[iHighest(Symbol(),1,MODE_HIGH,BarsToCheck,0)];ObjectCreate("HighWaterMark",OBJ_HLINE,0,TimeCurrent(),HighPoint);
double LowPoint  = Low[iLowest(Symbol(),1,MODE_LOW,BarsToCheck,0)];ObjectCreate("LowWaterMark",OBJ_HLINE,0,TimeCurrent(),LowPoint);

int Range = (HighPoint - LowPoint)/Point;

Comment (Range);

int a,b;
int Occourances;
int PriceDistribution[999];

for( a=0 ; a < Range+1 ; a++ ){
   
   for( b=0 ; b < BarsToCheck+1 ; b++ ){
      if((LowPoint + a * Point) <= iHigh(Symbol(),1,b)  &&  (LowPoint + a * Point >= iLow(Symbol(),1,b))){
         Occourances ++;
         }
      }
      PriceDistribution[a] = Occourances;
      Print(LowPoint + a * Point," Occourances ",PriceDistribution[a]);
      ObjectCreate(DoubleToStr(LowPoint + a * Point,Digits),OBJ_TEXT,0,iTime(Symbol(),1,Occourances),(LowPoint + a * Point));
      ObjectSetText(DoubleToStr(LowPoint + a * Point,Digits),DoubleToStr(Occourances,0),12,"Times New Roman",Blue);   
      Occourances =0;
}

    

   
}
   
   


