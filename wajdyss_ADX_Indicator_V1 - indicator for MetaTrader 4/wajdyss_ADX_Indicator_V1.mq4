//+------------------------------------------------------------------+
//|                                            wajdyss_ADX_indicator |
//|                                           Copyright 2009 WAJDYSS |
//|                                                wajdyss@yahoo.com |
//+------------------------------------------------------------------+
// ADX

#property copyright "Copyright 2008 Wajdyss"
#property link      "wajdyss@yahoo.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 LawnGreen
#property indicator_color2 Red
#property indicator_width1  2
#property indicator_width2  2

extern int ADX_Period=14;
extern string Note_Apply_to = "0=Close, 1=Open, 2=High, 3=Low, 4=Median (High+low)/2, 5=Typical (High+low+close)/3,6=Weighted close (High+low+close+close)/4";
extern int Apply_to =0;
extern string Note2="ÞæÉ ÇáÊÑäÏ";
extern int Level=30;
extern string Note3="ÈÚÏ ÇáÇÔÇÑÉ ÈÇáäÞÇØ ";
extern int Pips=20;
extern bool alert = true;
 extern string file="alert.wav";
 extern int TextSize=14;
 extern color TextColor1=White;
 extern color TextColor2=Yellow;
 extern color TextColor3=Aqua;
 extern color TextColor4=Red;
 extern color TextColor5=Chartreuse;
string Name="wajdyss ADX indicator";
bool manual=true;
int w=0,ww=0;
double CrossUp[];
double CrossDown[];
int eyear=9999;
int emonth=9;
int eday=9;
bool al1=false;
bool al2=false;
int MA_Result;
int ADX_Buy=1;
int j1,j2;
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
   
   //b
      if(ObjectFind("b label") != 0)
   {
      ObjectCreate("b label", OBJ_LABEL, 0,0,0);
      ObjectSetText("b label",Name , TextSize, "Arial", TextColor2);
      ObjectSet("b label", OBJPROP_XDISTANCE,330);
     ObjectSet("b label", OBJPROP_YDISTANCE,25);
   }
   
   // c

   
      if(ObjectFind("c label") != 0)
   {
      ObjectCreate("c label", OBJ_LABEL, 0,0,0);
      ObjectSetText("c label","wajdyss@yahoo.com"  , TextSize, "Arial", TextColor3);
      ObjectSet("c label", OBJPROP_XDISTANCE,335);
     ObjectSet("c label", OBJPROP_YDISTANCE,50);
   }

//if (Symbol()!="EURJPY" || Period()!=1440) return(0);
   
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
      
   int  same , notsame, samef, notsamef, samer, notsamer, samecandle, notsamecandle ;
   double  GSignalUP=0 , SignalUP=0 , GSignalDOWN=0, SignalDOWN=0 , AllSignal=0 , BSignalUP=0
    , BSignalDOWN=0 ,a=High[0]+50*Point ;
   
   double samep,notsamep,all,GSignals,GSignalsP, GSignalUPP,GSignalDOWNP,fastMAnow,fastMAprevious,slowMAnow,slowMAprevious;
   double FMA1,FMA2,SMA1,SMA2;
   string sameforecast,notsameforecast, wajdyssforecast , status ;
   int up=0;


   for (int i=Bars;i>=1;i--) 
   { 
   
   if (iADX(Symbol(),0,ADX_Period,Apply_to,MODE_PLUSDI,i)>iADX(Symbol(),0,ADX_Period,Apply_to,MODE_MINUSDI,i)  && ADX_Buy==-1 && iADX(Symbol(),0,ADX_Period,Apply_to,MODE_MAIN,i)>Level)
 // && iADX(Symbol(),0,ADX_Period,Apply_to,MODE_PLUSDI,i+1)<iADX(Symbol(),0,ADX_Period,Apply_to,MODE_MINUSDI,i+1)
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

   CrossUp[i] = Low[i]-Pips*Point;
   AllSignal++;
   SignalUP++;
   up=1;
   j1=i;
   ADX_Buy=1;
   if (iClose(Symbol(),NULL,i-1)>iOpen(Symbol(),NULL,i-1))
   GSignalUP++;
   else BSignalUP++;
   }
   
   //if ((iRSI(Symbol(),PERIOD_D1,RSI,PRICE_CLOSE,i)<50 && iRSI(Symbol(),PERIOD_D1,RSI,PRICE_CLOSE,i)>70) || iRSI(Symbol(),PERIOD_D1,RSI,PRICE_CLOSE,i)>30)
   
else    if (iADX(Symbol(),0,ADX_Period,Apply_to,MODE_PLUSDI,i)<iADX(Symbol(),0,ADX_Period,Apply_to,MODE_MINUSDI,i)  && ADX_Buy==1&& iADX(Symbol(),0,ADX_Period,Apply_to,MODE_MAIN,i)>Level)
 //&& iADX(Symbol(),0,ADX_Period,Apply_to,MODE_PLUSDI,i+1)>iADX(Symbol(),0,ADX_Period,Apply_to,MODE_MINUSDI,i+1)
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
    
    CrossDown[i] = High[i]+Pips*Point;
      AllSignal++;
      SignalDOWN++;
   up=-1;
   j2=i;
   ADX_Buy=-1;
   if (iClose(Symbol(),NULL,i-1)<iOpen(Symbol(),NULL,i-1))
    GSignalDOWN++;
   else BSignalDOWN++;
   }
}

GSignals=GSignalUP+GSignalDOWN;
GSignalsP=GSignals/AllSignal;
GSignalUPP=(GSignalUP/SignalUP);
GSignalDOWNP=(GSignalDOWN/SignalDOWN);
 
                      
                      //a

   
   int www=GSignalsP*100 ;
   //e



     if (up==1 && alert==true) {al1=false; if (al2==false) { Alert ("Symbol ",Symbol()," Time Frame  ",Period()," Close Sell Orders And Buy AT ",Close[j1]); PlaySound(file); al2=true;}}

     if (up==-1 && alert==true){al2=false; if (al1==false) { Alert ("Symbol ",Symbol()," Time Frame  ",Period()," Close Buy Orders And Sell AT ",Close[j2]); PlaySound(file); al1=true;}}

  
   return(0);
  }

