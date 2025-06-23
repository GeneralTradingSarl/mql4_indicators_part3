//+——————————————————————+
//| Ticks2Rangebar.mq4 |
//| A Sexy Trader |
//| http://5to5000.wordpress.com |
//+——————————————————————+
#property copyright "A Sexy Trader"
#property link "http://yijomza.wordpress.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Navy

#include <stdlib.mqh>
//—- buffers
extern int MaxDrawTicks=500
                        ,Range=10
;

double ExtMapBuffer1[],iNOpen[8888888],iLClose[8888888]
   ,nOpen,Price1,Price2,lastTick,lastOpen,lastClose
   ,TickMOM
   ,tick[8888888]
;
int myBars,Time1,Time2,BarTime1,BarTime2,shift;
int tickCounter,BarCounter,iBTime1[8888888],iBTime2[8888888];
int delimeterCounter;
bool NewBar;
string StrBar="Bar",tickstr;
//+——————————————————————+
//| Custom indicator initialization function |
//+——————————————————————+
int init()
  {
//—- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexEmptyValue(0,0.0);

   IndicatorShortName("TickPrice("+Range+")~MaxDrawTicks("+MaxDrawTicks+")");

//   for(int i=Bars-1;i>=0;i--) ExtMapBuffer1[i]=0.0;

   nOpen=Bid;

   ArrayResize(iNOpen,MaxDrawTicks);
   ArrayResize(iLClose,MaxDrawTicks);
   ArrayResize(iBTime1,MaxDrawTicks);
   ArrayResize(iBTime2,MaxDrawTicks);

   for(int i=0;i<ObjectsTotal();i++)
     {
      string ObjName=ObjectName(i);
      if(ObjectType(ObjName)==OBJ_RECTANGLE)
        {
         ObjectDelete(ObjName);
        }
     }
//—-
   return(0);
  }
//+——————————————————————+
//| Custom indicator deinitialization function |
//+——————————————————————+
int deinit()
  {
//—-

//—-
   return(0);
  }
//+——————————————————————+
//| ??????? ?????? |
//+——————————————————————+
void SetDelimeter()
  {
//—-
   string delimeterDate=TimeToStr(Time[0]);
//—-
   return(0);
  }
//+——————————————————————+
//| Shift Array          |
//+——————————————————————+
void ShiftArray()
  {
//—-
   int V_lines;
   string delimeterName;
   datetime firstTime;
   int BarFirstTime;

   if(tickCounter>2*MaxDrawTicks)
     {
      for(int i=tickCounter;i>=MaxDrawTicks;i--) ExtMapBuffer1[i]=0.0;
      tickCounter=MaxDrawTicks;
     }

   for(int cnt=tickCounter;cnt>0;cnt--)
     {
      ExtMapBuffer1[cnt]=ExtMapBuffer1[cnt-1];
     }

   if(NewBar==true)
     {
      for(int Bcnt=BarCounter;Bcnt>0;Bcnt--)
        {
         iBTime1[Bcnt]=Time[Bcnt+1];
         iBTime2[Bcnt]=Time[Bcnt];
         iNOpen[Bcnt] =iNOpen[Bcnt-1];
         iLClose[Bcnt]=iLClose[Bcnt-1];
        }
     }

   V_lines=ObjectsTotal();

   for(int z=0;z<V_lines;z++)
     {
      delimeterName=ObjectName(z);
      if(ObjectFind(delimeterName)!=-1)
        {
         if(ObjectType(delimeterName)==OBJ_VLINE)
           {
            Time1=ObjectGet(delimeterName,OBJPROP_TIME1);
            BarTime1=iBarShift(NULL,0,Time1);
            Time1=Time[BarTime1+1];
            ObjectSet(delimeterName,OBJPROP_TIME1,Time1);

            Time2=ObjectGet(delimeterName,OBJPROP_TIME2);
            BarTime2=iBarShift(NULL,0,Time2);
            Time2=Time[BarTime2+1];
            ObjectSet(delimeterName,OBJPROP_TIME1,Time2);

            Price1=ObjectGet(delimeterName,OBJPROP_PRICE1);
            ObjectSet(delimeterName,OBJPROP_PRICE1,Price1);
            Price2=ObjectGet(delimeterName,OBJPROP_PRICE2);
            ObjectSet(delimeterName,OBJPROP_PRICE2,Price2);

           }
        }
     }
//—-
   return(0);
  }
//+——————————————————————+
//| If The New Bar Comes |
//+——————————————————————+
bool isNewBar()
  {
//—-
   bool res=false;
   if(myBars!=Bars)
     {
      res=true;
      myBars=Bars;
     }
//—-
   return(res);
  }
//+——————————————————————+
//| Custom indicator iteration function |
//+——————————————————————+
int start()
  {
   int counted_bars=IndicatorCounted();
   int handle=WindowFind("TickPrice");
//—-
   if(isNewBar())
     {
      tickCounter++;
      SetDelimeter();
      ExtMapBuffer1[0]=Bid;
      lastTick=Bid;
     }
   else
     {
      tickCounter++;
      ShiftArray();
      ExtMapBuffer1[0]=Bid;
      lastTick=Bid;
     }

   if(IsConnected() && TimeHour(iTime(Symbol(),60,0))==Hour())
     {
      string name;
      if(MathAbs(nOpen-lastTick)/Point>=Range)
        {
         lastOpen=nOpen;
         lastClose=lastTick;

         NewBar=true;
         nOpen=Bid;
         ShiftArray();
         BarCounter++;shift++;
         StrBar="Bar"+(BarCounter+1);

         int i=1;
         for(i=1;i<=BarCounter;i++)
           {
            if(ObjectFind("Bar"+i)!=-1)
              {
               name="Bar"+i;

               int time1=ObjectGet(name,OBJPROP_TIME1);

               time1=iBarShift(Symbol(),0,time1,false);

               ObjectSet(name,OBJPROP_TIME1,Time[time1+1]);
               ObjectSet(name,OBJPROP_TIME2,Time[time1]);

               double p1=ObjectGet(name,OBJPROP_PRICE1)
                         ,p2=ObjectGet(name,OBJPROP_PRICE2);

               ObjectSet(name,OBJPROP_PRICE1,p1);
               ObjectSet(name,OBJPROP_PRICE2,p2);
               if(ObjectMove(name,0,Time[time1+1],p1)){}
               else
                 {
                  Print("OjectMove 1 : ",ErrorDescription(GetLastError()));
                 }

               if(ObjectMove(name,1,Time[time1],p2)){}
               else
                 {
                  Print("OjectMove 2 : ",ErrorDescription(GetLastError()));
                 }
              }
           }

         iNOpen[0]=nOpen;
         iLClose[0]=nOpen;
         iBTime1[0]=Time[1];
         iBTime2[0]=Time[0];

         ObjectCreate(StrBar,OBJ_RECTANGLE,0,Time[1],nOpen,Time[0],nOpen+(0.6*Point));
         ObjectSet(StrBar,OBJPROP_COLOR,DeepPink);
         ObjectSet(StrBar,OBJPROP_WIDTH,5);
         ObjectSet(StrBar,OBJPROP_RAY,0);
        }
      else
        {
         NewBar=false;
         lastTick=Bid;

         if(lastTick==nOpen)lastTick=nOpen+(0.6*Point);

         iLClose[0]=lastTick;
         iBTime1[0]=Time[1];
         iBTime2[0]=Time[0];
         if(ObjectsTotal(OBJ_RECTANGLE)==0)
           {
            StrBar="Bar"+(BarCounter+1);
            ObjectCreate(StrBar,OBJ_RECTANGLE,0,Time[1],nOpen,Time[0],lastTick);
            ObjectSet(StrBar,OBJPROP_COLOR,DeepPink);
            ObjectSet(StrBar,OBJPROP_WIDTH,5);
            ObjectSet(StrBar,OBJPROP_RAY,0);
           }
         else
         if(ObjectGet(StrBar,OBJPROP_TIME2)!=Time[0])//if(isNewBar())//
           {
            i=BarCounter;int j=0;
            for(i=BarCounter+1;i>=1;i--)
              {
               if(ObjectFind("Bar"+i)!=-1)
                 {
                  name="Bar"+(i);

                  int time2=ObjectGet(name,OBJPROP_TIME2);

                  time2=iBarShift(Symbol(),0,time2,false);

                  ObjectSet(name,OBJPROP_TIME2,Time[j]);
                  ObjectSet(name,OBJPROP_TIME1,Time[j+1]);

                  p1=ObjectGet(name,OBJPROP_PRICE1);
                  p2=ObjectGet(name,OBJPROP_PRICE2);

                  ObjectSet(name,OBJPROP_PRICE1,p1);
                  ObjectSet(name,OBJPROP_PRICE2,p2);
                  if(ObjectMove(name,0,Time[j+1],p2))
                    {
                     if(ObjectMove(name,1,Time[j],p1)){j++;}
                    }
                 }
              }
           }
         else
           {
            if(lastTick>=nOpen)
              {
               ObjectSet(StrBar,OBJPROP_COLOR,HotPink);
              }
            else
            if(lastTick<nOpen)
              {
               ObjectSet(StrBar,OBJPROP_COLOR,DeepSkyBlue);
              }
            else
              {
               ObjectSet(StrBar,OBJPROP_COLOR,DeepPink);
              }
            ObjectSet(StrBar,OBJPROP_PRICE2,lastTick);
            ObjectSet(StrBar,OBJPROP_PRICE1,nOpen);
            ObjectSet(StrBar,OBJPROP_TIME1,Time[1]);
            ObjectSet(StrBar,OBJPROP_TIME2,Time[0]);
           }
        }
     }

   Comment(
           "\nnOpen : "+DoubleToStr(nOpen,Digits)
           ,"\nlastTick : "+DoubleToStr(lastTick,Digits)

           ,"\n\nPrevOpen : "+DoubleToStr(iNOpen[1],Digits)
           ,"\nPrevClose : "+DoubleToStr(iLClose[1],Digits)

           ,"\n\nBarRange : "+DoubleToStr(MathAbs(nOpen-lastTick)/Point,0)
           ,"\nBarCounter : "+BarCounter
           ,"\nBars_Total : "+ObjectsTotal(OBJ_RECTANGLE)

           );
//—-
   return(0);
  }
//+——————————————————————+
