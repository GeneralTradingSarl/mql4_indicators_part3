//+------------------------------------------------------------------+
//|                                                  RoundLevels.mq4 |
//|                                        Version 2, "For Codebase" |
//|                                                   Author: Martes |
//|               http://championship.mql4.com/2007/ru/users/Martes/ |
//+------------------------------------------------------------------+
/*
   This code draws 4 horizontal lines with "00" at the end of
   the vertical coordinate (price). This 4 horizontal lines with
   this property are closest to current price.
*/

#property copyright "Martes"
#property link      "http://championship.mql4.com/2007/ru/users/Martes/"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Red
#property indicator_color2 MidnightBlue
#property indicator_color3 Orange
#property indicator_color4 MediumBlue

//Width of horizontal lines
extern int LineWidth=2;
//Do we need the previous value of the indicator?
extern bool KeepTraces;

//---- buffers
double Lower1[];
double Upper1[];
double Lower2[];
double Upper2[];
//---- names of horizontal lines
string Lower1Line="Lower1Line",
Upper1Line="Upper1Line",
Lower2Line="Lower2Line",
Upper2Line="Upper2Line";

bool objects_prepared=false;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool prepare_objects()
  {
   if(objects_prepared==true) return(false);
//closest lower "round" bound for price change
   Lower1[0]=MathFloor((Close[0]/Point)/100)*Point*100;
//closest upper "round" bound for price change
   Upper1[0]=MathCeil((Close[0]/Point)/100)*Point*100;
//next lower "round" bound (after Lower1) for price change
   Lower2[0]=Lower1[0]-100*Point;
//next upper "round" bound (after Upper1) for price change
   Upper2[0]=Upper1[0]+100*Point;
//---- create horizontal lines
   if(!ObjectCreate(Lower1Line,OBJ_HLINE,0,D'2004.02.20 12:30',Lower1[0]))
     {
      Print("error: can't create horizontal line! code #",GetLastError());
      return(0);
     }
   else
     {
      ObjectSet(Lower1Line,OBJPROP_COLOR,indicator_color1);
      ObjectSet(Lower1Line,OBJPROP_WIDTH,LineWidth);
     }
   if(!ObjectCreate(Upper1Line,OBJ_HLINE,0,D'2004.02.20 12:30',Upper1[0]))
     {
      Print("error: can't create horizontal line! code #",GetLastError());
      return(0);
     }
   else
     {
      ObjectSet(Upper1Line,OBJPROP_COLOR,indicator_color2);
      ObjectSet(Upper1Line,OBJPROP_WIDTH,LineWidth);
     }
   if(!ObjectCreate(Lower2Line,OBJ_HLINE,0,D'2004.02.20 12:30',Lower2[0]))
     {
      Print("error: can't create horizontal line! code #",GetLastError());
      return(0);
     }
   else
     {
      ObjectSet(Lower2Line,OBJPROP_COLOR,indicator_color3);
      ObjectSet(Lower2Line,OBJPROP_WIDTH,LineWidth);
     }
   if(!ObjectCreate(Upper2Line,OBJ_HLINE,0,D'2004.02.20 12:30',Upper2[0]))
     {
      Print("error: can't create horizontal line! code #",GetLastError());
      return(0);
     }
   else
     {
      ObjectSet(Upper2Line,OBJPROP_COLOR,indicator_color4);
      ObjectSet(Upper2Line,OBJPROP_WIDTH,LineWidth);
     }
//--- horizontal lines created

   objects_prepared=true;
   return(true);
  }
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,Lower1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,Upper1);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,Lower2);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,Upper2);
   objects_prepared=false;
//---- initial indicator values
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   if(ObjectFind(Lower1Line)==0)
      ObjectDelete(Lower1Line);
   if(ObjectFind(Upper1Line)==0)
      ObjectDelete(Upper1Line);
   if(ObjectFind(Lower2Line)==0)
      ObjectDelete(Lower2Line);
   if(ObjectFind(Upper2Line)==0)
      ObjectDelete(Upper2Line);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   if(!objects_prepared) prepare_objects();

   int    counted_bars=IndicatorCounted();
//----
//closest lower "round" bound for price change
   Lower1[0]=MathFloor((Close[0]/Point)/100)*Point*100;
//closest upper "round" bound for price change
   Upper1[0]=MathCeil((Close[0]/Point)/100)*Point*100;
//next lower "round" bound (after Lower1) for price change
   Lower2[0]=Lower1[0]-100*Point;
//next upper "round" bound (after Upper1) for price change
   Upper2[0]=Upper1[0]+100*Point;
//----
   if(ObjectFind(Lower1Line)==0)
      ObjectSet(Lower1Line,OBJPROP_PRICE1,Lower1[0]);
   if(ObjectFind(Upper1Line)==0)
      ObjectSet(Upper1Line,OBJPROP_PRICE1,Upper1[0]);
   if(ObjectFind(Lower2Line)==0)
      ObjectSet(Lower2Line,OBJPROP_PRICE1,Lower2[0]);
   if(ObjectFind(Upper2Line)==0)
      ObjectSet(Upper2Line,OBJPROP_PRICE1,Upper2[0]);
//----
   if(!KeepTraces)
     {
      Lower1[1]=EMPTY_VALUE;
      Upper1[1]=EMPTY_VALUE;
      Lower2[1]=EMPTY_VALUE;
      Upper2[1]=EMPTY_VALUE;
     }
   return(0);
  }
//+------------------------------------------------------------------+
