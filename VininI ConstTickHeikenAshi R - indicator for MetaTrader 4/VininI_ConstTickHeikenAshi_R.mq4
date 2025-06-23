//+------------------------------------------------------------------+
//|                                 VininI ConstTickHeikenAshi R.mq4 |
//|                      Copyright © 2008, Victor Nicolaev aka Vinin |
//|                                            e-mail: vinin@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, Victor Nicolaev aka Vinin"
#property link      "e-mail: vinin@mail.ru"

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 clrRed
#property indicator_color2 clrWhite
#property indicator_color3 clrRed
#property indicator_color4 clrWhite
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 2
#property indicator_width4 2

//----
extern int TickCount=100;
extern bool DrawAll=false;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
//----
int ExtCountedBars=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//|------------------------------------------------------------------|
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM, 0, 1);
   SetIndexBuffer(0, ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM, 0, 1);
   SetIndexBuffer(1, ExtMapBuffer2);
   SetIndexStyle(2,DRAW_HISTOGRAM, 0, 2);
   SetIndexBuffer(2, ExtMapBuffer3);
   SetIndexStyle(3,DRAW_HISTOGRAM, 0, 2);
   SetIndexBuffer(3, ExtMapBuffer4);


   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexBuffer(3,ExtMapBuffer4);
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
   if(Period()>PERIOD_D1) return(0);
   double haOpen, haHigh, haLow, haClose;
   double _Open, _High, _Low, _Close;
   int shift;
   if(Bars<=10) return(0);
   ExtCountedBars=IndicatorCounted();
//---- check for possible errors
   if (ExtCountedBars<0) return(-1);
//---- last counted bar will be recounted
   int i,pos=Bars-ExtCountedBars-3;
   if (ExtCountedBars==0) pos-=2;
   while(pos>=0){
      fPrice(pos, _Open, _High, _Low, _Close);
      shift=iCustom(NULL,0,"VininI ConstTickPriceM",TickCount,4,pos);
      haOpen=(ExtMapBuffer3[pos+shift+1]+ExtMapBuffer4[pos+shift+1])/2;
      haClose=(_High+_Low+_Close)/3;
      haHigh=MathMax(_High, MathMax(haOpen, haClose));
      haLow=MathMin(_Low, MathMin(haOpen, haClose));
      if (haOpen<haClose) 
        {
         ExtMapBuffer1[pos]=haLow;
         ExtMapBuffer2[pos]=haHigh;
        } 
      else
        {
         ExtMapBuffer1[pos]=haHigh;
         ExtMapBuffer2[pos]=haLow;
        } 
      ExtMapBuffer3[pos]=haOpen;
      ExtMapBuffer4[pos]=haClose;

      if (!DrawAll) {
         for (i=1;i<=shift;i++) {
            ExtMapBuffer1[pos+i]=ExtMapBuffer1[pos];
            ExtMapBuffer2[pos+i]=ExtMapBuffer2[pos];
            ExtMapBuffer3[pos+i]=ExtMapBuffer3[pos];
            ExtMapBuffer4[pos+i]=ExtMapBuffer4[pos];
         }
      }
      pos--;
   }

//----
   return(0);
  }
//+------------------------------------------------------------------+

void fPrice(int pos, double &_Open, double &_High, double &_Low, double &_Close){
   _Open =iCustom(NULL,0,"VininI ConstTickPriceM",TickCount,0,pos);
   _High =iCustom(NULL,0,"VininI ConstTickPriceM",TickCount,1,pos);
   _Low  =iCustom(NULL,0,"VininI ConstTickPriceM",TickCount,2,pos);
   _Close=iCustom(NULL,0,"VininI ConstTickPriceM",TickCount,3,pos);
}