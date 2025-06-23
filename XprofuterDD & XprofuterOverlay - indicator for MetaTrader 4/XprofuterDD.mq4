//+------------------------------------------------------------------+
//|                                                                  |
//|                 Filename:    XprofuterDD.mq4                     |
//|                                                                  |
//+------------------------------------------------------------------+
#property indicator_separate_window
#property indicator_buffers 3
//----
#property indicator_color1  Red
#property indicator_color2  Green
#property indicator_color3  DodgerBlue
//----
extern int per       =14;  // Period for signal
extern int drawShift =14;  // Forward shift
extern int useMA     =0;   // 1 = use MA
extern int maPeriod  =34;  // Moving average period
extern int useSignal2=0;   // Show current close - open shifted forward
// Buffers for signals
double ExtMapBuffer[];
double maBuffer[];
double closeBuffer[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  int init() 
  {
   string title="XProfuter(" + (string)per + ")";
   // Signal and MA are normal lines
   SetIndexStyle(0, DRAW_LINE);
   SetIndexBuffer(0, ExtMapBuffer);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexBuffer(1, maBuffer);
   // Signal2 is a dotted line
   SetIndexStyle(2, DRAW_LINE, 2, 1);
   SetIndexBuffer(2, closeBuffer);
   // Shift everything forward
   SetIndexShift(0, drawShift);
   SetIndexShift(1, drawShift);
   SetIndexShift(2, drawShift);
   // Titles for each line
   SetIndexLabel(0, "Signal(" + (string)per + ")");
   SetIndexLabel(1, "MA(" + (string)maPeriod + ")");
   SetIndexLabel(2, "Signal2(" + (string)per + ")");
//----
     if(useMA==1) 
     {
      title=title + " MA(" + (string)maPeriod + ")";
     }
   IndicatorShortName(title);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  int start() 
  {
   int    counted_bars=IndicatorCounted();
   int    shift, i, limit, lim;
   double imp;
   // This is to make sure we go back and update bars that have already been drawn.
   // This was missing in the original release. If it's not done the live signal line
   // will be the same as Signal2.
     if(counted_bars > per) 
     {
      limit=Bars - counted_bars + per;
      }
       else 
      {
      limit=Bars - 1;
     }
   // Loop through and calculate the signals. Everytime this runs we recalculate the
   // current and all future signals. The future is not set :)
     for(shift=limit; shift>=0; shift--) 
     {
      imp=0;
      // This isn't really needed but makes sure we don't look for future,
      // non-existant open and close points. It's just proper coding. You never know
      // how a program will handle variables that don't exist. MT4 currently sets them
      // to zero but you don't know if that will change.
        if(shift - per < 0) 
        {
         lim=0;
         }
          else 
         {
         lim=shift - per;
        }
      // Calculate the signal
        for(i=shift; i>=lim; i--) 
        {
         imp=imp + (Close[i] - Open[i])/Point;
        }
      ExtMapBuffer[shift]=imp;
      // If Signal2 is being used set it.
        if(useSignal2==1) 
        {
         closeBuffer[i]=(Close[i] - Open[i])/Point;
        }
     }
   // If we're using the MA calculate it.
     if(useMA==1) 
     {
        for(shift=Bars - counted_bars - 1; shift>=0; shift--) 
        {
           if(shift < Bars - maPeriod && shift < Bars - per) 
           {
            maBuffer[shift]=iMAOnArray(ExtMapBuffer, 0, maPeriod, 0, MODE_SMA, shift);
           }
        }
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+