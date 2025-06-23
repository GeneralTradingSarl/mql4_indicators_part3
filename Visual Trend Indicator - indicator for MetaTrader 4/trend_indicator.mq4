//+------------------------------------------------------------------+
//|                                              Trend Indicator.mq4 |
//|                                                    Jan Opocensky |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Jan Opocensky"
#property link      ""
#property version   "141.121"
#property strict
#property indicator_chart_window

int TimeFrame;
input int MovingAveragePeriod          =  100;
input int TextSize                     =  10;
int HorizontalBorderSize               =  18*TextSize;
int VerticalBorderSize                 =  10*TextSize;
int UpperRightBorderHorizontal         =  2*TextSize;
input int UpperRightBorderVertical     =  120;
color UP_color                         =  clrGreen;
color DOWN_color                       =  clrRed;
color TrendBarColor;
int TrendBarSize                     =  (int)2.5*TextSize;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
  EventSetTimer(PERIOD_M5);
  TrendCreate ();

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
  
  //TrendCreate ();
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
  
  TrendCreate ();
   
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+


void TrendCreate ()
{


//ENUM_TIMEFRAMES

string TimeFrameHead[6];
TimeFrameHead[1] =  "H1";
TimeFrameHead[2] =  "H4";
TimeFrameHead[3] =  "D1";
TimeFrameHead[4] =  "W1";
TimeFrameHead[5] =  "MN1";

for (int n=1;n<6;n++)
{
int TimeFrameHead_X_position    =  (int)NormalizeDouble(UpperRightBorderHorizontal + (n-1)*(1.7*TrendBarSize),0);
int TimeFrameHead_Y_position    =  UpperRightBorderVertical + TextSize/2;
//+------------------------------------------------------------------+
   ObjectDelete(  "TimeFrameHead" + IntegerToString(n) );
   ObjectCreate(  "TimeFrameHead" + IntegerToString(n)   ,OBJ_LABEL,0,0,0,0,0); 
   ObjectSet(     "TimeFrameHead" + IntegerToString(n) ,OBJPROP_CORNER,CORNER_RIGHT_UPPER); 
   ObjectSet(     "TimeFrameHead" + IntegerToString(n) ,OBJPROP_ANCHOR,ANCHOR_UPPER); 
   ObjectSet(     "TimeFrameHead" + IntegerToString(n) ,OBJPROP_XDISTANCE,TimeFrameHead_X_position);
   ObjectSet(     "TimeFrameHead" + IntegerToString(n) ,OBJPROP_YDISTANCE,TimeFrameHead_Y_position);
   ObjectSetText( "TimeFrameHead" + IntegerToString(n) , TimeFrameHead[n] ,TextSize,"Arial",clrBlack);
//+------------------------------------------------------------------+ 

if (n==1) {TimeFrame=PERIOD_H1;}    // (TimeFrameHead[n]=="H1")
if (n==2) {TimeFrame=PERIOD_H4;}    // (TimeFrameHead[n]=="H4")
if (n==3) {TimeFrame=PERIOD_D1;}    // (TimeFrameHead[n]=="D1")
if (n==4) {TimeFrame=PERIOD_W1;}    // (TimeFrameHead[n]=="W1")
if (n==5) {TimeFrame=PERIOD_MN1;}  // (TimeFrameHead[n]=="MN1")

//+------------------------------------------------------------------+
if (iMA (NULL,TimeFrame,MovingAveragePeriod,0,MODE_EMA,PRICE_CLOSE,1) > iMA (NULL,TimeFrame,MovingAveragePeriod,0,MODE_EMA,PRICE_CLOSE,2)) // UpTrend
{TrendBarColor=UP_color;}
//+------------------------------------------------------------------+
if (iMA (NULL,TimeFrame,MovingAveragePeriod,0,MODE_EMA,PRICE_CLOSE,1) < iMA (NULL,TimeFrame,MovingAveragePeriod,0,MODE_EMA,PRICE_CLOSE,2)) // DownTrend
{TrendBarColor=DOWN_color;}
//+------------------------------------------------------------------+

//**********************************************************************************  
   ObjectDelete      (     "TimeFrameBar" + IntegerToString(n) );
   ObjectCreate      (     "TimeFrameBar" + IntegerToString(n) ,OBJ_RECTANGLE_LABEL,0,0,0,0,0);
   ObjectSet         (     "TimeFrameBar" + IntegerToString(n) ,OBJPROP_CORNER,CORNER_RIGHT_UPPER); //
   ObjectSet         (     "TimeFrameBar" + IntegerToString(n) ,OBJPROP_XDISTANCE,TimeFrameHead_X_position +  TrendBarSize/2);
   ObjectSet         (     "TimeFrameBar" + IntegerToString(n) ,OBJPROP_YDISTANCE,TimeFrameHead_Y_position + TrendBarSize);    
   ObjectSetInteger  (0,   "TimeFrameBar" + IntegerToString(n) ,OBJPROP_XSIZE,TrendBarSize );
   ObjectSetInteger  (0,   "TimeFrameBar" + IntegerToString(n) ,OBJPROP_YSIZE,TrendBarSize );
   ObjectSetInteger  (0,   "TimeFrameBar" + IntegerToString(n) ,OBJPROP_WIDTH,1);
   ObjectSetInteger  (0,   "TimeFrameBar" + IntegerToString(n) ,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger  (0,   "TimeFrameBar" + IntegerToString(n) ,OBJPROP_BACK,false);
   ObjectSetInteger  (0,   "TimeFrameBar" + IntegerToString(n) ,OBJPROP_COLOR,clrBlack);
   ObjectSetInteger  (0,   "TimeFrameBar" + IntegerToString(n) ,OBJPROP_BGCOLOR,TrendBarColor);
   ObjectSetInteger  (0,   "TimeFrameBar" + IntegerToString(n) ,OBJPROP_HIDDEN,false);
//**********************************************************************************

   ObjectDelete(  "TimeFramePeriod" );
   ObjectCreate(  "TimeFramePeriod"   ,OBJ_LABEL,0,0,0,0,0); 
   ObjectSet(     "TimeFramePeriod" ,OBJPROP_CORNER,CORNER_RIGHT_UPPER); 
   ObjectSet(     "TimeFramePeriod" ,OBJPROP_ANCHOR,ANCHOR_UPPER); 
   ObjectSet(     "TimeFramePeriod" ,OBJPROP_XDISTANCE,UpperRightBorderHorizontal + 3.5*TrendBarSize);
   ObjectSet(     "TimeFramePeriod" ,OBJPROP_YDISTANCE,TimeFrameHead_Y_position + 2.1*TrendBarSize);
   ObjectSetText( "TimeFramePeriod" , "Period = " + IntegerToString(MovingAveragePeriod) ,TextSize,"Arial",clrBlack);
//+------------------------------------------------------------------+ 




}






}