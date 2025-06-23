#property copyright "wajdyss"
#property link      "wajdyss@yahoo.com"
//----
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Red
#property indicator_color2 Green
#property indicator_color3 Magenta
#property indicator_color4 Lime

#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
#property indicator_width4 2


//----
extern int  Lb           =10;
extern  bool alert = true;
//----
double ssld[];
double sslu[];
double Hlv[];

double CrossUp[];
double CrossDown[];

 string file="alert.wav";
 int TextSize=14;
 extern color TextColor1=White;
 extern  color TextColor2=Yellow;
 extern color TextColor3=Aqua;
 extern color TextColor4=Red;
 color TextColor5=Chartreuse;
 string Name=" wajdyss_SSL_Channel_Chart_Alert_Indicator";
int eyear=9999;
int emonth=9;
int eday=9;
bool al1=false;
bool al2=false;
int D;
 int second=20;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   
   IndicatorBuffers(8);
    SetIndexBuffer(0,ssld); SetIndexDrawBegin(0,Lb+1);
   SetIndexBuffer(1,sslu); SetIndexDrawBegin(0,Lb+1);
   SetIndexBuffer(4,Hlv);
  
   SetIndexStyle(3, DRAW_ARROW, EMPTY);
   SetIndexArrow(3, 233);
   SetIndexBuffer(3, CrossUp);
   SetIndexStyle(2, DRAW_ARROW, EMPTY);
   SetIndexArrow(2, 234);
   SetIndexBuffer(2, CrossDown);

D=Time[1];

   return(0);
  }

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
//|                                                                  |
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
      ObjectSet("b label", OBJPROP_XDISTANCE,230);
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

   int counted_bars=IndicatorCounted();
   int i,limit;
//----
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//----
   for(i=limit;i>=1;i--)
     {
      Hlv[i]=Hlv[i+1];
      if(Close[i]>iMA(Symbol(),0,Lb,0,MODE_SMA,PRICE_HIGH,i+1)) Hlv[i]= 1;
      if(Close[i]<iMA(Symbol(),0,Lb,0,MODE_SMA,PRICE_LOW,i+1))  Hlv[i]=-1;
      if(Hlv[i]==-1)
        {
         ssld[i]=iMA(Symbol(),0,Lb,0,MODE_SMA,PRICE_HIGH,i+1);
         sslu[i]=iMA(Symbol(),0,Lb,0,MODE_SMA,PRICE_LOW ,i+1);
        }
      else
        {
         ssld[i]=iMA(Symbol(),0,Lb,0,MODE_SMA,PRICE_LOW ,i+1);
         sslu[i]=iMA(Symbol(),0,Lb,0,MODE_SMA,PRICE_HIGH,i+1);
        }
    if (sslu[i]>ssld[i] && sslu[i+1]<=ssld[i+1])   { CrossUp  [i] = Low[i] -5*Point; al1=true; al2=false;}
    if (sslu[i]<ssld[i] && sslu[i+1]>=ssld[i+1])   { CrossDown[i] = High[i]+5*Point; al1=false; al2= true;}
    
     }
     //Comment ("i= ",i," sslu= ",sslu[1]," ssld= ",ssld[1]);
//----
//----
if (al1==true && D!=Time[i] && alert==true && Seconds()<second)
   {D=Time[1]; Alert (Name," Close Sell Orders And Buy  ",Symbol()," AT ",iClose(Symbol(),0,i)); PlaySound(file); }

if (al2==true && D!=Time[i] && alert==true && Seconds()<second)

 {D=Time[1];  Alert (Name," Close Buy Orders And Sell  ",Symbol()," AT ",iClose(Symbol(),0,i)); PlaySound(file); }


   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

