//+------------------------------------------------------------------+
//|                                    Waddah Attar Dayly CAMARRILLA |
//|                               Copyright © 2007, ww.metaforex.net |
//|                                   Waddah Attar www.metaforex.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, www.metaforex.net"
#property link      "www.metaforex.net"
//----
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_color3 Green
#property indicator_color4 Red
#property indicator_color5 Green
#property indicator_color6 Red
#property indicator_color7 Green
#property indicator_color8 Red

//---- buffers
double P1Buffer[];
double P2Buffer[];
double P3Buffer[];
double P4Buffer[];
double P5Buffer[];
double P6Buffer[];
double P7Buffer[];
double P8Buffer[];
//----
int myPeriod = PERIOD_D1;
//----
double H1, L1, H2, L2, H3, L3, H4, L4, Q;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0, P1Buffer);
   SetIndexBuffer(1, P2Buffer);
   SetIndexBuffer(2, P3Buffer);
   SetIndexBuffer(3, P4Buffer);
   SetIndexBuffer(4, P5Buffer);
   SetIndexBuffer(5, P6Buffer);
   SetIndexBuffer(6, P7Buffer);
   SetIndexBuffer(7, P8Buffer);
//----
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexStyle(2, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexStyle(3, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexStyle(4, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexStyle(5, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexStyle(6, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexStyle(7, DRAW_LINE, STYLE_SOLID, 1);
//----
   Comment("Dayly CAMARRILLA By eng.Waddah Attar  www.metaforex.net");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("DayH1");
   ObjectDelete("DayH2");
   ObjectDelete("DayH3");
   ObjectDelete("DayH4");

   ObjectDelete("DayL1");
   ObjectDelete("DayL2");
   ObjectDelete("DayL3");
   ObjectDelete("DayL4");

   ObjectDelete("txtDayH1");
   ObjectDelete("txtDayH2");
   ObjectDelete("txtDayH3");
   ObjectDelete("txtDayH4");

   ObjectDelete("txtDayL1");
   ObjectDelete("txtDayL2");
   ObjectDelete("txtDayL3");
   ObjectDelete("txtDayL4");
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
       dayi = iBarShift(Symbol(), myPeriod, Time[i], false);
       Q = (iHigh(Symbol(), myPeriod,dayi+1) - iLow(Symbol(), myPeriod, 
            dayi + 1));
       //----
       H1 = iClose(Symbol(), myPeriod,dayi+1) + (Q * 0.09);
       L1 = iClose(Symbol(), myPeriod,dayi+1) - (Q * 0.09);
       //----
       H2 = iClose(Symbol(), myPeriod,dayi+1) + (Q * 0.18);
       L2 = iClose(Symbol(), myPeriod,dayi+1) - (Q * 0.18);
       //----
       H3 = iClose(Symbol(), myPeriod,dayi+1) + (Q * 0.27);
       L3 = iClose(Symbol(), myPeriod,dayi+1) - (Q * 0.27);
       //----
       H4 = iClose(Symbol(), myPeriod,dayi+1) + (Q * 0.55);
       L4 = iClose(Symbol(), myPeriod,dayi+1) - (Q * 0.55);
       //----
       P1Buffer[i] = H1;
       SetPrice("DayH1", Time[i], H1, Green);
       SetText("txtDayH1", "H1", Time[i], H1, Green);
       //----
       P2Buffer[i] = L1;
       SetPrice("DayL1", Time[i], L1, Red);
       SetText("txtDayL1", "L1", Time[i], L1, Red);
       //----
       P3Buffer[i] = H2;
       SetPrice("DayH2", Time[i], H2, Green);
       SetText("txtDayH2", "H2", Time[i], H2, Green);
       //----
       P4Buffer[i] = L2;
       SetPrice("DayL2",Time[i],L2,Red);
       SetText("txtDayL2","L2",Time[i],L2,Red);
       //----
       P5Buffer[i] = H3;
       SetPrice("DayH3", Time[i], H3, Green);
       SetText("txtDayH3", "H3", Time[i], H3, Green);
       //----
       P6Buffer[i] = L3;
       SetPrice("DayL3", Time[i], L3, Red);
       SetText("txtDayL3", "L3", Time[i], L3, Red);
       //----
       P7Buffer[i] = H4;
       SetPrice("DayH4", Time[i], H4, Green);
       SetText("txtDayH4", "H4", Time[i], H4, Green);
       //----
       P8Buffer[i] = L4;
       SetPrice("DayL4", Time[i], L4, Red);
       SetText("txtDayL4", "L4", Time[i], L4, Red);

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