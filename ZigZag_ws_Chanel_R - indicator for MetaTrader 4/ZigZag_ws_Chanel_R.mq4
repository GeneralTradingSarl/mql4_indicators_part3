//+------------------------------------------------------------------+
//|                                           Zigzag_ws_Chanel_R.mq4 |
//|          Copyright © 2008, Dolsergon & MetaQuotes Software Corp. |
//|                                      http://tradecoder.narod.ru/ |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, Dolsergon & MetaQuotes Software Corp."
#property link      "http://tradecoder.narod.ru/; http://www.metaquotes.net/"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Red
#property indicator_width1 2
#property indicator_color2 Pink
#property indicator_color3 Pink
//---- indicator parameters
extern int ExtDepth=12;
extern int ExtDeviation=5;
extern int ExtBackstep=3;
//---- indicator buffers
double ZigzagBuffer[];
double HighMapBuffer[];
double LowMapBuffer[];
double BufChanelHigh[];
double BufChanelLow[];
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
   SetIndexBuffer(0,ZigzagBuffer);
   SetIndexEmptyValue(0,0.0);
   
   SetIndexStyle(1, DRAW_SECTION);
   SetIndexBuffer(1,BufChanelHigh);
   SetIndexEmptyValue(1,0.0);
   
   SetIndexStyle(2, DRAW_SECTION);
   SetIndexBuffer(2,BufChanelLow);
   SetIndexEmptyValue(2,0.0);

   SetIndexBuffer(3,HighMapBuffer);
   SetIndexBuffer(4,LowMapBuffer);

   IndicatorShortName("ZigZag_ws_Chanel_R("+ExtDepth+","+ExtDeviation+","+ExtBackstep+")");

	ObjectCreate("ZZCR1", OBJ_TREND, 0, Time[0], Close[0], Time[10], Close[10]);
	ObjectSet("ZZCR1", OBJPROP_COLOR, Aqua);
	ObjectSet("ZZCR1", OBJPROP_WIDTH, 2);
	ObjectSet("ZZCR1", OBJPROP_STYLE, STYLE_DOT);
	ObjectSet("ZZCR1", OBJPROP_BACK, false);
	ObjectSet("ZZCR1", OBJPROP_RAY, true);
	
	ObjectCreate("ZZCR2", OBJ_TREND, 0, Time[0], Close[0], Time[10], Close[10]);
	ObjectSet("ZZCR2", OBJPROP_COLOR, Khaki);
	ObjectSet("ZZCR2", OBJPROP_WIDTH, 2);
	ObjectSet("ZZCR2", OBJPROP_STYLE, STYLE_DOT);
	ObjectSet("ZZCR2", OBJPROP_BACK, false);
	ObjectSet("ZZCR2", OBJPROP_RAY, true);
	
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
      ArrayInitialize(BufChanelHigh,0.0);
      ArrayInitialize(BufChanelLow,0.0);
      ArrayInitialize(HighMapBuffer,0.0);
      ArrayInitialize(LowMapBuffer,0.0);
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
         
         BufChanelHigh[i]=0.0;
         BufChanelLow[i]=0.0;
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
      if (Low[shift]==val) LowMapBuffer[shift]=val; else LowMapBuffer[shift]=0.0;
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
                  SetHighZZ(shift, lasthigh);
                  res=1;
                 }
               if (LowMapBuffer[shift]!=0)
                 {
                  lastlow=Low[shift];
                  lastlowpos=shift;
                  whatlookfor=1;
                  SetLowZZ(shift, lastlow);
                  res=1;
                 }
              }
             break;  
         case 1: // look for peak
            if (LowMapBuffer[shift]!=0.0 && LowMapBuffer[shift]<lastlow && HighMapBuffer[shift]==0.0)
              {
               SetLowZZ(lastlowpos, 0.0);
               lastlowpos=shift;
               lastlow=LowMapBuffer[shift];
               SetLowZZ(shift, lastlow);
               res=1;
              }
            if (HighMapBuffer[shift]!=0.0 && LowMapBuffer[shift]==0.0)
              {
               lasthigh=HighMapBuffer[shift];
               lasthighpos=shift;
               SetHighZZ(shift, lasthigh);
               whatlookfor=-1;
               res=1;
              }   
            break;               
         case -1: // look for lawn
            if (HighMapBuffer[shift]!=0.0 && HighMapBuffer[shift]>lasthigh && LowMapBuffer[shift]==0.0)
              {
               SetHighZZ(lasthighpos, 0.0);
               lasthighpos=shift;
               lasthigh=HighMapBuffer[shift];
               SetHighZZ(shift, lasthigh);
              }
            if (LowMapBuffer[shift]!=0.0 && HighMapBuffer[shift]==0.0)
              {
               lastlow=LowMapBuffer[shift];
               lastlowpos=shift;
               SetLowZZ(shift, lastlow);
               whatlookfor=1;
              }   
            break;               
         default: return; 
        }
     }

   return(0);
  }


//=================================================================================================
void SetLowZZ(int pShift, double pValue) 
{
	ZigzagBuffer[pShift]=pValue;
	BufChanelLow[pShift]=pValue;
	
	// Верхний лучик ---------------------------------------------
	for (int b1=0; b1<200; b1++) 
	{
		if (BufChanelHigh[b1] > 0) break;
		
	}
	for (int b2=b1+1; b2<400; b2++) 
	{
		if (BufChanelHigh[b2] > 0) break;
	}
	ObjectSet("ZZCR1", OBJPROP_TIME1, Time[b2]);
	ObjectSet("ZZCR1", OBJPROP_PRICE1, High[b2]);
	ObjectSet("ZZCR1", OBJPROP_TIME2, Time[b1]);
	ObjectSet("ZZCR1", OBJPROP_PRICE2, High[b1]);
}
//=================================================================================================
void SetHighZZ(int pShift, double pValue) 
{
	ZigzagBuffer[pShift]=pValue;
	BufChanelHigh[pShift]=pValue;
	
	// Нижний лучик ---------------------------------------------
	for (int b1=0; b1<200; b1++) 
	{
		if (BufChanelLow[b1] > 0) break;
		
	}
	for (int b2=b1+1; b2<400; b2++) 
	{
		if (BufChanelLow[b2] > 0) break;
	}
	ObjectSet("ZZCR2", OBJPROP_TIME1, Time[b2]);
	ObjectSet("ZZCR2", OBJPROP_PRICE1, Low[b2]);
	ObjectSet("ZZCR2", OBJPROP_TIME2, Time[b1]);
	ObjectSet("ZZCR2", OBJPROP_PRICE2, Low[b1]);
}




