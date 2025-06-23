//+------------------------------------------------------------------+
//|                                            wajdyss_3MA_Indicator |
//|                                           Copyright 2009 Wajdyss |
//|                                                wajdyss@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2009 Wajdyss"
#property link      "wajdyss@yahoo.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 LawnGreen
#property indicator_color2 Magenta
#property indicator_width1  2
#property indicator_width2  2

int days=350;
int candle=350;
extern string MA_Method = "0 = Simple, 1 = Exponential, 2 = Smoothed, 3 = Linear Weighted";
extern string Apply_to = "0=Close, 1=Open, 2=High, 3=Low, 4=Median, 5=Typical,6=Weighted Close ";
extern int Faster_MA_Period = 5;
extern int Faster_MA_Shift  = 0;
extern int Faster_MA_method  = 1; 
extern int Faster_MA_Apply_to = 0;
extern string Note1="-----------------";
extern int Fast_MA_Period = 10;
extern int Fast_MA_Shift  = 0;
extern int Fast_MA_method  = 1; 
extern int Fast_MA_Apply_to = 0;
extern string Note2="-----------------";
extern int Slow_MA_Period = 20;
extern int Slow_MA_Shift  = 0;  
extern int Slow_MA_method  = 1;
extern int Slow_MA_Apply_to  = 0;
extern string Note3="ÈõÚÏ ÇáÇÔÇÑÉ ÈÇáäÞÇØ ";
extern int Pips=20;
extern string Note4="-----------------";
extern bool alert = true;
extern string file="alert.wav";
extern string Note5="-----------------";
extern int TextSize=14;
extern color TextColor1=White;
extern color TextColor2=Yellow;
extern color TextColor3=Aqua;
extern color TextColor4=Red;
extern color TextColor5=Chartreuse;
bool manual=true;
int w=0,ww=0;
double CrossUp[];
double CrossDown[];
int eyear=9999;
int emonth=9;
int eday=9;
bool al1=false;
bool al2=false;
int MA_Buy=1;
int j1,j2;
string Name="wajdyss 3MA Indicators";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW, EMPTY);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, CrossDown);
//----

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
  Comment("");
 ObjectDelete("a label");
 ObjectDelete("b label");
 ObjectDelete("c label");
 ObjectDelete("d label");
 ObjectDelete("e label");


   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
  //a
          if(ObjectFind("a label") != 0)
   {
      ObjectCreate("a label", OBJ_LABEL, 0,0,0);
      ObjectSetText("a label","ÈÓã Çááå ÇáÑÍãä ÇáÑÍíã" , TextSize, "Arial", TextColor1);
      ObjectSet("a label", OBJPROP_XDISTANCE,350);
     ObjectSet("a label", OBJPROP_YDISTANCE,0);
   }
   else
   {
   ObjectMove("a label", 0,  0,0);
   }
   
   //b
      if(ObjectFind("b label") != 0)
   {
      ObjectCreate("b label", OBJ_LABEL, 0,0,0);
      ObjectSetText("b label",Name , TextSize, "Arial", TextColor2);
      ObjectSet("b label", OBJPROP_XDISTANCE,325);
     ObjectSet("b label", OBJPROP_YDISTANCE,25);
   }
   else
   {
   ObjectMove("b label", 0,  0,0);
   }
   
   // c

   
      if(ObjectFind("c label") != 0)
   {
      ObjectCreate("c label", OBJ_LABEL, 0,0,0);
      ObjectSetText("c label","wajdyss@yahoo.com"  , TextSize, "Arial", TextColor3);
      ObjectSet("c label", OBJPROP_XDISTANCE,335);
     ObjectSet("c label", OBJPROP_YDISTANCE,50);
   }
   else
   {
   ObjectMove("c label", 0,  0,0);
   }
   
    if ((Year()>eyear) || (Year()==eyear && Month()>emonth) || (Year()==eyear && Month()==emonth && Day()>eday))
    {
       //d
   if(ObjectFind("d label") != 0)
   {
      ObjectCreate("d label", OBJ_LABEL, 0,0,0);
      ObjectSetText("d label","the indicator has expired , contact us by E-mail" ,TextSize, "Arial", TextColor4);
      ObjectSet("d label", OBJPROP_XDISTANCE,250);
     ObjectSet("d label", OBJPROP_YDISTANCE,75);
   }
   else
   {
   ObjectMove("d label", 0,  0,0);
   }
      return(0);
    } 
   else 
       if(ObjectFind("d label") != 0)
   {
      ObjectCreate("d label", OBJ_LABEL, 0,0,0);
      ObjectSetText("d label","the indicator well expire after ( " + eday+"-"+emonth+"-"+eyear+" )",TextSize, "Arial", TextColor4);
      ObjectSet("d label", OBJPROP_XDISTANCE,265);
     ObjectSet("d label", OBJPROP_YDISTANCE,75);
   }
   else
   {
   ObjectMove("d label", 0,  0,0);
   }
      
   int  same , notsame, samef, notsamef, samer, notsamer, samecandle, notsamecandle ;
   double  GSignalUP=0 , SignalUP=0 , GSignalDOWN=0, SignalDOWN=0 , AllSignal=0 , BSignalUP=0
    , BSignalDOWN=0 ,a ;
   
   double samep,notsamep,all,GSignals,GSignalsP, GSignalUPP,GSignalDOWNP,FRMA1,FRMA2,FMA1,FMA2,SMA1,SMA2,FMA11,FMA22,SMA11,SMA22;
   string sameforecast,notsameforecast, wajdyssforecast , status ;


//   if (manual ==true) status="manual"; else status="auto";
   int up=0;

   for (int i=Bars;i>=1;i--) 
   { 
    FRMA1=iMA(Symbol(), 0, Faster_MA_Period, Faster_MA_Shift, Faster_MA_method, Faster_MA_Apply_to, i);
    FRMA2=iMA(Symbol(), 0, Faster_MA_Period, Faster_MA_Shift, Faster_MA_method, Faster_MA_Apply_to, i+1);

    FMA1=iMA(Symbol(), 0, Fast_MA_Period, Fast_MA_Shift, Fast_MA_method, Fast_MA_Apply_to, i);
    FMA2=iMA(Symbol(), 0, Fast_MA_Period, Fast_MA_Shift, Fast_MA_method, Fast_MA_Apply_to, i+1);

    SMA1=iMA(Symbol(), 0, Slow_MA_Period, Slow_MA_Shift, Slow_MA_method, Slow_MA_Apply_to, i);
    SMA2=iMA(Symbol(), 0, Slow_MA_Period, Slow_MA_Shift, Slow_MA_method, Slow_MA_Apply_to, i+1);

       if (FRMA1>FMA1 && FMA1>SMA1 && !(FRMA2>FMA2 && FMA2>SMA2) && MA_Buy==-1)
        //if (FMA1>SMA1 && FMA2<SMA2)
 
   {
    if ((Year()>eyear) || (Year()==eyear && Month()>emonth) || (Year()==eyear && Month()==emonth && Day()>eday))
    {
       //d
   if(ObjectFind("d label") != 0)
   {
      ObjectCreate("d label", OBJ_LABEL, 0,0,0);
      ObjectSetText("d label","the indicator has expired , contact us by E-mail" ,TextSize, "Arial", TextColor4);
      ObjectSet("d label", OBJPROP_XDISTANCE,250);
     ObjectSet("d label", OBJPROP_YDISTANCE,75);
   }
   else
   {
   ObjectMove("d label", 0,  0,0);
   }
      return(0);
    } 
   else 
       if(ObjectFind("d label") != 0)
   {
      ObjectCreate("d label", OBJ_LABEL, 0,0,0);
      ObjectSetText("d label","the indicator well expire after ( " + eday+"-"+emonth+"-"+eyear+" )",TextSize, "Arial", TextColor4);
      ObjectSet("d label", OBJPROP_XDISTANCE,265);
     ObjectSet("d label", OBJPROP_YDISTANCE,75);
   }
   else
   {
   ObjectMove("d label", 0,  0,0);
   }
   CrossUp[i] = Low[i]-Pips*Point;
   AllSignal++;
   SignalUP++;
   up=1;
   j1=i;
   MA_Buy=1;

   if (iClose(Symbol(),NULL,i-1)>iOpen(Symbol(),NULL,i-1))
   GSignalUP++;
   else BSignalUP++;
   }
   
   
      if (FRMA1<FMA1 && FMA1<SMA1 && !(FRMA2<FMA2 && FMA2<SMA2) && MA_Buy==1)
//      if (FMA1<SMA1 && FMA2>SMA2)
 
   { 
    if ((Year()>eyear) || (Year()==eyear && Month()>emonth) || (Year()==eyear && Month()==emonth && Day()>eday))
    {
       //d
   if(ObjectFind("d label") != 0)
   {
      ObjectCreate("d label", OBJ_LABEL, 0,0,0);
      ObjectSetText("d label","the indicator has expired , contact us by E-mail" ,TextSize, "Arial", TextColor4);
      ObjectSet("d label", OBJPROP_XDISTANCE,250);
     ObjectSet("d label", OBJPROP_YDISTANCE,75);
   }
   else
   {
   ObjectMove("d label", 0,  0,0);
   }
      return(0);
    } 
   else 
       if(ObjectFind("d label") != 0)
   {
      ObjectCreate("d label", OBJ_LABEL, 0,0,0);
      ObjectSetText("d label","the indicator well expire after ( " + eday+"-"+emonth+"-"+eyear+" )",TextSize, "Arial", TextColor4);
      ObjectSet("d label", OBJPROP_XDISTANCE,265);
     ObjectSet("d label", OBJPROP_YDISTANCE,75);
   }
   else
   {
   ObjectMove("d label", 0,  0,0);
   }
    
    CrossDown[i] = High[i]+Pips*Point;
      AllSignal++;
      SignalDOWN++;
   up=-1;
   j2=i;
   MA_Buy=-1;
   if (iClose(Symbol(),NULL,i-1)<iOpen(Symbol(),NULL,i-1))
    GSignalDOWN++;
   else BSignalDOWN++;
   }
}

GSignals=GSignalUP+GSignalDOWN;
GSignalsP=GSignals/AllSignal;
GSignalUPP=(GSignalUP/SignalUP);
GSignalDOWNP=(GSignalDOWN/SignalDOWN);
 

   

     if (up==1 && alert==true) {al1=false; if (al2==false) { Alert (Name," Symbol ",Symbol()," Time Frame  ",Period()," Close Sell Orders And Buy AT ",Close[j1]); PlaySound(file); al2=true;}}

     if (up==-1 && alert==true){al2=false; if (al1==false) { Alert (Name," Symbol ",Symbol()," Time Frame  ",Period()," Close Buy Orders And Sell AT ",Close[j2]); PlaySound(file); al1=true;}}

   return(0);
  }

