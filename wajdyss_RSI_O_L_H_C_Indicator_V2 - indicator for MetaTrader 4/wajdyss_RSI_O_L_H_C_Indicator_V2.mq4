//+------------------------------------------------------------------+
//|                                             wajdyss_MA_indicator |
//|                                           Copyright 2007 Wajdyss |
//|                                                wajdyss@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2008 Wajdyss"
#property link      "wajdyss@yahoo.com"

#property indicator_chart_window
extern int RSI_Period =14;
extern int Result_Size=10;
extern int Result_Candles=20;
extern color Open_Color=Green;
extern color Low_Color=Blue;
extern color High_Color=Red;
extern color Close_Color=Black;
extern int Result_Point=100;
extern string Note="-------------------";
extern int TextSize=14;
 extern color TextColor1=Black;
 extern  color TextColor2=Red;
 extern color TextColor3=Blue;
 extern color TextColor4=White;
 color TextColor5=Chartreuse;
int eyear=9999;
int emonth=9;
int eday=9;
string Name="wajdyss RSI O L H C Indicator";
string hname;
double Result;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
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
  ObjectsDeleteAll(0,OBJ_TEXT);

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
  Comment("");
 ObjectDelete("a label");
 ObjectDelete("b label");
 ObjectDelete("c label");
 ObjectDelete("d label");
  ObjectsDeleteAll(0,OBJ_TEXT);
 //   ArrayResize(Result33,Days);

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
      ObjectSetText("b label",Name  , TextSize, "Arial", TextColor2);
      ObjectSet("b label", OBJPROP_XDISTANCE,300);
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

//if (Period() != 1440) return(0);
   
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
   int  same , notsame, samef, notsamef, samer, notsamer, samecandle, notsamecandle ;
   
   double samep,notsamep,all,GSignals,GSignalsP, GSignalUPP,GSignalDOWNP,fastMAnow,fastMAprevious,slowMAnow,slowMAprevious;
   double FMA1,FMA2,SMA1,SMA2,rsiOpen,rsiLow,rsiHigh,rsiClose;
   string status,O_Name,L_Name,H_Name,C_Name,O_Name2,L_Name2,H_Name2,C_Name2 ;



   for (int i=Result_Candles;i>=0;i--) 
   { 
  
  rsiOpen= iRSI(Symbol(),0,RSI_Period,PRICE_OPEN,i);
  O_Name="O"+i;
  O_Name2=DoubleToStr(rsiOpen,1);
  
  rsiLow=  iRSI(Symbol(),0,RSI_Period,PRICE_LOW,i);
  L_Name="L"+i;
  L_Name2=DoubleToStr(rsiLow,1);

  rsiHigh= iRSI(Symbol(),0,RSI_Period,PRICE_HIGH,i);
  H_Name="H"+i;
  H_Name2=DoubleToStr(rsiHigh,1);

  rsiClose=iRSI(Symbol(),0,RSI_Period,PRICE_CLOSE,i);
  C_Name="C"+i;
  C_Name2=DoubleToStr(rsiClose,1);
  
  if (rsiOpen<rsiClose) 

  {
  SetText(L_Name,L_Name2,Time[i],(High[i]+(Result_Point*Point*2)),"Arial",Result_Size,Low_Color);
  SetText(H_Name,H_Name2,Time[i],(High[i]+Result_Point*Point),"Arial",Result_Size,High_Color);
  }

  else
  {
  SetText(H_Name,H_Name2,Time[i],(High[i]+(Result_Point*Point*2)),"Arial",Result_Size,High_Color);
  SetText(L_Name,L_Name2,Time[i],(High[i]+Result_Point*Point),"Arial",Result_Size,Low_Color);
  }
  
  SetText(O_Name,O_Name2,Time[i],(Low[i]-Result_Point*Point),"Arial",Result_Size,Open_Color);
  SetText(C_Name,C_Name2,Time[i],(Low[i]-(Result_Point*Point*2)),"Arial",Result_Size,Close_Color);
  

 //Comment(rsiOpen,"      ",rsiLow,"      ",rsiHigh,"      ",rsiClose);
   }
   
   
   return(0);
  }

void SetText(string name,string txt,datetime x,double y,string font,int size,color clr)
{
  int idx=0;
  if(ObjectFind(name) == -1)
  {
    ObjectCreate(name, OBJ_TEXT, idx, 0, 0);
    ObjectSetText(name, txt, size, font, clr);
    ObjectSet(name, OBJPROP_TIME1, x);
    ObjectSet(name, OBJPROP_PRICE1, y);
  }
  else
  {
    ObjectSet(name, OBJPROP_TIME1, x);
    ObjectSet(name, OBJPROP_PRICE1, y);
    ObjectSetText(name, txt, size, font, clr);
  } 
}