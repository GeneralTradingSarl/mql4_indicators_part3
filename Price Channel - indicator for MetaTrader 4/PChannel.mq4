//+------------------------------------------------------------------+
//|                                                     PChannel.mq4 |
//|                                           Copyright © 2005, Xaoc |
//|                                             http://forex.xcd.ru/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, Xaoc"
#property link      "http://forex.xcd.ru/"

#property indicator_chart_window
#property indicator_buffers 2 

#property indicator_color1 Blue 
#property indicator_color2 Red 

double topband[]; 
double botband[]; 

//---- input parameters
extern int       PCPeriod=55;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(2); 
    
   SetIndexBuffer(0,topband); 
   SetIndexStyle(0, DRAW_LINE, EMPTY, 2, Blue); 
   SetIndexDrawBegin(0,2); 
   IndicatorShortName("PChan"); 
   SetIndexLabel(0,"TOPBAND");  
    
   SetIndexBuffer(1,botband); 
   SetIndexStyle(1, DRAW_LINE, EMPTY, 2, Red); 
   SetIndexDrawBegin(1,2); 
   SetIndexLabel(1,"BOTBAND");  
//---- indicators
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- 
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    shift,counted_bars=IndicatorCounted(); 
   double lasthigh=0;
   double lastlow=0;
   //double ma40dbl; 
//---- TODO: add your code here 
   //ma40dbl=iMA(NULL,0,21,0,MODE_SMA,PRICE_CLOSE,0); 

  //---- check for possible errors 
     if(counted_bars<0) return(-1); 
  //---- last counted bar will be recounted 
     if(counted_bars>0) counted_bars--; 
     //limit=Bars-counted_bars; 
  //---- main loop 
//---- main calculation loop 
   shift=Bars-1; 
   while(shift>=0) 
     { 
     topband[shift]=lasthigh;
     botband[shift]=lastlow;
     lasthigh=High[Highest(NULL,0,MODE_HIGH,PCPeriod,shift)];     
     lastlow=Low[Lowest(NULL,0,MODE_LOW,PCPeriod,shift)];
     shift--;//
     }
//---- 
   
//----
   return(0);
  }
//+------------------------------------------------------------------+