//+------------------------------------------------------------------+
//|                                                   wajdyss        |
//|                                           Copyright 2009 Wajdyss |
//|                                              wajdyss@yahoo.com   |
//+------------------------------------------------------------------+
#property copyright "Copyright 2009 Wajdyss"
#property link      "wajdyss@yahoo.com"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 LawnGreen
#property indicator_color2 Red
#property indicator_width1  1
#property indicator_width2  1

extern int TargetPeriod=34;
extern int FiboPeriod=17;
extern int Pips=20;
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
int second=60;
string Name="wajdyss FIBO_S Indicator";

double ExtMapBuffer[];
double zzL[];
double zzH[];
double zz[];

double target1=0,target2=0;

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
      ObjectSet("a label",OBJPROP_XDISTANCE,650);
      ObjectSet("a label",OBJPROP_YDISTANCE,0);
     }

//b
   if(ObjectFind("b label")!=0)
     {
      ObjectCreate("b label",OBJ_LABEL,0,0,0);
      ObjectSetText("b label",Name,TextSize,"Arial",TextColor2);
      ObjectSet("b label",OBJPROP_XDISTANCE,610);
      ObjectSet("b label",OBJPROP_YDISTANCE,25);
     }

// c

   if(ObjectFind("c label")!=0)
     {
      ObjectCreate("c label",OBJ_LABEL,0,0,0);
      ObjectSetText("c label","wajdyss@yahoo.com",TextSize,"Arial",TextColor3);
      ObjectSet("c label",OBJPROP_XDISTANCE,635);
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
         ObjectSet("d label",OBJPROP_XDISTANCE,550);
         ObjectSet("d label",OBJPROP_YDISTANCE,75);
        }
      return(0);
     }
   else
   if(ObjectFind("d label")!=0)
     {
      ObjectCreate("d label",OBJ_LABEL,0,0,0);
      ObjectSetText("d label","the indicator well expire after ( "+eday+"-"+emonth+"-"+eyear+" )",TextSize,"Arial",TextColor4);
      ObjectSet("d label",OBJPROP_XDISTANCE,565);
      ObjectSet("d label",OBJPROP_YDISTANCE,75);
     }

   ArrayResize(ExtMapBuffer,Bars+1);

// if (Period()!=1440 || Symbol()!="GBPJPY") return(0);      
   int  same,notsame,samef,notsamef,samer,notsamer,samecandle,notsamecandle;
   double  GSignalUP=0,SignalUP=0,GSignalDOWN=0,SignalDOWN=0,AllSignal=0,BSignalUP=0
      ,BSignalDOWN=0;

   double samep,notsamep,all,GSignals,GSignalsP,GSignalUPP,GSignalDOWNP,fastMAnow,fastMAprevious,slowMAnow,slowMAprevious;
   double FMA1,FMA2,SMA1,SMA2;
   string sameforecast,notsameforecast,wajdyssforecast,status;
   double high,low,price;
   int k;
   int    ii,shift,pos,lasthighpos,lastlowpos,curhighpos,curlowpos;
   int    targethighpos,targetlowpos;
   double curlow,curhigh,lasthigh,lastlow,targethigh,targetlow;
   double min,max;

   lasthighpos=Bars-1; lastlowpos=Bars-1;
   lastlow=Low[Bars-1];lasthigh=High[Bars-1];

   targethighpos=Bars-1; targetlowpos=Bars-1;
   targetlow=Low[Bars-1];targethigh=High[Bars-1];

   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+MathMax(TargetPeriod,FiboPeriod);

   if(limit>0)
     {
      int size=ArraySize(CrossUp);
      ArrayResize(zzH,size);
      ArrayResize(zzL,size);
      ArrayResize(zz,size);
     }

   for(shift=limit; shift>=1; shift--)
     {
      curlowpos=Lowest(NULL,0,MODE_LOW,FiboPeriod,shift);
      curlow=Low[curlowpos];
      curhighpos=Highest(NULL,0,MODE_HIGH,FiboPeriod,shift);
      curhigh=High[curhighpos];

      if(shift<Bars-TargetPeriod)
        {
         targetlowpos=Lowest(NULL,0,MODE_LOW,TargetPeriod,shift);
         targetlow=Low[targetlowpos];
         targethighpos=Highest(NULL,0,MODE_HIGH,TargetPeriod,shift);
         targethigh=High[targethighpos];
        }
      //------------------------------------------------
      if(curlow>=lastlow) { lastlow=curlow; }
      else
        {
         if(lasthighpos>curlowpos)
           {
            zzL[curlowpos]=curlow;
            min=100000; pos=lasthighpos;
            for(ii=lasthighpos; ii>=curlowpos; ii--)
              {
               if(zzL[ii]==0.0) continue;
               if(zzL[ii]<min) { min=zzL[ii]; pos=ii; }
               zz[ii]=0.0;
              }
            zz[pos]=min;
           }
         lastlowpos=curlowpos;
         lastlow=curlow;
        }
      //--- high
      if(curhigh<=lasthigh) { lasthigh=curhigh;}
      else
        {
         if(lastlowpos>curhighpos)
           {
            zzH[curhighpos]=curhigh;
            max=-100000; pos=lastlowpos;
            for(ii=lastlowpos; ii>=curhighpos; ii--)
              {
               if(zzH[ii]==0.0) continue;
               if(zzH[ii]>max) { max=zzH[ii]; pos=ii; }
               zz[ii]=0.0;
              }
            zz[pos]=max;
           }
         lasthighpos=curhighpos;
         lasthigh=curhigh;
        }
      double p,r5,r4,r3,r2,r1,r0;
      double R2= targethigh - targetlow;
      double R1= lasthigh - lastlow;
      double R=High[lasthighpos]-Low[lastlowpos];
      int div=10000;
      color Line_color=Green;
      color Target_color=Red;
      if(Digits==2)div=100;
      if(Digits==4)div=10000;

      ExtMapBuffer[shift]=0;

      if(lastlowpos<lasthighpos)
        {
         p=curlow;
         r5 = p + (R * 1);
         r4 = p + (R * 0.618);
         r3 = p + (R * 0.5);
         r2 = p + (R * 0.382);
         r1 = p + (R * 0.236);
         r0 = p + (R * 0);
         if(Close[0]>(targetlow+(R2*0.618)))target1=targethigh+(R2*0.618);
         if(Close[0]>target1)target1=0;

         if(Close[shift]>(curlow+(R1*0.382))) ExtMapBuffer[shift]=((Close[shift]-curlow)-R1)*div;
         else  ExtMapBuffer[shift]=((Close[shift]-curlow)-R1)*div;
         //Comment(ExtMapBuffer[shift+1]);
        }

      if(lasthighpos<lastlowpos)
        {
         p=curhigh;
         r5 = p - (R * 1);
         r4 = p - (R * 0.618);
         r3 = p - (R * 0.5);
         r2 = p - (R * 0.382);
         r1 = p - (R * 0.236);
         r0 = p - (R * 0);
         if(Close[0]<(targethigh-(R2*0.618)))target2=targetlow -(R2*0.618);
         if(Close[0]<target2)target2=0;

         if(Close[shift]<(curhigh-(R1*0.382))) ExtMapBuffer[shift]=(R1-(curhigh-Close[shift]))*div;
         else  ExtMapBuffer[shift]=(R1-(curhigh-Close[shift]))*div;
        }

      int i=shift;
      if(ExtMapBuffer[i]>=0 && ExtMapBuffer[i+1]<0)

        {
         if((Year()>eyear) || (Year()==eyear && Month()>emonth) || (Year()==eyear && Month()==emonth && Day()>eday))
           {
            //d
            if(ObjectFind("d label")!=0)
              {
               ObjectCreate("d label",OBJ_LABEL,0,0,0);
               ObjectSetText("d label","the indicator has expired , contact us by E-mail",TextSize,"Arial",TextColor4);
               ObjectSet("d label",OBJPROP_XDISTANCE,550);
               ObjectSet("d label",OBJPROP_YDISTANCE,75);
              }
            return(0);
           }
         else
         if(ObjectFind("d label")!=0)
           {
            ObjectCreate("d label",OBJ_LABEL,0,0,0);
            ObjectSetText("d label","the indicator well expire after ( "+eday+"-"+emonth+"-"+eyear+" )",TextSize,"Arial",TextColor4);
            ObjectSet("d label",OBJPROP_XDISTANCE,565);
            ObjectSet("d label",OBJPROP_YDISTANCE,75);
           }

         CrossUp[i]=Low[i]-Pips*Point;
         AllSignal++;
         SignalUP++;
         if(iClose(Symbol(),NULL,i-1)>iOpen(Symbol(),NULL,i-1))
            GSignalUP++;
         else BSignalUP++;
        }

      else   if(ExtMapBuffer[i]<0 && ExtMapBuffer[i+1]>=0)

        {
         if((Year()>eyear) || (Year()==eyear && Month()>emonth) || (Year()==eyear && Month()==emonth && Day()>eday))
           {
            //d
            if(ObjectFind("d label")!=0)
              {
               ObjectCreate("d label",OBJ_LABEL,0,0,0);
               ObjectSetText("d label","the indicator has expired , contact us by E-mail",TextSize,"Arial",TextColor4);
               ObjectSet("d label",OBJPROP_XDISTANCE,550);
               ObjectSet("d label",OBJPROP_YDISTANCE,75);
              }
            return(0);
           }
         else
         if(ObjectFind("d label")!=0)
           {
            ObjectCreate("d label",OBJ_LABEL,0,0,0);
            ObjectSetText("d label","the indicator well expire after ( "+eday+"-"+emonth+"-"+eyear+" )",TextSize,"Arial",TextColor4);
            ObjectSet("d label",OBJPROP_XDISTANCE,565);
            ObjectSet("d label",OBJPROP_YDISTANCE,75);
           }

         CrossDown[i]=High[i]+Pips*Point;
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
   if(ExtMapBuffer[i]>=0 && ExtMapBuffer[i+1]<0 && alert==true && date1!=date3 && date2!=date4 && date5!=date6 && Seconds()<second)
     {date1=date3; date2=date4; date6=date5; Alert(Name," Close Sell Orders And Buy  ",Symbol()," AT ",iClose(Symbol(),0,i)); PlaySound(file); }

   if(ExtMapBuffer[i]<0 && ExtMapBuffer[i+1]>=0 && alert==true && date1!=date3 && date2!=date4 && date5!=date6 && Seconds()<second)
     {date1=date3; date2=date4; date6=date5; Alert(Name," Close Buy Orders And Sell  ",Symbol()," AT ",iClose(Symbol(),0,i)); PlaySound(file); }

   return(0);
  }
//+------------------------------------------------------------------+
