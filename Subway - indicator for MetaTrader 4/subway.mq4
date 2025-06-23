//+------------------------------------------------------------------+
//|                                                       Subway.mq4 |
//|                                               Yuriy Tokman (YTG) |
//|                                               http://ytg.com.ua/ |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman (YTG)"
#property link      "http://ytg.com.ua/"
#property version   "1.00"
#property strict
#property indicator_chart_window

#property indicator_buffers 8
#property indicator_color1 Green
#property indicator_color2 Blue
#property indicator_color3 Red
#property indicator_color4 Red
#property indicator_color5 Red
#property indicator_color6 Red
#property indicator_color7 Red
#property indicator_color8 Red
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum LM
  {
   Model_1=1,
   Model_2=2,
   Model_3=3,
   Model_4=4,
  };

input  LM        Level_Model=1;
extern int       MA_1=24;
extern int       MA_2=28;

double E0[];
double E1[];
double E2[];
double E3[];
double E4[];
double E5[];
double E6[];
double E7[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,E0);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,E1);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,E2);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,E3);
   SetIndexStyle(4,DRAW_LINE);
   SetIndexBuffer(4,E4);
   SetIndexStyle(5,DRAW_LINE);
   SetIndexBuffer(5,E5);
   SetIndexStyle(6,DRAW_LINE);
   SetIndexBuffer(6,E6);
   SetIndexStyle(7,DRAW_LINE);
   SetIndexBuffer(7,E7);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   int limit=rates_total-prev_calculated;
   if(prev_calculated==0)limit--;
   else  limit++;
   double hi=0,lo=0,ce=0;
   for(int i=0; i<limit && !IsStopped(); i++)
     {
      //----
      E0[i]=iMA(NULL,0,MA_1,0,MODE_EMA,PRICE_CLOSE,i);
      E1[i]=iMA(NULL,0,MA_2,0,MODE_EMA,PRICE_CLOSE,i);

      //Model #1 89,144,233
      if(Level_Model==1)
        {
         E2[i]=E1[i]+89*GetPoint();
         E3[i]=E1[i]+144*GetPoint();
         E4[i]=E1[i]+233*GetPoint();

         E5[i]=E1[i]-89*GetPoint();
         E6[i]=E1[i]-144*GetPoint();
         E7[i]=E1[i]-233*GetPoint();
        }

      //Model #2 144,233,377
      if(Level_Model==2)
        {
         E2[i]=E1[i]+144*GetPoint();
         E3[i]=E1[i]+233*GetPoint();
         E4[i]=E1[i]+377*GetPoint();

         E5[i]=E1[i]-144*GetPoint();
         E6[i]=E1[i]-233*GetPoint();
         E7[i]=E1[i]-377*GetPoint();
        }

      //Model #3 233,377,610
      if(Level_Model==3)
        {
         E2[i]=E1[i]+233*GetPoint();
         E3[i]=E1[i]+377*GetPoint();
         E4[i]=E1[i]+610*GetPoint();

         E5[i]=E1[i]-233*GetPoint();
         E6[i]=E1[i]-377*GetPoint();
         E7[i]=E1[i]-610*GetPoint();
        }

      //Model #4 377,610,987
      if(Level_Model==4)
        {
         E2[i]=E1[i]+377*GetPoint();
         E3[i]=E1[i]+610*GetPoint();
         E4[i]=E1[i]+987*GetPoint();

         E5[i]=E1[i]-377*GetPoint();
         E6[i]=E1[i]-610*GetPoint();
         E7[i]=E1[i]-987*GetPoint();
        }

      Comment("\nLevel_Model #",Level_Model,"\n\nEMA_1 - ",DoubleToStr(E0[0],Digits),"\nEMA_2 - ",DoubleToStr(E1[0],Digits),
              "\n\nL+1 - ",DoubleToStr(E2[0],Digits),"\nL+2 - ",DoubleToStr(E3[0],Digits),
              "\nL+3 - ",DoubleToStr(E4[0],Digits),"\n\nL-1 - ",DoubleToStr(E5[0],Digits),
              "\nL-2 - ",DoubleToStr(E6[0],Digits),"\nL-3 - ",DoubleToStr(E7[0],Digits));
      //----
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
double GetPoint()
  {
   int vres= StringFind(Symbol(),"JPY");
   if(vres == -1) return(0.0001);
   return(0.01);
  }
//+------------------------------------------------------------------+
