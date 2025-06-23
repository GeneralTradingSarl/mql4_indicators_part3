//+------------------------------------------------------------------+
//| r-squared indicator
//| by Onur Sirek
//+------------------------------------------------------------------+
#property copyright "Onur Sirek"
#property link      "melihonurs@gmail.com"
#property strict

#property indicator_separate_window
#property indicator_maximum 100
#property indicator_minimum -100
/*
#property indicator_minimum 0
#property indicator_maximum 1
#property indicator_level1 0.2
#property indicator_level2 0.8
*/
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Fuchsia

enum onB {BA_ActualBar,BA_PastBar};

extern int                 RSQPeriod=50;
extern ENUM_APPLIED_PRICE  RSQ_Price=PRICE_MEDIAN;
extern onB                 RSQ_Bar=BA_PastBar;
extern int                 RSQ_Timer=1;
extern int                 RSQ_MaxBars=500;
double RSQBuffer[],DegBuffer[];
double Graph[],Data[];

int      barsCounted=0,offsetBar=0;
bool     flgSeconds=false,flgDoOnce=false;
double   stdDev=0,variance=0;
double Slope=0,kOrigin=0,Degrees=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
   short_name="r-squared("+(string)RSQPeriod+")";
   IndicatorShortName(short_name);
//IndicatorDigits(2);
   SetLevelValue(0,calcLevel(RSQPeriod));

   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,RSQBuffer);
   SetIndexLabel(0,short_name);
   SetIndexDrawBegin(0,RSQPeriod);

   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,DegBuffer);
   SetIndexLabel(1,"Degrees");
   SetIndexDrawBegin(1,RSQPeriod);

   ArrayResize(Graph,RSQPeriod);
   ArrayResize(Data,RSQPeriod);
   offsetBar=0;
   if(RSQ_Bar==BA_PastBar)
      offsetBar=1;
   if(RSQ_Timer>0)
     {
      if(EventSetTimer(RSQ_Timer)==false)
         Print("No timer!!!!");
     }
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
   flgSeconds=true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
//if(flgDoOnce)ExpertRemove();
//Print("OnMainCycle: ",TimeCurrent());
//if(flgSeconds)Print("MainCycle->Secs: ",TimeCurrent());
   int bars_count;
   int counted_bars=IndicatorCounted();

   if((RSQPeriod<2) || (Bars<RSQPeriod))
      return(0);
   bars_count=Bars-RSQPeriod-1;
   if(counted_bars>RSQPeriod)
      bars_count=Bars-counted_bars-1;
   if(bars_count>RSQ_MaxBars)
      bars_count=RSQ_MaxBars;

   for(int i=0+offsetBar; i<bars_count+offsetBar; i++)
     {
      stats_copy_prices(RSQ_Price,RSQPeriod,i,Data);
      RSQBuffer[i] = RSquared(RSQPeriod,i,Data,Graph,stdDev,variance,Slope,Degrees,kOrigin,true)*100;
      DegBuffer[i] = Degrees;
      if(!flgDoOnce || flgSeconds || isNewBar())
        {
         //Print("Redrawing: ",TimeCurrent());
         stats_draw_line(offsetBar,stdDev);
        }
     }
//flgDoOnce=true;
   flgSeconds=false;
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void stats_copy_prices(int price,int period,int shift,double &data[])
  {
//Print("Copiando: ",period," Datos");
   for(int i=0; i<period; i++)
     {
        {if(price==PRICE_CLOSE)data[i]=Close[i+shift];}
        {if(price==PRICE_HIGH)data[i]=High[i+shift];}
        {if(price==PRICE_LOW)data[i]=Low[i+shift];}
        {if(price==PRICE_OPEN)data[i]=Open[i+shift];}
        {if(price==PRICE_MEDIAN)data[i]=(High[i+shift]+Low[i+shift])/2;}
        {if(price==PRICE_TYPICAL)data[i]=(High[i+shift] + Low[i+shift] + Close[i+shift])/3;}
        {if(price==PRICE_WEIGHTED)data[i]=(High[i+shift] + Low[i+shift] + Close[i+shift] + Close[i+shift])/4;}
      //Print("i: ",i," Dato: ",data[i]);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void stats_draw_line(int offset,double std_dev)
  {
   double StdDevUp[],StdDevDn[];
   ArrayResize(StdDevUp,RSQPeriod+2);
   ArrayResize(StdDevDn,RSQPeriod+2);
   ObjectsDeleteAll(0,"TrendLine");
   drawFakeGraph("TrendLine",clrAqua,Graph,offset);
   if(std_dev>0)
     {
      for(int i=0; i<ArraySize(Graph)-0; i++)
        {
         StdDevUp[i]=Graph[i]+std_dev;
         StdDevDn[i]=Graph[i]-std_dev;
        }
      ObjectsDeleteAll(0,"StdDev_");
      drawFakeGraph("StdDev_Up",clrFuchsia,StdDevUp,offset);
      drawFakeGraph("StdDev_Dn",clrFuchsia,StdDevDn,offset);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double calcLevel(double per)
  {
   double per1=0,lev1=0,lenper=0,levdif=0;
   if(per<=5)
      return(0.77);
   if((per>5) && (per<=10))
     {per1=5; lev1=0.77; lenper=5; levdif=0.37;}
   if((per>10) && (per<=14))
     {per1=10; lev1=0.40; lenper=4; levdif=0.13;}
   if((per>14) && (per<=20))
     {per1=14; lev1=0.27; lenper=6; levdif=0.07;}
   if((per>20) && (per<=25))
     {per1=20; lev1=0.20; lenper=5; levdif=0.04;}
   if((per>25) && (per<=30))
     {per1=25; lev1=0.16; lenper=5; levdif=0.03;}
   if((per>30) && (per<=50))
     {per1=30; lev1=0.13; lenper=20; levdif=0.05;}
   if((per>50) && (per<=60))
     {per1=50; lev1=0.08; lenper=10; levdif=0.02;}
   if((per>60) && (per<=120))
     {per1=60; lev1=0.06; lenper=60; levdif=0.03;}
   if(per>120)
      return(0.03);
   return(lev1 - (per-per1)*(levdif/lenper));
  }

// r-squared shows the correlation with its linear regression line
// values close to 1.0 show perfect relation
// values close to 0.0 show poor relation
// See Metastock Help
// To determine if the trend is statistically significant for a given x-period linear regression line,
// plot the r-squared indicator and refer to the following table.  This table shows the values of
// r-squared required for a 95% confidence level at various time periods.  If the r-squared value
// is less than the critical values shown, you should assume that prices show no statistically
// significant trend.
// Number ofPeriods  r-squaredCritical Value(95%confidence)
//       5                 0.77
//       10                0.40
//       14                0.27
//       20                0.20
//       25                0.16
//       30                0.13
//       50                0.08
//       60                0.06
//       120               0.03
// You may even consider opening a short-term position opposite the prevailing trend when you
// observe r-squared rounding off at extreme levels.  For example, if the slope is positive and
// r-squared is above 0.80 and begins to turn down, you may consider selling or opening a short position.
// There are numerous ways to use the linear regression outputs of r-squared and Slope in trading
// systems.  For more detailed coverage, refer to the book The New Technical Trader by Tushar Chande
// and Stanley Kroll.
//+------------------------------------------------------------------+
void drawLineTrendPoints(string name,datetime t1,double price1,datetime t2,double price2,color clr=clrWheat,bool flgExtend=false,int wdth=1,int stle=STYLE_SOLID,bool bkgrnd=true)
  {
   if(ObjectCreate(name,OBJ_TREND,0,t1,price1,t2,price2))
     {
      //ObjectSet(name,OBJPROP_RAY,flgExtend);
      ObjectSetInteger(ChartID(),name,OBJPROP_COLOR,clr);
      ObjectSetInteger(ChartID(),name,OBJPROP_ZORDER,FALSE);
      ObjectSetInteger(ChartID(),name,OBJPROP_STYLE,stle);
      ObjectSetInteger(ChartID(),name,OBJPROP_WIDTH,wdth);
      ObjectSetInteger(ChartID(),name,OBJPROP_RAY,flgExtend);
      ObjectSetInteger(ChartID(),name,OBJPROP_BACK,bkgrnd);
     }
   else
     {
      ObjectMove(name,0,t1,price1);
      ObjectMove(name,1,t2,price2);
      //--- forced chart redraw
     }
//if(wait>0)Sleep(wait);
   ChartRedraw(ChartID());
  }
//+------------------------------------------------------------------+
void drawFakeGraph(string name,color fColor,double &points[],int offset)
  {
   for(int i=0; i<ArraySize(points)-1; i++)
     {
      if(points[i]>0 && points[i+1]>0)
        {
         drawLineTrendPoints(name+"_"+IntegerToString(i),Time[i+offset],points[i],Time[i+1+offset],points[i+1],fColor,false,1,STYLE_SOLID,false);
        }
     }
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool isNewBar()
  {
   bool r=false;
   static datetime TempoSalvato=0;
   if(TempoSalvato!=Time[0])
     {barsCounted++; r=true; TempoSalvato=Time[0];}
   return(r);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
double shifted_data_variance(double &data[])
  {
   double varianc=0,Ex=0,Ex2=0;
   if(ArraySize(data)< 2)
      return (0.0);
   double K = data[0];
   double n = Ex = Ex2 = 0.0;
   for(int x=0; x<ArraySize(data); x++)
     {
      n = n + 1;
      Ex += data[x] - K;
      Ex2 += (data[x] - K) * (data[x] - K);
     }
   varianc = (Ex2 - (Ex * Ex) / n) / (n - 1);
// use n instead of (n-1) if want to compute the exact variance of the given data
// use (n-1) if data are samples of a larger population
   return (varianc);
  }
//+------------------------------------------------------------------+
double two_pass_variance(double &data[])
  {
   double varianc=0, n = 0,sum1 = 0,sum2 = 0,mean=0;

   for(int x=0; x<ArraySize(data); x++)
     {
      n += 1;
      sum1 += data[x];
     }

   mean = sum1 / n;

   for(int x=0; x<ArraySize(data); x++)
     {
      sum2 += (data[x] - mean) * (data[x] - mean);
     }

//varianc = sum2 / (n - 1);
   varianc = sum2 / (n - 0);
   return (varianc);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void label_to_candle(string name,string Text,int candleNo,double price,color Clr=clrWhite,int Win=0,int FSize=10)
  {
   bool created=ObjectCreate(Win,name,OBJ_TEXT,0,Time[candleNo],price);
   if(created)// If set up - let's make tuning for it
     {
      //--- Point anchor is above in order not to cover bar
      ObjectSetInteger(Win,name,OBJPROP_ANCHOR,ANCHOR_TOP);
      //--- Final touch - Text
      ObjectSetText(name,Text,FSize,"Arial",Clr);
     }
   ObjectMove(Win,name,0,Time[candleNo],price);
   ObjectSetString(Win,name,OBJPROP_TEXT,Text);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double RSquared(int per,int shift,double &data[],double &graph[],double &StdDeviation,double &varianc,double &slope,double &degrees,double &b,bool flgGenerateGraph=true)
  {
   int i;
   double x, y, div;
   double Ex=0.0, Ey=0.0, Exy=0.0, Ex2=0.0, Ey2=0.0;
   double Ex22, Ey22;
   double r=0,rSquared=0;
   for(i=1; i<=per; i++)
     {
      x = i;                 // x axis value
      y = data[i-1];  // y axis value
      //y = Close[i-1+shift];  // y axis value
      Ex  += x;
      Ey  += y;
      Exy += x*y;
      Ex2 += MathPow(x,2);
      Ey2 += MathPow(y,2);
     }
   Ex22=MathPow(Ex,2);
   Ey22=MathPow(Ey,2);
   slope = (per*Exy-Ex*Ey) / (per*Ex2-Ex22);  // slope of regression line
   b = (Ey-slope*Ex)/per;
   if(flgGenerateGraph)
     {
        {for(i=0; i<per; i++) {graph[i]=((i+1)*slope)+b;}}
     }
   slope=slope*-1;
   degrees=NormalizeDouble(MathArctan(slope)*(180/M_PI),2);
//---
   double Deviation=0,Sredn_y=0;
   Sredn_y=Ey/per;
   for(i=0; i<per; i++)
     {Deviation=Deviation+MathPow((data[i]-Sredn_y),2);}
   StdDeviation=MathSqrt(Deviation/per);
   varianc=Deviation/per;
//---
   div = MathSqrt((per*Ex2-Ex22)*(per*Ey2-Ey22));
   if(div==0)
      return(0);
   r = (per*Exy-Ex*Ey) / div;
   rSquared=MathPow(r,2);
   string cmt="RSquared: "+(string)rSquared+" StdDev: "+(string)StdDeviation+" Variance: "+(string)varianc+" Slope: "+(string)slope+" B: "+(string)b+" Dg: "+(string)degrees+" Lvl: "+(string)calcLevel(RSQPeriod);
   Comment(cmt);
//Print(cmt);
   return(rSquared);
  }
//+------------------------------------------------------------------+
