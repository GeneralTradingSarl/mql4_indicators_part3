//+------------------------------------------------------------------+
//|                                             wajdyss_MA_indicator |
//|                                           Copyright 2007 Wajdyss |
//|                                                wajdyss@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2008 Wajdyss"
#property link      "wajdyss@yahoo.com"

#property indicator_chart_window
extern bool High_Low=true;
extern int Result_Size=10;
extern color Result_Color=Lime;
extern int Result_Point=100;
extern string Note="-------------------";
extern int TextSize=14;
extern color TextColor1=White;
extern color TextColor2=Yellow;
extern color TextColor3=Aqua;
extern color TextColor4=Red;
extern color TextColor5=Chartreuse;
int eyear=9999;
int emonth=9;
int eday=9;
string Name="wajdyss Candles Length";
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
      ObjectSetText("b label",Name,TextSize,"Arial",TextColor2);
      ObjectSet("b label",OBJPROP_XDISTANCE,320);
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

//if (Period() != 1440) return(0);

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
   string sameforecast,notsameforecast,wajdyssforecast,status;

//   if (manual ==true) status="manual"; else status="auto";

  // for(int i=Bars;i>=1;i--)
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit--;  
  
  for(int i=limit;i>=1;i--)
     {
      hname="h"+i;
      if(High_Low) Result=(High[i]-Low[i])/Point; else Result=(Close[i]-Open[i])/Point;
      string Name2=DoubleToStr(Result,0);
      SetText(hname,Name2,Time[i],(High[i]+Result_Point*Point),"Arial",Result_Size,Result_Color);
     }

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetText(string name,string txt,datetime x,double y,string font,int size,color clr)
  {
   int idx=0;
   if(ObjectFind(name)==-1)
     {
      ObjectCreate(name,OBJ_TEXT,idx,0,0);
      ObjectSetText(name,txt,size,font,clr);
      ObjectSet(name,OBJPROP_TIME1,x);
      ObjectSet(name,OBJPROP_PRICE1,y);
     }
   else
     {
      ObjectSet(name,OBJPROP_TIME1,x);
      ObjectSet(name,OBJPROP_PRICE1,y);
      ObjectSetText(name,txt,size,font,clr);
     }
  }
//+------------------------------------------------------------------+
