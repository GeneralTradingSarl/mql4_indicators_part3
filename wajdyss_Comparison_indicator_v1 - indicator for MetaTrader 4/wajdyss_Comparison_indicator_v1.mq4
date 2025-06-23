//+------------------------------------------------------------------+
//|          indicator                          wajdi Comparison.mq4 |
//|                                           Copyright 2007 Wajdyss |
//|                                                wajdyss@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2008 Wajdyss"
#property link      "wajdyss@yahoo.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_width1  2
#property indicator_width2  2

int days=350;
//int candle=350;
extern string C="USDCHF";
extern int TextSize=14;
 extern color TextColor1=Black;
 extern color TextColor2=Red;
 extern color TextColor3=Blue;
extern color TextColor4=White;
extern color TextColor5=Green;
bool manual=true;
int w=0,ww=0;
double CrossUp[];
double CrossDown[];
int eyear=9999;
int emonth=9;
int eday=9;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW, EMPTY);
   SetIndexArrow(0, 67);
   SetIndexBuffer(0, CrossUp);
   SetIndexStyle(1, DRAW_ARROW, EMPTY);
   SetIndexArrow(1, 68);
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
      ObjectSetText("b label","wajdyss Comparision indicator"  , TextSize, "Arial", TextColor2);
      ObjectSet("b label", OBJPROP_XDISTANCE,295);
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
   
   double samep,notsamep,all,GSignals,GSignalsP, GSignalUPP,GSignalDOWNP;
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

   for (int j=days;j>=1;j--) 
   {   if (((iClose(Symbol(),NULL,j)>iOpen(Symbol(),NULL,j)) && (iClose(C,NULL,j)>iOpen(C,NULL,j))) || 
   ((iClose(Symbol(),NULL,j)<iOpen(Symbol(),NULL,j)) && (iClose(C,NULL,j)<iOpen(C,NULL,j)))) 
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
   CrossUp[j] = High[j]+20*Point;
   AllSignal++;
   //SignalUP++;
   //if (iClose(Symbol(),NULL,j-1)>iOpen(Symbol(),NULL,j-1) && iClose(C,NULL,j-1)>iOpen(C,NULL,j-1))
   GSignalUP++;
   //else BSignalUP++;
   }
   
   
       else
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
//      SignalDOWN++;
  // if (iClose(Symbol(),NULL,j-1)<iOpen(Symbol(),NULL,j-1) && iClose(C,NULL,j-1)<iOpen(C,NULL,j-1))
    //GSignalDOWN++;
   //else 
   BSignalDOWN++;
   }
}

GSignals=GSignalUP;
GSignalsP=GSignals/AllSignal;
//GSignalUPP=(GSignalUP/SignalUP);
//GSignalDOWNP=(GSignalDOWN/SignalDOWN);
 
 //   Comment ("\n" , "ÈÓã Çááå Ç áÑÍãä ÇáÑÍíã" ,"\n" ,"\n","wajdyss@yahoo.com", "\n" ,"\n" , "wajdyss forecast indicator", "\n","\n",
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
   if(ObjectFind("e label") != 0)
   {
      ObjectCreate("e label", OBJ_LABEL, 0,0,0);
      ObjectSetText("e label","%"+ "äÓÈÉ äÌÇÍ ÇáãÄÔÑ ="+ www  , TextSize, "Arial", TextColor5);
      ObjectSet("e label", OBJPROP_XDISTANCE,340);
     ObjectSet("e label", OBJPROP_YDISTANCE,100);
   }
   else
   {
   ObjectMove("e label", 0,  0,0);
   }
 
   return(0);
  }

