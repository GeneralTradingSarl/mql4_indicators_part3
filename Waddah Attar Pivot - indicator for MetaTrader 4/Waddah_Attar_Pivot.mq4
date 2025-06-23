//+------------------------------------------------------------------+
//|                                               Waddah Attar Pivot |
//|                        Copyright © 2007, waddahattar@hotmail.com |
//|                             Waddah Attar waddahattar@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, waddahattar@hotmail.com"
#property link      "waddahattar@hotmail.com"
//----
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_color3 Gold
//---- buffers
double P1Buffer[];
double P2Buffer[];
double P3Buffer[];
//----
double PP, Q;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0, P1Buffer);
   SetIndexBuffer(1, P2Buffer);
   SetIndexBuffer(2, P3Buffer);
//----
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexStyle(2, DRAW_LINE, STYLE_SOLID, 2);
//----
   Comment("Waddah Attar Pivot");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("DayP");
   ObjectDelete("WeekP");
   ObjectDelete("MonthP");
   ObjectDelete("txtDayP");
   ObjectDelete("txtWeekP");
   ObjectDelete("txtMonthP");

   Comment("");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i, dayi, counted_bars = IndicatorCounted();
//---- check for possible errors
   if(counted_bars < 0) 
       return(-1);
//---- last counted bar will be recounted
   if(counted_bars > 0) 
       counted_bars--;  
   int limit = Bars - counted_bars;
//----   
   for(i = limit - 1; i >= 0; i--)
     {
       dayi = iBarShift(Symbol(), PERIOD_D1, Time[i], false);
       Q = (iHigh(Symbol(), PERIOD_D1,dayi + 1) - iLow(Symbol(), PERIOD_D1, dayi + 1));
       PP = (iHigh(Symbol(), PERIOD_D1, dayi + 1) + iLow(Symbol(), PERIOD_D1, dayi + 1) + iClose(Symbol(), PERIOD_D1, dayi + 1)) / 3;    
       //----
       P1Buffer[i] = PP;
       SetPrice("DayP", Time[i], PP, indicator_color1);
       SetText("txtDayP", "Day Pivot", Time[i], PP, indicator_color1);

       dayi = iBarShift(Symbol(), PERIOD_W1, Time[i], false);
       Q = (iHigh(Symbol(), PERIOD_W1,dayi + 1) - iLow(Symbol(), PERIOD_W1, dayi + 1));
       PP = (iHigh(Symbol(), PERIOD_W1, dayi + 1) + iLow(Symbol(), PERIOD_W1, dayi + 1) + iClose(Symbol(), PERIOD_W1, dayi + 1)) / 3;    
       //----
       P2Buffer[i] = PP;
       SetPrice("WeekP", Time[i], PP, indicator_color2);
       SetText("txtWeekP", "Week Pivot", Time[i], PP, indicator_color2);

       dayi = iBarShift(Symbol(), PERIOD_MN1, Time[i], false);
       Q = (iHigh(Symbol(), PERIOD_MN1,dayi + 1) - iLow(Symbol(), PERIOD_MN1, dayi + 1));
       PP = (iHigh(Symbol(), PERIOD_MN1, dayi + 1) + iLow(Symbol(), PERIOD_MN1, dayi + 1) + iClose(Symbol(), PERIOD_MN1, dayi + 1)) / 3;    
       //----
       P3Buffer[i] = PP;
       SetPrice("MonthP", Time[i], PP, indicator_color3);
       SetText("txtMonthP", "Month Pivot", Time[i], PP, indicator_color3);

    }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetPrice(string name, datetime Tm, double Prc, color clr)
  {
   if(ObjectFind(name) == -1)
     {
       ObjectCreate(name, OBJ_ARROW, 0, Tm, Prc);
       ObjectSet(name, OBJPROP_COLOR, clr);
       ObjectSet(name, OBJPROP_WIDTH, 1);
       ObjectSet(name, OBJPROP_ARROWCODE, SYMBOL_RIGHTPRICE);
     }
   else
     {
       ObjectSet(name, OBJPROP_TIME1, Tm);
       ObjectSet(name, OBJPROP_PRICE1, Prc);
       ObjectSet(name, OBJPROP_COLOR, clr);
       ObjectSet(name, OBJPROP_WIDTH, 1);
       ObjectSet(name, OBJPROP_ARROWCODE, SYMBOL_RIGHTPRICE);
     } 
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetText(string name, string txt, datetime Tm, double Prc, color clr)
  {
   if(ObjectFind(name) == -1)
     {
       ObjectCreate(name, OBJ_TEXT, 0, Tm, Prc);
       ObjectSetText(name, txt, 10, "Times New Roman", clr);
       ObjectSet(name, OBJPROP_CORNER, 2);
     }
   else
     {
       ObjectSet(name, OBJPROP_TIME1, Tm);
       ObjectSet(name, OBJPROP_PRICE1, Prc);
       ObjectSetText(name, txt, 10, "Times New Roman", clr);
       ObjectSet(name, OBJPROP_CORNER, 2);
     } 
  }
//+------------------------------------------------------------------+