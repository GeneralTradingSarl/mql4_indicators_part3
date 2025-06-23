//+------------------------------------------------------------------+
//|                                         WelchCandlesticks_v2.mq4 |
//|                                 Copyright 2013, Timothy A. Welch |
//|                                     http://www.timothy-welch.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, Timothy A. Welch"
#property link      "http://www.timwel.ch"

#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Tomato
#property indicator_color2 White
#property indicator_color3 Tomato
#property indicator_color4 White
#property indicator_color5 Lime
#property indicator_color6 Lime
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 3
#property indicator_width4 3
#property indicator_width5 1
#property indicator_width6 1

//----
extern color color1 = Tomato;
extern color color2 = White;
extern color color3 = Tomato;
extern color color4 = White;
extern color color5 = Lime;
extern color color6 = Lime;

//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];

double tHigh[];
double tLow[];

//----
int ExtCountedBars=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//|------------------------------------------------------------------|
int init()
  {
   IndicatorBuffers(8);
   SetIndexBuffer(6,tHigh);
   SetIndexBuffer(7,tLow);
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM, 0, 1, color1);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM, 0, 1, color2);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexStyle(2,DRAW_HISTOGRAM, 0, 3, color3);
   SetIndexBuffer(2, ExtMapBuffer3);
   SetIndexStyle(3,DRAW_HISTOGRAM, 0, 3, color4);
   SetIndexBuffer(3, ExtMapBuffer4);
   SetIndexStyle(4,DRAW_HISTOGRAM, 0, 1, color5);
   SetIndexBuffer(4, ExtMapBuffer5);
   SetIndexStyle(5,DRAW_HISTOGRAM, 0, 1, color6);
   SetIndexBuffer(5, ExtMapBuffer6);
//----
   SetIndexDrawBegin(0,10);
   SetIndexDrawBegin(1,10);
   SetIndexDrawBegin(2,10);
   SetIndexDrawBegin(3,10);
   SetIndexDrawBegin(4,10);
   SetIndexDrawBegin(5,10);
//---- indicator buffers mapping
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexBuffer(4,ExtMapBuffer5);
   SetIndexBuffer(5,ExtMapBuffer6);
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   double haOpen, haHigh, haLow, haClose;
   if(Bars<=10) return(0);
   ExtCountedBars=IndicatorCounted();
//---- check for possible errors
   if (ExtCountedBars<0) return(-1);
//---- last counted bar will be recounted
//   if (ExtCountedBars>0) ExtCountedBars--;
   int pos=Bars-ExtCountedBars-1;
   
   // If we have not counted any bars yet, let's zero out all values of tHigh and tLow
   if (ExtCountedBars<1) {
      for (int i=0; i<Bars; i++) { tHigh[i]=EMPTY_VALUE; tLow[i]=EMPTY_VALUE; }
   }
   
   while(pos>=0)
     {
      
      // Let's add in the spread for the current bar, which should give us a more accurate
      // depiction of the REAL price movement for this candle.  Rather than the averaged
      // price that is sent to MT4 to create the candlestick.  This should eliminate some
      // false stop losses, in theory.
      if (pos == 0) {
         double tSpread = MarketInfo(Symbol(), MODE_SPREAD)*Point;

         if (tHigh[pos]==EMPTY_VALUE) { haHigh = High[pos]; } else { haHigh = tHigh[pos]; }
         if (tLow[pos]==EMPTY_VALUE) { haLow = Low[pos]; } else {haLow = tLow[pos]; }        
         
         if (Ask > haHigh) {
            haHigh=Ask;
         }

         if (Bid < haLow) {
            haLow = Bid;
         } 
         
         // Set our high/low buffers to the current max high of the candle
         // so that we can use them in redrawing (if that's necessary) the
         // rest of the candles down the line. Or at least using these values
         // for other indicators to pull from. ;-)
         tHigh[pos] = haHigh;
         tLow[pos] = haLow;
      } else {
      
         // If our tHigh and tLow buffers have data in them, use them
         // otherwise default to showing the High/Low which do not 
         // contain accurate data...
         if (tHigh[pos]==EMPTY_VALUE) {
            haHigh = High[pos];
         } else {
            haHigh = tHigh[pos];
         }
         
         if (tLow[pos]==EMPTY_VALUE) {
            haLow = Low[pos];
         } else {
            haLow = tLow[pos];
         }
      }

      haOpen=Open[pos];
      haClose=Close[pos];

      if (haOpen<haClose) 
        {
            ExtMapBuffer1[pos]=Low[pos];
            ExtMapBuffer2[pos]=High[pos];
        } 
      else
        {
            ExtMapBuffer1[pos]=High[pos];
            ExtMapBuffer2[pos]=Low[pos];
        } 
      ExtMapBuffer3[pos]=haOpen;
      ExtMapBuffer4[pos]=haClose;
      
      // Show me the spread differential in the High / Ask
      ExtMapBuffer5[pos]=High[pos];
      ExtMapBuffer6[pos]=tHigh[pos];
      
 	   pos--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+