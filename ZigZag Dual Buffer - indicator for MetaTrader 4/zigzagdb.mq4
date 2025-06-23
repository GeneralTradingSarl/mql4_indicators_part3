//+------------------------------------------------------------------+
//|                                                     ZigZagDB.mq4 |
//|                                           Copyright 2015, WongKL |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, WongKL"
#property link      "http://www.mql4.com"
#property version   "1.00"
#property description "This ZigZag indicator uses dual buffers to store high and low points."
#property description "A point is considered as a new high/low point if its high/low is higher/lower"
#property description "than the high/low of N earlier bars' high/low where parameter N is "
#property description "the number of earlier bars represented by <Bars>. Default value is 2."
#property strict
#property indicator_chart_window
//---
#property indicator_buffers 4
#property indicator_color1 clrRed
#property indicator_color2 clrNONE
#property indicator_color3 clrMagenta
#property indicator_color4 clrAqua

input int inpBars=2;  //Bars (1,2 or 3)
input double inpMinRetrace=0.22; //Min retracement to delete
input bool inpShowHiLo=false; //Show High & Low

#define _Top  1
#define _Bottom -1
#define _Unknown  0

//#define _testDT D'2014.12.17 18:00'
//#define _TEST_REM
#ifdef _TEST_REM
bool printnext=false;
int tmplus=0;
#endif
bool doPrint=false;

double zzTop[];
double zzBot[];
double HiBuf[];
double LoBuf[];

int xDepth;
double xRetracement;
datetime lastTopbar,lastBotbar,lastTop2ndbar,lastBot2ndbar;
int lastPosition;
int prevHi,prevLo;
double curHi,curLo;
int lastDir=0;
datetime curBarTime;
//int curPeriod;
int printCount=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   IndicatorBuffers(4);
//---- drawing settings
   SetIndexStyle(0,DRAW_ZIGZAG);
   SetIndexStyle(1,DRAW_ZIGZAG);
   if(inpShowHiLo)
     {
      SetIndexStyle(2,DRAW_ARROW);
      SetIndexStyle(3,DRAW_ARROW);
     }
   else
     {
      SetIndexStyle(2,DRAW_NONE);
      SetIndexStyle(3,DRAW_NONE);
     }
   SetIndexBuffer(0,zzTop);
   SetIndexBuffer(1,zzBot);
   SetIndexBuffer(2,HiBuf);
   SetIndexBuffer(3,LoBuf);

   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   SetIndexEmptyValue(2,0.0);
   SetIndexEmptyValue(3,0.0);

   lastPosition=_Unknown;
//Print("Point="+DoubleToStr(Point,Digits));
   xDepth=inpBars;

   xRetracement=inpMinRetrace;
   if(xDepth<=0)
      xDepth=1;
   if(xDepth>3)
      xDepth=3;
   if(xRetracement>0.3)
      xRetracement=0.3;

   curHi =0;
   curLo =999999999;
   curBarTime=0;
//curPeriod = 0;
   IndicatorShortName("ZigZagDB("+string(xDepth)+")");
   IndicatorDigits(Digits());
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//  if(reason != REASON_CLOSE)
//     objClear(0,_obj_Prefix);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   int i,limit,Zcnt;
   double res;
   string ss;
   int dir;
   int lastTop = GetLastTopBar();
   int lastBot = GetLastBotBar();
//---
   if(rates_total<xDepth)
      return(0);
//--- first calculations
   dir=open[0]>close[0]?1:(open[0]<close[0]?-1:0);
   if((prev_calculated==rates_total) && 
      (curHi >= high[0]) &&
      (curLo <= low[0]) &&
      (curBarTime==time[0]) && 
      (dir==lastDir)
      )
      return(rates_total);

   ArraySetAsSeries(time,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   ArraySetAsSeries(open,true);
   ArraySetAsSeries(close,true);

   curBarTime=time[0];
   curHi = high[0];
   curLo = low[0];
   lastDir=dir;
//curPeriod = Period();

   limit=rates_total-xDepth-3;
   if(prev_calculated==0)
     {
      ArrayInitialize(zzTop,0.0);
      ArrayInitialize(zzBot,0.0);
      ArrayInitialize(HiBuf,0.0);
      ArrayInitialize(LoBuf,0.0);
      lastPosition=_Unknown;
#ifdef _TEST_CALC_
      Print("prev_calc=0. Time=",TimeToStr(Time[0]),"  last TOP=",IntegerToString(lastTop),"  last Bot=",IntegerToString(lastBot));
#endif
      lastTop = limit;
      lastBot = limit;
#ifdef _TEST_CALC_
      Print("prev_calc=0","  NEW last TOP=",IntegerToString(lastTop),"  NEW last Bot=",IntegerToString(lastBot));
      printnext=true;
#endif
     }

   if(prev_calculated>0)
     {
      i=0; Zcnt=0;
      prevHi=lastTop;
      while(Zcnt<1 && i<100)
        {
         res=HiBuf[i];
         if(res!=0)
           {
            Zcnt++;
            prevHi=i;
           }
         i++;
        }

      i=0; Zcnt=0;
      prevLo=lastBot;
      while(Zcnt<1 && i<100)
        {
         res=LoBuf[i];
         if(res!=0)
           {
            Zcnt++;
            prevLo=i;
           }
         i++;
        }

      if(prevHi<prevLo)
         limit=prevHi;
      else
         limit=prevLo;

      if(limit>lastTop)
         limit=lastTop;

      if(limit>lastBot)
         limit=lastBot;
     }
#ifdef _TEST_
   ss=StringConcatenate(IntegerToString(printCount++),". OnCalc: lastTOP=",IntegerToString(lastTop)," lastBot=",IntegerToString(lastBot),
                        "  lastPosition=",IntegerToString(lastPosition)," limit=",IntegerToString(limit));
   if(Time[0]>=_testDT)
      if(printnext)
         Print(ss);
   printnext=true;
#endif

   SetLastBotBar(lastBot);
   SetLastTopBar(lastTop);
   FindHiLo(limit,high,low,open,close);

//mapping ZZ
   DrawZZ(limit,high,low,open,close);

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,// Event ID
                  const long& lparam,   // Parameter of type long event
                  const double& dparam, // Parameter of type double event
                  const string &sparam)
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetLastTop2ndBar(int shift)
  {
   datetime newdt;

   newdt=iTime(Symbol(),0,shift);
   lastTop2ndbar=newdt;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetLastTopBar(int shift)
  {
   datetime newdt;

   newdt=iTime(Symbol(),0,shift);
   if(newdt>lastTopbar)
      lastTop2ndbar=lastTopbar;
   lastTopbar=newdt;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetLastTopBar()
  {
   return(iBarShift(Symbol(),0,lastTopbar));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetLastTop2ndBar()
  {
   return(iBarShift(Symbol(),0,lastTop2ndbar));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetLastBot2ndBar(int shift)
  {
   datetime newdt;

   newdt=iTime(Symbol(),0,shift);
   lastBot2ndbar=newdt;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetLastBotBar(int shift)
  {
   datetime newdt;

   newdt=iTime(Symbol(),0,shift);
   if(newdt>lastBotbar)
      lastBot2ndbar=lastBotbar;
   lastBotbar=newdt;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetLastBotBar()
  {
   return(iBarShift(Symbol(),0,lastBotbar));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetLastBot2ndBar()
  {
   return(iBarShift(Symbol(),0,lastBot2ndbar));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FindHiLo(const int nLimit,const double &hi[],const double &lo[],const double &op[],const double &cl[])
  {
   int i;
   double val;
   bool gdbar;

   for(i=nLimit;i>=0 && !IsStopped();i--)
     {
      val=hi[i];
      if((val>=hi[i+1])
         &&((xDepth<2) ||(val>= hi[i+2]))
         &&((xDepth<3) ||(val>= hi[i+3]))
         )
        {
         HiBuf[i]=NormalizeDouble(val,_Digits);
         prevHi=i;
        }

      val=lo[i];
      if((val<=lo[i+1])
         &&((xDepth<2) ||(val<= lo[i+2]))
         &&((xDepth<3) ||(val<= lo[i+3]))
         )
        {
         LoBuf[i]=NormalizeDouble(val,_Digits);
         prevLo=i;
        }

      //delete previous marking
      if(HiBuf[i+1]!=0 && LoBuf[i+1]==0) //up trend
        {
         if(HiBuf[i+2]!=0 && LoBuf[i+2]==0) HiBuf[i+2]=0;
         gdbar=(HiBuf[i+2]==0);
         if((xDepth>=2 && gdbar) && (prevLo>i+3) && (HiBuf[i+3]!=0 && LoBuf[i+3]==0)) HiBuf[i+3]=0;
         gdbar=(HiBuf[i+3]==0);
         if((xDepth>=3 && gdbar) && (prevLo>i+4) && (HiBuf[i+4]!=0 && LoBuf[i+4]==0)) HiBuf[i+4]=0;
        }

      if(HiBuf[i+1]==0 && LoBuf[i+1]!=0) //down trend
        {
         if(LoBuf[i+2]!=0 && HiBuf[i+2]==0) LoBuf[i+2]=0;
         gdbar=(LoBuf[i+2]==0);
         if((xDepth>=2 && gdbar) && (prevHi>i+3) && (LoBuf[i+3]!=0 && HiBuf[i+3]==0)) LoBuf[i+3]=0;
         gdbar=(LoBuf[i+3]==0);
         if((xDepth>=3 && gdbar) && (prevHi>i+4) && (LoBuf[i+4]!=0 && HiBuf[i+4]==0)) LoBuf[i+4]=0;
        }
     } //end for hibuf && lobuf  
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawZZ(const int nLimit,const double &hi[],const double &lo[],const double &op[],const double &cl[])
  {
   int i;

   for(i=nLimit;i>=0 && !IsStopped();i--)
     {
      if(Time[i]== D'2015.05.26 21:00')
         doPrint = true;
      if(HiBuf[i]!=0.0 && LoBuf[i]!=0.0)
        {
         SetZZBothEnds(i,HiBuf[i],LoBuf[i],hi,lo,op,cl);
         //AdjustPoint(i);
        }
      else
      if(HiBuf[i]!=0.0 && LoBuf[i]==0.0)
        {
         SetZZTop(i,HiBuf[i],hi,op,cl);
        }
      else
      if(HiBuf[i]==0.0 && LoBuf[i]!=0.0)
        {
         SetZZBot(i,LoBuf[i],lo,op,cl);
        }
      else
      if(HiBuf[i]==0.0 && LoBuf[i]==0.0)
        {
         zzTop[i] = 0.0;
         zzBot[i] = 0.0;
        }

      //remove retracement that doesn't reach xRetracement%
      RemoveRetracement(i,xRetracement,op,cl);
     }//end for
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetZZBothEnds(int n,const double hival,const double loval,
                   const double &hi[],const double &lo[],
                   const double &op[],const double &cl[])
  {
//int i;
   int lastTop = GetLastTopBar();
   int lastBot = GetLastBotBar();
   int zt,zb,m;

#ifdef _TEST_
   string ss=StringConcatenate("SetZZBothEnds: n=",IntegerToString(n)," lastTop=",IntegerToString(lastTop)," lastBot=",IntegerToString(lastBot)," LastPosition=",IntegerToString(lastPosition));
   string ss1;
   if(TimeCurrent()>=_testDT+tmplus)
      Print(ss);
   printnext=false;
#endif

   if(hival==hi[n] && loval==lo[n])
     {
      if(op[n]<cl[n]) //bullish
        {
         //check previous top
         if(lastTop==n || lastBot==n)
           {
            zt = GetLastTop2ndBar();
            zb = GetLastBot2ndBar();
            if(zt<zb)
              {
               zzTop[zt]=hi[zt];
               lastPosition=_Top;
              }
            if(zt>zb)
              {
               zzBot[zb]=lo[zb];
               lastPosition=_Bottom;
              }
           }
         else
           {
            zt = lastTop;
            zb = lastBot;
           }

         if(lastPosition==_Top || zt<zb)
           {
            if(op[zt]>cl[zt] && zt<zb)
               m=GetLowestPoint(n,zt,lo);
            else
               m=GetLowestPoint(n,zt-1,lo);

            lastBot=m;
            zzBot[m]=lo[m];

            lastTop=n;
            zzTop[n]=hi[n];

            lastPosition=_Top;
           }
         else
         if(lastPosition==_Bottom || zb<zt)
           {
            m=GetLowestPoint(n,zb,lo);

            if(m!=zb)
               zzBot[zb]=0;
            lastBot=m;
            zzBot[m]=lo[m];

            if(op[m]<cl[m])
               m=GetHighestPoint(n,m,hi);
            else
               m=GetHighestPoint(n,m-1,hi);

            lastTop=m;
            zzTop[m]=hi[m];

            lastPosition=_Top;
           }
        }
      else
      if(op[n]>cl[n]) //bearish
        {
         if(lastTop==n || lastBot==n)
           {
            zt = GetLastTop2ndBar();
            zb = GetLastBot2ndBar();
            if(zt<zb)
              {
               zzTop[zt]=hi[zt];
               lastPosition=_Top;
              }
            if(zt>zb)
              {
               zzBot[zb]=lo[zb];
               lastPosition=_Bottom;
              }
           }
         else
           {
            zt = lastTop;
            zb = lastBot;
           }

         if(lastPosition==_Bottom || zb<zt)
           {
            if(op[zb]<cl[zb] && zb<zt)
               m=GetHighestPoint(n,zb,hi);
            else
               m=GetHighestPoint(n,zb-1,hi);

            lastTop=m;
            zzTop[m]=hi[m];

            lastBot=n;
            zzBot[n]=lo[n];

            lastPosition=_Bottom;
           }
         else
         if(lastPosition==_Top || zt<zb)
           {
            m=GetHighestPoint(n,zt,hi);

            if(m!=zt)
               zzTop[zt]=0;
            lastTop=m;
            zzTop[m]=hi[m];

            if(op[m]>cl[m])
               m=GetLowestPoint(n,m,lo);
            else
               m=GetLowestPoint(n,m-1,lo);

            lastBot=m;
            zzBot[m]=lo[m];

            lastPosition=_Bottom;
           }
        }
      else  //doji
        {
         zt = lastTop;
         zb = lastBot;
         if(hi[n]-cl[n]<cl[n]-lo[n]) //more toward the upper side
           {
            if(lastPosition==_Top || zt<zb)
              {
               if(op[zt]>cl[zt])
                  m=GetLowestPoint(n,zt,lo);
               else
                  m=GetLowestPoint(n,zt-1,lo);

               lastBot=m;
               zzBot[m]= lo[m];
               lastTop = n;
               zzTop[n]= hi[n];

               lastPosition=_Top;
              }
            else
            if(lastPosition==_Bottom || zb<zt)
              {
               m=GetLowestPoint(n,zb,lo);

               if(m!=zb)
                  zzBot[zb]=0;
               lastBot=m;
               zzBot[m]= lo[m];
               lastTop = n;
               zzTop[lastTop]=hi[lastTop];

               lastPosition=_Top;
              }
           }
         else
         if(hi[n]-cl[n]>cl[n]-lo[n]) //more toward the lower side
           {
            if(lastPosition==_Bottom || zb<zt)
              {
               m=GetHighestPoint(n,zb,hi);

               if(m!=zb)
                  zzTop[zb]=0;
               lastTop=m;
               zzTop[m]= hi[m];
               lastBot = n;
               zzBot[n]= lo[n];

               lastPosition=_Bottom;
              }
            else
            if(lastPosition==_Top || zt<zb)
              {
               if(op[zt]<cl[zt])
                  m=GetHighestPoint(n,zt,hi);
               else
                  m=GetHighestPoint(n,zt-1,hi);

               lastTop=m;
               zzTop[m]= hi[m];
               lastBot = n;
               zzBot[n]= lo[n];

               lastPosition=_Bottom;
              }
           }
         else  //if same => follow previous last position
           {
            if(lastPosition==_Top || zt<zb)
              {
               m=GetHighestPoint(n,zt,hi);
               if(m!=zt)
                  zzTop[zt]=0;
               lastTop=m;
               zzTop[m]=hi[m];

               lastPosition=_Top;
              }
            else
            if(lastPosition==_Bottom || zb<zt)
              {
               m=GetLowestPoint(n,zb,lo);
               if(m!=zb)
                  zzBot[zb]=0;
               lastBot=m;
               zzBot[m]=lo[m];

               lastPosition=_Bottom;
              }
           }

#ifdef _TEST_
         if(TimeCurrent()>=_testDT+tmplus) ss1="doji";
         printnext=true;
#endif
        }
     }

   SetLastBotBar(lastBot);
   SetLastTopBar(lastTop);
#ifdef _TEST_
   if(TimeCurrent()>=_testDT+tmplus)
     {
      ss=StringConcatenate(ss," @",ss1," NEW lastTop=",IntegerToString(lastTop)," NEW lastBot=",IntegerToString(lastBot)," NEW Position=",IntegerToString(lastPosition));
      Print(ss);
      tmplus+=60;
     }
#endif
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SetZZTop(int n,double Value,const double &hi[],const double &op[],const double &cl[])
  {
   int m;
   double hival;
   int lastTop = GetLastTopBar();
   int lastBot = GetLastBotBar();

#ifdef _TEST_
   string ss=StringConcatenate("SetZZTop: n=",IntegerToString(n)," lastTop=",IntegerToString(lastTop)," lastBot=",IntegerToString(lastBot)," LastPosition=",IntegerToString(lastPosition));

   if(Time[n]>=_testDT)
      Print(ss);
   printnext=false;
#endif

   if(lastPosition==_Top)
     {
      if(Value>=zzTop[lastTop])
        {
         if(lastTop>n && lastBot>=lastTop)
           {
            zzTop[lastTop]=0.0;
           }
         //lastPosition=_Top;
         lastTop=n;
         zzTop[lastTop]=Value;
#ifdef _TEST_
         if(Time[n]>=_testDT)
            Print("@TOP: ",ss," NEW lastTop=",IntegerToString(lastTop)," LastPosition=",IntegerToString(lastPosition),
                  " ZZ value=",DoubleToStr(Value,5));
         printnext=true;
#endif
        }
     }
   else
   if(lastBot<=lastTop)
     {
      if(Value<=zzBot[lastBot] && zzBot[lastBot]!=0)
        {
         zzTop[n]=0.0;
        }
      else
      //if(Value > zzMap[lastBotbar])
        {
         //check if the top is the highest
         if((lastPosition==0) || (op[lastBot]<=cl[lastBot] && lastBot>n && lastTop!=lastBot)) //if last Top is bullish
            m=GetHighestPoint(n,lastBot,hi);
         else
            m=GetHighestPoint(n,lastBot-1,hi);

         hival=hi[m];

         if(HiBuf[m]!=0.0)
            hival=HiBuf[m];

         lastPosition=_Top;
         lastTop=m;

         zzTop[lastTop]=hival;
#ifdef _TEST_
         if(Time[n]>=_testDT)
            Print("@Bot: ",ss," NEW lastTopbar=",IntegerToString(lastTop)," LastPosition=",IntegerToString(lastPosition),
                  " ZZ value=",DoubleToStr(hival,5));
         printnext=true;
#endif
        }
     }
//SetLastBotBar(lastBot);
   SetLastTopBar(lastTop);
   return(zzTop[lastTop]);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SetZZBot(int n,double Value,const double &lo[],const double &op[],const double &cl[])
  {
   int m;
   double loval;
   int lastTop = GetLastTopBar();
   int lastBot = GetLastBotBar();

#ifdef _TEST_
   string ss=StringConcatenate("SetZZBot: n=",IntegerToString(n)," lastTop=",IntegerToString(lastTop),
                               " lastBot=",IntegerToString(lastBot)," LastPosition=",IntegerToString(lastPosition));

   if(Time[n]>=_testDT)
      Print(ss);
   printnext=false;
#endif
   if(lastPosition==_Bottom)
     {
      if(Value<=zzBot[lastBot]) //replacing old lowest with a new lowest
        {
         if(lastBot>n && lastBot<=lastTop)
           {
            zzBot[lastBot]=0.0;
           }
         //lastPosition=_Bottom;
         lastBot=n;
         zzBot[lastBot]=Value;
#ifdef _TEST_
         if(Time[n]>=_testDT)
            Print("@BOT: ",ss," NEW lastBot=",IntegerToString(lastBot)," LastPosition=",IntegerToString(lastPosition),
                  " ZZ value=",DoubleToStr(Value,5));
         printnext=true;
#endif
        }
     }
   else
   if(lastBot>=lastTop)
     {
      if(Value>=zzTop[lastTop] && zzTop[lastTop]!=0)
        {
         zzBot[n]=0.0;
        }
      else
        {
         //check if the bottom is the lowest
         if((lastPosition==0) || (op[lastTop]>=cl[lastTop] && lastTop>n && lastTop!=lastBot)) //if last Top is bearish
            m=GetLowestPoint(n,lastTop,lo);
         else
            m=GetLowestPoint(n,lastTop-1,lo);
         //printf("m=%d  lastTopbar=%d.",m,lastTopbar);
         loval=lo[m];

         if(LoBuf[m]!=0.0)
            loval=LoBuf[m];

         lastPosition=_Bottom;
         lastBot=m;

         zzBot[lastBot]=loval;
#ifdef _TEST_
         if(Time[n]>=_testDT)
            Print("@Top: ",ss," NEW lastBotbar=",IntegerToString(lastBot)," LastPosition=",IntegerToString(lastPosition),
                  "  last ZZ Value=",DoubleToStr(loval,5));
         printnext=true;
#endif
        }
     }
   SetLastBotBar(lastBot);
//SetLastTopBar(lastTop);

   return(zzBot[lastBot]);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetLowestPoint(int cur,int last,const double &lo[])
  {
   int i,pnt;
   double lowestVal;

   pnt=cur;
   lowestVal=lo[pnt];
   if(LoBuf[pnt]!=0.0)
      if(LoBuf[pnt]<lowestVal)
         lowestVal=LoBuf[pnt];

   for(i=cur+1;i<=last;i++)
     {
      if(lo[i]<lowestVal)
        {
         lowestVal=lo[i];
         pnt=i;
        }
     }//end for

   return(pnt);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetHighestPoint(int cur,int last,const double &hi[])
  {
   int i,pnt;
   double highestVal;

   pnt=cur;
   highestVal=hi[pnt];
   if(HiBuf[pnt]!=0.0)
      if(HiBuf[pnt]>highestVal)
         highestVal=HiBuf[pnt];

   for(i=cur+1;i<=last;i++)
     {
      if(hi[i]>highestVal)
        {
         highestVal=hi[i];
         pnt=i;
        }
     }//end for

   return(pnt);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RemoveRetracement(int cur,double xret,const double &op[],const double &cl[])
  {
   int i,j,amx;
   int p[6];
   bool retrace;

   if(cur==0)  return;

   ArrayInitialize(p,0);  // p[0]=0; p[1]=0; p[2]=0; p[3]=0; p[4] =0; p[5] =0;
   j=0;

   amx=MathMin(ArraySize(zzTop),ArraySize(zzBot));

   for(i=cur; i<amx && !IsStopped(); i++)
     {
      if(zzTop[i]!=0.0)
         p[j++]=i;
      if(j>5 || i>cur+100)
         break;

      if(zzBot[i]!=0.0)
         p[j++]=i;

      if(j>5 || i>cur+100)
         break;
     }//end for

   if(p[1]==cur) return;

   if(p[0]<=p[1] && p[1]<=p[2] && p[2]<=p[3] && p[3]<=p[4] && p[4]<=p[5])
     {
      if((zzTop[p[0]] != 0) && (zzTop[p[2]] != 0) && (zzTop[p[4]] != 0) &&
         (zzBot[p[1]] != 0) && (zzBot[p[3]] != 0) && (zzBot[p[5]] != 0))
        {
         if(zzTop[p[2]]<zzTop[p[0]] && zzBot[p[3]]<zzBot[p[1]]
            && zzBot[p[3]]<zzTop[p[2]] && zzTop[p[2]]>zzBot[p[1]])
           {  //up trend
            retrace=(zzTop[p[2]]-zzBot[p[1]])/(zzTop[p[2]]-zzBot[p[3]])<xret; //any retracement below xret% => cleared
            if(retrace)
              {
               zzTop[p[2]] = 0;
               zzBot[p[1]] = 0;
               return;
              }
           }

         if(zzBot[p[3]]<zzBot[p[1]] && zzTop[p[4]]>zzTop[p[2]]
            && zzTop[p[2]]>zzBot[p[1]] && zzTop[p[2]]<zzTop[p[0]])
           {  //down trend
            retrace=(zzTop[p[2]]-zzBot[p[3]])/(zzTop[p[4]]-zzBot[p[3]])<xret; //any retracement below xret% => cleared
            if(retrace)
              {
               zzBot[p[1]] = 0;
               zzTop[p[2]] = 0;
               return;
              }
           }

         if(zzBot[p[3]]>zzBot[p[1]] && zzTop[p[4]]>zzTop[p[2]]
            && zzTop[p[2]]>zzBot[p[3]])
           {  //down trend
            retrace=(zzTop[p[2]]-zzBot[p[3]])/(zzTop[p[4]]-zzBot[p[3]])<xret; //any retracement below xret% => cleared
            if(retrace)
              {
               zzBot[p[3]] = 0;
               zzTop[p[2]] = 0;
               return;
              }
           }
        }
      else
         if((zzBot[p[0]] != 0) && (zzBot[p[2]] != 0) && (zzBot[p[4]] != 0) &&
            (zzTop[p[1]] != 0) && (zzTop[p[3]] != 0) && (zzTop[p[5]] != 0))
           {
            if(zzBot[p[2]]>zzBot[p[0]] && zzTop[p[3]]>zzTop[p[1]]
               && zzTop[p[3]]>zzBot[p[2]] && zzBot[p[2]]<zzTop[p[1]])
              {  //down trend
               retrace=(zzTop[p[1]]-zzBot[p[2]])/(zzTop[p[3]]-zzBot[p[2]])<xret; //any retracement below xret% => cleared
               if(retrace)
                 {
                  zzBot[p[2]] = 0;
                  zzTop[p[1]] = 0;
                  return;
                 }
              }

            if(zzTop[p[3]]>zzTop[p[1]] && zzBot[p[4]]<zzBot[p[2]]
               && zzBot[p[2]]<zzTop[p[1]] && zzBot[p[2]]>zzBot[p[0]])
              {  //up trend
               retrace=(zzTop[p[3]]-zzBot[p[2]])/(zzTop[p[3]]-zzBot[p[4]])<xret; //any retracement below xret% => cleared
               if(retrace)
                 {
                  zzTop[p[1]] = 0;
                  zzBot[p[2]] = 0;
                  return;
                 }
              }

            if(zzTop[p[3]]<zzTop[p[1]] && zzBot[p[4]]<zzBot[p[2]]
               && zzBot[p[2]]<zzTop[p[2]])
              {  //up trend
               retrace=(zzTop[p[3]]-zzBot[p[2]])/(zzTop[p[3]]-zzBot[p[4]])<xret; //any retracement below xret% => cleared
               if(retrace)
                 {
                  zzTop[p[3]] = 0;
                  zzBot[p[2]] = 0;
                  return;
                 }
              }
           }
     }
  }
//+------------------------------------------------------------------+
