//+------------------------------------------------------------------+
//|                                                  ZigZagArrow.mq4 |
//|                              Copyright 2015,  3rjfx ~ 31/03/2015 |
//|                              https://www.mql5.com/en/users/3rjfx |
//+------------------------------------------------------------------+
#property copyright "2006-2014, MetaQuotes Software Corp."
#property link      "http://www.mql4.com"
#property link      "https://www.mql5.com/en/users/3rjfx"
#property version   "2.00"
//---
/* Last Update (Update_01 ~ 2015-07-30)
   ~ Add color options for arrow
   ~ Adjust the position of the arrow for each timeframe.
*/
//---
#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1  clrNONE
#property indicator_color2  clrBlue
#property indicator_color3  clrRed
#property indicator_color4  clrNONE
#property indicator_color5  clrNONE
//---
#property indicator_width2 2
#property indicator_width3 2
//---- indicator parameters
input int InpDepth=12;     // Depth
input int InpDeviation=5;  // Deviation
input int InpBackstep=3;   // Backstep
input color ArrowUp=clrBlue; // Color for Arrow Up
input color ArrowDown=clrRed; // Color for Arrow Down
//---- indicator buffers
double ExtZigzagBuffer[];
double UpZigzagBuffer[];
double DnZigzagBuffer[];
double ExtHighBuffer[];
double ExtLowBuffer[];
//--- globals
int    ExtLevel=3; // recounting's depth of extremums
int ad;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(InpBackstep>=InpDepth)
     {
      Print("Backstep cannot be greater or equal to Depth");
      return(INIT_FAILED);
     }
//--- 2 additional buffers
   IndicatorBuffers(5);
//---- drawing settings
   SetIndexStyle(0,DRAW_NONE);
   SetIndexStyle(1,DRAW_ARROW,STYLE_SOLID,EMPTY,ArrowUp);
   SetIndexArrow(1,241);
   SetIndexStyle(2,DRAW_ARROW,STYLE_SOLID,EMPTY,ArrowDown);
   SetIndexArrow(2,242);
   SetIndexStyle(3,DRAW_NONE);
   SetIndexStyle(4,DRAW_NONE);
//---- indicator buffers
   SetIndexBuffer(0,ExtZigzagBuffer);
   SetIndexBuffer(1,UpZigzagBuffer);
   SetIndexBuffer(2,DnZigzagBuffer);
   SetIndexBuffer(3,ExtHighBuffer);
   SetIndexBuffer(4,ExtLowBuffer);
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   SetIndexEmptyValue(2,0.0);
//---- indicator short name
   IndicatorShortName("ZigZagArrow("+string(InpDepth)+","+string(InpDeviation)+","+string(InpBackstep)+")");
//---
   switch(_Period)
     {
      //---
      case 1: ad=2; break;
      case 5: ad=3; break;
      case 15: ad=4; break;
      case 30: ad=7; break;
      case 60: ad=9; break;
      case 240: ad=16; break;
      case 1440: ad=70; break;
      case 10080: ad=120; break;
      case 43200: ad=220; break;
     }
//---- initialization done
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
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
   int    i,limit,counterZ,whatlookfor=0;
   int    back,pos,lasthighpos=0,lastlowpos=0;
   double extremum;
   double curlow=0.0,curhigh=0.0,lasthigh=0.0,lastlow=0.0;
//---
//--- check for history and inputs
   if(rates_total<InpDepth || InpBackstep>=InpDepth)
      return(0);
//--- first calculations
   if(prev_calculated==0)
      limit=InitializeAll();
   else
     {
      //--- find first extremum in the depth ExtLevel or 100 last bars
      i=counterZ=0;
      while(counterZ<ExtLevel && i<100)
        {
         if(ExtZigzagBuffer[i]!=0.0)
            counterZ++;
         i++;
        }
      //--- no extremum found - recounting all from begin
      if(counterZ==0)
         limit=InitializeAll();
      else
        {
         //--- set start position to found extremum position
         limit=i-1;
         //--- what kind of extremum?
         if(ExtLowBuffer[i]!=0.0)
           {
            //--- low extremum
            curlow=ExtLowBuffer[i];
            //--- will look for the next high extremum
            whatlookfor=1;
           }
         else
           {
            //--- high extremum
            curhigh=ExtHighBuffer[i];
            //--- will look for the next low extremum
            whatlookfor=-1;
           }
         //--- clear the rest data
         for(i=limit-1; i>=0; i--)
           {
            ExtZigzagBuffer[i]=0.0;
            ExtLowBuffer[i]=0.0;
            ExtHighBuffer[i]=0.0;
           }
        }
     }
//--- main loop      
   for(i=limit; i>=0; i--)
     {
      //--- find lowest low in depth of bars
      extremum=low[iLowest(NULL,0,MODE_LOW,InpDepth,i)];
      //--- this lowest has been found previously
      if(extremum==lastlow)
         extremum=0.0;
      else
        {
         //--- new last low
         lastlow=extremum;
         //--- discard extremum if current low is too high
         if(low[i]-extremum>InpDeviation*Point)
            extremum=0.0;
         else
           {
            //--- clear previous extremums in backstep bars
            for(back=1; back<=InpBackstep; back++)
              {
               pos=i+back;
               if(ExtLowBuffer[pos]!=0 && ExtLowBuffer[pos]>extremum)
                  ExtLowBuffer[pos]=0.0;
              }
           }
        }
      //--- found extremum is current low
      if(low[i]==extremum)
         ExtLowBuffer[i]=extremum;
      else
         ExtLowBuffer[i]=0.0;
      //--- find highest high in depth of bars
      extremum=high[iHighest(NULL,0,MODE_HIGH,InpDepth,i)];
      //--- this highest has been found previously
      if(extremum==lasthigh)
         extremum=0.0;
      else
        {
         //--- new last high
         lasthigh=extremum;
         //--- discard extremum if current high is too low
         if(extremum-high[i]>InpDeviation*Point)
            extremum=0.0;
         else
           {
            //--- clear previous extremums in backstep bars
            for(back=1; back<=InpBackstep; back++)
              {
               pos=i+back;
               if(ExtHighBuffer[pos]!=0 && ExtHighBuffer[pos]<extremum)
                  ExtHighBuffer[pos]=0.0;
              }
           }
        }
      //--- found extremum is current high
      if(high[i]==extremum)
         ExtHighBuffer[i]=extremum;
      else
         ExtHighBuffer[i]=0.0;
     }
//--- final cutting 
   if(whatlookfor==0)
     {
      lastlow=0.0;
      lasthigh=0.0;
     }
   else
     {
      lastlow=curlow;
      lasthigh=curhigh;
     }
   for(i=limit; i>=0; i--)
     {
      switch(whatlookfor)
        {
         case 0: // look for peak or lawn 
            if(lastlow==0.0 && lasthigh==0.0)
              {
               if(ExtHighBuffer[i]!=0.0)
                 {
                  lasthigh=High[i];
                  lasthighpos=i;
                  whatlookfor=-1;
                  ExtZigzagBuffer[i]=lasthigh;
                  DnZigzagBuffer[i]=lasthigh+(ad*Point);
                 }
               if(ExtLowBuffer[i]!=0.0)
                 {
                  lastlow=Low[i];
                  lastlowpos=i;
                  whatlookfor=1;
                  ExtZigzagBuffer[i]=lastlow;
                  UpZigzagBuffer[i]=lastlow-(ad*Point);
                 }
              }
            break;
         case 1: // look for peak
            if(ExtLowBuffer[i]!=0.0 && ExtLowBuffer[i]<lastlow && ExtHighBuffer[i]==0.0)
              {
               ExtZigzagBuffer[lastlowpos]=0.0;
               lastlowpos=i;
               lastlow=ExtLowBuffer[i];
               ExtZigzagBuffer[i]=lastlow;
               UpZigzagBuffer[i]=lastlow-(ad*Point);
              }
            if(ExtHighBuffer[i]!=0.0 && ExtLowBuffer[i]==0.0)
              {
               lasthigh=ExtHighBuffer[i];
               lasthighpos=i;
               ExtZigzagBuffer[i]=lasthigh;
               DnZigzagBuffer[i]=lasthigh+(ad*Point);
               whatlookfor=-1;
              }
            break;
         case -1: // look for lawn
            if(ExtHighBuffer[i]!=0.0 && ExtHighBuffer[i]>lasthigh && ExtLowBuffer[i]==0.0)
              {
               ExtZigzagBuffer[lasthighpos]=0.0;
               lasthighpos=i;
               lasthigh=ExtHighBuffer[i];
               ExtZigzagBuffer[i]=lasthigh;
               DnZigzagBuffer[i]=lasthigh+(ad*Point);
              }
            if(ExtLowBuffer[i]!=0.0 && ExtHighBuffer[i]==0.0)
              {
               lastlow=ExtLowBuffer[i];
               lastlowpos=i;
               ExtZigzagBuffer[i]=lastlow;
               UpZigzagBuffer[i]=lastlow-(ad*Point);
               whatlookfor=1;
              }
            break;
        }
     }
//--- done
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int InitializeAll()
  {
   ArrayInitialize(ExtZigzagBuffer,0.0);
   ArrayInitialize(UpZigzagBuffer,0.0);
   ArrayInitialize(DnZigzagBuffer,0.0);
   ArrayInitialize(ExtHighBuffer,0.0);
   ArrayInitialize(ExtLowBuffer,0.0);
//--- first counting position
   return(Bars-InpDepth);
  }
//+------------------------------------------------------------------+
