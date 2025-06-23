//+------------------------------------------------------------------+
//|                                       Indicator: Real Signal.mq4 |
//|                                       Created with EABuilder.com |
//|                                             http://eabuilder.com |
//+------------------------------------------------------------------+
#property copyright "Created with EABuilder.com"
#property link      "http://eabuilder.com"
#property version   "1.00"
#property description ""

#include <stdlib.mqh>
#include <stderror.mqh>

//--- indicator settings
#property indicator_separate_window
#property indicator_buffers 6

#property indicator_type1 DRAW_HISTOGRAM
#property indicator_style1 STYLE_SOLID
#property indicator_width1 1
#property indicator_color1 0xFFAA00
#property indicator_label1 "Buy"

#property indicator_type2 DRAW_HISTOGRAM
#property indicator_style2 STYLE_SOLID
#property indicator_width2 1
#property indicator_color2 0x0000FF
#property indicator_label2 "Sell"

#property indicator_type3 DRAW_ARROW
#property indicator_width3 1
#property indicator_color3 0xFFAA00
#property indicator_label3 "Buy"

#property indicator_type4 DRAW_ARROW
#property indicator_width4 1
#property indicator_color4 0x0000FF
#property indicator_label4 "Sell"

#property indicator_type5 DRAW_NONE
#property indicator_style5 STYLE_SOLID
#property indicator_width5 1
#property indicator_color5 0xFFAA00
#property indicator_label5 "Buy"

#property indicator_type6 DRAW_NONE
#property indicator_style6 STYLE_SOLID
#property indicator_width6 1
#property indicator_color6 0x0000FF
#property indicator_label6 "Sell"

//--- indicator buffers
double Buffer1[];
double Buffer2[];
double Buffer3[];
double Buffer4[];
double Buffer5[];
double Buffer6[];

extern int Profit_Check = 1;
double myPoint; //initialized in OnInit

void myAlert(string type, string message)
  {
   if(type == "print")
      Print(message);
   else if(type == "error")
     {
      Print(type+" | Real Signal @ "+Symbol()+","+Period()+" | "+message);
     }
   else if(type == "order")
     {
     }
   else if(type == "modify")
     {
     }
  }

void DrawLine(string objname, double price, int count, int start_index) //creates or modifies existing object if necessary
  {
   if((price < 0) && ObjectFind(objname) >= 0)
     {
      ObjectDelete(objname);
     }
   else if(ObjectFind(objname) >= 0 && ObjectType(objname) == OBJ_TREND)
     {
      ObjectSet(objname, OBJPROP_TIME1, Time[start_index]);
      ObjectSet(objname, OBJPROP_PRICE1, price);
      ObjectSet(objname, OBJPROP_TIME2, Time[start_index+count-1]);
      ObjectSet(objname, OBJPROP_PRICE2, price);
     }
   else
     {
      ObjectCreate(objname, OBJ_TREND, 0, Time[start_index], price, Time[start_index+count-1], price);
      ObjectSet(objname, OBJPROP_RAY, false);
      ObjectSet(objname, OBJPROP_COLOR, C'0x00,0x00,0xFF');
      ObjectSet(objname, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(objname, OBJPROP_WIDTH, 2);
     }
  }

double Support(int time_interval, bool fixed_tod, int hh, int mm, bool draw, int shift)
  {
   int start_index = shift;
   int count = time_interval / 60 / Period();
   if(fixed_tod)
     {
      datetime start_time;
      if(shift == 0)
	     start_time = TimeCurrent();
      else
         start_time = Time[shift-1];
      datetime dt = StringToTime(StringConcatenate(TimeToString(start_time, TIME_DATE)," ",hh,":",mm)); //closest time hh:mm
      if (dt > start_time)
         dt -= 86400; //go 24 hours back
      int dt_index = iBarShift(NULL, 0, dt, true);
      datetime dt2 = dt;
      while(dt_index < 0 && dt > Time[Bars-1-count]) //bar not found => look a few days back
        {
         dt -= 86400; //go 24 hours back
         dt_index = iBarShift(NULL, 0, dt, true);
        }
      if (dt_index < 0) //still not found => find nearest bar
         dt_index = iBarShift(NULL, 0, dt2, false);
      start_index = dt_index + 1; //bar after S/R opens at dt
     }
   double ret = Low[iLowest(NULL, 0, MODE_LOW, count, start_index)];
   if (draw) DrawLine("Support", ret, count, start_index);
   return(ret);
  }

double Resistance(int time_interval, bool fixed_tod, int hh, int mm, bool draw, int shift)
  {
   int start_index = shift;
   int count = time_interval / 60 / Period();
   if(fixed_tod)
     {
      datetime start_time;
      if(shift == 0)
	     start_time = TimeCurrent();
      else
         start_time = Time[shift-1];
      datetime dt = StringToTime(StringConcatenate(TimeToString(start_time, TIME_DATE)," ",hh,":",mm)); //closest time hh:mm
      if (dt > start_time)
         dt -= 86400; //go 24 hours back
      int dt_index = iBarShift(NULL, 0, dt, true);
      datetime dt2 = dt;
      while(dt_index < 0 && dt > Time[Bars-1-count]) //bar not found => look a few days back
        {
         dt -= 86400; //go 24 hours back
         dt_index = iBarShift(NULL, 0, dt, true);
        }
      if (dt_index < 0) //still not found => find nearest bar
         dt_index = iBarShift(NULL, 0, dt2, false);
      start_index = dt_index + 1; //bar after S/R opens at dt
     }
   double ret = High[iHighest(NULL, 0, MODE_HIGH, count, start_index)];
   if (draw) DrawLine("Resistance", ret, count, start_index);
   return(ret);
  }

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {   
   IndicatorBuffers(6);
   SetIndexBuffer(0, Buffer1);
   SetIndexEmptyValue(0, 0);
   SetIndexBuffer(1, Buffer2);
   SetIndexEmptyValue(1, 0);
   SetIndexBuffer(2, Buffer3);
   SetIndexEmptyValue(2, 0);
   SetIndexArrow(2, 241);
   SetIndexBuffer(3, Buffer4);
   SetIndexEmptyValue(3, 0);
   SetIndexArrow(3, 242);
   SetIndexBuffer(4, Buffer5);
   SetIndexEmptyValue(4, 0);
   SetIndexBuffer(5, Buffer6);
   SetIndexEmptyValue(5, 0);
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
   ArraySetAsSeries(Buffer6, true);
   //--- initial zero
   if(prev_calculated < 1)
     {
      ArrayInitialize(Buffer1, 0);
      ArrayInitialize(Buffer2, 0);
      ArrayInitialize(Buffer3, 0);
      ArrayInitialize(Buffer4, 0);
      ArrayInitialize(Buffer5, 0);
      ArrayInitialize(Buffer6, 0);
     }
   else
      limit++;
   
   //--- main loop
   for(int i = limit-1; i >= 0; i--)
     {
      if (i >= MathMin(300-1, rates_total-1-10)) continue; //omit some old rates to prevent "Array out of range" or slow calculation   
      //Indicator Buffer 1
      if(Open[i] > iFractals(NULL, PERIOD_H4, MODE_LOWER, i) //Candlestick Open > Fractals
      )
        {
         Buffer1[i] = iFractals(NULL, PERIOD_H4, MODE_LOWER, i); //Set indicator value at Fractals
        }
      else
        {
         Buffer1[i] = 0;
        }
      //Indicator Buffer 2
      if(Open[i] < iFractals(NULL, PERIOD_H4, MODE_UPPER, i) //Candlestick Open < Fractals
      )
        {
         Buffer2[i] = iFractals(NULL, PERIOD_H4, MODE_UPPER, i); //Set indicator value at Fractals
        }
      else
        {
         Buffer2[i] = 0;
        }
      //Indicator Buffer 3
      if(Open[i] > iFractals(NULL, PERIOD_H1, MODE_LOWER, i) //Candlestick Open > Fractals
      )
        {
         Buffer3[i] = iFractals(NULL, PERIOD_CURRENT, MODE_LOWER, i); //Set indicator value at Fractals
        }
      else
        {
         Buffer3[i] = 0;
        }
      //Indicator Buffer 4
      if(Open[i] < iFractals(NULL, PERIOD_H1, MODE_UPPER, i) //Candlestick Open < Fractals
      )
        {
         Buffer4[i] = iFractals(NULL, PERIOD_CURRENT, MODE_UPPER, i); //Set indicator value at Fractals
        }
      else
        {
         Buffer4[i] = 0;
        }
      //Indicator Buffer 5
      if(true //no conditions!
      )
        {
         Buffer5[i] = Support(Profit_Check * PeriodSeconds(), false, 00, 00, false, i); //Set indicator value at Support
        }
      else
        {
         Buffer5[i] = 0;
        }
      //Indicator Buffer 6
      if(true //no conditions!
      )
        {
         Buffer6[i] = Resistance(Profit_Check * PeriodSeconds(), false, 00, 00, false, i); //Set indicator value at Resistance
        }
      else
        {
         Buffer6[i] = 0;
        }
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+