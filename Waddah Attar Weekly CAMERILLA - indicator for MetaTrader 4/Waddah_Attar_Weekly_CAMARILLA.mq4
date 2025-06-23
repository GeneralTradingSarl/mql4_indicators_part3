//+------------------------------------------------------------------+
//|                                   Waddah Attar Weekly CAMARRILLA |
//|                               Copyright © 2007, ww.metaforex.net |
//|                                   Waddah Attar www.metaforex.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, www.metaforex.net"
#property link      "www.metaforex.net"
//----
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 LightSeaGreen
#property indicator_color2 DeepPink
#property indicator_color3 LightSeaGreen
#property indicator_color4 DeepPink
#property indicator_color5 LightSeaGreen
#property indicator_color6 DeepPink
#property indicator_color7 LightSeaGreen
#property indicator_color8 DeepPink

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
int myPeriod = PERIOD_W1;
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
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexStyle(2, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexStyle(3, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexStyle(4, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexStyle(5, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexStyle(6, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexStyle(7, DRAW_LINE, STYLE_SOLID, 2);
//----
   Comment("Weekly CAMARRILLA By eng.Waddah Attar  www.metaforex.net");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("WeekH1");
   ObjectDelete("WeekH2");
   ObjectDelete("WeekH3");
   ObjectDelete("WeekH4");

   ObjectDelete("WeekL1");
   ObjectDelete("WeekL2");
   ObjectDelete("WeekL3");
   ObjectDelete("WeekL4");

   ObjectDelete("txtWeekH1");
   ObjectDelete("txtWeekH2");
   ObjectDelete("txtWeekH3");
   ObjectDelete("txtWeekH4");

   ObjectDelete("txtWeekL1");
   ObjectDelete("txtWeekL2");
   ObjectDelete("txtWeekL3");
   ObjectDelete("txtWeekL4");
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
       SetPrice("WeekH1", Time[i], H1, LightSeaGreen);
       SetText("txtWeekH1", "H1", Time[i], H1, LightSeaGreen);
       //----
       P2Buffer[i] = L1;
       SetPrice("WeekL1", Time[i], L1, DeepPink);
       SetText("txtWeekL1", "L1", Time[i], L1, DeepPink);
       //----
       P3Buffer[i] = H2;
       SetPrice("WeekH2", Time[i], H2, LightSeaGreen);
       SetText("txtWeekH2", "H2", Time[i], H2, LightSeaGreen);
       //----
       P4Buffer[i] = L2;
       SetPrice("WeekL2",Time[i],L2,DeepPink);
       SetText("txtWeekL2","L2",Time[i],L2,DeepPink);
       //----
       P5Buffer[i] = H3;
       SetPrice("WeekH3", Time[i], H3, LightSeaGreen);
       SetText("txtWeekH3", "H3", Time[i], H3, LightSeaGreen);
       //----
       P6Buffer[i] = L3;
       SetPrice("WeekL3", Time[i], L3, DeepPink);
       SetText("txtWeekL3", "L3", Time[i], L3, DeepPink);
       //----
       P7Buffer[i] = H4;
       SetPrice("WeekH4", Time[i], H4, LightSeaGreen);
       SetText("txtWeekH4", "H4", Time[i], H4, LightSeaGreen);
       //----
       P8Buffer[i] = L4;
       SetPrice("WeekL4", Time[i], L4, DeepPink);
       SetText("txtWeekL4", "L4", Time[i], L4, DeepPink);

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
       ObjectSet(name, OBJPROP_WIDTH, 2);
       ObjectSet(name, OBJPROP_ARROWCODE, SYMBOL_RIGHTPRICE);
     }
   else
     {
       ObjectSet(name, OBJPROP_TIME1, Tm);
       ObjectSet(name, OBJPROP_PRICE1, Prc);
       ObjectSet(name, OBJPROP_COLOR, clr);
       ObjectSet(name, OBJPROP_WIDTH, 2);
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
       ObjectSetText(name, txt, 9, "Times New Roman", clr);
     }
   else
     {
       ObjectSet(name, OBJPROP_TIME1, Tm);
       ObjectSet(name, OBJPROP_PRICE1, Prc);
       ObjectSetText(name, txt, 9, "Times New Roman", clr);
     } 
  }
//+------------------------------------------------------------------+