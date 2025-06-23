//+------------------------------------------------------------------+
//|                                         Waddah_Attar_Def_RSI.mq4 |
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
extern int RSIPeriod1=14;
extern int RSIPeriod2=28;

double   ind_buffer1[];
double   MABuffer1[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 2);
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 2);
//----   
   SetIndexBuffer(0, ind_buffer1);
   SetIndexBuffer(1, MABuffer1);
//----   
   IndicatorShortName("Waddah Attar Def RSI");
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
   double RSI1,RSI2,Explo;

   int  limit, i, counted_bars = IndicatorCounted();
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
     RSI1 = iRSI(NULL, 0, RSIPeriod1, PRICE_CLOSE, i);
     RSI2 = iRSI(NULL, 0, RSIPeriod2, PRICE_CLOSE, i);

     MABuffer1[i] = (RSI1-RSI2);
   }

   for(i = 0; i < Bars; i++)
   {
     ind_buffer1[i] = iMAOnArray(MABuffer1,0,14,0,MODE_SMA,i);
   }

   for(i = 0; i < Bars; i++)
   {
     MABuffer1[i]=0;
   }

   return(0);
}
//+------------------------------------------------------------------+


