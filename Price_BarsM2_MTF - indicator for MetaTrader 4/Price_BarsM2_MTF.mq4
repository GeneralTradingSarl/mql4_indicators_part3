//+------------------------------------------------------------------+
//|                                                   Price_MTF .mq4 |
//|                                      Copyright © 2006, Keris2112 |
//| 2008forextsd    ki                                        pubilc |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, Keris2112"
#property link   "public" // Keris f-la; IgorAd Mladen; KI put together :)
//----
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Red     
#property indicator_color2 DodgerBlue 
#property indicator_color3 Red     
#property indicator_color4 DodgerBlue 
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 5
#property indicator_width4 5
//----
extern int TimeFrame=60;
extern int Shift=0;
extern int xShift=0;
extern bool SetShift0ToTFBarCloseTime=true;
extern bool ShowMultipleBars= false;
extern int MaxBarsToCount   = 1500;
extern string note_timeFrames="M1;5,15,30,60H1;240H4;1440D1;10080W1;43200MN";
//---- 
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
int ShiftToBarClose;
datetime TimeArray[];
//+------------------------------------------------------------------+
int init()
  {
//---- 
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexStyle(3,DRAW_HISTOGRAM);
//----      
   if(TimeFrame==0) TimeFrame=Period();
   if(SetShift0ToTFBarCloseTime)ShiftToBarClose=TimeFrame/Period()-1;
//----  
   SetIndexShift(0,Shift+xShift*TimeFrame/Period()+ShiftToBarClose);
   SetIndexShift(1,Shift+xShift*TimeFrame/Period()+ShiftToBarClose);
   SetIndexShift(2,Shift+xShift*TimeFrame/Period()+ShiftToBarClose);
   SetIndexShift(3,Shift+xShift*TimeFrame/Period()+ShiftToBarClose);
//----  
   switch(TimeFrame)
     {
      case 1 : string TimeFrameStr="M1";  break;
      case 5 : TimeFrameStr="M5";  break;
      case 15 : TimeFrameStr=       "M15"; break;
      case 30 : TimeFrameStr=       "M30"; break;
      case 60 : TimeFrameStr=       "H1";  break;
      case 240 : TimeFrameStr="H4";  break;
      case 1440 : TimeFrameStr="D1";  break;
      case 10080 : TimeFrameStr=    "W1";  break;
      case 43200 : TimeFrameStr=    "MN1"; break;
      default : TimeFrameStr="TF0";
     }
   IndicatorShortName("Price ["+TimeFrameStr+"]");
   if(TimeFrame<Period()) TimeFrame=Period();
//----   
   return(0);
  }
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
int start()
  {
   double open,close,high,low;
   int    i,y=0;
//---- 
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+TimeFrame/Period();

   ArrayCopySeries(TimeArray,MODE_TIME,Symbol(),TimeFrame);
//----
   for(i=0,y=0;i<limit;i++)
     {
      if(y<ArraySize(TimeArray)) {if(Time[i]<TimeArray[y]) y++;}
      //---- 
      open = iOpen (NULL,TimeFrame,y);
      close= iClose(NULL,TimeFrame,y);
      high = iHigh (NULL,TimeFrame,y);
      low  = iLow  (NULL,TimeFrame,y);
      if(!ShowMultipleBars)
        {

         if(y<ArraySize(TimeArray))
           {
            if(Time[i]==TimeArray[y])
              {
               if(open<close)
                 {
                  ExtMapBuffer1[i]=low;
                  ExtMapBuffer2[i]=high;
                 }
               else
                 {
                  ExtMapBuffer1[i]=high;
                  ExtMapBuffer2[i]=low;
                 }
               ExtMapBuffer3[i]=open;
               ExtMapBuffer4[i]=close;
              }
           }
        }
      else
        {
         if(open<close)
           {
            ExtMapBuffer1[i]=low;
            ExtMapBuffer2[i]=high;
           }
         else
           {
            ExtMapBuffer1[i]=high;
            ExtMapBuffer2[i]=low;
           }
         ExtMapBuffer3[i]=open;
         ExtMapBuffer4[i]=close;
        }
     }
//----  
   return(0);
  }
//+------------------------------------------------------------------+
