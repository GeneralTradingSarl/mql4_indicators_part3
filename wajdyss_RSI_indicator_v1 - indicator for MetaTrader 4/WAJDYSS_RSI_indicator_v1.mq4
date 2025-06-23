//+------------------------------------------------------------------+
//|                                            WAJDYSS_RSI_indicator |
//|                                           Copyright 2008 WAJDYSS |
//|                                                wajdyss@yahoo.com |
//+------------------------------------------------------------------+
// ÃÑ ÇÓ Çí

#property copyright "Copyright 2008 Wajdyss"
#property link      "wajdyss@yahoo.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 LawnGreen
#property indicator_color2 Red
#property indicator_width1  2
#property indicator_width2  2

extern int RSI_Period=14;
extern string Apply_to="0=Close, 1=Open, 2=High, 3=Low, 4=Median (High+low)/2, 5=Typical (High+low+close)/3,6=Weighted close (High+low+close+close)/4";
extern int RSI_Apply_to =0;
extern int RSI_1st_Level=70;
extern int RSI_2nd_Level=50;
extern int RSI_3rd_Level=30;
extern int Pips=20;
int days=350;
extern bool alert=true;
string file="alert.wav";
int TextSize=14;
extern color TextColor1=White;
extern color TextColor2=Yellow;
extern color TextColor3=Aqua;
extern color TextColor4=Red;
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
int MA_Result;
int RSI_Buy=1;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_ARROW,EMPTY);
   SetIndexArrow(0,233);
   SetIndexBuffer(0,CrossUp);
   SetIndexStyle(1,DRAW_ARROW,EMPTY);
   SetIndexArrow(1,234);
   SetIndexBuffer(1,CrossDown);
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
   if(ObjectFind("a label")!=0)
     {
      ObjectCreate("a label",OBJ_LABEL,0,0,0);
      ObjectSetText("a label","ÈÓã Çááå ÇáÑÍãä ÇáÑÍíã",TextSize,"Arial",TextColor1);
      ObjectSet("a label",OBJPROP_XDISTANCE,350);
      ObjectSet("a label",OBJPROP_YDISTANCE,0);
     }

//b
   if(ObjectFind("b label")!=0)
     {
      ObjectCreate("b label",OBJ_LABEL,0,0,0);
      ObjectSetText("b label","wajdyss RSI indicator",TextSize,"Arial",TextColor2);
      ObjectSet("b label",OBJPROP_XDISTANCE,330);
      ObjectSet("b label",OBJPROP_YDISTANCE,25);
     }

// c

   if(ObjectFind("c label")!=0)
     {
      ObjectCreate("c label",OBJ_LABEL,0,0,0);
      ObjectSetText("c label","wajdyss@yahoo.com",TextSize,"Arial",TextColor3);
      ObjectSet("c label",OBJPROP_XDISTANCE,335);
      ObjectSet("c label",OBJPROP_YDISTANCE,50);
     }

//if (Symbol()!="EURJPY" || Period()!=1440) return(0);

   if((Year()>eyear) || (Year()==eyear && Month()>emonth) || (Year()==eyear && Month()==emonth && Day()>eday))
     {
      //d
      if(ObjectFind("d label")!=0)
        {
         ObjectCreate("d label",OBJ_LABEL,0,0,0);
         ObjectSetText("d label","the indicator has expired , contact us by E-mail",TextSize,"Arial",TextColor4);
         ObjectSet("d label",OBJPROP_XDISTANCE,250);
         ObjectSet("d label",OBJPROP_YDISTANCE,75);
        }
      return(0);
     }
   else
   if(ObjectFind("d label")!=0)
     {
      ObjectCreate("d label",OBJ_LABEL,0,0,0);
      ObjectSetText("d label","the indicator well expire after ( "+eday+"-"+emonth+"-"+eyear+" )",TextSize,"Arial",TextColor4);
      ObjectSet("d label",OBJPROP_XDISTANCE,265);
      ObjectSet("d label",OBJPROP_YDISTANCE,75);
     }

   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit--;

   int  samer,notsamer,samecandle,notsamecandle;
   double  GSignalUP=0,SignalUP=0,GSignalDOWN=0,SignalDOWN=0,AllSignal=0,BSignalUP=0,BSignalDOWN=0,a=High[0]+50*Point;

   double samep,notsamep,all,GSignals,GSignalsP,GSignalUPP,GSignalDOWNP;
   string sameforecast,notsameforecast,wajdyssforecast,status;
   int up=0;

//   if (manual ==true) status="manual"; else status="auto";
     //{samecandle=w; notsamecandle=ww;}
   all=days;
   samep=(samer/all);
   notsamep=(notsamer/all);

   samecandle=w;
   notsamecandle=ww;
   if(iClose(Symbol(),NULL,samecandle)>iOpen(Symbol(),NULL,samecandle)) sameforecast="up trend"; else sameforecast="down trend";
   if(iClose(Symbol(),NULL,notsamecandle)<iOpen(Symbol(),NULL,notsamecandle)) notsameforecast="up trend"; else notsameforecast="down trend";
   if(sameforecast==notsameforecast) wajdyssforecast=sameforecast;
   else wajdyssforecast="no trading today";

   for(int i=limit;i>=1;i--)
     {
      int date=TimeDay(Time[i-1]);
      if(((iRSI(Symbol(),0,RSI_Period,RSI_Apply_to,i)>RSI_2nd_Level && iRSI(Symbol(),0,RSI_Period,RSI_Apply_to,i)<RSI_1st_Level) || iRSI(Symbol(),0,RSI_Period,RSI_Apply_to,i)<RSI_3rd_Level) && RSI_Buy==-1)

        {
         if((Year()>eyear) || (Year()==eyear && Month()>emonth) || (Year()==eyear && Month()==emonth && Day()>eday))
           {
            //d
            if(ObjectFind("d label")!=0)
              {
               ObjectCreate("d label",OBJ_LABEL,0,0,0);
               ObjectSetText("d label","the indicator has expired , contact us by E-mail",TextSize,"Arial",TextColor4);
               ObjectSet("d label",OBJPROP_XDISTANCE,250);
               ObjectSet("d label",OBJPROP_YDISTANCE,75);
              }
            return(0);
           }
         else
         if(ObjectFind("d label")!=0)
           {
            ObjectCreate("d label",OBJ_LABEL,0,0,0);
            ObjectSetText("d label","the indicator well expire after ( "+eday+"-"+emonth+"-"+eyear+" )",TextSize,"Arial",TextColor4);
            ObjectSet("d label",OBJPROP_XDISTANCE,265);
            ObjectSet("d label",OBJPROP_YDISTANCE,75);
           }

         CrossUp[i]=Low[i]-Pips*Point;
         AllSignal++;
         SignalUP++;
         up=1;
         RSI_Buy=1;
         if(iClose(Symbol(),NULL,i-1)>iOpen(Symbol(),NULL,i-1))
            GSignalUP++;
         else BSignalUP++;
        }

      //if ((iRSI(Symbol(),PERIOD_D1,RSI,PRICE_CLOSE,i)<50 && iRSI(Symbol(),PERIOD_D1,RSI,PRICE_CLOSE,i)>70) || iRSI(Symbol(),PERIOD_D1,RSI,PRICE_CLOSE,i)>30)

      else if(RSI_Buy==1)
        {
         if((Year()>eyear) || (Year()==eyear && Month()>emonth) || (Year()==eyear && Month()==emonth && Day()>eday))
           {
            //d
            if(ObjectFind("d label")!=0)
              {
               ObjectCreate("d label",OBJ_LABEL,0,0,0);
               ObjectSetText("d label","the indicator has expired , contact us by E-mail",TextSize,"Arial",TextColor4);
               ObjectSet("d label",OBJPROP_XDISTANCE,250);
               ObjectSet("d label",OBJPROP_YDISTANCE,75);
              }
            return(0);
           }
         else
         if(ObjectFind("d label")!=0)
           {
            ObjectCreate("d label",OBJ_LABEL,0,0,0);
            ObjectSetText("d label","the indicator well expire after ( "+eday+"-"+emonth+"-"+eyear+" )",TextSize,"Arial",TextColor4);
            ObjectSet("d label",OBJPROP_XDISTANCE,265);
            ObjectSet("d label",OBJPROP_YDISTANCE,75);
           }

         CrossDown[i]=High[i]+Pips*Point;
         AllSignal++;
         SignalDOWN++;
         up=-1;
         RSI_Buy=-1;
         if(iClose(Symbol(),NULL,i-1)<iOpen(Symbol(),NULL,i-1))
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
//}
//a
   int www=GSignalsP*100;
//e
   if(up==1 && alert==true) {al1=false; if(al2==false) { Alert("Close Sell Orders And Buy AT ",Close[1]); PlaySound(file); al2=true;}}
   if(up==-1 && alert==true){al2=false; if(al1==false) { Alert("Close Buy Orders And Sell AT ",Close[1]); PlaySound(file); al1=true;}}
//e
//  if(ObjectFind("e label") != 0)
//{
//  ObjectCreate("e label", OBJ_LABEL, 0,0,0);
//  ObjectSetText("e label","%"+ "äÓÈÉ äÌÇÍ ÇáãÄÔÑ ="+ www  , TextSize, "Arial", TextColor5);
//  ObjectSet("e label", OBJPROP_XDISTANCE,340);
// ObjectSet("e label", OBJPROP_YDISTANCE,100);
// }

   return(0);
  }
//+------------------------------------------------------------------+
