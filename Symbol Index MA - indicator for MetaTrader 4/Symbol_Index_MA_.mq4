//+------------------------------------------------------------------+
//|                                             Symbol_Index_MA_.mq4 |
//|                              Copyright © 2006, Eng. Waddah Attar |
//|                                          waddahattar@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Advanced by Waddah Attar"
#property link      "waddahattar@hotmail.com"
//----
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 DarkOrange
#property indicator_color2 Red
#property indicator_color3 Blue
//----
extern string Use_This_Only = "USD,EUR,GBP,CHF,JPY,AUD,CAD";
extern string _____________ = "___________________________";
extern string MySymbol = "USD";
extern bool ShowMA = true;
extern int MA1_Period = 13;
extern int MA1_Mode = 0;
extern int MA2_Period = 5;
extern int MA2_Mode = 0;
//----
double Idx1[];
double Idx2[];
double Idx3[];
double v1[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorShortName("WA " + MySymbol + " Index (" + MA1_Period + ", " + 
                      MA2_Period + ")");
   SetIndexLabel(1, "WASymbol(" + MA1_Period + ")");
   SetIndexLabel(2, "WASymbol(" + MA2_Period + ")");      
//----
   SetIndexStyle(0, DRAW_LINE, 0, 1);
   SetIndexBuffer(0, Idx1);
//----
   SetIndexStyle(1, DRAW_LINE, 0, 2);
   SetIndexBuffer(1, Idx2);
//----
   SetIndexStyle(2, DRAW_LINE, 0, 1);
   SetIndexBuffer(2, Idx3);
//----
   ObjectsDeleteAll(1, OBJ_HLINE);
   ObjectsDeleteAll(2, OBJ_HLINE);
//----
   Print("USDCAD Bars = " , iBars("USDCAD", 0), " GBPUSD Bars = ", iBars("GBPUSD", 0), 
                                " AUDUSD Bars = " , iBars("AUDUSD", 0));
   Print("EURUSD Bars = " , iBars("EURUSD", 0), " USDCHF Bars = ", iBars("USDCHF", 0), 
                                " USDJPY Bars = " , iBars("USDJPY",0));
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void start()
  {
   int MinBars = iBars("EURUSD", 0);
   if(MinBars >= iBars("USDCHF", 0)) 
       MinBars = iBars("USDCHF", 0);
   if(MinBars >= iBars("USDJPY", 0)) 
       MinBars=iBars("USDJPY", 0);
   if(MinBars >= iBars("USDCAD", 0)) 
       MinBars=iBars("USDCAD", 0);
   if(MinBars >= iBars("GBPUSD", 0)) 
       MinBars=iBars("GBPUSD", 0);
   if(MinBars >= iBars("AUDUSD", 0))
       MinBars=iBars("AUDUSD", 0);
   ArrayResize (v1,MinBars); 
   double C_USD;
   for(int i = 0; i < MinBars; i++)
     {
       C_USD = MathPow(iClose("USDCHF", 0, i)*iClose("USDJPY", 0, i)*iClose("USDCAD", 0, i) / 
                       iClose("EURUSD", 0, i) / iClose("GBPUSD", 0, i) / 
                       iClose("AUDUSD", 0, i), 1. / 7.);
       if(MySymbol == "USD") 
           v1[i] = C_USD;
       if(MySymbol == "EUR")
           v1[i] = C_USD*iClose("EURUSD",0,i);
       if (MySymbol == "GBP")
           v1[i] = C_USD*iClose("GBPUSD",0,i);
       if(MySymbol == "AUD")
           v1[i] = C_USD*iClose("AUDUSD",0,i);
       if(MySymbol == "CHF")
           v1[i] = C_USD/iClose("USDCHF",0,i);
       if(MySymbol == "JPY")
           v1[i] = C_USD/iClose("USDJPY",0,i);
       if(MySymbol == "CAD")
           v1[i] = C_USD/iClose("USDCAD",0,i);
       int win_idx = WindowFind("WA " + MySymbol + " Index (" + MA1_Period + ", " + 
                      MA2_Period + ")");
       Idx1[i] = v1[i];
       if(ObjectCreate("HLINE" + MySymbol, OBJ_HLINE, win_idx, Time[0], Idx1[0]) == false)
         {
           ObjectSet("HLINE" + MySymbol, OBJPROP_PRICE1, Idx1[0]);
           ObjectSet("HLINE" + MySymbol, OBJPROP_COLOR, DimGray);
         }
     }
   if(ShowMA == true)
     {
       for(i = 0; i < MinBars - MA1_Period; i++)
         {
           Idx2[i] = iMAOnArray(Idx1, 0, MA1_Period, 0, MA1_Mode, i);
           Idx3[i] = iMAOnArray(Idx1, 0, MA2_Period, 0, MA2_Mode, i);
         }
     }
  }
//+------------------------------------------------------------------+

