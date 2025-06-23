//+------------------------------------------------------------------+
//|                                           Waddah_Attar_Trend.mq4 |
//|                              Copyright © 2007, Eng. Waddah Attar |
//|                                          waddahattar@hotmail.com |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2007, Eng. Waddah Attar"
#property  link      "waddahattar@hotmail.com"
//----
#property  indicator_separate_window
#property  indicator_buffers 2
#property  indicator_color1  Green
#property  indicator_color2  Red
//----
double   ind_buffer1[];
double   ind_buffer2[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID, 2);
   SetIndexStyle(1, DRAW_HISTOGRAM, STYLE_SOLID, 2);
//----   
   SetIndexBuffer(0, ind_buffer1);
   SetIndexBuffer(1, ind_buffer2);
//----   
   IndicatorShortName("Waddah Attar Trend");
   Comment("copyright waddahwttar@hotmail.com");
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   Comment("");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   double Trend,Explo,val;
   int    limit, i, counted_bars = IndicatorCounted();
//----
   if(counted_bars < 0) 
       return(-1);
//----
   if(counted_bars > 0) 
       counted_bars--;
   limit = Bars - counted_bars;
//----
   for(i = limit - 1; i >= 0; i--)
     {
       Trend = (iMACD(NULL, 0, 20, 40, 9, PRICE_CLOSE, MODE_MAIN, i) - 
                iMACD(NULL, 0, 20, 40, 9, PRICE_CLOSE, MODE_MAIN, i + 1)) / Point;
       Explo = (iBands(NULL, 0, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, i) - 
                iBands(NULL, 0, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, i)) / Point;
       ind_buffer1[i] = 0;
       ind_buffer2[i] = 0;
       val=Trend*Explo;
       if(val >= 0)
           ind_buffer1[i] = val;
       if(val < 0)
           ind_buffer2[i] = val;
     }
   return(0);
  }
//+------------------------------------------------------------------+


