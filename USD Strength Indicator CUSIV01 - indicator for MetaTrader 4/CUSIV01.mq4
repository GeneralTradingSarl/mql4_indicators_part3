//+------------------------------------------------------------------+
//|                   Coensio Usd Strength Indicator V01 CUSIV01.mq4 |
//|                                         © Copyright 2013 Coesnio |
//|                                                  www.coensio.com |
//+------------------------------------------------------------------+
#property copyright "© Coensio"
#property link      "www.coensio.com"

#property indicator_separate_window
#property indicator_buffers 6
//Pairs
#property indicator_color1 Purple
#property indicator_color2 RoyalBlue
#property indicator_color3 Yellow
#property indicator_color4 LightBlue
//Histograms
#property indicator_color5 Lime
#property indicator_color6 Red

extern int  EMASize           = 50;
string      EaName            = "CUSIV01";
double      ExtMapBuffer1[];
double      ExtMapBuffer2[];
double      ExtMapBuffer3[];
double      ExtMapBuffer4[];
double      ExtMapBuffer5[];
double      ExtMapBuffer6[];
int         dS1,dS2,dS3,dS4   = 0;  //Deviation in pips for each symbol 
double      UsdStrength       = 0;
static bool Started           = false;
int init()
{
   //Check EA name
   if(WindowExpertName()!=EaName)
   {
      Alert("Copyright protection enabled!");
      Print("Copyright protection enabled!");
      return(0);
   }
   IndicatorShortName(EaName);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexLabel(0,"EURUSD");
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexLabel(1,"GBPUSD");
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexLabel(2,"AUDUSD");
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,ExtMapBuffer4);
   SetIndexLabel(3,"USDJPY");   
   //Histograms
   SetIndexStyle(4,DRAW_HISTOGRAM,2,3);
   SetIndexBuffer(4,ExtMapBuffer5);
   SetIndexLabel(4,"BUY USD"); 
   SetIndexStyle(5,DRAW_HISTOGRAM,2,3);
   SetIndexBuffer(5,ExtMapBuffer6);
   SetIndexLabel(5,"SELL USD"); 

   return(0);
}

int deinit()
{
   return(0);
}

int start()
{
   int StartBars = IndicatorCounted();
   int Position=Bars-StartBars-1;
   if(!Started)
   {
      //Display labels
      DrawLabel("Name"+WindowExpertName(),WindowExpertName()+": Coensio USD Strength Indicator",20,0,Yellow,8);
      DrawLabel("Info"+WindowExpertName(),"© Copyright 2013 www.Coensio.com",20,10,Yellow,8); 
      Started=true;   
   }   
   while(Position>=0){
      dS1=-(iClose("EURUSD",NULL,Position)-iMA("EURUSD",NULL,EMASize,0,MODE_EMA,MODE_OPEN,Position))/(10*MarketInfo("EURUSD",MODE_POINT));
      dS2=-(iClose("GBPUSD",NULL,Position)-iMA("GBPUSD",NULL,EMASize,0,MODE_EMA,MODE_OPEN,Position))/(10*MarketInfo("GBPUSD",MODE_POINT));
      dS3=-(iClose("AUDUSD",NULL,Position)-iMA("AUDUSD",NULL,EMASize,0,MODE_EMA,MODE_OPEN,Position))/(10*MarketInfo("AUDUSD",MODE_POINT));
      dS4=(iClose("USDJPY",NULL,Position)-iMA("USDJPY",NULL,EMASize,0,MODE_EMA,MODE_OPEN,Position))/(10*MarketInfo("USDJPY",MODE_POINT));
      
      ExtMapBuffer1[Position]=dS1;
      ExtMapBuffer2[Position]=dS2;
      ExtMapBuffer3[Position]=dS3;
      ExtMapBuffer4[Position]=dS4;
      
      UsdStrength=(dS1+dS2+dS3+dS4);
      if(UsdStrength>0) ExtMapBuffer5[Position]=UsdStrength/4;
      if(UsdStrength<0) ExtMapBuffer6[Position]=UsdStrength/4;
 	   Position--;
   }
   
   return(0);
}

void DrawLabel(string STRING="",string TEXT="",int X=0, int Y=0,color COLOR=Blue,int FONT_SIZE=5)
{
   ObjectCreate(STRING,OBJ_LABEL,WindowFind(WindowExpertName()),0,0);
   ObjectSetText(STRING,TEXT,FONT_SIZE,"",COLOR);
   ObjectSet(STRING,OBJPROP_CORNER, 1); 
   ObjectSet(STRING,OBJPROP_XDISTANCE,X);
   ObjectSet(STRING,OBJPROP_YDISTANCE,Y);
}