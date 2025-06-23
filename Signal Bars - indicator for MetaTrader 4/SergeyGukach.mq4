//+------------------------------------------------------------------+
//|                                                  Signal Bars.mq4 |
//+------------------------------------------------------------------+
#property copyright "© Maloma"
//----
#property indicator_chart_window
#property indicator_buffers 6
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_color3 OrangeRed
#property indicator_color4 CornflowerBlue
#property indicator_color5 Magenta
#property indicator_color6 Teal
//---- input parameters
//---- buffers
double dUpFractalsBuffer[];
double dDownFractalsBuffer[];
double dUpSignalBuffer[];
double dDownSignalBuffer[];
double UpDiapazonBuffer[];
double DnDiapazonBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicator buffers mapping  
   SetIndexBuffer(0,dUpFractalsBuffer);
   SetIndexBuffer(1,dDownFractalsBuffer);
   SetIndexBuffer(2,dUpSignalBuffer);
   SetIndexBuffer(3,dDownSignalBuffer);
   SetIndexBuffer(4,UpDiapazonBuffer);
   SetIndexBuffer(5,DnDiapazonBuffer);
//---- drawing settings
   SetIndexStyle(0,DRAW_NONE,EMPTY,2);
   SetIndexArrow(0,119);
   SetIndexStyle(1,DRAW_NONE,EMPTY,2);
   SetIndexArrow(1,119);
   SetIndexStyle(2,DRAW_ARROW,EMPTY,3);
   SetIndexArrow(2,119);
   SetIndexStyle(3,DRAW_ARROW,EMPTY,3);
   SetIndexArrow(3,119);
   SetIndexStyle(4,DRAW_NONE,EMPTY,2);
   SetIndexStyle(5,DRAW_NONE,EMPTY,2);
//----
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   SetIndexEmptyValue(2,0.0);
   SetIndexEmptyValue(3,0.0);
   SetIndexEmptyValue(4,0.0);
   SetIndexEmptyValue(5,0.0);
//---- name for DataWindow
   SetIndexLabel(0,"Fractal Up");
   SetIndexLabel(1,"Fractal Down");
   SetIndexLabel(2,"Signal Up");
   SetIndexLabel(3,"Signal Down");
   SetIndexLabel(4,"Diapazon Up");
   SetIndexLabel(5,"Diapazon Down");
//---- initialization done   
   IndicatorShortName("F5S");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
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
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int i=Bars-counted_bars;
   if(counted_bars==0) i-=1+5;
///----
   while(i>=0)
     {
      //----Up and Down Fractals
      //----5 bars Fractal
      if(High[i+3]>High[i+3+1] && High[i+3]>High[i+3+2] && High[i+3]>High[i+3-1] && High[i+3]>High[i+3-2])
        {
         dUpSignalBuffer[i]=Open[i+1];
         dUpFractalsBuffer[i+3]=High[i+3];
         UpDiapazonBuffer[i]=Open[i];
         UpDiapazonBuffer[i+3]=High[i+3];
        }
      if(Low[i+3]<Low[i+3+1] && Low[i+3]<Low[i+3+2] && Low[i+3]<Low[i+3-1] && Low[i+3]<Low[i+3-2])
        {
         dDownSignalBuffer[i]=Open[i+1];
         dDownFractalsBuffer[i+3]=Low[i+3];
         DnDiapazonBuffer[i]=Open[i];
         DnDiapazonBuffer[i+3]=Low[i+3];
         i--;
         continue;
        }
      //----6 bars Fractal
      if(High[i+3]==High[i+3+1] && High[i+3]>High[i+3+2] && High[i+3]>High[i+3+3] && High[i+3]>High[i+3-1] && High[i+3]>High[i+3-2])
        {
         dUpSignalBuffer[i]=Open[i+1];
         dUpFractalsBuffer[i+3]=High[i+3];
         UpDiapazonBuffer[i]=Open[i];
         UpDiapazonBuffer[i+3]=High[i+3];
        }
      if(Low[i+3]==Low[i+3+1] && Low[i+3]<Low[i+3+2] && Low[i+3]<Low[i+3+3] && Low[i+3]<Low[i+3-1] && Low[i+3]<Low[i+3-2])
        {
         dDownSignalBuffer[i]=Open[i+1];
         dDownFractalsBuffer[i+3]=Low[i+3];
         DnDiapazonBuffer[i]=Open[i];
         DnDiapazonBuffer[i+3]=Low[i+3];
         i--;
         continue;
        }
      //----7 bars Fractal
      if(High[i+3]>=High[i+3+1] && High[i+3]==High[i+3+2] && High[i+3]>High[i+3+3] && High[i+3]>High[i+3+4] && High[i+3]>High[i+3-1] && 
         High[i+3]>High[i+3-2])
        {
         dUpSignalBuffer[i]=Open[i+1];
         dUpFractalsBuffer[i+3]=High[i+3];
         UpDiapazonBuffer[i]=Open[i];
         UpDiapazonBuffer[i+3]=High[i+3];
        }
      if(Low[i+3]<=Low[i+3+1] && Low[i+3]==Low[i+3+2] && Low[i+3]<Low[i+3+3] && Low[i+3]<Low[i+3+4] && Low[i+3]<Low[i+3-1] && 
         Low[i+3]<Low[i+3-2])
        {
         dDownSignalBuffer[i]=Open[i+1];
         dDownFractalsBuffer[i+3]=Low[i+3];
         DnDiapazonBuffer[i]=Open[i];
         DnDiapazonBuffer[i+3]=Low[i+3];
         i--;
         continue;
        }
      //----8 bars Fractal                          
      if(High[i+3]>=High[i+3+1] && High[i+3]==High[i+3+2] && High[i+3]==High[i+3+3] && High[i+3]>High[i+3+4] && High[i+3]>High[i+3+5] && 
         High[i+3]>High[i+3-1] && High[i+3]>High[i+3-2])
        {
         dUpSignalBuffer[i]=Open[i+1];
         dUpFractalsBuffer[i+3]=High[i+3];
         UpDiapazonBuffer[i]=Open[i];
         UpDiapazonBuffer[i+3]=High[i+3];
        }
      if(Low[i+3]<=Low[i+3+1] && Low[i+3]==Low[i+3+2] && Low[i+3]==Low[i+3+3] && Low[i+3]<Low[i+3+4] && Low[i+3]<Low[i+3+5] && 
         Low[i+3]<Low[i+3-1] && Low[i+3]<Low[i+3-2])
        {
         dDownSignalBuffer[i]=Open[i+1];
         dDownFractalsBuffer[i+3]=Low[i+3];
         DnDiapazonBuffer[i]=Open[i];
         DnDiapazonBuffer[i+3]=Low[i+3];
         i--;
         continue;
        }
      //----9 bars Fractal                                        
      if(High[i+3]>=High[i+3+1] && High[i+3]==High[i+3+2] && High[i+3]>=High[i+3+3] && High[i+3]==High[i+3+4] && High[i+3]>High[i+3+5] && 
         High[i+3]>High[i+3+6] && High[i+3]>High[i+3-1] && High[i+3]>High[i+3-2])
        {
         dUpSignalBuffer[i]=Open[i+1];
         dUpFractalsBuffer[i+3]=High[i+3];
         UpDiapazonBuffer[i]=Open[i];
         UpDiapazonBuffer[i+3]=High[i+3];
        }
      if(Low[i+3]<=Low[i+3+1] && Low[i+3]==Low[i+3+2] && Low[i+3]<=Low[i+3+3] && Low[i+3]==Low[i+3+4] && Low[i+3]<Low[i+3+5] && 
         Low[i+3]<Low[i+3+6] && Low[i+3]<Low[i+3-1] && Low[i+3]<Low[i+3-2])
        {
         dDownSignalBuffer[i]=Open[i+1];
         dDownFractalsBuffer[i+3]=Low[i+3];
         DnDiapazonBuffer[i]=Open[i];
         DnDiapazonBuffer[i+3]=Low[i+3];
         i--;
         continue;
        }
      i--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
