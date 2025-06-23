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
extern string MA_Method = "0 = Simple, 1 = Exponential, 2 = Smoothed, 3 = Linear Weighted";
extern string Apply_to = "0=Close, 1=Open, 2=High, 3=Low, 4=Median, 5=Typical,6=Weighted Close ";
extern int Fast_MA_Period = 10;
extern int Fast_MA_Shift  = 0;
extern int Fast_MA_method  = 1; 
extern int Fast_MA_Apply_to = 0;
extern int Slow_MA_Period = 20;
extern int Slow_MA_Shift  = 0;  
extern int Slow_MA_method  = 1;
extern int Slow_MA_Apply_to  = 0;
extern bool alert = true;
extern string file="alert.wav";
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
int eyear=2100;
int emonth=1;
int eday=1;
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
   else
   {
   ObjectMove("a label", 0,  0,0);
   }
   
   //b
      if(ObjectFind("b label") != 0)
   {
      ObjectCreate("b label", OBJ_LABEL, 0,0,0);
      ObjectSetText("b label","wajdyss MA indicator"  , TextSize, "Arial", TextColor2);
      ObjectSet("b label", OBJPROP_XDISTANCE,330);
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
    , BSignalDOWN=0 ,a=High[0]+50*Point ;
   
   double samep,notsamep,all,GSignals,GSignalsP, GSignalUPP,GSignalDOWNP,FMA1,FMA2,SMA1,SMA2,FMA11,FMA22,SMA11,SMA22;
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

   for (int j=Bars;j>=1;j--) 
   { 
    FMA1=iMA(Symbol(), 0, Fast_MA_Period, Fast_MA_Shift, Fast_MA_method, Fast_MA_Apply_to, j);
    FMA2=iMA(Symbol(), 0, Fast_MA_Period, Fast_MA_Shift, Fast_MA_method, Fast_MA_Apply_to, j+1);

    SMA1=iMA(Symbol(), 0, Slow_MA_Period, Slow_MA_Shift, Slow_MA_method, Slow_MA_Apply_to, j);
    SMA2=iMA(Symbol(), 0, Slow_MA_Period, Slow_MA_Shift, Slow_MA_method, Slow_MA_Apply_to, j+1);

    if (FMA1>SMA1 && FMA2<SMA2)
 
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
   CrossUp[j] = Low[j]-20*Point;
   AllSignal++;
   SignalUP++;
   if (iClose(Symbol(),NULL,j-1)>iOpen(Symbol(),NULL,j-1))
   GSignalUP++;
   else BSignalUP++;
   }
   
   
      if (FMA1<SMA1 && FMA2>SMA2)
 
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
    
    CrossDown[j] = High[j]+20*Point;
      AllSignal++;
      SignalDOWN++;
   if (iClose(Symbol(),NULL,j-1)<iOpen(Symbol(),NULL,j-1))
    GSignalDOWN++;
   else BSignalDOWN++;
   }
}

GSignals=GSignalUP+GSignalDOWN;
GSignalsP=GSignals/AllSignal;
GSignalUPP=(GSignalUP/SignalUP);
GSignalDOWNP=(GSignalDOWN/SignalDOWN);
 
 //   Comment ("\n" , "ÈÓã Çááå Ç áÑÍãä ÇáÑÍíã" ,"\n" ,"\n","wajdyss@yahoo.com", "\n" ,"\n" , "wajdyss MA indicator", "\n","\n",
   //"all signals=",AllSignal, "\n", "\n","Up Signals =",SignalUP, "\n","Good Up Signals =",
   //GSignalUP,"\n","Bad Up Signals =",BSignalUP,"\n", "\n","Down Signals=",SignalDOWN,"\n",
   //"Good Down Signals =",GSignalDOWN,"\n","Bad Down Signals =",BSignalDOWN, "\n","\n",
   //"Good Signals =",GSignals,"\n","Good Signals percent=",GSignalsP);
              //       ObjectCreate("up label", OBJ_LABEL, 0,0,0);
                     
                //     ObjectSetText("up label", text, 15, "Arial", clr);
                     //bool ObjectSetText( string name, string text, int font_size, string font=NULL, color text_color=CLR_NONE)
                  //   ObjectSet("up label", OBJPROP_XDISTANCE,430);
                    // ObjectSet("up label", OBJPROP_YDISTANCE,0);
                  // }
                    // else
                      //{
                        //ObjectMove("up label", 0, 0, 0);
                      //}
                      
                      //a

   
   int www=GSignalsP*100 ;
   //e
    FMA11=iMA(Symbol(), 0, Fast_MA_Period, Fast_MA_Shift, Fast_MA_method, Fast_MA_Apply_to, 1);
    FMA22=iMA(Symbol(), 0, Fast_MA_Period, Fast_MA_Shift, Fast_MA_method, Fast_MA_Apply_to, 2);

    SMA11=iMA(Symbol(), 0, Slow_MA_Period, Slow_MA_Shift, Slow_MA_method, Slow_MA_Apply_to, 1);
    SMA22=iMA(Symbol(), 0, Slow_MA_Period, Slow_MA_Shift, Slow_MA_method, Slow_MA_Apply_to, 2);
   
  if (FMA11>SMA11 && FMA22<SMA22 && alert==true) {al1=false; if (al2==false) { Alert ("Close Sell Orders And Buy AT ",Close[1]); PlaySound(file); al2=true;}}

  if (FMA11<SMA11 && FMA22>SMA22 && alert==true) {al2=false; if (al1==false) { Alert ("Close Buy Orders And Sell AT ",Close[1]); PlaySound(file); al1=true;}}

   return(0);
  }

