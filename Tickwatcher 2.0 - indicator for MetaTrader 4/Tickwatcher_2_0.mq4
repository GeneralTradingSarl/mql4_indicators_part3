//+------------------------------------------------------------------+
//|                                                  Tickwatcher.mq4 |
//|                                                           mladen |
//+------------------------------------------------------------------+
#property copyright "mladen"
#property link      "mladenrakic@msn.com"
//----
#property indicator_separate_window
#property indicator_buffers 0
#property indicator_minimum 0
#property indicator_maximum 1
//--------------------------------
extern string _           ="pairs and timeframes";
extern string pairs       ="EURUSD;EURJPY;GBPUSD;GBPJPY;USDCHF;USDCAD;USDJPY";
extern string timeFrames  ="M1;M5;M15;M30;H1;H4;D1;W1;MN";
extern string __          ="levels";
extern double AdxLevel1   =20.00;
extern double AdxLevel2   =30.00;
extern string ___         ="colors";
extern color  ColorUp     =ForestGreen;
extern color  ColorNeutral=Gray;
extern color  ColorDown   =OrangeRed;
extern color  ColorPrice  =LimeGreen;
extern color  ColorLabels =Gray;
extern string ____        ="other";
extern bool   ShowLegend  =true;
//---------------------------------
int      window;
int      totalPairs;
int      totalTimeFrames;
int      totalLabels;
int      aTimes[];
string   aPairs[];
string   sTimes[];
//---------------------------------
color    adx_color;
color    sar_color;
color    aos_color;
string   adx_arrow;
string   sar_arrow;
string   aos_arrow;
string   labelNames;
string   shortName;
int      corner;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   corner    =0;
   shortName =MakeUniqueName("TW ","");
   labelNames=shortName;
   IndicatorShortName(shortName);
   //
   pairs=StringUpperCase(StringTrimLeft(StringTrimRight(pairs)));
   if (StringSubstr(pairs,StringLen(pairs),1)!=";")
      pairs=StringConcatenate(pairs,";");
   //
   bool isMini=IsMini();
   int  s     =0;
   int  i     =StringFind(pairs,";",s);
   string current;
   while(i > 0)
     {
      current=StringSubstr(pairs,s,i-s);
      if (isMini) current=StringConcatenate(current,"m");
        if (iClose(current,0,0) > 0) 
        {
         ArrayResize(aPairs,ArraySize(aPairs)+1);
        aPairs[ArraySize(aPairs)-1]=current; 
        }
      s=i + 1;
      i=StringFind(pairs,";",s);
     }
   //
   timeFrames=StringUpperCase(StringTrimLeft(StringTrimRight(timeFrames)));
   if (StringSubstr(timeFrames,StringLen(timeFrames),1)!=";")
      timeFrames=StringConcatenate(timeFrames,";");
   //
   s=0;
   i=StringFind(timeFrames,";",s);
   int time;
   while(i > 0)
     {
      current=StringSubstr(timeFrames,s,i-s);
      time   =stringToTimeFrame(current);
        if (time > 0) 
        {
         ArrayResize(sTimes,ArraySize(sTimes)+1);
         ArrayResize(aTimes,ArraySize(aTimes)+1);
         sTimes[ArraySize(sTimes)-1]=TimeFrameToString(time);
        aTimes[ArraySize(aTimes)-1]=time; 
        }
      s=i + 1;
      i=StringFind(timeFrames,";",s);
     }
   //
   totalTimeFrames=ArraySize(aTimes);
   totalPairs     =ArraySize(aPairs);
   totalLabels    =0;
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   while(totalLabels>0) { ObjectDelete(StringConcatenate(labelNames,totalLabels)); totalLabels--;}
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int m,n;
   int i,k;
   //
   window     =WindowFind(shortName);
   totalLabels=0;
   for(i=0,m=80; i < totalPairs;      i++, m+=140)
      for(k=0,n=20; k < totalTimeFrames; k++, n+=13)
         showPair(aPairs[i],aTimes[k],sTimes[k],m,n);
   if (ShowLegend) DoShowLegend();
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DoShowLegend()
  {
   corner=1;
   setObject(next(),"up"       ,30,20,ColorLabels); setObject(next(),"l",11,21,ColorUp     ,"Wingdings");
   setObject(next(),"weak up"  ,30,33,ColorLabels); setObject(next(),"¡",10,34,ColorUp     ,"Wingdings");
   setObject(next(),"neutral"  ,30,46,ColorLabels); setObject(next(),"¡",10,47,ColorNeutral,"Wingdings");
   setObject(next(),"weak down",30,59,ColorLabels); setObject(next(),"¡",10,60,ColorDown   ,"Wingdings");
   setObject(next(),"down"     ,30,72,ColorLabels); setObject(next(),"l",11,74,ColorDown   ,"Wingdings");
   corner=0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void showPair(string pair, int timeFrame, string label, int xdistance, int ydistance)
  {
   double price=iClose(pair,0,0);
   double adx  =iADX(pair,timeFrame,14,PRICE_CLOSE,0,0);
   double dip  =iADX(pair,timeFrame,14,PRICE_CLOSE,1,0);
   double dim  =iADX(pair,timeFrame,14,PRICE_CLOSE,2,0);
   double sarv =iSAR(pair,timeFrame ,0.02,0.2,0);
   double aosv =iAO(pair,timeFrame,0);
   double aosp =iAO(pair,timeFrame,1);
   //
     if (ydistance==20) 
     {
      setObject(next(),pair                                           ,xdistance-1 ,20,ColorLabels,"Arial bold",12,270);
      setObject(next(),DoubleToStr(price,(int)MarketInfo(pair,MODE_DIGITS)),xdistance-16, 1,ColorPrice ,"Arial bold",12);
     }
//----   
   setAdxColorArrow(adx,dip,dim);
   setSarColorArrow(sarv,price);
   setAosColorArrow(aosv,aosp);
   setLabel(label,xdistance   ,ydistance,(string)adx,adx_color,adx_arrow);
   setLabel(" "  ,xdistance+79,ydistance," ",sar_color,sar_arrow,false);
   setLabel(" "  ,xdistance+91,ydistance," ",aos_color,aos_arrow,false);
  }
//+------------------------------------------------------------------+
//| Custom functions and procedures                                  |
//+------------------------------------------------------------------+
string next() { totalLabels++; return((string)totalLabels); }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void setAosColorArrow(double first,double second)
  {
   if (first==second) { aos_color=ColorNeutral; aos_arrow="¡"; }
   if (first > second)
     {
      aos_color=ColorUp;
      if (first < 0)
         aos_arrow="¡";
      else  aos_arrow="l";
     }
   if (first < second)
     {
      aos_color=ColorDown;
      if (first > 0)
         aos_arrow="¡";
      else  aos_arrow="l";
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void setSarColorArrow(double first,double second)
  {
   double diff=first-second;
   if (diff <0) { sar_color=ColorUp;      sar_arrow="l"; }
   if (diff >0) { sar_color=ColorDown;    sar_arrow="l"; }
   if (diff==0) { sar_color=ColorNeutral; sar_arrow="¡"; }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void setAdxColorArrow(double first,double second,double third)
  {
   if((first < AdxLevel1) && (first!=0)) { adx_color=ColorNeutral; adx_arrow="¡";}
   if (first >=AdxLevel1)
        if (second > third) 
        {
         adx_color=ColorUp;
         if   (first < AdxLevel2) adx_arrow="¡";
         else                     adx_arrow="l";
        }
        else 
        {
         adx_color=ColorDown;
         if   (first < AdxLevel2) adx_arrow="¡";
         else                     adx_arrow="l";
        }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void setLabel(string text,int x,int y,string value, color theColor, string arrow, bool isADX=true)
  {
   int last=0;
   if (isADX) {last=67;}
   if (isADX) setObject(next(),text                   ,x     ,y,ColorLabels);
   if (isADX) setObject(next(),StringSubstr(value,0,5),x+30  ,y,theColor);
   setObject(next(),arrow                  ,x+last,y,theColor,"Wingdings",9);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void setObject(string name,string text,int x,int y,color theColor, string font="Arial",int size=10,int angle=0)
  {
   string labelName=StringConcatenate(labelNames,name);
//----
   if (ObjectFind(labelName)==-1)
     {
      ObjectCreate(labelName,OBJ_LABEL,window,0,0);
      ObjectSet(labelName,OBJPROP_CORNER,corner);
      if (angle!=0)
         ObjectSet(labelName,OBJPROP_ANGLE,angle);
     }
   ObjectSet(labelName,OBJPROP_XDISTANCE,x);
   ObjectSet(labelName,OBJPROP_YDISTANCE,y);
   ObjectSetText(labelName,text,size,font,theColor);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int stringToTimeFrame(string tfs)
  {
   int tf=0;
   tfs=StringTrimLeft(StringTrimRight(StringUpperCase(tfs)));
   if (tfs=="M1" || tfs=="1")     tf=PERIOD_M1;
   if (tfs=="M5" || tfs=="5")     tf=PERIOD_M5;
   if (tfs=="M15"|| tfs=="15")    tf=PERIOD_M15;
   if (tfs=="M30"|| tfs=="30")    tf=PERIOD_M30;
   if (tfs=="H1" || tfs=="60")    tf=PERIOD_H1;
   if (tfs=="H4" || tfs=="240")   tf=PERIOD_H4;
   if (tfs=="D1" || tfs=="1440")  tf=PERIOD_D1;
   if (tfs=="W1" || tfs=="10080") tf=PERIOD_W1;
   if (tfs=="MN" || tfs=="43200") tf=PERIOD_MN1;
   return(tf);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string TimeFrameToString(int tf)
  {
   string tfs;
     switch(tf) 
     {
         case PERIOD_M1:  tfs="M1" ;break;
         case PERIOD_M5:  tfs="M5" ;break;
         case PERIOD_M15: tfs="M15";break;
         case PERIOD_M30: tfs="M30";break;
         case PERIOD_H1:  tfs="H1" ;break;
         case PERIOD_H4:  tfs="H4" ;break;
         case PERIOD_D1:  tfs="D1" ;break;
         case PERIOD_W1:  tfs="W1" ;break;
         case PERIOD_MN1: tfs="MN1";
        }
      return(tfs);
     }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
         string StringUpperCase(string str)
           {
            string   s=str;
            int      length=StringLen(str) - 1;
            int      Char;
            while(length>=0)
              {
               Char=StringGetChar(s, length);
               //
               if((Char > 96 && Char < 123) || (Char > 223 && Char < 256))
                  s=StringSetChar(s, length, Char - 32);
               else
                  if(Char > -33 && Char < 0)
                     s=StringSetChar(s, length, Char + 224);
               length--;
              }
            //----
            return(s);
           }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
         string MakeUniqueName(string first, string rest)
           {
            string result=first+(string)(MathRand()%1001)+rest;

            while(WindowFind(result)> 0)
               result=first+(string)(MathRand()%1001)+rest;
            return(result);
           }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
         bool IsMini()
           {
            if (StringFind(Symbol(),"m") > -1)
               return(true);
            else  return(false);
           }
//+------------------------------------------------------------------+