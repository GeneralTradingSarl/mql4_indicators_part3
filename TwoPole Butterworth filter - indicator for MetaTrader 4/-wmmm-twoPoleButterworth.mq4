//+------------------------------------------------------------------+
//|                                     -wmmm-twoPoleSuperSmooth.mq4 |
//|                                                           zzuegg |
//|                                       when-money-makes-money.com |
//+------------------------------------------------------------------+
#property copyright "zzuegg"
#property link      "when-money-makes-money.com"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Yellow
#property indicator_color2 Blue
#property indicator_color3 Red
//---- buffers
double filter[];
double up[];
double do1[];
color lc[]={Yellow,Gold,Orange,DarkOrange,OrangeRed,Red,OrangeRed,DarkOrange,Orange,Gold};
extern int CutoffPeriod=15; // Indicator period
extern int Shift=0; 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

double coef1,coef2,coef3,coef4;

int init()
  {
//---- indicators
     ObjectCreate("logo",OBJ_LABEL,0,0,0);
   ObjectSetText("logo","when-money-makes-money.com",20);
   ObjectSet("logo",OBJPROP_XDISTANCE,0);
   ObjectSet("logo",OBJPROP_YDISTANCE,30);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,filter);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,up);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,do1);
   SetIndexEmptyValue(0,0);
//----

   double tempReal= MathArctan(1.0);
   double rad2Deg = 45.0 / tempReal;
   double deg2Rad = 1.0 / rad2Deg;
   double pi = MathArctan(1.0) * 4.0;
   double a1 = MathExp(-MathSqrt(2.0) * pi / CutoffPeriod);
   double b1 = 2 * a1 * MathCos(deg2Rad * MathSqrt(2.0) * 180 / CutoffPeriod);
   coef2 = b1;
   coef3 = -a1 * a1;
   coef1 = (1.0 - b1 + a1 * a1) / 4.0;

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
      ObjectDelete("logo");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+1;
          static int currc=0;
   ObjectSet("logo",OBJPROP_COLOR,lc[currc]);
   currc++;
   if(currc>=ArraySize(lc))currc=0;
//----
   for(int i=limit;i>=0;i--){
      if(i<Bars-3){
         filter[i]=coef1 *(((High[i]+Low[i]) /2)+2.0*((High[i+1]+Low[i+1]) /2) +((High[i+2]+Low[i+2]) /2))+coef2*filter[i+1]+coef3*filter[i+2];
      }else{
         filter[i]=((High[i]+Low[i]) /2);
      }
      if(filter[i]>filter[i+1]){
         up[i]=filter[i];
         up[i+1]=filter[i+1];
      }else{
         do1[i]=filter[i];
         do1[i+1]=filter[i+1];
      }
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+