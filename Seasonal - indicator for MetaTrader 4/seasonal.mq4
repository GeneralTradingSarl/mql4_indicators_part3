//+------------------------------------------------------------------+
//|                                                     seasonal.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property description "Seasonal moves indicator"
#property strict
#property indicator_separate_window
//--- indicator settings
#property indicator_buffers 4
#property indicator_type1   DRAW_LINE
#property indicator_type2   DRAW_LINE

#property indicator_style1  STYLE_SOLID
#property indicator_style2  STYLE_SOLID

#property indicator_width1  2
#property indicator_width2  2

#property indicator_color1  DodgerBlue
#property indicator_color2  Gold
#property indicator_color3  CLR_NONE
#property indicator_color4  CLR_NONE
//--- indicator parameters
input int  years=5;  // Number of years for averaging:
//+------------------------------------------------------------------+
//| Types of prices                                                  |
//+------------------------------------------------------------------+
enum dy
  {
   i0, //Close
   i1  //(Open+Close)/2
  };
input dy type=i0;  // Apply to:
input bool Histogram=false;   // Histogram:
bool work=true;
int q;
//--- indicator buffers
double Buffer0[],Buffer1[],Buffer2[],Buffer3[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(_Period!=PERIOD_D1)
     {
      IndicatorShortName("Working timeframe is only daily!");
      work=false;
      return(INIT_SUCCEEDED);
     }
   if(years<=0)
     {
      IndicatorShortName("Wrong parameter!");
      work=false;
      return(INIT_SUCCEEDED);
     }
//---
   IndicatorBuffers(4);
   IndicatorDigits(_Digits);
//--- indicator short name
   IndicatorShortName(" "+(string)years+" years.    ");
//--- drawing settings
   if(!Histogram)
     {
      SetIndexStyle(0,DRAW_LINE);
      SetIndexStyle(1,DRAW_LINE);
     }
   else
     {
      SetIndexStyle(0,DRAW_HISTOGRAM);
      SetIndexStyle(1,DRAW_HISTOGRAM);
     }
   SetIndexStyle(2,DRAW_LINE);
   SetIndexStyle(3,DRAW_LINE);
//--- indicator buffers mapping
   SetIndexBuffer(0,Buffer0);
   SetIndexBuffer(1,Buffer1);
   SetIndexBuffer(2,Buffer2);
   SetIndexBuffer(3,Buffer3);
//---
   return(INIT_SUCCEEDED);
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
   if(rates_total==prev_calculated)
      return(rates_total);
   Function();
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| OnChartEvent()                                                   |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(id!=CHARTEVENT_CLICK)
      return;
   int diff=WindowBarsPerChart()-WindowFirstVisibleBar();
   if(diff<0 || q==diff || !work)
      return;
   q=diff;
   Function();
  }
//+------------------------------------------------------------------+
//| Function()                                                       |
//+------------------------------------------------------------------+
void Function()
  {
   if(!work)
      return;

   int i,d,x0[],x1[];
   double y0[],y1[];
   double value=0;
   int c=0;
   int e=0;
   int f=0;
   int n0=0;
   int n1=0;
   int n2=0;
   int z=0;
//---
   ArrayResize(x0,368,368);
   ArrayResize(x1,368,368);
   ArrayResize(y0,368,368);
   ArrayResize(y1,368,368);

   ArrayInitialize(x0,0);
   ArrayInitialize(x1,0);
   ArrayInitialize(y0,0.0);
   ArrayInitialize(y1,0.0);

//---- number of limiting bar
   for(i=Bars-1; i>0; i--)
     {
      if(TimeYear(Time[i])==TimeYear(Time[i-1]))
         continue;
      n2=i-1;
      break;
     }
//---- summation data for current year
   for(i=0; i<Bars-1; i++)
     {
      if(c>0)
        {
         z=TimeDayOfYear(Time[i]);
         if(f==1)
           {
            d=367-z;
            f=0;
           }
         else
            d=TimeDayOfYear(Time[i-1])-z;
         //----
         switch(type)
           {
            case 0:  value=Close[i];   break;
            case 1:  value=(Open[i]+Close[i])/2;   break;
            default:     break;
           }
         //----
         for(e=0; e<d; e++)
           {
            y0[z+e]+=value;
            x0[z+e]+=1;
           }
        }
      //----
      if(TimeYear(Time[i])==TimeYear(Time[i+1]))
         continue;
      f=1;
      if(c>0)
        {
         d=z-2;
         for(e=0; e<d; e++)
           {
            y0[2+e]+=value;
            x0[2+e]+=1;
           }
         if(c<2)
            n1=i;
        }
      else
         n0=i;
      //----
      if(c>=years || i==n2)
         break;
      c++;
     }
//---- display some information
   if(c==0)
     {
      if(years>0)
         IndicatorShortName("Not enough data!");
      return;
     }
   if(i==n2)
      IndicatorShortName(" "+(string)c+" years.    ");
//---- summation data for last year 
   c=0;
   f=0;
   for(i=0; i<Bars-1; i++)
     {
      if(c>1)
        {
         z=TimeDayOfYear(Time[i]);
         if(f==1)
           {
            d=367-z;
            f=0;
           }
         else
            d=TimeDayOfYear(Time[i-1])-z;
         //----
         switch(type)
           {
            case 0:  value=Close[i];   break;
            case 1:  value=(Open[i]+Close[i])/2;   break;
            default:    break;
           }
         //----
         for(e=0; e<d; e++)
           {
            y1[z+e]+=value;
            x1[z+e]+=1;
           }
        }
      //----
      if(TimeYear(Time[i])==TimeYear(Time[i+1]))
         continue;
      f=1;
      if(c>1)
        {
         d=z-2;
         for(e=0; e<d; e++)
           {
            y1[2+e]+=value;
            x1[2+e]+=1;
           }
        }
      //----
      if(c>years || i==n2)
         break;
      c++;
     }
//---- draw blue line
   for(i=n1; i>=0; i--)
     {
      z=TimeDayOfYear(Time[i]);
      if(i>n0)
        {
         if(c>years && x1[z]>0)
            Buffer0[i]=y1[z]/x1[z];
        }
      else
        {
         if(x0[z]>0)
            Buffer0[i]=y0[z]/x0[z];
        }
     }
//---- draw yellow line
   e=WindowBarsPerChart()-WindowFirstVisibleBar();
   double max=-1;
   double min=1000000;
   d=260-n0;
   f=0;
   for(i=d; i>1; i--)
     {
      if(TimeDayOfWeek(Time[0]+f*86460)==6)
         f+=2;
      z=TimeDayOfYear(Time[0]+f*86460);
      if(x0[z]>0)
        {
         Buffer1[i]=y0[z]/x0[z];
         if(d-i<e)
           {
            if(max<Buffer1[i])
               max=Buffer1[i];
            if(min>Buffer1[i])
               min=Buffer1[i];
           }
        }
      if(TimeYear(Time[0]+f*86460)!=TimeYear(Time[0]+(f+1)*86460))
         break;
      f++;
     }
//--- drawing settings
   SetIndexShift(1,d);
//---- cleaning of lines
   if(e>0)
     {
      Buffer2[0]=max;
      Buffer3[0]=min;
     }
   else
     {
      Buffer2[0]=EMPTY_VALUE;
      Buffer3[0]=EMPTY_VALUE;
     }
//---- 
   z=0;
   for(i=261-n0; i<Bars; i++)
     {
      Buffer1[i]=EMPTY_VALUE;
      z++;
      Buffer2[z]=EMPTY_VALUE;
      Buffer3[z]=EMPTY_VALUE;
     }
//----
   if(c>years)
      d=n1;
   else
      d=n0;
   for(i=Bars-1; i>d; i--)
      Buffer0[i]=EMPTY_VALUE;
  }
//+------------------------------------------------------------------+
