//+------------------------------------------------------------------+
//|                                        Waddah Attar Monthly Fibo |
//|                                   Copyright © 2007, Waddah Attar |
//|                             Waddah Attar waddahattar@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, Waddah Attar waddahattar@hotmail.com"
#property link      "waddahattar@hotmail.com"
//----
#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 Orange
#property indicator_color2 Orange
#property indicator_color3 DarkOrange
#property indicator_color4 DarkOrange
#property indicator_color5 DarkOrange
#property indicator_color6 DarkOrange
#property indicator_color7 DarkOrange

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
int myPeriod=PERIOD_MN1;
//----
double Q,H,L,F;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0,P1Buffer);
   SetIndexBuffer(1,P2Buffer);
   SetIndexBuffer(2,P3Buffer);
   SetIndexBuffer(3,P4Buffer);
   SetIndexBuffer(4,P5Buffer);
   SetIndexBuffer(5,P6Buffer);
   SetIndexBuffer(6,P7Buffer);
//----
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,3);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,3);
   SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(3,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(4,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(5,DRAW_LINE,STYLE_SOLID,1);
   SetIndexStyle(6,DRAW_LINE,STYLE_SOLID,1);
//----
   Comment("Waddah Attar Monthly Fibo");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("MonthF1");
   ObjectDelete("MonthF2");
   ObjectDelete("MonthF3");
   ObjectDelete("MonthF4");
   ObjectDelete("MonthF5");
   ObjectDelete("MonthF6");
   ObjectDelete("MonthF7");
   ObjectDelete("txtMonthF1");
   ObjectDelete("txtMonthF2");
   ObjectDelete("txtMonthF3");
   ObjectDelete("txtMonthF4");
   ObjectDelete("txtMonthF5");
   ObjectDelete("txtMonthF6");
   ObjectDelete("txtMonthF7");
   ObjectDelete("MPercent");
   Comment("");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i,dayi;
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+1;
//----   
   for(i=limit-1; i>=0; i--)
     {
      dayi=iBarShift(Symbol(),myPeriod,Time[i],false);
      H=iHigh(Symbol(), myPeriod,dayi + 1);
      L=iLow(Symbol(), myPeriod,dayi + 1);
      Q=(H-L);
      //----
      P1Buffer[i]=H;
      SetPrice("MonthF1",Time[i],H,indicator_color1);
      SetText("txtMonthF1","Monthly High                   ",Time[i],H,indicator_color1);
      //----
      P2Buffer[i]=L;
      SetPrice("MonthF2",Time[i],L,indicator_color2);
      SetText("txtMonthF2","Monthly Low                   ",Time[i],L,indicator_color2);
      //----
      P3Buffer[i]=L+(Q*0.236);
      SetPrice("MonthF3",Time[i],L+(Q*0.236),indicator_color3);
      SetText("txtMonthF3","Monthly 23.6%                   ",Time[i],L+(Q*0.236),indicator_color3);
      //----
      P4Buffer[i]=L+(Q*0.382);
      SetPrice("MonthF4",Time[i],L+(Q*0.382),indicator_color4);
      SetText("txtMonthF4","Monthly 38.2%                   ",Time[i],L+(Q*0.382),indicator_color4);
      //----
      P5Buffer[i]=L+(Q*0.50);
      SetPrice("MonthF5",Time[i],L+(Q*0.50),indicator_color5);
      SetText("txtMonthF5","Monthly 50%                   ",Time[i],L+(Q*0.50),indicator_color5);
      //----
      P6Buffer[i]=L+(Q*0.618);
      SetPrice("MonthF6",Time[i],L+(Q*0.618),indicator_color6);
      SetText("txtMonthF6","Monthly 61.8%                   ",Time[i],L+(Q*0.618),indicator_color6);
      //----
      P7Buffer[i]=L+(Q*0.764);
      SetPrice("MonthF7",Time[i],L+(Q*0.764),indicator_color7);
      SetText("txtMonthF7","Monthly 76.4%                   ",Time[i],L+(Q*0.764),indicator_color7);

     }

   if(Q!=0)
     {
      F=(Bid-L)/Q*100;
      if(ShowPercent==true)
        {
         SetLabel("MPercent","M Fibo="+DoubleToStr(F,2)+"%",1,51,"Simplified Arabic Fixed",20,0,indicator_color1);
        }
      else
        {
         ObjectDelete("WPercent");
        }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetPrice(string name,datetime Tm,double Prc,color clr)
  {
   if(ObjectFind(name)==-1)
     {
      ObjectCreate(name,OBJ_ARROW,0,Tm,Prc);
      ObjectSet(name,OBJPROP_COLOR,clr);
      ObjectSet(name,OBJPROP_WIDTH,1);
      ObjectSet(name,OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
     }
   else
     {
      ObjectSet(name,OBJPROP_TIME1,Tm);
      ObjectSet(name,OBJPROP_PRICE1,Prc);
      ObjectSet(name,OBJPROP_COLOR,clr);
      ObjectSet(name,OBJPROP_WIDTH,1);
      ObjectSet(name,OBJPROP_ARROWCODE,SYMBOL_RIGHTPRICE);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetText(string name,string txt,datetime Tm,double Prc,color clr)
  {
   if(ObjectFind(name)==-1)
     {
      ObjectCreate(name,OBJ_TEXT,0,Tm,Prc);
      ObjectSetText(name,txt,10,"Times New Roman",clr);
      ObjectSet(name,OBJPROP_CORNER,2);
     }
   else
     {
      ObjectSet(name,OBJPROP_TIME1,Tm);
      ObjectSet(name,OBJPROP_PRICE1,Prc);
      ObjectSetText(name,txt,10,"Times New Roman",clr);
      ObjectSet(name,OBJPROP_CORNER,2);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetLabel(string name,string txt,int x,int y,string font,int size,int angle,color clr)
  {
   int idx=0;
   if(ObjectFind(name)==-1)
     {
      ObjectCreate(name,OBJ_LABEL,idx,0,0);
      ObjectSetText(name,txt,size,font,clr);
      ObjectSet(name,OBJPROP_XDISTANCE,x);
      ObjectSet(name,OBJPROP_YDISTANCE,y);
      ObjectSet(name,OBJPROP_CORNER,2);
      ObjectSet(name,OBJPROP_ANGLE,angle);
     }
   else
     {
      ObjectSet(name,OBJPROP_XDISTANCE,x);
      ObjectSet(name,OBJPROP_YDISTANCE,y);
      ObjectSetText(name,txt,size,font,clr);
      ObjectSet(name,OBJPROP_CORNER,2);
      ObjectSet(name,OBJPROP_ANGLE,angle);
     }
  }

//+------------------------------------------------------------------+
