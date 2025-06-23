//+------------------------------------------------------------------+
//|                                        PriceHistgram_OnClick.mq4 |
//|        PriceHistgram_OnClick              Copyright 2015, fxborg |
//|                                  http://blog.livedoor.jp/fxborg/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, fxborg"
#property link      "http://blog.livedoor.jp/fxborg/"
#property version   "1.02"
#property indicator_chart_window
//--- input parameters
input double InpBinRange=2.5;       // Bin range of price histogram
input  int InpCalcTime=4;           // Calculation Time(hour)
input  int InpShortTermPeriod =3;   // Short term period(day)
input  int InpMediumTermPeriod=7;   // Medium term period(day)
input  int InpLongTermPeriod =26;   // Long term period(day)
input bool InpUsingVolumeWeight=true;   // Using TickVolume
input double InpDrawScale=0.5;

input  color Inp1DayColor=Red;
input  color InpShortTermColor=Gold;
input  color InpMediumTermColor=DeepPink;
input  color InpLongTermColor=Blue;

int BinRangeScale=4;
double LtBinRange=InpBinRange*BinRangeScale;       // Bin range of price histogram

//---
int PivotHour=4;                    // Pivot period (hour) 
//---
int d1_period=24*12;   // for 5min
int st_period = InpShortTermPeriod*24*12;   // for 5min
int mt_period = InpMediumTermPeriod*48;     // for 30
int lt_period = InpLongTermPeriod*48;       // for 1h
//---
int zoom_out_factor=8;
string prefix="PRICE_HISTGRAM_";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   ObjectDelete(0,"V Line");
   cleaningObj(prefix);
   return(0);
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
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
//--- the mouse has been clicked on the graphic object
   if(id==CHARTEVENT_CLICK)
     {  //--- Prepare variables
      int      x     =(int)lparam;
      int      y     =(int)dparam;
      datetime dt    =0;
      double   price =0;
      int      window=0;
      //--- Convert the X and Y coordinates in terms of date/time
      if(ChartXYToTimePrice(0,x,y,window,dt,price))
        {
         //--- Perform reverse conversion: (X,Y) => (Time,Price)
         if(!ChartTimePriceToXY(0,window,dt,price,x,y))
            return;
         // if(dtreturn;
         if(dt>TimeLocal()) return;
         //--- delete lines
         ObjectDelete(0,"V Line");
         //--- create horizontal and vertical lines of the crosshair
         MqlDateTime tm;
         TimeToStruct(dt,tm);
         string datestr=StringFormat("%04d.%02d.%02d %02d:00",tm.year,tm.mon,tm.day,InpCalcTime);
         datetime t=StringToTime(datestr);

         generate_histgram(window,t);
         ObjectCreate(0,"V Line",OBJ_VLINE,window,t,price);

         ChartRedraw(0);
        }
      else
         return;
     }
  }
//+------------------------------------------------------------------+
//| Short term peak line                                             |
//+------------------------------------------------------------------+  
void draw_histgram(int window,datetime t,int offset,const int  &d1_vh[],const int &st_vh[],const int &mt_vh[],const int &lt_vh[])
  {
   int len=MathMin(ArraySize(d1_vh),ArraySize(st_vh));
   if(len<1)return;
   cleaningObj(prefix);
   int i;

   int max=0;
   for(i=0;i<len;i++)
     {
      if(st_vh[i]+d1_vh[i]>max)
         max=st_vh[i]+d1_vh[i];
     }
   int vline=iBarShift(NULL,Period(),t,false);
   int pos=vline+MathRound(max*InpDrawScale);
//int pos=iBarShift(NULL,Period(),Time[zero],false);
   double p1,p2;
   for(i=0;i<len;i++)
     {
      int st=MathRound(st_vh[i]*InpDrawScale);
      datetime st_to=Time[MathMax(0,pos-st)];
      p1 = (offset+i*InpBinRange)*Point;
      p2 = p1+InpBinRange*Point;
      ObjectCreate(prefix+"ST_"+IntegerToString(i),OBJ_RECTANGLE,window,Time[pos],p1,st_to,p2);
      ObjectSet(prefix+"ST_"+IntegerToString(i),OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet(prefix+"ST_"+IntegerToString(i),OBJPROP_COLOR,InpShortTermColor);

      int d1=MathRound(d1_vh[i]*InpDrawScale);
      datetime d1_to=Time[MathMax(0,pos-st-d1)];
      ObjectCreate(prefix+"D1_"+IntegerToString(i),OBJ_RECTANGLE,window,st_to,p1,d1_to,p2);
      ObjectSet(prefix+"D1_"+IntegerToString(i),OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet(prefix+"D1_"+IntegerToString(i),OBJPROP_COLOR,Inp1DayColor);
     }
   len=MathMin(ArraySize(mt_vh),ArraySize(lt_vh));
   if(len<1)return;

   for(i=0;i<len;i++)
     {
      int mt=MathRound(mt_vh[i]*InpDrawScale);
      datetime mt_from=Time[MathMax(0,pos+mt)];
      p1 = (offset + i * LtBinRange) * Point;
      p2 = p1 + LtBinRange * Point;
      ObjectCreate(prefix+"MT_"+IntegerToString(i),OBJ_RECTANGLE,window,mt_from,p1,Time[pos],p2);
      ObjectSet(prefix+"MT_"+IntegerToString(i),OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet(prefix+"MT_"+IntegerToString(i),OBJPROP_COLOR,InpMediumTermColor);

      int lt=MathRound(lt_vh[i]*InpDrawScale);
      datetime lt_from=Time[MathMax(0,pos+mt+lt)];
      ObjectCreate(prefix+"LT_"+IntegerToString(i),OBJ_RECTANGLE,window,lt_from,p1,mt_from,p2);
      ObjectSet(prefix+"LT_"+IntegerToString(i),OBJPROP_STYLE,STYLE_SOLID);
      ObjectSet(prefix+"LT_"+IntegerToString(i),OBJPROP_COLOR,InpLongTermColor);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool generate_histgram(int window,datetime t)
  {
   double m5high[];
   double m5low[];
   long m5vol[];
   ArraySetAsSeries(m5high,true);
   ArraySetAsSeries(m5low,true);
   ArraySetAsSeries(m5vol,true);
   int m5_len1=CopyTickVolume(Symbol(),PERIOD_M5,t,st_period,m5vol);
   int m5_len2=CopyHigh(Symbol(),PERIOD_M5,t,st_period,m5high);
   int m5_len3=CopyLow (Symbol(),PERIOD_M5,t,st_period,m5low);
   bool m5_ok = (st_period==m5_len1 && m5_len1==m5_len2 && m5_len2==m5_len3);
   if(!m5_ok)return (false);
   double m30high[];
   double m30low[];
   long   m30vol[];
   ArraySetAsSeries(m30high,true);
   ArraySetAsSeries(m30low,true);
   ArraySetAsSeries(m30vol,true);
//---
   int m30_len1=CopyTickVolume(Symbol(),PERIOD_M30,t,lt_period,m30vol);
   int m30_len2=CopyHigh(Symbol(),PERIOD_M30,t,lt_period,m30high);
   int m30_len3=CopyLow (Symbol(),PERIOD_M30,t,lt_period,m30low);
   bool m30_ok = (lt_period==m30_len1 && m30_len1==m30_len2 && m30_len2==m30_len3);
   if(!m30_ok)return (false);

   int st_offset=(int)MathRound(m5low[ArrayMinimum(m5low)]/_Point);
   int st_limit=(int)MathRound(m5high[ArrayMaximum(m5high)]/_Point);

//--- 1Day peak line
   int d1_offset=(int)MathRound(m5low[ArrayMinimum(m5low,d1_period,0)]/_Point);
   int d1_limit=(int)MathRound(m5high[ArrayMaximum(m5high,d1_period,0)]/_Point);
//   
   int lt_offset=(int)MathRound(m30low[ArrayMinimum(m30low)]/_Point);
   int lt_limit=(int)MathRound(m30high[ArrayMaximum(m30high)]/_Point);
//--- Middle term peak line
   int mt_offset=(int)MathRound(m30low[ArrayMinimum(m30low,mt_period,0)]/_Point);
   int mt_limit=(int)MathRound(m30high[ArrayMaximum(m30high,mt_period,0)]/_Point);

   int offset = MathMin(MathMin(MathMin(d1_offset,st_offset),mt_offset),lt_offset);
   int limit  = MathMax(MathMax(MathMax(d1_limit,st_limit),mt_limit),lt_limit);
   int lt_vh[];
   int mt_vh[];
   int st_vh[];
   int d1_vh[];
   int lt_vhZO[];
   int mt_vhZO[];
   int st_vhZO[];
   int d1_vhZO[];

   calc_histgram(lt_vh,lt_vhZO,m30high,m30low,m30vol,offset,limit,InpBinRange*BinRangeScale,lt_period);
   calc_histgram(mt_vh,mt_vhZO,m30high,m30low,m30vol,offset,limit,InpBinRange*BinRangeScale,mt_period);
   calc_histgram(st_vh,st_vhZO,m5high,m5low,m5vol,offset,limit,InpBinRange,st_period);
   calc_histgram(d1_vh,d1_vhZO,m5high,m5low,m5vol,offset,limit,InpBinRange,d1_period);

   draw_histgram(window,t,offset,d1_vh,st_vh,mt_vh,lt_vh);
   return (true);
  }
//+------------------------------------------------------------------+
//| calc histgram                                                    |
//+------------------------------------------------------------------+
bool calc_histgram(int &vh[],int &vhZO[],const double  &hi[],const double  &lo[],const long  &vol[],int offset,int limit,double binRange,int barcount=NULL)
  {
//---
   int j,k;
   int factor=zoom_out_factor;  // zoom out factor 
//---
//--- for calcuration
   int work[][2];
//--- binrange zoom out
   double binRangeZO=binRange*factor;
//--- histgram bin steps
   int steps=(int)MathRound((limit-offset)/binRange)+1;
//--- histgram bin*zoomout steps
   int stepsZO=(int)MathRound((limit-offset)/binRangeZO)+1;
//--- init
   ArrayResize(vh,steps);
   ArrayInitialize(vh,0);
   ArrayResize(vhZO,stepsZO);
   ArrayInitialize(vhZO,0);
//--- histgram loop
   for(j=barcount-1;j>=0;j--)
     {
      int l =(int)MathRound(lo[j]/_Point);
      int h =(int)MathRound(hi[j]/_Point);
      int v=1;
      if(InpUsingVolumeWeight)
        {
         v=(int)MathRound(MathSqrt(MathMin(vol[j],1)));
        }
      int min = (int)MathRound((l-offset)/binRange);
      int max = (int)MathRound((h-offset)/binRange);
      int minZO = (int)MathRound((l-offset)/binRangeZO);
      int maxZO = (int)MathRound((h-offset)/binRangeZO);
      //--- for normal
      for(k=min;k<=max;k++)vh[k]+=v;
      //--- for zoomout
      for(k=minZO;k<=maxZO;k++)vhZO[k]+=v;
     }
   return(true);
  }
//+------------------------------------------------------------------+
//| Delete all objects with given prefix                             |
//+------------------------------------------------------------------+
void cleaningObj(string Prefix)
  {
   int L = StringLen(Prefix);
   int i = 0;
   while(i<ObjectsTotal())
     {
      string ObjName=ObjectName(i);
      if(StringSubstr(ObjName,0,L)!=Prefix)
        {
         i++;
         continue;
        }
      ObjectDelete(ObjName);
     }
  }
//+------------------------------------------------------------------+
