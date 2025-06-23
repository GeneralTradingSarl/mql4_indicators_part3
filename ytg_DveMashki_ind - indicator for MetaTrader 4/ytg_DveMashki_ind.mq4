//+------------------------------------------------------------------+
//|                                            ytg_DveMashki_ind.mq4 |
//|                                                     Yuriy Tokman |
//|                                            yuriytokman@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman"
#property link      "yuriytokman@gmail.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Lime
#property indicator_color2 Red
#property indicator_width1 6
#property indicator_width2 6
//----
extern color color1 = Lime;
extern color color2 = Red;
extern int ma_1 = 25;
extern int ma_2 = 50;
extern int method = 0;
extern int price = 0;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
//----
int ExtCountedBars=0;
//\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n
int init()
  {
  string char[256]; int i;
  for (i = 0; i < 256; i++) char[i] = CharToStr(i);
  string txt =  
  char[121]+char[117]+char[114]+char[105]+char[121]+char[116]+char[111]
  +char[107]+char[109]+char[97]+char[110]+char[64]+char[103]+char[109]
  +char[97]+char[105]+char[108]+char[46]+char[99]+char[111]+char[109];
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM, 0, 6, color1);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM, 0, 6, color2);
   SetIndexBuffer(1, ExtMapBuffer2);
   IndicatorShortName(txt);
   SetIndexLabel(0,txt);
   SetIndexLabel(1,txt);   
//----
   SetIndexDrawBegin(0,10);
   SetIndexDrawBegin(1,10);
//---- indicator buffers mapping
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexBuffer(1,ExtMapBuffer2);
     
Comment("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n  "+txt);

   return(0);
  }
//\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n
int start()
  {
   if(Bars<=10) return(0);
   ExtCountedBars=IndicatorCounted();
//---- check for possible errors
   if (ExtCountedBars<0) return(-1);
//---- last counted bar will be recounted
   if (ExtCountedBars>0) ExtCountedBars--;
   int pos=Bars-ExtCountedBars-1;
   while(pos>=0)
     { 
      ExtMapBuffer1[pos]=iMA(Symbol(),0,ma_1,0,method,price,pos);
      ExtMapBuffer2[pos]=iMA(Symbol(),0,ma_2,0,method,price,pos);
 	   pos--;
     }
//----
   return(0);
  }
//\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nn\n\n\n\n\n\n\n\n\n\n\n