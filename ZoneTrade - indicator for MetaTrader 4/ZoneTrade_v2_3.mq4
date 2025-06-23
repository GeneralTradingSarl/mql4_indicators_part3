//+------------------------------------------------------------------+
//|                                                    ZoneTrade.mq4 |
//|                                                           Duke3D |
//|                                             duke3datomic@mail.ru |
//+------------------------------------------------------------------+
#property copyright "Duke3D"
#property link      "duke3datomic@mail.ru"

#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_color3 Gray
#property indicator_color4 Gray
#property indicator_color5 Green
#property indicator_color6 Red
#property indicator_color7 Gray
#property indicator_color8 Gray

#property indicator_width1 3
#property indicator_width2 3
#property indicator_width3 3
#property indicator_width4 3
#property indicator_width5 1
#property indicator_width6 1
#property indicator_width7 1
#property indicator_width8 1

extern color GreenZone        = Green;          // ÷вет зелЄнной зоны
extern color RedZone          = Red;            // ÷вет красной зоны
extern color GreyZone         = Gray;           // ÷вет серой зоны
double AC_0;
double AC_1;
double AO_0;
double AO_1;
string name;
extern int BodyWidth          = 3;              // Ўирина тела свечи
extern int ShadowWidth        = 1;              // Ўирина тени свечи
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double ExtMapBuffer7[];
double ExtMapBuffer8[];
//----

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM, 0, BodyWidth, GreenZone);
   SetIndexBuffer(0, ExtMapBuffer1);

   SetIndexStyle(1,DRAW_HISTOGRAM, 0, BodyWidth, RedZone);
   SetIndexBuffer(1, ExtMapBuffer2);
   
   SetIndexStyle(2,DRAW_HISTOGRAM, 0, BodyWidth, GreyZone);
   SetIndexBuffer(2, ExtMapBuffer3);

   SetIndexStyle(3,DRAW_HISTOGRAM, 0, BodyWidth, GreyZone);
   SetIndexBuffer(3, ExtMapBuffer4);

   SetIndexStyle(4,DRAW_HISTOGRAM, 0, ShadowWidth, GreenZone);
   SetIndexBuffer(4, ExtMapBuffer5);
   
   SetIndexStyle(5,DRAW_HISTOGRAM, 0, ShadowWidth, RedZone);
   SetIndexBuffer(5, ExtMapBuffer6);

   SetIndexStyle(6,DRAW_HISTOGRAM, 0, ShadowWidth, GreyZone);
   SetIndexBuffer(6, ExtMapBuffer7);
   
   SetIndexStyle(7,DRAW_HISTOGRAM, 0, ShadowWidth, GreyZone);
   SetIndexBuffer(7, ExtMapBuffer8);

//----
   SetIndexDrawBegin(0,10);
   SetIndexDrawBegin(1,10);
   SetIndexDrawBegin(2,10);
   SetIndexDrawBegin(3,10);
   SetIndexDrawBegin(4,10);
   SetIndexDrawBegin(5,10);
   SetIndexDrawBegin(6,10);
   SetIndexDrawBegin(7,10);
//---- initialization done
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
   int i, limit;
   double ZTOpen, ZTHigh, ZTLow, ZTClose;
 
   if(counted_bars > 0) counted_bars--;
   limit = Bars - counted_bars - 1;
   
   //for(limit=i; limit>0; limit--)
   while(limit>=0)
      {
      ZTOpen  = Open[limit];
      ZTHigh  = High[limit];
      ZTLow   = Low[limit];
      ZTClose = Close[limit];
//===================================================================================================================      
      if(IndAC(limit)==1 && IndAO(limit)==1)            // «елЄна€ зона 
        {
        if(Open[limit]>Close[limit])                    // bear
          {
           ExtMapBuffer1[limit] = ZTClose;
           ExtMapBuffer2[limit] = ZTOpen;
          }
        if(Open[limit]<Close[limit])                    // bull
          {
           ExtMapBuffer1[limit] = ZTOpen;
           ExtMapBuffer2[limit] = ZTClose;
          }
        ExtMapBuffer5[limit] = ZTLow;
        ExtMapBuffer6[limit] = ZTHigh;
          
        } 
//===================================================================================================================  
      if(IndAC(limit)==2 && IndAO(limit)==2)            //  расна€ зона 
        {
        if(Open[limit]>Close[limit])                    // bear
          {
           ExtMapBuffer1[limit] = ZTOpen;
           ExtMapBuffer2[limit] = ZTClose;
          }
        if(Open[limit]<Close[limit])                    // bull
          {
           ExtMapBuffer1[limit] = ZTClose;
           ExtMapBuffer2[limit] = ZTOpen;
          }
        ExtMapBuffer5[limit] = ZTHigh;
        ExtMapBuffer6[limit] = ZTLow;
        } 
//===================================================================================================================
      if((IndAC(limit)==1 && IndAO(limit)==2) || (IndAC(limit)==2 && IndAO(limit)==1))            // —ера€ зона
        {
        if(Open[limit]>Close[limit])                    // bear
          {
           ExtMapBuffer3[limit] = ZTClose;
           ExtMapBuffer4[limit] = ZTOpen;
          }
        if(Open[limit]<Close[limit])                    // bull
          {
           ExtMapBuffer3[limit] = ZTOpen;
           ExtMapBuffer4[limit] = ZTClose;
          }
        ExtMapBuffer7[limit] = ZTLow;
        ExtMapBuffer8[limit] = ZTHigh;
        }
      limit--;
      }
//===================================================================================================================     
  return(0);
  }
//===================================================================================================================     
int IndAC(int Shift)
   {
   int DirectionAC;
   AC_0 = iAC(Symbol(),0,Shift);
   AC_1 = iAC(Symbol(),0,Shift-1);
   if(AC_0>AC_1) {DirectionAC = 1;}               // «елЄный бар
   if(AC_0<AC_1) {DirectionAC = 2;}               //  расный бар
   return(DirectionAC);
   }
//===================================================================================================================     
int IndAO(int Shift)
   {
   int DirectionAO;
   AO_0 = iAO(Symbol(),0,Shift);
   AO_1 = iAO(Symbol(),0,Shift-1);
   if(AO_0>AO_1) {DirectionAO = 1;}               // «елЄный бар
   if(AO_0<AO_1) {DirectionAO = 2;}               //  расный бар
   return(DirectionAO);
   }
//===================================================================================================================     
   