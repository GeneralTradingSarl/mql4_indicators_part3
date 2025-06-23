//+------------------------------------------------------------------+
//|                                                   wajdyss        |
//|                                           Copyright 2009 Wajdyss |
//|                                              wajdyss@yahoo.com   |
//+------------------------------------------------------------------+
#property copyright "Copyright 2009 Wajdyss"
#property link      "wajdyss@yahoo.com"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 LawnGreen
#property indicator_color2 Red
#property indicator_color3 Blue
#property indicator_width1  2
#property indicator_width2  2
#property indicator_width3  2

extern int Tenkan=9;
extern int Kijun=26;
extern int Senkou=52;
extern bool alert=true;
string file="alert.wav";
int TextSize=14;
color TextColor1=Black;
color TextColor2=Blue;
color TextColor3=Red;
color TextColor4=Black;

double CrossUp[];
double CrossDown[];
int eyear=9999;
int emonth=9;
int eday=9;
bool al1=false;
bool al2=false;
int date1=999;
int date2=999;
int date6=999;
int second=20;
string Name="wajdyss Ichimoku Indicator";

double Kijun_Buffer[];
//----
int a_begin;
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
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,Kijun_Buffer);
   SetIndexDrawBegin(2,Kijun-1);
   SetIndexLabel(2,"Kijun Sen");
//----
   a_begin=Kijun; if(a_begin<Tenkan) a_begin=Tenkan;

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
      ObjectSetText("b label",Name,TextSize,"Arial",TextColor2);
      ObjectSet("b label",OBJPROP_XDISTANCE,310);
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

// if (Period() != 1440) return(0);

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

// if (Period()!=1440 || Symbol()!="GBPJPY") return(0);      
   int  same,notsame,samef,notsamef,samer,notsamer,samecandle,notsamecandle;
   double  GSignalUP=0,SignalUP=0,GSignalDOWN=0,SignalDOWN=0,AllSignal=0,BSignalUP=0
      ,BSignalDOWN=0;

   double samep,notsamep,all,GSignals,GSignalsP,GSignalUPP,GSignalDOWNP,fastMAnow,fastMAprevious,slowMAnow,slowMAprevious;
   double FMA1,FMA2,SMA1,SMA2;
   string sameforecast,notsameforecast,wajdyssforecast,status;
   double high,low,price;
   int k;

   if(Bars<=Tenkan || Bars<=Kijun || Bars<=Senkou) return(0);

   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+Kijun;

   for(int i=limit;i>=1;i--)
     {
      high=High[i]; low=Low[i]; k=i-1+Kijun;
      while(k>=i)
        {
         price=High[k];
         if(high<price) high=price;
         price=Low[k];
         if(low>price) low=price;
         k--;
        }
      Kijun_Buffer[i]=(high+low)/2;

      if(Close[i]>=Kijun_Buffer[i] && Close[i+1]<Kijun_Buffer[i+1])

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

         CrossUp[i]=Low[i]-5*Point;
         AllSignal++;
         SignalUP++;
         if(iClose(Symbol(),NULL,i-1)>iOpen(Symbol(),NULL,i-1))
            GSignalUP++;
         else BSignalUP++;
        }

      else  if(Close[i]<=Kijun_Buffer[i] && Close[i+1]>Kijun_Buffer[i+1])

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

         CrossDown[i]=High[i]+5*Point;
         AllSignal++;
         SignalDOWN++;
         if(iClose(Symbol(),NULL,i-1)<iOpen(Symbol(),NULL,i-1))
            GSignalDOWN++;
         else BSignalDOWN++;
        }
     }
   int j=1;
   i=1;
   int date3=TimeHour(Time[j]);
   int date4=TimeMinute(Time[j]);
   int date5=TimeDay(Time[j]);
   if(Close[i]>=Kijun_Buffer[i] && Close[i+1]<Kijun_Buffer[i+1] && alert==true && date1!=date3 && date2!=date4 && date5!=date6 && Seconds()<second)
     {date1=date3; date2=date4; date6=date5; Alert(Name," Close Sell Orders And Buy  ",Symbol()," AT ",iClose(Symbol(),0,i)); PlaySound(file); }

   if(Close[i]<=Kijun_Buffer[i] && Close[i+1]>Kijun_Buffer[i+1] && alert==true && date1!=date3 && date2!=date4 && date5!=date6 && Seconds()<second)

     {date1=date3; date2=date4; date6=date5; Alert(Name," Close Buy Orders And Sell  ",Symbol()," AT ",iClose(Symbol(),0,i)); PlaySound(file); }

   return(0);
  }
//+------------------------------------------------------------------+
