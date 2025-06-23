//+------------------------------------------------------------------+
//|svs_trend  svs_oscillator                                         |
//+------------------------------------------------------------------+
#property copyright "Tver,SVS,S Vadim,svstnd@mail.ru,2011."
#property link      ""
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Green
#property indicator_color2 Blue
#property indicator_color3 Red
#property indicator_color4 Black 
extern int period=4; 
extern int thic=4;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM,0,thic);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_HISTOGRAM,0,thic);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_HISTOGRAM,0,thic);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_HISTOGRAM,0,thic);
   SetIndexBuffer(3,ExtMapBuffer4);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+   
int start()
  {
   double v1,v2,vv1,vv2,z,m1,m2,m3,smm,smz,zm1,m1z,zm2,msm,rmm,rms;
   int p1,p2,p3,MODE;
//---- TODO: add your code here
   int limit;
   int counted_bars=IndicatorCounted();
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars-1;
   for(int i=0;i<=limit;i++){                   
//----------------------------
      MODE=0;
      p1=period;
      p2=period*2;
      p3=(p1+p2)/2;    
      //------------------------------------
      z=iMA(NULL,0,1,0,MODE,5,i);
      m1=iMA(NULL,0,p1,0,MODE,5,i);
      m2=iMA(NULL,0,p2,0,MODE,5,i);
      m3=iMA(NULL,0,p3,0,MODE,5,i);
      //---------------------------------------
      smm=(m1+m2)/2;
      smz=(m2+z)/2;
      zm1=z-m1;   
      m1z=smz-m1; 
      zm2=z-m2;        
      msm=smm-m3;
      rmm=m1-m2;   
      rms=smz-smm;     
      v1=(zm1+m1z+msm)/3;
      v2=(zm2+rmm+rms)/3;     
      vv1=(v1+v2)/2;
      vv2=v2-v1;              
      //-------------------------      
      ExtMapBuffer1[i]=v2;
      ExtMapBuffer2[i]=vv1;
      ExtMapBuffer3[i]=v1/2;
      ExtMapBuffer4[i]=vv2;
      }
   return(0);
  }
//+--------------------------------+