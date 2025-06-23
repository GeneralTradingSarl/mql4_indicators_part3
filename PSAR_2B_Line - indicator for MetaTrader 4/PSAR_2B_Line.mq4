//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
/*------------------------------------------------------------------+
 |                                                 PSAR_2B_Line.mq4 |
 |                                                 Copyright © 2011 |
 |                                             basisforex@gmail.com |
 +------------------------------------------------------------------*/
#property copyright "Copyright © 2011, basisforex@gmail.com"
#property link      "basisforex@gmail.com"
//-----
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 White
#property indicator_color2 Yellow
#property indicator_color3 Aqua
#property indicator_color4 Orange
//-----
extern int        VisualBars=500;
//-----
extern double     Step             = 0.02;
extern double     Maximum          = 0.2;
//-----
double s0[];
double s1[];
double s2[];
double s3[];
//-----
double s01[];
double s23[];
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(6);
   SetIndexBuffer(0,s0);
   SetIndexBuffer(1,s1);
   SetIndexBuffer(2,s2);
   SetIndexBuffer(3,s3);
//-----
   SetIndexBuffer(4,s01);
   SetIndexBuffer(5,s23);
//-----
   SetIndexStyle(0,DRAW_LINE,EMPTY,3);
   SetIndexStyle(1,DRAW_LINE,EMPTY,3);
   SetIndexStyle(2,DRAW_LINE,EMPTY,3);
   SetIndexStyle(3,DRAW_LINE,EMPTY,3);
//------
   return(0);
  }
//+------------------------------------------------------------------+
int GetNextTF(int curTF)
  {
   switch(curTF)
     {
      case 1:
         return(5);
         break;
      case 5:
         return(15);
         break;
      case 15:
         return(30);
         break;
      case 30:
         return(60);
         break;
      case 60:
         return(240);
         break;
      case 240:
         return(1440);
         break;
     }
   return(1);
  }
//+------------------------------------------------------------------+ 
int start()
  {
   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit--;
   //if (limit>VisualBars) limit=VisualBars;
//-----
   int tf1= GetNextTF(Period());
   int tf2=tf1/Period();
   if(tf2==0) tf2=1;
//-----
   for(int i=limit-1; i>=0; i--)
     {
      s01[i]  = iSAR(NULL, 0, Step, Maximum, i);
      s23[i]  = iSAR(NULL, tf1, Step, Maximum, i / tf2);
      if(s01[i]<iLow(NULL,0,i)) s0[i]=s01[i];
      if(s01[i] > iHigh(NULL,0, i)) s1[i] = s01[i];
      if(s23[i] < iLow(NULL, 0, i)) s2[i] = s23[i];
      if(s23[i] > iHigh(NULL,0, i)) s3[i] = s23[i];
     }
   return(0);
  }
//+------------------------------------------------------------------+
