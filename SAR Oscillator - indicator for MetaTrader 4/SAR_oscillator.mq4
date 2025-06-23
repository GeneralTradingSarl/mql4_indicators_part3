//+------------------------------------------------------------------+
//|                                               SAR Oscillator.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2004, MetaQuotes Software Corp."
#property  link      "http://www.metaquotes.net/"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 5
#property  indicator_color1  Green
#property  indicator_color2 Green
#property  indicator_color3  Red
#property  indicator_color4  Red
#property  indicator_color5  Black

//#property  indicator_level1  0.0003
//#property  indicator_level2  -0.0003

//---- indicator buffers
extern double pas=0.02;
extern double max=0.2;

double     ind_buffer1[],ind_buffer1s[];
double     ind_buffer2[],ind_buffer2s[];
double     ind_buffer3[];
double fastcci[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- 1 additional buffer used for counting.
   IndicatorBuffers(6);
//---- drawing settings
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,2);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,1);
   SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_SOLID,2);
   SetIndexStyle(3,DRAW_HISTOGRAM,STYLE_SOLID,1);
   SetIndexStyle(4,DRAW_LINE,0,2);
//---- 3 indicator buffers mapping
   SetIndexBuffer(0,ind_buffer1);
   SetIndexBuffer(1,ind_buffer1s);
   SetIndexBuffer(2,ind_buffer2);
   SetIndexBuffer(3,ind_buffer2s);
   SetIndexBuffer(4,ind_buffer3);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName(" SAR Oscillator");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| SAR Oscillator                                                   |
//+------------------------------------------------------------------+
int start()
  {
   double prev,current;

   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=2;

//---- macd counted in the 1-st additional buffer
   for(int i=0; i<limit; i++)
     {
      ind_buffer3[i]=Close[i]-iSAR(NULL,0,pas,max,i);
     }

//---- dispatch values between 2 buffers
   bool up=true;
   for(i=limit; i>=0; i--)
     {
      current=ind_buffer3[i];
      prev=ind_buffer3[i+1];
      if(((current<0)&&(prev>0))||(current<0))   up= false;
      if(((current>0)&&(prev<0))||(current>0))   up= true;

      if(!up)
        {
         if(current>prev)
           {
            ind_buffer2s[i]=current;
            ind_buffer2[i]=0.0;
            ind_buffer1[i]=0.0;
            ind_buffer1s[i]=0.0;
           }
         else
           {
            ind_buffer2[i]=current;
            ind_buffer2s[i]=0.0;
            ind_buffer1[i]=0.0;
            ind_buffer1s[i]=0.0;
           }
        }
      else
        {
         if(current<prev)
           {
            ind_buffer1s[i]=current;
            ind_buffer1[i]=0.0;
            ind_buffer2[i]=0.0;
            ind_buffer2s[i]=0.0;
           }
         else
           {
            ind_buffer1[i]=current;
            ind_buffer1s[i]=0.0;
            ind_buffer2[i]=0.0;
            ind_buffer2s[i]=0.0;
           }
        }
     }
//---- done
   return(0);
  }
//+------------------------------------------------------------------+
