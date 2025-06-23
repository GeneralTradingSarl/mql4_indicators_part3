#property link      "http://www.metaquotes.net"
#property copyright "Copyright © 2015 Matus German, www.mtexperts.net"
#property version   "1.1" 

#property indicator_separate_window

#property indicator_buffers 4               // Number of buffers
#property indicator_color2 Green
#property indicator_color3 Red
#property indicator_color4 Yellow

extern int UpDown_Period = 20;
extern int Average_Period = 10;
extern ENUM_MA_METHOD Average_Method = MODE_SMA;

double UpDown[], Down[], Up[], Average[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
    SetIndexBuffer(0,UpDown);
    SetIndexStyle (0,DRAW_NONE);
    SetIndexBuffer(1,Up);
    SetIndexStyle (1,DRAW_HISTOGRAM);
    SetIndexBuffer(2,Down);
    SetIndexStyle (2,DRAW_HISTOGRAM);
    SetIndexBuffer(3,Average);
    SetIndexStyle (3,DRAW_LINE);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   if(Bars<=UpDown_Period+Average_Period) return(0);
   
   int i;
   int    counted_bars=IndicatorCounted();
   
   double bar, ups, downs, upsDivide, downsDivide;
   int upsCount, downsCount;
   
   int limit=Bars-counted_bars;
   limit-=UpDown_Period;
//---- macd counted in the 1-st buffer
   for(i=0; i<limit; i++)
   {
      ups = 0;
      downs = 0;
      bar = 0;
      upsCount = 0;
      downsCount = 0;
      upsDivide=0;
      downsDivide=0;
      for(int j=UpDown_Period;j>=0;j--)
      {
         bar=(Close[i+j]-Open[i+j])*100000;
         if(bar>0)
         {
            ups+=(MathSqrt(bar)*((UpDown_Period+1-j)));
            upsCount++;
         }
         if(bar<0)
         {
            downs+=(MathSqrt(-bar)*((UpDown_Period+1-j)));
            downsCount++;
         }
      }
      if(upsCount!=0)
         upsDivide = ups/upsCount;
         
      if(downsCount!=0)
         downsDivide = downs/downsCount;
         
      UpDown[i]=NormalizeDouble(((upsDivide)-(downsDivide)),3);
      if(UpDown[i]>=0)
      {
         Up[i]=UpDown[i];
         Down[i]=EMPTY_VALUE;
      }
      if(UpDown[i]<0)
      {
         Up[i]=EMPTY_VALUE;
         Down[i]=UpDown[i];
      }
   }
   
   for(i=0; i<limit; i++)
   {
      Average[i]=iMAOnArray(UpDown,Bars,Average_Period,0, Average_Method,i);
   }
   return(0);
}
//+------------------------------------------------------------------+