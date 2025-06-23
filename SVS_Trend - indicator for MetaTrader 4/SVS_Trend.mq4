//+------------------------------------------------------------------+
//|                                                    svs_trend.mq4 |
//|                                           Copyright © 2007, SVS. |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Tver,Spirovo,SVS,S Vadim S,svstnd@mail.ru,2008."
#property link      ""

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 MediumSeaGreen
#property indicator_color2 Blue
#property indicator_color3 Red
#property indicator_color4 Black 
extern int Period1=4; 
extern int Period2=8;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM,0,2);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM,0,2);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_HISTOGRAM,0,2);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_HISTOGRAM,0,2);
   SetIndexBuffer(3,ExtMapBuffer4);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+   
int start()
  {
   double v0,v1;
   double f0,f1;
   double vv,ff;
   double vj,vk,vd;
   double vts;
   int MODE,p1,p2;
//---- TODO: add your code here
   int limit;
   int counted_bars=IndicatorCounted();
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars-1;
   for(int i=0;i<=limit;i++){                   
//------------------------------------------------------
      MODE=0;
      vts=0;
      p1=Period1;
      if(Period2<=p1)Period2=p1+1;
      p2=Period2;
      //------------------------------------
      f0=iMA(NULL,0,p1,0,MODE,PRICE_WEIGHTED,i);
      f1=iMA(NULL,0,p2,0,MODE,PRICE_WEIGHTED,i);
      //-----------------------------------------
      for (int c=0;c<=p2;c++){      
         vts=vts+iMA(NULL,0,c,0,MODE,PRICE_WEIGHTED,i);
         if(c==p1)v0=(vts/p1);
         if(c==p2)v1=(vts/p2);                  
         }
      //-------------------------------------------                                              
      vv=v0-v1;
      ff=f0-f1;          
      vk=(vv+ff)/2;
      vd=(vv/2);           
      vj=(ff-vd);
      //-------------------------
      ExtMapBuffer1[i]=ff;
      ExtMapBuffer2[i]=vk;
      ExtMapBuffer3[i]=vd;
      ExtMapBuffer4[i]=vj;
   }
   return(0);
  }
//+--------------------------------+