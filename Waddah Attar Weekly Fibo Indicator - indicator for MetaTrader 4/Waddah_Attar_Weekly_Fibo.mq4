//+------------------------------------------------------------------+
//|                                         Waddah Attar Weekly Fibo |
//|                                   Copyright © 2007, Waddah Attar |
//|                             Waddah Attar waddahattar@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, Waddah Attar waddahattar@hotmail.com"
#property link      "waddahattar@hotmail.com"
//----
#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 Blue
#property indicator_color2 Blue
#property indicator_color3 DodgerBlue
#property indicator_color4 DodgerBlue
#property indicator_color5 DodgerBlue
#property indicator_color6 DodgerBlue
#property indicator_color7 DodgerBlue

extern bool ShowPercent=true;

//---- buffers
double P1Buffer[];
double P2Buffer[];
double P3Buffer[];
double P4Buffer[];
double P5Buffer[];
double P6Buffer[];
double P7Buffer[];
//----
int myPeriod = PERIOD_W1;
//----
double Q,H,L,F;
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
//----
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexStyle(2, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexStyle(3, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexStyle(4, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexStyle(5, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexStyle(6, DRAW_LINE, STYLE_SOLID, 1);
//----
   Comment("Waddah Attar Weekly Fibo");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("WeekF1");
   ObjectDelete("WeekF2");
   ObjectDelete("WeekF3");
   ObjectDelete("WeekF4");
   ObjectDelete("WeekF5");
   ObjectDelete("WeekF6");
   ObjectDelete("WeekF7");
   ObjectDelete("txtWeekF1");
   ObjectDelete("txtWeekF2");
   ObjectDelete("txtWeekF3");
   ObjectDelete("txtWeekF4");
   ObjectDelete("txtWeekF5");
   ObjectDelete("txtWeekF6");
   ObjectDelete("txtWeekF7");
   ObjectDelete("WPercent");
   ObjectDelete("WPrice");
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
       H=iHigh(Symbol(), myPeriod,dayi + 1);
       L=iLow(Symbol(), myPeriod,dayi + 1);
       Q = (H-L);
       //----
       P1Buffer[i] = H;
       SetPrice("WeekF1", Time[i], H, indicator_color1);
       SetText("txtWeekF1", "Weekly High                   ", Time[i], H, indicator_color1);
       //----
       P2Buffer[i] = L;
       SetPrice("WeekF2", Time[i], L, indicator_color2);
       SetText("txtWeekF2", "Weekly Low                   ", Time[i], L, indicator_color2);
       //----
       P3Buffer[i] = L+(Q*0.236);
       SetPrice("WeekF3", Time[i], L+(Q*0.236), indicator_color3);
       SetText("txtWeekF3", "Weekly 23.6%                   ", Time[i], L+(Q*0.236), indicator_color3);
       //----
       P4Buffer[i] = L+(Q*0.382);
       SetPrice("WeekF4", Time[i], L+(Q*0.382), indicator_color4);
       SetText("txtWeekF4", "Weekly 38.2%                   ", Time[i], L+(Q*0.382), indicator_color4);
       //----
       P5Buffer[i] = L+(Q*0.50);
       SetPrice("WeekF5", Time[i], L+(Q*0.50), indicator_color5);
       SetText("txtWeekF5", "Weekly 50%                   ", Time[i], L+(Q*0.50), indicator_color5);
       //----
       P6Buffer[i] = L+(Q*0.618);
       SetPrice("WeekF6", Time[i], L+(Q*0.618), indicator_color6);
       SetText("txtWeekF6", "Weekly 61.8%                   ", Time[i], L+(Q*0.618), indicator_color6);
       //----
       P7Buffer[i] = L+(Q*0.764);
       SetPrice("WeekF7", Time[i], L+(Q*0.764), indicator_color7);
       SetText("txtWeekF7", "Weekly 76.4%                   ", Time[i], L+(Q*0.764), indicator_color7);

    }
    
    F=(Bid-L)/Q*100;
    
    if (ShowPercent==true)
    {
      SetLabel("WPrice","Price ="+DoubleToStr(Bid,Digits),1,30,"Simplified Arabic Fixed",20,0,indicator_color1);
      SetLabel("WPercent","W Fibo="+DoubleToStr(F,2)+"%",1,10,"Simplified Arabic Fixed",20,0,indicator_color1);
    }
    else
    {
      ObjectDelete("WPercent");
      ObjectDelete("WPrice");
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
  
void SetLabel(string name,string txt,int x,int y,string font,int size,int angle,color clr)
  {
   int idx=0;
   if(ObjectFind(name) == -1)
     {
       ObjectCreate(name, OBJ_LABEL, idx, 0, 0);
       ObjectSetText(name, txt, size, font, clr);
       ObjectSet(name, OBJPROP_XDISTANCE, x);
       ObjectSet(name, OBJPROP_YDISTANCE, y);
       ObjectSet(name, OBJPROP_CORNER, 2);
       ObjectSet(name, OBJPROP_ANGLE, angle);
     }
   else
     {
       ObjectSet(name, OBJPROP_XDISTANCE, x);
       ObjectSet(name, OBJPROP_YDISTANCE, y);
       ObjectSetText(name, txt, size, font, clr);
       ObjectSet(name, OBJPROP_CORNER, 2);
       ObjectSet(name, OBJPROP_ANGLE, angle);
     } 
  }

//+------------------------------------------------------------------+