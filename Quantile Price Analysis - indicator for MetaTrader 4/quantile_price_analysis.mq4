//+------------------------------------------------------------------+
//|                                      Quantile Price Analysis.mq4 |
//|                                                           Jas Wu |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property description "Quantile Price Analysis"
#property description "Indicator Made By Jas Wu"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 8

extern int Main = 30; //Look Back Period
extern int UpQ = 40; //Down Quant %
extern int DnQ = 60; //Up Quant %
enum PriceOption {
Closed = 1,//Closed Price
HighLow = 2,//High and Low
};
extern PriceOption Mode = Closed;

double DnQuantile[], UpQuantile[], MidQuantile[], UpQuant[], DnQuant[], CPrice[], Up[], Chop[], Dn[];
double trueUP, trueDN, trueMID;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
 ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,true);
 IndicatorShortName("Quantile Price Analysis");
 IndicatorBuffers(8);
 
   SetIndexStyle(0,DRAW_HISTOGRAM, STYLE_SOLID, 5, clrLime); 
   SetIndexBuffer(0,UpQuant);
   SetIndexLabel(0, "UpQant");
   
   SetIndexStyle(1,DRAW_HISTOGRAM, STYLE_SOLID, 4, clrPaleVioletRed);
   SetIndexBuffer(1,DnQuant);
   SetIndexLabel(1, "DnQuant");
   
   SetIndexStyle(2,DRAW_NONE);
   SetIndexBuffer(2,UpQuantile);
   SetIndexLabel(2, "UpQuantile");
   
   SetIndexStyle(3,DRAW_NONE);
   SetIndexBuffer(3,MidQuantile);
   SetIndexLabel(3, "MidQuantile");   
   
   SetIndexStyle(4,DRAW_NONE);
   SetIndexBuffer(4,DnQuantile);
   SetIndexLabel(4, "DnQuantile"); 
   
   SetIndexBuffer(5,Dn); 
   SetIndexStyle(5,DRAW_ARROW, STYLE_SOLID, 1, clrOrangeRed);
   SetIndexArrow(5, 110);
   SetIndexLabel(5, "Dn");     
   
   SetIndexBuffer(6,Up); 
   SetIndexStyle(6,DRAW_ARROW, STYLE_SOLID, 1, clrLime);
   SetIndexArrow(6, 110);
   SetIndexLabel(6, "Up"); 
   
   SetIndexBuffer(7,Chop); 
   SetIndexStyle(7,DRAW_ARROW, STYLE_SOLID, 1, clrGray);
   SetIndexArrow(7, 110);
   SetIndexLabel(7, "Chop");        
   
   trueUP = (double)Main*((double)UpQ*0.01);
   trueDN = (double)Main*((double)DnQ*0.01);
   trueMID = (double)Main/2;
   ArrayResize(CPrice, Main);   
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
 int ExtCountedBars=IndicatorCounted();
 if (ExtCountedBars<0) return(-1);
 int pos;
 int limit=Bars-Main-1;
 if(ExtCountedBars>2) limit=Bars-ExtCountedBars-1;
 pos=limit;   
   
      for(int t=0; t<=limit; t++)
      {  
         for(int p=0; p<Main; p++)
         {
            CPrice[p] = Close[t+p];
         }  
         ArraySort(CPrice, WHOLE_ARRAY, 0, MODE_DESCEND);
         UpQuantile[t] = CPrice[(int)trueUP];
         DnQuantile[t] = CPrice[(int)trueDN];
         MidQuantile[t] = CPrice[(int)trueMID];
      } 
      
    if(Mode == Closed)
    {  
      for(int t=0; t<=limit; t++)
      {  
         DnQuant[t] = Close[t]-UpQuantile[t];
         UpQuant[t] = Close[t]-DnQuantile[t];
      }
    }
    
    if(Mode == HighLow)
    {  
      for(int t=0; t<=limit; t++)
      {  
         DnQuant[t] = High[t]-UpQuantile[t];
         UpQuant[t] = Low[t]-DnQuantile[t];
      }
    }    
    
      for(int t=0; t<=limit; t++)
      { 
         if(UpQuant[t] > 0 && DnQuant[t] < 0) Chop[t] = 0;
         if(UpQuant[t] < 0 && DnQuant[t] > 0) Chop[t] = 0;  
         if(UpQuant[t] > 0 && DnQuant[t] > 0)
         {
            Up[t] = 0;
            Dn[t] = EMPTY_VALUE;
            Chop[t] = EMPTY_VALUE;
         }   
         if(UpQuant[t] < 0 && DnQuant[t] < 0)
         {
            Dn[t] = 0;
            Up[t] = EMPTY_VALUE;
            Chop[t] = EMPTY_VALUE;
         }
         if(UpQuant[t] == 0 || DnQuant[t] == 0) 
         {
            Up[t] = EMPTY_VALUE;
            Dn[t] = EMPTY_VALUE;            
            Chop[t] = 0; 
         }              
      }        
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
   
  }
//+------------------------------------------------------------------+
