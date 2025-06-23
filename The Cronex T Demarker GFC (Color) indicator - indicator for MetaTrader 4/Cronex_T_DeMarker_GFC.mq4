//+------------------------------------------------------------------+
//|                                         Cronex T DeMarker GF.mq4 |
//|                                        Copyright © 2009, Cronex. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2008, Cronex"
#property  link      "http://www.metaquotes.net/"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 6
#property  indicator_color1  DarkOrange
#property  indicator_color2  DodgerBlue
#property  indicator_color3  Blue
#property  indicator_color4  Red
#property  indicator_color5  Green
#property  indicator_color6  Red

#property  indicator_width1  2

#property indicator_level1  20
#property indicator_level2  10
#property indicator_level3 -10
#property indicator_level4 -20

//---- indicator parameters
extern int DeMarker=24;
extern int  DeMStep=4;
extern double Curvature=0.618;
//---- indicator buffers
double     DeMarkerBuffer[];
double     DeMarkerTBuffer[];
double     CrossUpTBuffer[];
double     CrossDnTBuffer[];
double     DiverTBuffUP[];
double     DiverTBuffDN[];

double e1,e2,e3,e4,e5,e6;
double c1,c2,c3,c4;
double n,w1,w2,b2,b3;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_ARROW);   
   SetIndexStyle(3,DRAW_ARROW);   
   SetIndexStyle(4,DRAW_HISTOGRAM);
   SetIndexStyle(5,DRAW_HISTOGRAM);

   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0); 
   SetIndexEmptyValue(2,0.0);
   SetIndexEmptyValue(3,0.0); 
   SetIndexEmptyValue(4,0.0);
   SetIndexEmptyValue(5,0.0);   
      
   SetIndexArrow(2,217);
   SetIndexArrow(3,218);

//---- indicator buffers mapping
   SetIndexBuffer(0,DeMarkerTBuffer);
   SetIndexBuffer(1,DeMarkerBuffer);
   SetIndexBuffer(2,CrossUpTBuffer);
   SetIndexBuffer(3,CrossDnTBuffer);
   SetIndexBuffer(4,DiverTBuffUP);   
   SetIndexBuffer(5,DiverTBuffDN);    
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("Cronex T DeMarker GF("+DeMarker+")");
   SetIndexLabel(0,"DeMarker GF");
   SetIndexLabel(1,"DeMarker Smoothed");   
   SetIndexLabel(2,"Cross UP");
   SetIndexLabel(3,"Cross DN");
   SetIndexLabel(4,"Divergence move UP"); 
   SetIndexLabel(5,"Divergence move DN");      
//---- variable reset
   e1=0; e2=0; e3=0; e4=0; e5=0; e6=0;
   c1=0; c2=0; c3=0; c4=0;
   n=0;
   w1=0; w2=0;
   b2=0; b3=0;
   //
   b2=Curvature*Curvature;
   b3=b2*Curvature;
   c1=-b3;
   c2=(3*(b2+b3));
   c3=-3*(2*b2+Curvature+b3);
   c4=(1+3*Curvature+b3+3*b2);
   n=DeMarker;
   //
   if (n<1) n=1;
   n=1 + 0.5*(n-1);
   w1=2/(n + 1);
   w2=1 - w1;
//----   

//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Cronex T DeMarker GFC                                            |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
//   if(counted_bars>0) counted_bars--;
   limit=300;

//---- DeMarker counted in the 1-st buffer

   for(int i=limit; i>=0; i--)
    {  
      DeMarkerBuffer[i]=(
                           iDeMarker(NULL,0,DeMarker+DeMStep*0,i)+
                           iDeMarker(NULL,0,DeMarker+DeMStep*1,i)+
                           iDeMarker(NULL,0,DeMarker+DeMStep*2,i)+
                           iDeMarker(NULL,0,DeMarker+DeMStep*3,i))*100/4-50;
                           
      e1=w1*DeMarkerBuffer[i] + w2*e1;
      e2=w1*e1 + w2*e2;
      e3=w1*e2 + w2*e3;
      e4=w1*e3 + w2*e4;
      e5=w1*e4 + w2*e5;
      e6=w1*e5 + w2*e6;
      //
      DeMarkerTBuffer[i]=c1*e6 + c2*e5 + c3*e4 + c4*e3;
    } 
//---- signal line counted in the 2-nd buffer

/* */ 
   for(i=limit; i>=0; i--)
    {  
      if (DeMarkerBuffer[i+1]<=DeMarkerTBuffer[i+1] && DeMarkerBuffer[i]>DeMarkerTBuffer[i])
         {
         CrossUpTBuffer[i]=DeMarkerTBuffer[i];
         }

      if (DeMarkerBuffer[i+1]>=DeMarkerTBuffer[i+1] && DeMarkerBuffer[i]<DeMarkerTBuffer[i])
         {
         CrossDnTBuffer[i]=DeMarkerTBuffer[i];
         }

      DiverTBuffUP[i]=0.0;
      DiverTBuffDN[i]=0.0;
      
      if (DeMarkerBuffer[i]-DeMarkerTBuffer[i]>DeMarkerBuffer[i+1]-DeMarkerTBuffer[i+1])
         {
          DiverTBuffUP[i]=DeMarkerBuffer[i]-DeMarkerTBuffer[i];
         }
      else
         { 
          DiverTBuffDN[i]=DeMarkerBuffer[i]-DeMarkerTBuffer[i];
         }
    } 

//---- done
   return(0);
  }
//+------------------------------------------------------------------+