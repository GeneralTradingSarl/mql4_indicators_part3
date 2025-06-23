//+------------------------------------------------------------------+
//|                                                         Z3MA.mq4 |
//|                                                   Hassane Zibara |
//|                             https://www.mql5.com/en/users/377812 |
//+------------------------------------------------------------------+
#property copyright "Hassane Zibara"
#property link      "https://www.mql5.com/en/users/377812"
#property version   "1.00"
#property strict
#include <stdlib.mqh>
#include <stderror.mqh>

//--- indicator settings
#property indicator_chart_window
#property indicator_buffers 5

#property indicator_type1 DRAW_ARROW
#property indicator_width1 1
#property indicator_color1 0xFFAA00
#property indicator_label1 "Buy"

#property indicator_type2 DRAW_ARROW
#property indicator_width2 1
#property indicator_color2 0x0000FF
#property indicator_label2 "Sell"

#property indicator_type3 DRAW_LINE
#property indicator_style3 STYLE_SOLID
#property indicator_width3 1
#property indicator_color3 0xFFAA00
#property indicator_label3 "medium term"

#property indicator_type4 DRAW_LINE
#property indicator_style4 STYLE_SOLID
#property indicator_width4 1
#property indicator_color4 0x00FFEE
#property indicator_label4 "Long Term"

#property indicator_type5 DRAW_LINE
#property indicator_style5 STYLE_SOLID
#property indicator_width5 1
#property indicator_color5 0x1500FF
#property indicator_label5 "EMA"

//--- indicator buffers
double Buffer1[];
double Buffer2[];
double Buffer3[];
double Buffer4[];
double Buffer5[];

extern string First_MA = "";//First MA
extern int Period1 = 55;
extern int Shift = 0;
input ENUM_MA_METHOD MAMethod1=MODE_EMA;         // MA1 method
input ENUM_APPLIED_PRICE MAPrice1=PRICE_CLOSE;     // MA1 price
extern string Second_MA = "";//Second_MA
extern int Period2 = 9;
extern int Shift2 = 0;
input ENUM_MA_METHOD MAMethod2=MODE_EMA;         // MA2 method
input ENUM_APPLIED_PRICE MAPrice2=PRICE_CLOSE;     // MA2 price
extern string therd_MA = "";//3rd MA
extern int Period3 = 21;
extern int Shift3 = 0;
input ENUM_MA_METHOD MAMethod3=MODE_EMA;         // MA3 method
input ENUM_APPLIED_PRICE MAPrice3=PRICE_CLOSE;     // MA3 price
datetime time_alert; //used when sending alert
bool Audible_Alerts = true;
double myPoint; //initialized in OnInit

void myAlert(string type, string message)
  {
   if(type == "print")
      Print(message);
   else if(type == "error")
     {
      Print(type+" | 3 MA @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
     }
   else if(type == "order")
     {
     }
   else if(type == "modify")
     {
     }
   else if(type == "indicator")
     {
      Print(type+" | 3 MA @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
      if(Audible_Alerts) Alert(type+" | 3 MA @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
     }
  }

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {   
   IndicatorBuffers(5);
   SetIndexBuffer(0, Buffer1);
   SetIndexEmptyValue(0, EMPTY_VALUE);
   SetIndexArrow(0, 241);
   SetIndexBuffer(1, Buffer2);
   SetIndexEmptyValue(1, EMPTY_VALUE);
   SetIndexArrow(1, 242);
   SetIndexBuffer(2, Buffer3);
   SetIndexEmptyValue(2, EMPTY_VALUE);
   SetIndexBuffer(3, Buffer4);
   SetIndexEmptyValue(3, EMPTY_VALUE);
   SetIndexBuffer(4, Buffer5);
   SetIndexEmptyValue(4, EMPTY_VALUE);
   //initialize myPoint
   myPoint = Point();
   if(Digits() == 5 || Digits() == 3)
     {
      myPoint *= 10;
     }
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime& time[],
                const double& open[],
                const double& high[],
                const double& low[],
                const double& close[],
                const long& tick_volume[],
                const long& volume[],
                const int& spread[])
  {
   int limit = rates_total - prev_calculated;
   //--- counting from 0 to rates_total
   ArraySetAsSeries(Buffer1, true);
   ArraySetAsSeries(Buffer2, true);
   ArraySetAsSeries(Buffer3, true);
   ArraySetAsSeries(Buffer4, true);
   ArraySetAsSeries(Buffer5, true);
   //--- initial zero
   if(prev_calculated < 1)
     {
      ArrayInitialize(Buffer1, EMPTY_VALUE);
      ArrayInitialize(Buffer2, EMPTY_VALUE);
      ArrayInitialize(Buffer3, EMPTY_VALUE);
      ArrayInitialize(Buffer4, EMPTY_VALUE);
      ArrayInitialize(Buffer5, EMPTY_VALUE);
     }
   else
      limit++;
   
   //--- main loop
   for(int i = limit-1; i >= 0; i--)
     {
      if (i >= MathMin(5000-1, rates_total-1-50)) continue; //omit some old rates to prevent "Array out of range" or slow calculation   
      
      //Indicator Buffer 1
      if(iMA(NULL, PERIOD_CURRENT, Period2, 0, MAMethod2, MAPrice2, Shift2+i) > iMA(NULL, PERIOD_CURRENT, Period3, 0, MAMethod3, MAPrice3, Shift3+i)
      && iMA(NULL, PERIOD_CURRENT, Period2, 0, MAMethod2, MAPrice2, Shift2+i+1) < iMA(NULL, PERIOD_CURRENT, Period3, 0, MAMethod3, MAPrice3, Shift3+i+1) //Moving Average crosses above Moving Average
      && iMA(NULL, PERIOD_CURRENT, Period1, 0, MAMethod1, MAPrice1, Shift+i) < iMA(NULL, PERIOD_CURRENT, Period2, 0, MAMethod2, MAPrice2, Shift2+i) //Moving Average < Moving Average
      && iMA(NULL, PERIOD_CURRENT, Period1, 0, MAMethod1, MAPrice1, Shift+i) < iMA(NULL, PERIOD_CURRENT, Period3, 0, MAMethod3, MAPrice3, Shift3+i) //Moving Average < Moving Average
      && iMA(NULL, PERIOD_CURRENT, Period3, 0, MAMethod3, MAPrice3, Shift3+i) < iMA(NULL, PERIOD_CURRENT, Period2, 0, MAMethod2, MAPrice2, Shift2+i) //Moving Average < Moving Average
      )
        {
         Buffer1[i] = Low[1+i]; //Set indicator value at Candlestick Low
         if(i == 1 && Time[1] != time_alert) myAlert("indicator", "Buy"); //Alert on next bar open
         time_alert = Time[1];
        }
      else
        {
         Buffer1[i] = EMPTY_VALUE;
        }
      //Indicator Buffer 2
      if(iMA(NULL, PERIOD_CURRENT, Period2, 0, MAMethod2, MAPrice2, Shift2+i) < iMA(NULL, PERIOD_CURRENT, Period3, 0, MAMethod3, MAPrice3, Shift3+i)
      && iMA(NULL, PERIOD_CURRENT, Period2, 0, MAMethod2, MAPrice2, Shift2+i+1) > iMA(NULL, PERIOD_CURRENT, Period3, 0, MAMethod3, MAPrice3, Shift3+i+1) //Moving Average crosses below Moving Average
      && iMA(NULL, PERIOD_CURRENT, Period1, 0, MAMethod1, MAPrice1, Shift+i) > iMA(NULL, PERIOD_CURRENT, Period2, 0, MAMethod2, MAPrice2, Shift2+i) //Moving Average > Moving Average
      && iMA(NULL, PERIOD_CURRENT, Period1, 0, MAMethod1, MAPrice1, Shift+i) > iMA(NULL, PERIOD_CURRENT, Period3, 0, MAMethod3, MAPrice3, Shift3+i) //Moving Average > Moving Average
      && iMA(NULL, PERIOD_CURRENT, Period3, 0, MAMethod3, MAPrice3, Shift3+i) > iMA(NULL, PERIOD_CURRENT, Period2, 0, MAMethod2, MAPrice2, Shift2+i) //Moving Average > Moving Average
      )
        {
         Buffer2[i] = High[1+i]; //Set indicator value at Candlestick High
         if(i == 1 && Time[1] != time_alert) myAlert("indicator", "Sell"); //Alert on next bar open
         time_alert = Time[1];
        }
      else
        {
         Buffer2[i] = EMPTY_VALUE;
        }
      //Indicator Buffer 3
      if(true //no conditions!
      )
        {
         Buffer3[i] = iMA(NULL, PERIOD_CURRENT, Period2, 0, MAMethod2, MAPrice2, Shift2+i); //Set indicator value at Moving Average
         if(i == 1 && Time[1] != time_alert) myAlert("indicator", "medium term"); //Alert on next bar open
         time_alert = Time[1];
        }
      else
        {
         Buffer3[i] = EMPTY_VALUE;
        }
      //Indicator Buffer 4
      if(true //no conditions!
      )
        {
         Buffer4[i] = iMA(NULL, PERIOD_CURRENT, Period1, 0, MAMethod1, MAPrice1, Shift+i); //Set indicator value at Moving Average
         if(i == 1 && Time[1] != time_alert) myAlert("indicator", "Long Term"); //Alert on next bar open
         time_alert = Time[1];
        }
      else
        {
         Buffer4[i] = EMPTY_VALUE;
        }
      //Indicator Buffer 5
      if(true //no conditions!
      )
        {
         Buffer5[i] = iMA(NULL, PERIOD_CURRENT, Period3, 0, MAMethod3, MAPrice3, Shift3+i); //Set indicator value at Moving Average
         if(i == 1 && Time[1] != time_alert) myAlert("indicator", "EMA"); //Alert on next bar open
         time_alert = Time[1];
        }
      else
        {
         Buffer5[i] = EMPTY_VALUE;
        }
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+