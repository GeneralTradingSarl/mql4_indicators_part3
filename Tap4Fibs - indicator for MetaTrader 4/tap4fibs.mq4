//+------------------------------------------------------------------+
//|                                                 Tap4Fibs.mq4.mq4 |
//|                                  Copyright 2018, TJD-ENTERPRISES |
//|                              https://www.forexprobabilities.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, TJD-ENTERPRISES"
#property link      "https://www.forexprobabilities.com/"
#property version   "1.00"
#property strict
#property indicator_chart_window

//--- input parameters
input string   inpName           = "Fib_01";       // Fibo Name
input int      inpDepth          = 4;              // ZigZag Depth
input int      inpDeviation      = 5;              // ZigZag Deviation
input int      inpBackStep       = 2;              // ZigZag BackStep
input int      inpLegsBack       = 6;              // ZigZag Swing - Tap Back Key or Forward Key
input int      inpLegShift       = 0;              // Shift swing offset of the Fibonacci indicator
input color    inpLineColor      = clrOlive;       // Line Color
input color    inpLevelsColor    = clrOlive;       // Levels Color
input bool     inpRay            = true;           // Ray
input double   inpLevel1         = -61.8;          // Level 1
input double   inpLevel2         = -27.2;          // Level 2
input double   inpLevel3         = 0.0;            // Level 3
input double   inpLevel4         = 38.2;           // Level 4
input double   inpLevel5         = 50.0;           // Level 5
input double   inpLevel6         = 61.8;           // Level 6
input double   inpLevel7         = 78.6;           // Level 7
input double   inpLevel8         = 100.0;          // Level 8
input double   inpLevel9         = 127.2;          // Level 9
input double   inpLevel10        = 161.8;          // Level 10
input int      BackKey           = 90;             // Back Key #:    90 = Z
input int      FwrdKey           = 88;             // Forward Key #: 88 = X
input bool     ShowATR           = true;           // Show ATR value.
input int      ATRtimeframe      = 1440;           // ATR Time Frame in minutes: 5,15,30,60,240,1440
input int      ATRperiod         = 14;             // ATR Period
input int      ATRshift          = 0;              // ATR Shift
       


//--- global variables
int      inpLeg = 0;
string   tempState;
int      prevLeg;
int      prevBars;
double   levels[10];     // Levels Array

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
// Set Levels Array
   levels[0] = inpLevel1;  levels[1] = inpLevel2;  levels[2] = inpLevel3;  levels[3] = inpLevel4;  levels[4] = inpLevel5;
   levels[5] = inpLevel6;  levels[6] = inpLevel7;  levels[7] = inpLevel8;  levels[8] = inpLevel9;  levels[9] = inpLevel10;
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

// To Delete Fibonacci
   ObjectDelete(0,inpName);

//---
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {   
  //-- Checking for key press
   if(id == CHARTEVENT_KEYDOWN)
   { 
      Print(lparam, ", is key pressed");
      if(lparam == BackKey && inpLeg <= inpLegsBack+1) 
      {
         inpLeg++;
         if(inpLeg > inpLegsBack) 
         {
            inpLeg = 0;  
            ObjectDelete(0,inpName);
         }
      }
      
      if(lparam == FwrdKey && inpLeg > -1) //inpLegsBack) 
      {
         inpLeg--;
         if(inpLeg == 0) ObjectDelete(0,inpName);
         if(inpLeg < 0) inpLeg = inpLegsBack;
      }  
      
      ObjectDelete(0,inpName);
      if(inpLeg != 0) ReDoTheFib();
   }  
   //-- Checking for dragged Fibo
   if(id == CHARTEVENT_OBJECT_DRAG)
   {
      datetime times2[2];
      double prices2[2];
      times2[1] = ObjectGet(inpName,OBJPROP_TIME1);
      times2[0] = ObjectGet(inpName,OBJPROP_TIME2);
      prices2[1] = ObjectGet(inpName,OBJPROP_PRICE1); 
      prices2[0] = ObjectGet(inpName,OBJPROP_PRICE2);  
      FiboMove(inpName,times2,prices2,inpLevelsColor);    // Move Fibonacci
      ChartRedraw();
       
   }     
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
  {   // Refresh chart
      if(inpLeg !=0 && (inpLeg != prevLeg || Bars != prevBars)) ReDoTheFib();
      prevLeg = inpLeg;
      prevBars = Bars;
     
      if(ShowATR) Comment("ATR(",ATRtimeframe,", ",ATRperiod,", ",ATRshift,") = ", DoubleToString(iATR(NULL,ATRtimeframe,ATRperiod,ATRshift)/(10*Point),1));
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ReDoTheFibs function                                                |
//+------------------------------------------------------------------+
void ReDoTheFib()
{
//---
   datetime times[2];
   double price[2];

// Get Times and Price ZigZag Values.
   if(!GetZZ(times,price)) Print("Failed to create ZigZag");

   if(ObjectFind(0,inpName)<0) FiboDraw(inpName,times,price,inpLineColor,inpLevelsColor);    // Create new Fibonacci
   else FiboMove(inpName,times,price,inpLevelsColor);                                        // Move current Fibonacci
   ChartRedraw();  
} 
//+------------------------------------------------------------------+
//| FiboMove function                                                |
//+------------------------------------------------------------------+
void FiboMove(string name,datetime &time[],double &price[],color clrLevels)
  {
// Move current Fibonacci
   ObjectMove(0,name,0,time[1],price[1]);    // Move first point of the fibo
   ObjectMove(0,name,1,time[0],price[0]);    // Move second point of the fibo
   FiboSetLevels(name,price,clrLevels);      // Set Levels of the fibo
   ChartRedraw();                            // Refresh chart
  }
//+------------------------------------------------------------------+ 
//| FiboDraw function                                                | 
//+------------------------------------------------------------------+ 
bool FiboDraw( const string      name,                   // object name 
              datetime          &time[],                // array time 
              double            &price[],               // array price 
              const color       clrFibo=clrRed,         // object color 
              const color       clrLevels=clrYellow)    // levels color 
  {

   long chart_ID=0;
   int sub_window=0;

   ResetLastError();

// Create Fibonacci Object
   if(!ObjectCreate(chart_ID,name,OBJ_FIBO,sub_window,time[1],price[1],time[0],price[0]))
     {
      Print(__FUNCTION__,
            ": failed to create \"Fibonacci Retracement\"! Error code = ",GetLastError());
      return(false);
     }
//--- set fibonacci object properties
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clrFibo);      // Set Fibo Color
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,STYLE_SOLID);  // Set Fibo Line Style
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,1);            // Set Fibo Line Width
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,false);         // Set Fibo To Front
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,true);   // Set Fibo Not Selectable
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,true);     // Set Fibo Not Selected
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,inpRay);   // Set Fibo Ray
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,false);       // Set Fibo Hidden in Object List
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,0);

// Set Fibonacci Levels
   FiboSetLevels(name,price,clrLevels);

//--- successful execution 
   return(true);
  }
//+------------------------------------------------------------------+ 
//| FiboSetLevels function                                           | 
//+------------------------------------------------------------------+ 
bool FiboSetLevels( const string      name,                   // object name 
                   double            &price[],               // array price 
                   const color       clrLevels=clrYellow)    // levels color 
  {

   long chart_ID=0;
   int sub_window=0;
   int N=ArraySize(levels);
   string str="";

   ResetLastError();

// Define number of levels
   ObjectSetInteger(chart_ID,name,OBJPROP_LEVELS,N);

// Set Levels Properties
   for(int i=0;i<N;i++)
      {
         ObjectSetDouble(chart_ID,name,OBJPROP_LEVELVALUE,i,levels[i]/100.0);    // Set Level Value
         ObjectSetInteger(chart_ID,name,OBJPROP_LEVELCOLOR,i,clrLevels);         // Set Level Color
         ObjectSetInteger(chart_ID,name,OBJPROP_LEVELSTYLE,i,STYLE_DOT);         // Set Level Line Style
         ObjectSetInteger(chart_ID,name,OBJPROP_LEVELWIDTH,i,1);                 // Set Level Line Width
      }
// Set Levels descriptions
   for(int i=0;i<N;i++)
      {
         str = DoubleToString(levels[i],1) + "% = ";                                            // Set % levels value
         str += DoubleToString(price[0]+(levels[i]/100.0)*(price[1]-price[0]),_Digits) + "  ";  // Set price level value
         ObjectSetString(chart_ID,name,OBJPROP_LEVELTEXT,i,str);                                // Set Description Text
      }
//--- successful execution 
   return(true);
  }
//+------------------------------------------------------------------+
//| GetZZ function                                                   |
//+------------------------------------------------------------------+
bool GetZZ(datetime &time[],double &price[])
  {
   bool ret= false;
   int leg = (int)MathMax(1,inpLeg+inpLegShift);
   int cnt = 0;
   int idx = 0;
   double zz=0.0;

   //-- Get the swings of the ZigZag
   for(int i=0; i<Bars-1; i++)
     {
      zz=iCustom(_Symbol,0,"ZigZag",inpDepth,inpDeviation,inpBackStep,0,i);
      if(zz<=0.0 || zz==EMPTY_VALUE || zz>1000000.0) continue;
      cnt++;
      if(cnt<leg) continue;
      time[idx]=Time[i];
      price[idx]=zz;
      idx++;
      if(idx>1) { ret=true; break; }
     }

   return ret;
  }
//+------------------------------------------------------------------+
