//+------------------------------------------------------------------+
//|                   Zigzag_with_line_at_lows_and_line_at_highs.mq4 |
//|                                        Copyright © 2013, deVries |
//|                                      http://forum.mql4.com/54660 |
//|                                                                  |
//| Now the Highs (buffer4) of ZigZag are also connected with a line |                            
//|     and the Lows (buffer5) of ZigZag are connected with a line   |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2013, deVries"
#property link      "http://forum.mql4.com/54660"

#property indicator_chart_window
#property indicator_buffers 5
#property indicator_color1 Red            //ZigZag Buffer
#property indicator_width1 3
#property indicator_color2 Green
#property indicator_color3 Yellow
#property indicator_color4 Magenta        //ZigZag High
#property indicator_width4 3
#property indicator_color5 LightSkyBlue   //ZigZag Low
#property indicator_width5 3

//---- indicator parameters
extern int ExtDepth=12;
extern int ExtDeviation=5;
extern int ExtBackstep=3;
//---- indicator buffers
double ZigzagBuffer[];
double HighMapBuffer[];
double LowMapBuffer[];
double UPBuffer[];
double DNBuffer[];

int level=3; // recounting's depth 
bool downloadhistory=false;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(5);
//---- drawing settings
   SetIndexStyle(0,DRAW_SECTION);
   SetIndexStyle(1,DRAW_SECTION);   
   SetIndexStyle(2,DRAW_SECTION);
   SetIndexStyle(3,DRAW_SECTION);   
   SetIndexStyle(4,DRAW_SECTION);   
      
//---- indicator buffers mapping
   SetIndexBuffer(0,ZigzagBuffer);
   SetIndexBuffer(1,HighMapBuffer);
   SetIndexBuffer(2,LowMapBuffer);
   SetIndexBuffer(3,UPBuffer);
   SetIndexBuffer(4,DNBuffer);   
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);   
   SetIndexEmptyValue(2,0.0);   
   SetIndexEmptyValue(3,0.0);   
   SetIndexEmptyValue(4,0.0);      

//---- indicator short name
   IndicatorShortName("ZigZag("+ExtDepth+","+ExtDeviation+","+ExtBackstep+")");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int i, counted_bars = IndicatorCounted();
   int limit,counterZ,whatlookfor;
   int shift,back,lasthighpos,lastlowpos;
   double val,res;
   double curlow,curhigh,lasthigh,lastlow;

   if (counted_bars==0 && downloadhistory) // history was downloaded
     {
      ArrayInitialize(ZigzagBuffer,0.0);
      ArrayInitialize(HighMapBuffer,0.0);
      ArrayInitialize(LowMapBuffer,0.0);
      ArrayInitialize(UPBuffer,0.0);
      ArrayInitialize(DNBuffer,0.0);
     }
   if (counted_bars==0) 
     {
      limit=Bars-ExtDepth;
      downloadhistory=true;
     }
   if (counted_bars>0) 
     {
      while (counterZ<level && i<100)
        {
         res=ZigzagBuffer[i];
         if (res!=0) counterZ++;
         i++;
        }
      i--;
      limit=i;
      if (LowMapBuffer[i]!=0) 
        {
         curlow=LowMapBuffer[i];
         whatlookfor=1;
        }
      else
        {
         curhigh=HighMapBuffer[i];
         whatlookfor=-1;
        }
      for (i=limit-1;i>=0;i--)  
        {
         ZigzagBuffer[i]=0.0;  
         LowMapBuffer[i]=0.0;
         HighMapBuffer[i]=0.0;
         UPBuffer[i]=0.0;
         DNBuffer[i]=0.0;
        }
     }
      
   for(shift=limit; shift>=0; shift--)
     {
      val=Low[iLowest(NULL,0,MODE_LOW,ExtDepth,shift)];
      if(val==lastlow) val=0.0;
      else 
        { 
         lastlow=val; 
         if((Low[shift]-val)>(ExtDeviation*Point)) val=0.0;
         else
           {
            for(back=1; back<=ExtBackstep; back++)
              {
               res=LowMapBuffer[shift+back];
               if((res!=0)&&(res>val)) LowMapBuffer[shift+back]=0.0; 
              }
           }
        } 
      if (Low[shift]==val) 
           LowMapBuffer[shift]=val;else LowMapBuffer[shift]=0.0;
      //--- high
      val=High[iHighest(NULL,0,MODE_HIGH,ExtDepth,shift)];
      if(val==lasthigh) val=0.0;
      else 
        {
         lasthigh=val;
         if((val-High[shift])>(ExtDeviation*Point)) val=0.0;
         else
           {
            for(back=1; back<=ExtBackstep; back++)
              {
               res=HighMapBuffer[shift+back];
               if((res!=0)&&(res<val)) HighMapBuffer[shift+back]=0.0; 
              } 
           }
        }
      if (High[shift]==val) HighMapBuffer[shift]=val; else HighMapBuffer[shift]=0.0;
     }

   // final cutting 
   if (whatlookfor==0)
     {
      lastlow=0;
      lasthigh=0;  
     }
   else
     {
      lastlow=curlow;
      lasthigh=curhigh;
     }
   for (shift=limit;shift>=0;shift--)
     {
      res=0.0;
      switch(whatlookfor)
        {
         case 0: // look for peak or lawn 
            if (lastlow==0 && lasthigh==0)
              {
               if (HighMapBuffer[shift]!=0)
                 {
                  lasthigh=High[shift];
                  lasthighpos=shift;
                  whatlookfor=-1;
                  ZigzagBuffer[shift]=lasthigh;
                  UPBuffer[shift]=lasthigh;
                  res=1;
                 }
               if (LowMapBuffer[shift]!=0)
                 {
                  lastlow=Low[shift];
                  lastlowpos=shift;
                  whatlookfor=1;
                  ZigzagBuffer[shift]=lastlow;
                  DNBuffer[shift]=lastlow;
                  res=1;
                 }
              }
             break;  
         case 1: // look for peak
            if (LowMapBuffer[shift]!=0.0 && LowMapBuffer[shift]<lastlow && HighMapBuffer[shift]==0.0)
              {
               ZigzagBuffer[lastlowpos]=0.0;
               DNBuffer[lastlowpos]=0.0;
               lastlowpos=shift;
               lastlow=LowMapBuffer[shift];
               ZigzagBuffer[shift]=lastlow;
               DNBuffer[shift]=lastlow;
               res=1;
              }
            if (HighMapBuffer[shift]!=0.0 && LowMapBuffer[shift]==0.0)
              {
               lasthigh=HighMapBuffer[shift];
               lasthighpos=shift;
               ZigzagBuffer[shift]=lasthigh;
               UPBuffer[shift]=lasthigh;
               whatlookfor=-1;
               res=1;
              }   
            break;               
         case -1: // look for lawn
            if (HighMapBuffer[shift]!=0.0 && HighMapBuffer[shift]>lasthigh && LowMapBuffer[shift]==0.0)
              {
               ZigzagBuffer[lasthighpos]=0.0;
               UPBuffer[lasthighpos]=0.0;
               lasthighpos=shift;
               lasthigh=HighMapBuffer[shift];
               ZigzagBuffer[shift]=lasthigh;
               UPBuffer[shift]=lasthigh;
              }
            if (LowMapBuffer[shift]!=0.0 && HighMapBuffer[shift]==0.0)
              {
               lastlow=LowMapBuffer[shift];
               lastlowpos=shift;
               ZigzagBuffer[shift]=lastlow;
               DNBuffer[shift]=lastlow;
               whatlookfor=1;
              }   
            break;               
         default: return; 
        }
     }

   return(0);
  }
//+------------------------------------------------------------------+