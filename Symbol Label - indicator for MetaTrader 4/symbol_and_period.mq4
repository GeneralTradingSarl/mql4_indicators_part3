//+------------------------------------------------------------------+
//|                                                       Symbol.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, File45."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property description "Draws label of chart symbol and period"
#property strict
#property indicator_chart_window

input color  Text_Color=LightGray; // Text Color
input int    Text_Size=40; // Text Size
input string Text_Font="Verdana"; // Text Type
input int    Corner_=0; // Corner
input int    Left_Right=240; // Left - Right
input int    Up_Down=1; // Up - Dowm

string periodx;
string TF;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {

   int Minx=Period();
   string Miny = "M";
   string Minz = IntegerToString(Period());

   if(Period()<60)
     {
      TF=StringConcatenate(Miny,Minz);
     }
   else if(Period()==60)
     {
      TF="H1";
     }
   else if(Period()==240)
     {
      TF="H4";
     }
   else if(Period()==1440)
     {
      TF="D1";
     }
   else if(Period()==10080)
     {
      TF="W1";
     }
   else
     {
      TF="MN";
     }

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectDelete("SymbolName");

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

   ObjectCreate("SymbolName",OBJ_LABEL,0,0,0);
   ObjectSetText("SymbolName",Symbol()+" "+TF,Text_Size,Text_Font,Text_Color);
   ObjectSet("SymbolName",OBJPROP_CORNER,Corner_);
   ObjectSet("SymbolName",OBJPROP_XDISTANCE,Left_Right);
   ObjectSet("SymbolName",OBJPROP_YDISTANCE,Up_Down);

   return(rates_total);
  }
//+------------------------------------------------------------------+
