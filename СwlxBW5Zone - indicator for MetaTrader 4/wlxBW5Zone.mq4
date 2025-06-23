//+------------------------------------------------------------------+
//|                                                   wlxBW5Zone.mq4 |
//|                        Copyright © 2005 B.Williams, coding wellx |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005 B.Williams, coding wellx"
#property link      "http://www.metaquotes.net"
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 PaleGoldenrod
#property indicator_color2 Red
//---- input parameters
extern int       updown=12;
//---- buffers
double BWZone5Up[];
double BWZone5Down[];
int pos=0;
double AC1,AC2,AC3,AC4,AC5;
double AO1,AO2,AO3,AO4,AO5;
bool flagUP=false, flagDown=false;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,144);
   SetIndexBuffer(0,BWZone5Up);
   SetIndexEmptyValue(0,0.0);
   //
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,144);
   SetIndexBuffer(1,BWZone5Down);
   SetIndexEmptyValue(1,0.0);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
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
   int    cbars=IndicatorCounted();
   if  (cbars<0) return(-1);
   if  (cbars>0) cbars--;
//---- TODO: add your code here
   if (cbars > (Bars-6)) pos=(Bars-6);
   else pos=cbars;
   while(pos > 0)
     {
      BWZone5Up[pos]=0;
      BWZone5Down[pos]=0;
      AO1=iAO(NULL,0,pos);
      AO2=iAO(NULL,0,pos+1);
      AO3=iAO(NULL,0,pos+2);
      AO4=iAO(NULL,0,pos+3);
      AO5=iAO(NULL,0,pos+4);
      //
      AC1=iAC(NULL,0,pos);
      AC2=iAC(NULL,0,pos+1);
      AC3=iAC(NULL,0,pos+2);
      AC4=iAC(NULL,0,pos+3);
      AC5=iAC(NULL,0,pos+4);
//----
      if ((AO1>AO2 && AO2>AO3 && AO3>AO4 && AO4>AO5) &&
          (AC1>AC2 && AC2>AC3 && AC3>AC4 && AC4>AC5))
        {
         if (flagUP==false)
           { BWZone5Up[pos] =High[pos]+updown*Point;
            flagUP=true;
           }
        }
      if ((AO1<AO2 && AO2<AO3 && AO3<AO4 && AO4<AO5) &&
          (AC1<AC2 && AC2<AC3 && AC3<AC4 && AC4<AC5))
        {
         if (flagDown==false)
           {
            BWZone5Down[pos]= Low[pos]-updown*Point;
            flagDown=True;
           }
        }
      if ((AO1<AO2)||(AC1<AC2)) flagUP=false;
      if ((AO1>AO2)||(AC1>AC2)) flagDown=false;
      pos--;
     }
//----
   return(0);
  }
//+------------------------------------------------------------------+