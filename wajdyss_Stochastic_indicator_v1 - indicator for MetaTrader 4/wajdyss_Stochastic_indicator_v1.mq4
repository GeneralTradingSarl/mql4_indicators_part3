//+------------------------------------------------------------------+
//|                                             wajdyss_MA_indicator |
//|                                           Copyright 2007 Wajdyss |
//|                                                wajdyss@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2008 Wajdyss"
#property link      "wajdyss@yahoo.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 LawnGreen
#property indicator_color2 Red
#property indicator_width1  2
#property indicator_width2  2

int days=350;
int candle=350;
extern int KPeriod = 5;
extern int Slowing  = 3;
extern int DPeriod  = 3; 
extern string Pric_Field_Note = "0=Low/High , 1=Close/Close";
extern int Price_Field = 0;
extern string MA_Method_Note = "0 = Simple , 1 = Exponential , 2 = Smoothed , 3 = Linear ";
extern int MA_Method  = 0;
extern bool alert = true;
extern string file="alert.wav";
extern int TextSize=14;
extern color TextColor1=Black;
extern color TextColor2=Red;
extern color TextColor3=Blue;
extern color TextColor4=Black;
 color TextColor5=Chartreuse;
bool manual=true;
int w=0,ww=0;
double CrossUp[];
double CrossDown[];
int eyear=9999;
int emonth=9;
int eday=9;
bool al1=false;
bool al2=false;

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
      ObjectSetText("b label","wajdyss Stochastic indicator"  , TextSize, "Arial", TextColor2);
      ObjectSet("b label", OBJPROP_XDISTANCE,305);
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
      ObjectSetText("d label","http://forum.m-e-c.biz",TextSize, "Arial", TextColor4);
      ObjectSet("d label", OBJPROP_XDISTANCE,338);
     ObjectSet("d label", OBJPROP_YDISTANCE,75);
   }

      
   int  same , notsame, samef, notsamef, samer, notsamer, samecandle, notsamecandle ;
   double  GSignalUP=0 , SignalUP=0 , GSignalDOWN=0, SignalDOWN=0 , AllSignal=0 , BSignalUP=0
    , BSignalDOWN=0 ,a=High[0]+50*Point ;
   
   double samep,notsamep,all,GSignals,GSignalsP, GSignalUPP,GSignalDOWNP,fastMAnow,fastMAprevious,slowMAnow,slowMAprevious;
   string sameforecast,notsameforecast, wajdyssforecast , status ;


//   if (manual ==true) status="manual"; else status="auto";
 {samecandle=w; notsamecandle=ww;}
   all=days;
   samep=(samer/all);
   notsamep=(notsamer/all);

   samecandle=w;
   notsamecandle=ww;
   if (iClose(Symbol(),NULL,samecandle)>iOpen(Symbol(),NULL,samecandle)) sameforecast="up trend"; else sameforecast="down trend";
   if (iClose(Symbol(),NULL,notsamecandle)<iOpen(Symbol(),NULL,notsamecandle)) notsameforecast="up trend"; else notsameforecast="down trend";
   if (sameforecast==notsameforecast) wajdyssforecast=sameforecast;
   else wajdyssforecast="no trading today";

   for (int i=days;i>=1;i--) 
   { 
      fastMAnow=iStochastic(NULL, 0, KPeriod, DPeriod, Slowing,MA_Method, Price_Field, MODE_MAIN, i);
      fastMAprevious=iStochastic(NULL, 0, KPeriod, DPeriod, Slowing,MA_Method, Price_Field, MODE_MAIN, i+1);
      slowMAnow=iStochastic(NULL, 0, KPeriod, DPeriod, Slowing,MA_Method, Price_Field, MODE_SIGNAL, i);
      slowMAprevious=iStochastic(NULL, 0, KPeriod, DPeriod, Slowing,MA_Method, Price_Field, MODE_SIGNAL, i+1);

   if (fastMAnow > slowMAnow && !(fastMAprevious > slowMAprevious))
 
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
 
   CrossUp[i] = Low[i]-20*Point;
   AllSignal++;
   SignalUP++;
   if (iClose(Symbol(),NULL,i-1)>iOpen(Symbol(),NULL,i-1))
   GSignalUP++;
   else BSignalUP++;
   }
   
   
   if (fastMAnow < slowMAnow && !(fastMAprevious < slowMAprevious))
 
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
 
    
    CrossDown[i] = High[i]+20*Point;
      AllSignal++;
      SignalDOWN++;
   if (iClose(Symbol(),NULL,i-1)<iOpen(Symbol(),NULL,i-1))
    GSignalDOWN++;
   else BSignalDOWN++;
   }
}

GSignals=GSignalUP+GSignalDOWN;
GSignalsP=GSignals/AllSignal;
GSignalUPP=(GSignalUP/SignalUP);
GSignalDOWNP=(GSignalDOWN/SignalDOWN);
 

   
   int www=GSignalsP*100 ;
   //e
      fastMAnow=iStochastic(NULL, 0, KPeriod, DPeriod, Slowing,MA_Method, Price_Field, MODE_MAIN, 1);
      fastMAprevious=iStochastic(NULL, 0, KPeriod, DPeriod, Slowing,MA_Method, Price_Field, MODE_MAIN, 2);
      slowMAnow=iStochastic(NULL, 0, KPeriod, DPeriod, Slowing,MA_Method, Price_Field, MODE_SIGNAL, 1);
      slowMAprevious=iStochastic(NULL, 0, KPeriod, DPeriod, Slowing,MA_Method, Price_Field, MODE_SIGNAL, 2);

  if (fastMAnow > slowMAnow && !(fastMAprevious > slowMAprevious) && alert==true) {al1=false; if (al2==false) { Alert ("Close Sell Orders And Buy AT ",Close[1]); PlaySound(file); al2=true;}}

  if (fastMAnow < slowMAnow && !(fastMAprevious < slowMAprevious) && alert==true) {al2=false; if (al1==false) { Alert ("Close Buy Orders And Sell AT ",Close[1]); PlaySound(file); al1=true;}}

  
   return(0);
  }

