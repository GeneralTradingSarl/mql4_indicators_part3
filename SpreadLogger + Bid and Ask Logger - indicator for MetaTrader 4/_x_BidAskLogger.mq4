//+------------------------------------------------------------------+
//|                                                 SpreadLogger.mq4 |
//|                                                           Mr. T. |
//|                                         http://www.codeforex.com |
//+------------------------------------------------------------------+
#property copyright "Mr. T."
#property link      "http://www.codeforex.com"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_width1 2
#property indicator_width2 2

extern int LastTicks=500;

double Spread_Ask[];
double Spread_Bid[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
   IndicatorBuffers(2);

   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,Spread_Ask);

   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,Spread_Bid);

   short_name="Bid Ask Logger ("+LastTicks+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"ASK");
   SetIndexLabel(1,"BID");
   objectCreate("mrt",10,10,"CopyRight by Mr. T @ www.codeforex.com ");
// ArrayResize(Spread_Ask,LastTicks+1);
//ArrayResize(Spread_Bid,LastTicks+1);

   for(int i=0; i<ArraySize(Spread_Ask); i++)
     {
      Spread_Ask[i]=EMPTY_VALUE;
     }

   for(int j=0; j<ArraySize(Spread_Bid); j++)
     {
      Spread_Bid[j]=EMPTY_VALUE;
     }
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete("mrt");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {

   for(int i=ArraySize(Spread_Bid)-1;i>0;i--)
     {
      if(Spread_Bid[i-1]!=EMPTY_VALUE) Spread_Ask[i] = Spread_Ask[i-1];
     }
   for(int j=ArraySize(Spread_Ask)-1;j>0;j--)
     {
      if(Spread_Ask[j-1]!=EMPTY_VALUE) Spread_Bid[j] = Spread_Bid[j-1];
     }
   Spread_Bid[0] = Bid;
   Spread_Ask[0] = Ask;

   return(0);
  }
//+------------------------------------------------------------------+
//    Create an Object -                                             |       
//+------------------------------------------------------------------+   
void objectCreate(string name,int x,int y,string text="",int size=12,
                  string font="Arial",color colour=Red)
  {
   ObjectCreate(name,OBJ_LABEL,1,0,0);
   ObjectSet(name,OBJPROP_CORNER,2);
   ObjectSet(name,OBJPROP_COLOR,colour);
   ObjectSet(name,OBJPROP_XDISTANCE,x);
   ObjectSet(name,OBJPROP_YDISTANCE,y);
   ObjectSetText(name,text,size,font,colour);
  }
//+------------------------------------------------------------------+
