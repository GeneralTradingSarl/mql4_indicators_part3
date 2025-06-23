//+------------------------------------------------------------------+
//|                                      Waddah Attar Strong Level   |
//|                              Copyright © 2007, www.metaforex.net |
//|                                   Waddah Attar www.metaforex.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2007, www.metaforex.net"
#property link      "www.metaforex.net"
//---- 
#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Red
#property indicator_color2 Green
#property indicator_color3 Blue
#property indicator_color4 Red
#property indicator_color5 Green
#property indicator_color6 Blue
#property indicator_color7 Orange
#property indicator_color8 Orange

extern bool BackTest=false;
extern bool DrawMonth=true;
extern bool DrawWeek=true;
extern bool DrawDay=true;
extern bool DrawH4=false;

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
int levelPeriod1 = PERIOD_D1;
int levelPeriod2 = PERIOD_H4;
int levelPeriod3 = PERIOD_W1;
int levelPeriod4 = PERIOD_MN1;

bool FixSunday;
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
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexStyle(2, DRAW_LINE, STYLE_SOLID, 3);
   SetIndexStyle(3, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexStyle(4, DRAW_LINE, STYLE_SOLID, 1);
   SetIndexStyle(5, DRAW_LINE, STYLE_SOLID, 3);
   SetIndexStyle(6, DRAW_LINE, STYLE_SOLID, 4);
   SetIndexStyle(7, DRAW_LINE, STYLE_SOLID, 4);
//---- 
   Comment("Strong Level By eng.Waddah Attar www.metaforex.net");
   FixSunday=false;
   for(int i = 0; i <7; i++)
     {
       if (TimeDayOfWeek(iTime(Symbol(),PERIOD_D1,i))==0)
       {
         FixSunday=true;
       }
     }
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("level1");
   ObjectDelete("txtlevel1");
   ObjectDelete("level2");
   ObjectDelete("txtlevel2");
   ObjectDelete("level3");
   ObjectDelete("txtlevel3");
   ObjectDelete("level4");
   ObjectDelete("txtlevel4");
   ObjectDelete("level5");
   ObjectDelete("txtlevel5");
   ObjectDelete("level6");
   ObjectDelete("txtlevel6");
   ObjectDelete("level7");
   ObjectDelete("txtlevel7");
   ObjectDelete("level8");
   ObjectDelete("txtlevel8");
//---- 
   Comment("");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   if(DrawDay) DrawPeriod1();
   if(DrawH4) DrawPeriod2();
   if(DrawWeek) DrawPeriod3();
   if(DrawMonth) DrawPeriod4();

   if (BackTest==false)
   {
     for(int i=1; i < Bars; i++)
     {
       P1Buffer[i]=P1Buffer[0];
       P2Buffer[i]=P2Buffer[0];
       P3Buffer[i]=P3Buffer[0];
       P4Buffer[i]=P4Buffer[0];
       P5Buffer[i]=P5Buffer[0];
       P6Buffer[i]=P6Buffer[0];
       P7Buffer[i]=P7Buffer[0];
       P8Buffer[i]=P8Buffer[0];
     }
   }
   return(0);
  }
  
int DrawPeriod1()
{
   int i, ii, counted_bars = IndicatorCounted();
   double c1, c2, dc;
   string TrendType;
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
       ii = iBarShift(Symbol(), levelPeriod1, Time[i],true);
       if (TimeDayOfWeek(Time[i])==1 && FixSunday==true)
       {
         ii=ii+1;
       }

       if(ii != -1)
         {
           c1 = iClose(Symbol(), levelPeriod1, ii + 1);
           c2 = iClose(Symbol(), levelPeriod1, ii + 2);
           //----
           dc = c1 - c2;
           //----
           if(dc == 0)
             {
               c2 = iClose(Symbol(), levelPeriod1, ii + 3);
             }
           //----
           dc = c1 - c2;
           //----
           if(dc == 0)
             {
               dc = c1;
             }
           //----
           P1Buffer[i] = c1-dc;
           P4Buffer[i] = c1+dc;
           if (P1Buffer[i]<P4Buffer[i])
           {
             TrendType="Day Up                           ";
           }
           else
           {
             TrendType="Day Down                         ";
           }
           SetPrice("level1", Time[i],P1Buffer[i], Red);
           SetText("txtlevel1", TrendType, Time[i], P1Buffer[i], Red);
           
           SetPrice("level4", Time[i],P4Buffer[i], Red);
           SetText("txtlevel4", TrendType, Time[i], P4Buffer[i], Red);
           //----
        }
     }
//----
   return(0);
}

int DrawPeriod2()
{
   int i, ii, counted_bars = IndicatorCounted();
   double c1, c2, dc;
   string TrendType;
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
       ii = iBarShift(Symbol(), levelPeriod2, Time[i],true);

       if(ii != -1)
         {
           c1 = iClose(Symbol(), levelPeriod2, ii + 1);
           c2 = iClose(Symbol(), levelPeriod2, ii + 2);
           //----
           dc = c1 - c2;
           //----
           if(dc == 0)
             {
               c2 = iClose(Symbol(), levelPeriod2, ii + 3);
             }
           //----
           dc = c1 - c2;
           //----
           if(dc == 0)
             {
               dc = c1;
             }
           //----
           P2Buffer[i] = c1-dc;
           P5Buffer[i] = c1+dc;

           if (P2Buffer[i]<P5Buffer[i])
           {
             TrendType="H4 Up                       ";
           }
           else
           {
             TrendType="H4 Down                     ";
           }
           SetPrice("level2", Time[i],P2Buffer[i], Green);
           SetText("txtlevel2", TrendType, Time[i], P2Buffer[i], Green);

           SetPrice("level5", Time[i],P5Buffer[i], Green);
           SetText("txtlevel5", TrendType, Time[i], P5Buffer[i], Green);
           //----
        }
     }
//----
   return(0);
}

int DrawPeriod3()
{
   int i, ii, counted_bars = IndicatorCounted();
   double c1, c2, dc;
   string TrendType;
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
       ii = iBarShift(Symbol(), levelPeriod3, Time[i],true);

       if(ii != -1)
         {
           c1 = iClose(Symbol(), levelPeriod3, ii + 1);
           c2 = iClose(Symbol(), levelPeriod3, ii + 2);
           //----
           dc = c1 - c2;
           //----
           if(dc == 0)
             {
               c2 = iClose(Symbol(), levelPeriod3, ii + 3);
             }
           //----
           dc = c1 - c2;
           //----
           if(dc == 0)
             {
               dc = c1;
             }
           //----
           P3Buffer[i] = c1-dc;
           P6Buffer[i] = c1+dc;

           if (P3Buffer[i]<P6Buffer[i])
           {
             TrendType="Week Up                           ";
           }
           else
           {
             TrendType="Week Down                         ";
           }
           SetPrice("level3", Time[i],P3Buffer[i], Blue);
           SetText("txtlevel3", TrendType, Time[i], P3Buffer[i], Blue);

           SetPrice("level6", Time[i],P6Buffer[i], Blue);
           SetText("txtlevel6", TrendType, Time[i], P6Buffer[i], Blue);
           //----
        }
     }
//----
   return(0);
}
int DrawPeriod4()
{
   int i, ii, counted_bars = IndicatorCounted();
   double c1, c2, dc;
   string TrendType;
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
       ii = iBarShift(Symbol(), levelPeriod4, Time[i],true);

       if(ii != -1)
         {
           c1 = iClose(Symbol(), levelPeriod4, ii + 1);
           c2 = iClose(Symbol(), levelPeriod4, ii + 2);
           //----
           dc = c1 - c2;
           //----
           if(dc == 0)
             {
               c2 = iClose(Symbol(), levelPeriod4, ii + 3);
             }
           //----
           dc = c1 - c2;
           //----
           if(dc == 0)
             {
               dc = c1;
             }
           //----
           P7Buffer[i] = c1-dc;
           P8Buffer[i] = c1+dc;

           if (P7Buffer[i]<P8Buffer[i])
           {
             TrendType="Month Up                           ";
           }
           else
           {
             TrendType="Month Down                         ";
           }
           SetPrice("level7", Time[i],P7Buffer[i], Orange);
           SetText("txtlevel7", TrendType, Time[i], P7Buffer[i], Orange);

           SetPrice("level8", Time[i],P8Buffer[i], Orange);
           SetText("txtlevel8", TrendType, Time[i], P8Buffer[i], Orange);
           //----
        }
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
void SetText(string name,string txt,datetime Tm,double Prc,color clr)
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