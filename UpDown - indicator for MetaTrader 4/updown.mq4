//+------------------------------------------------------------------+
//|                                                       UpDown.mq4 |
//|                                         Copyright 2015, mrak297. |
//|                            https://www.mql5.com/ru/users/mrak297 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, mrak297."
#property link      "https://www.mql5.com/ru/users/mrak297"
#property version   "15.6"
#property strict
#property indicator_chart_window
#define LINES 50 //Number of pairs
#define ELEMS 3  //Number of elements
//--- input parameters
input string Info       = "MODE button for change sorting.";
input int    Method     = 1;            //Method (1 open/close, 2 high/low)
input int    Num        = 10;           //Number of buttons
input int    FontSize   = 10;           //Font Size
input color  UpColor    = clrDarkGreen; //Color for uptrend
input color  DownColor  = clrOrangeRed; //Color for downtrend
input color  TextColor  = clrBlack;     //Color for text
input ENUM_BASE_CORNER CORNER=CORNER_LEFT_UPPER; //Corner
//---
string buttonname=" ";
int X;
int Y;
int ModeSort=1;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   X = 10;
   Y = 20;
   if(CORNER==CORNER_LEFT_LOWER)
     {
      Y=FontSize*2+10;
      for(int m=Num; m>=0; m--)
        {
         buttonname=IntegerToString(m);
         ButtonCreate(buttonname,clrBlack,X,Y);
         Y=Y+(FontSize*2);
        }
     }
   else if(CORNER==CORNER_RIGHT_LOWER)
     {
      Y = FontSize*2+10;
      X = X + FontSize*10;
      for(int m=Num; m>=0; m--)
        {
         buttonname=IntegerToString(m);
         ButtonCreate(buttonname,clrBlack,X,Y);
         Y=Y+(FontSize*2);
        }
     }
   else if(CORNER==CORNER_RIGHT_UPPER)
     {
      X=X+FontSize*10;
      for(int m=0; m<=Num; m++)
        {
         buttonname=IntegerToString(m);
         ButtonCreate(buttonname,clrBlack,X,Y);
         Y=Y+(FontSize*2);
        }
     }
   else
     {
      for(int m=0; m<=Num; m++)
        {
         buttonname=IntegerToString(m);
         ButtonCreate(buttonname,clrBlack,X,Y);
         Y=Y+(FontSize*2);
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   Find();
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   for(int d=Num; d>=0; d--) ObjectDelete(0,(string)d);
   return(0);
  }
//+------------------------------------------------------------------+
//| Main function                                                    |
//+------------------------------------------------------------------+
void Find()
  {
   string name;
   double Pairs[LINES][ELEMS];
//---
   ArrayInitialize(Pairs,1000);
//---
   for(int i=0; i<LINES; i++)
     {
      name=SymbolName(i,true);
      Pairs[i][0] = (double)i;
      Pairs[i][1] = CalcRange(name, Method);
      Pairs[i][2] = Moving(name);
     }
//---
   SortArray(ModeSort,Pairs);
//---
   for(int n=0; n<Num; n++)
     {
      string lName=IntegerToString(n);
      if(ObjectFind(0,lName)==0)
        {
         string lTxt=SymbolName((int)Pairs[n][0],true)+" "+DoubleToString(Pairs[n][1],0);
         ObjectSetString(0,lName,OBJPROP_TEXT,lTxt);
         if(Pairs[n][2] == 0) ObjectSetInteger(0, lName, OBJPROP_BGCOLOR, clrBlue);
         if(Pairs[n][2] == 1) ObjectSetInteger(0, lName, OBJPROP_BGCOLOR, UpColor);
         if(Pairs[n][2] == -1) ObjectSetInteger(0, lName, OBJPROP_BGCOLOR, DownColor);
        }
     }
//---
   string modebutt=IntegerToString(Num);
   if(ObjectFind(0,modebutt)==0)
     {
      ObjectSetString(0,modebutt,OBJPROP_TEXT,"MODE");
      ObjectSetInteger(0,modebutt,OBJPROP_BGCOLOR,clrDodgerBlue);
     }
  }
//+------------------------------------------------------------------+
//| Button creation                                                  |
//+------------------------------------------------------------------+
void ButtonCreate(string name,color bgcolor,int x,int y)
  {
   if(ObjectCreate(0,name,OBJ_BUTTON,0,0,0))
     {
      ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(0,name,OBJPROP_XSIZE,FontSize*10);
      ObjectSetInteger(0,name,OBJPROP_YSIZE,FontSize*2);
      ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER);
      ObjectSetInteger(0,name,OBJPROP_FONTSIZE,FontSize);
      ObjectSetInteger(0,name,OBJPROP_BGCOLOR,bgcolor);
      ObjectSetInteger(0,name,OBJPROP_COLOR,TextColor);
      ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrNONE);
      ObjectSetInteger(0,name,OBJPROP_BACK,false);
      ObjectSetInteger(0,name,OBJPROP_STATE,false);
      ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,name,OBJPROP_SELECTED,false);
      ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
      ObjectSetInteger(0,name,OBJPROP_ZORDER,0);
      ObjectSetString(0,name,OBJPROP_FONT,"Arial");
     }
   return;
  }
//+------------------------------------------------------------------+
//| Array sorting                                                    |
//+------------------------------------------------------------------+
void SortArray(int mode,double &array[][])
  {
   if(mode==1)
     {
      for(int c=0; c<=(LINES*ELEMS); c++)
        {
         for(int x=0; x<LINES-1; x++)
           {
            if(array[x][1]<array[x+1][1])
              {
               for(int y=0; y<ELEMS; y++)
                 {
                  double temp1= array[x][y];
                  array[x][y] = array[x+1][y];
                  array[x+1][y]=temp1;
                 }
              }
           }
        }
     }
   else if(mode==2)
     {
      for(int d=0; d<(LINES*ELEMS); d++)
        {
         for(int a=0; a<LINES-1; a++)
           {
            if(array[a][1]>array[a+1][1])
              {
               for(int b=0; b<ELEMS; b++)
                 {
                  double temp2= array[a][b];
                  array[a][b] = array[a+1][b];
                  array[a+1][b]=temp2;
                 }
              }
           }
        }
     }
   else Print("ERROR SortArray mode.");
   return;
  }
//+------------------------------------------------------------------+
//| Click handler                                                    |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if(sparam!=IntegerToString(Num))
        {
         string pn=StringSubstr(ObjectGetString(0,sparam,OBJPROP_TEXT),0,6);
         ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
         ChartOpen(pn,15);
        }
      else
        {
         if(ModeSort==1) ModeSort=2;
         else ModeSort=1;
         WindowRedraw();
        }
     }
  }
//+------------------------------------------------------------------+
//| Range calculation                                                |
//+------------------------------------------------------------------+
double CalcRange(const string &symbol,int modecalc)
  {
   double result=0;
   double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
   double spread=(double)SymbolInfoInteger(symbol,SYMBOL_SPREAD);
   double Pp=(ask-bid)/spread;
//---
   if(modecalc==1 && Pp!=0)
     {
      double op = iOpen(symbol, 1440, 0);
      double cl = iClose(symbol, 1440, 0);
      if(op>cl) result=(op-cl)/Pp;
      else if(op<cl) result=(cl-op)/Pp;
      else result=0;
     }
   if(modecalc==2 && Pp!=0)
     {
      double hi = iHigh(symbol, 1440, 0);
      double lo = iLow(symbol, 1440, 0);
      result=(hi-lo)/Pp;
     }
//---
   return(MathRound(result));
  }
//+------------------------------------------------------------------+
//| Direction detection                                              |
//+------------------------------------------------------------------+
double Moving(const string &symbol)
  {
   double res= 0;
   double op = iOpen(symbol, 1440, 0);
   double cl = iClose(symbol, 1440, 0);
   if(op > cl) res = -1;
   if(op < cl) res = 1;
   if(op==cl) res=0;
   return(res);
  }
//+-------------------------------------------------------------------+
