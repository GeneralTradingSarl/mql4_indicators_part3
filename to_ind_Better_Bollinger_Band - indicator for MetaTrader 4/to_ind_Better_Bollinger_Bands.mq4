//+------------------------------------------------------------------+
//|                                to_ind_Better_Bollinger_Bands.mq4 |
//|                                                                * |
//|                                                                * |
//+------------------------------------------------------------------+
#property copyright "http://dmffx.com"
#property link      "http://dmffx.com"
//----
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Red
#property indicator_color2 Red
#property indicator_color3 Red
//---- input parameters
extern int       Periods=20;
extern double    Devs=2;
extern int       Price=1;
//---- buffers
double mt[];
double ut[];
double mt2[];
double ut2[];
double but[];
double blt[];
double bct[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   IndicatorBuffers(7);

   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,but);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,blt);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,bct);

   SetIndexBuffer(3,mt);
   SetIndexBuffer(4,ut);
   SetIndexBuffer(5,mt2);
   SetIndexBuffer(6,ut2);
//----
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
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=2;

   double alpha=2.0/(Periods+1);
   for(int i=limit;i>=0;i--)
     {
      mt[i]=alpha*iMA(NULL,0,1,0,0,Price,i)+(1-alpha)*mt[i+1];
      ut[i]=alpha*mt[i]+(1-alpha)*ut[i+1];
      double dt=((2-alpha)*mt[i]-ut[i])/(1-alpha);
      mt2[i]=alpha*MathAbs(iMA(NULL,0,1,0,0,Price,i)-dt)+(1-alpha)*mt2[i+1];
      ut2[i]=alpha*mt2[i]+(1-alpha)*ut2[i+1];
      double dt2=((2-alpha)*mt2[i]-ut2[i])/(1-alpha);
      but[i]=dt+Devs*dt2;
      blt[i]=dt-Devs*dt2;
      bct[i]=dt;
     }
   return(0);
  }
//+------------------------------------------------------------------+
