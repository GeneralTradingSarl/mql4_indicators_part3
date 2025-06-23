//+------------------------------------------------------------------+
//|                                          Brooky_USD_Strength.mq4 |
//|                                          Copyright © 2010,Brooky |
//|                               http://forex-indicators.weebly.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010,Brooky"
#property link      "http://forex-indicators.weebly.com"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 C'47,47,47'
#property indicator_color2 DodgerBlue
#property indicator_width1 1
#property indicator_width2 2
#property indicator_level1 0
#property indicator_maximum 10
#property indicator_minimum -10

extern string Author_Site = "Forex-Indicators.weebly.com";
extern string Major_USD = "Usd as Major 3 Pairs";
extern string maj_pair1 = "USDCHF";
extern string maj_pair2 = "USDJPY";
extern string maj_pair3 = "USDCAD";
extern string Minor_USD = "Usd as Minor 4 Pairs";
extern string min_pair1 = "AUDUSD";
extern string min_pair2 = "EURUSD";
extern string min_pair3 = "GBPUSD";
extern string min_pair4 = "NZDUSD";
extern string Checking_MAs = "Fast v Slow Checks";
extern int slow_check_ma = 55;
extern int fast_check_ma = 34;
extern string Data_Smoothie = "Smoothing Line";
extern int sig_smooth = 15;
extern string Checking_TF = "Timeframe 0 is current";
extern int check_tf = 0;
//--string to call for iCustom--+
//double val=iCustom(NULL, 0, "Brooky_USD_Strength",".",".","USDCHF","USDJPY","USDCAD",".","AUDUSD","EURUSD","GBPUSD","NZDUSD",".",55,34,".",15,".",0,1,0);

//---- buffers
double data_buffer[];
double sig_buffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators


   SetIndexBuffer(0,data_buffer);SetIndexStyle(0,DRAW_LINE);
   
   SetIndexStyle(1,DRAW_LINE);SetIndexBuffer(1,sig_buffer);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("forex-indicators.weebly.com "
                       +"(USD Strength Effect)"
                        );   

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
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
     int limit;
     int counted_bars=IndicatorCounted();
  //---- check for possible errors
     if(counted_bars<0) return(-1);
  //---- the last counted bar will be recounted
     if(counted_bars>0) counted_bars--;
     limit=Bars-counted_bars;
  //---- main loop
     for(int i=0; i<limit; i++)
       {
      int c1=0,c2=0,c3=0,c4=0,c5=0,c6=0,c7=0;
      double multiplier = -1.4285714285714285714285714285714;
  //-- USD Majors --+          
      //--Pair 1--+
      if(iMA(maj_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(maj_pair1,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(maj_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(maj_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c1=1 ;
      if(iMA(maj_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(maj_pair1,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(maj_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(maj_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c1=0.5 ;           
           
      if(iMA(maj_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(maj_pair1,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(maj_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(maj_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c1=-1 ;

      if(iMA(maj_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(maj_pair1,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(maj_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(maj_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c1=-0.5 ;
                      
      if(iMA(maj_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         ==iMA(maj_pair1,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i))
           c1=0 ;
           
      //--Pair 2--+
      if(iMA(maj_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(maj_pair2,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(maj_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(maj_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c2=1 ;
      if(iMA(maj_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(maj_pair2,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(maj_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(maj_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c2=0.5 ;           
           
      if(iMA(maj_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(maj_pair2,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(maj_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(maj_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c2=-1 ;
           
      if(iMA(maj_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(maj_pair2,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(maj_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(maj_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c2=-0.5 ;
           
                      
      if(iMA(maj_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         ==iMA(maj_pair2,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i))
           c2=0 ; 
               
      //--Pair 3--+
      if(iMA(maj_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(maj_pair3,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(maj_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(maj_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c3=1 ;
      if(iMA(maj_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(maj_pair3,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(maj_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(maj_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c3=0.5 ;
                      
      if(iMA(maj_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(maj_pair3,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(maj_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(maj_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c3=-1 ;
      if(iMA(maj_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(maj_pair3,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(maj_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(maj_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c3=-0.5 ;
                      
      if(iMA(maj_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         ==iMA(maj_pair3,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i))
           c3=0 ; 
           
 //-- USD Minors --+          
      //--Pair 4--+
      if(iMA(min_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(min_pair1,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(min_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(min_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c4=-1 ;
      if(iMA(min_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(min_pair1,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(min_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(min_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c4=-0.5 ;
                      
      if(iMA(min_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(min_pair1,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(min_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(min_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c4=1 ;
      if(iMA(min_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(min_pair1,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(min_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(min_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c4=0.5 ;
                      
      if(iMA(min_pair1,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         ==iMA(min_pair1,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i))
           c4=0 ; 
           
      //--Pair 5--+
      if(iMA(min_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(min_pair2,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(min_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(min_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c5=-1 ;
      if(iMA(min_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(min_pair2,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(min_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(min_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c5=-0.5 ;          
      if(iMA(min_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(min_pair2,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(min_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(min_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c5=1 ;
      if(iMA(min_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(min_pair2,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(min_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(min_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c5=0.5 ;           
      if(iMA(min_pair2,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         ==iMA(min_pair2,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i))
           c5=0 ;    
           
      //--Pair 6--+
      if(iMA(min_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(min_pair3,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(min_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(min_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c6=-1 ;
      if(iMA(min_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(min_pair3,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(min_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(min_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c6=-0.5 ;           
      if(iMA(min_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(min_pair3,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(min_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(min_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c6=1 ;
      if(iMA(min_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(min_pair3,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(min_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(min_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c6=0.5 ;           
      if(iMA(min_pair3,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         ==iMA(min_pair3,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i))
           c6=0 ;  
           
      //--Pair 7--+
      if(iMA(min_pair4,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(min_pair4,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(min_pair4,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(min_pair4,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c7=-1 ;
      if(iMA(min_pair4,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(min_pair4,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(min_pair4,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(min_pair4,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c7=-0.5 ;
      if(iMA(min_pair4,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(min_pair4,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(min_pair4,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(min_pair4,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c7=1 ;
      if(iMA(min_pair4,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         <iMA(min_pair4,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         && iMA(min_pair4,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         >iMA(min_pair4,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i+1))
           c7=0.5 ;
      if(iMA(min_pair4,check_tf,fast_check_ma,0,MODE_LWMA,PRICE_CLOSE,i)
         ==iMA(min_pair4,check_tf,slow_check_ma,0,MODE_LWMA,PRICE_CLOSE,i))
           c7=0 ;   
       
      data_buffer[i]=(c1+c2+c3+c4+c5+c6+c7)*multiplier;
      
             
       }
            for(i=0; i<limit; i++)
       {
      sig_buffer[i]=iMAOnArray(data_buffer,0,sig_smooth,0,MODE_LWMA,i);
       Comment("Level (",sig_buffer[i]);
       }
  //---- done
     return(0);
    }
//+------------------------------------------------------------------+