//+------------------------------------------------------------------+
//|                 This has been coded by MT-Coder                  |
//|                                                                  |
//|                     Email: mt-coder@hotmail.com                  |
//|                      Website: mt-coder.110mb.com                 |
//|                                                                  |
//| For a price I can code for you any strategy you have in mind     |
//|            into EA, I can code any indicator you have in mind    |
//|                                                                  |
//|          Don't hesitate to contact me at mt-coder@hotmail.com    |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|        This indicator shows the interaction between price open   |
//|        and the market volume                                     |
//+------------------------------------------------------------------+


#property copyright "Copyright © 2009, MT-Coder."
#property link      "http://mt-coder.110mb.com/"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 LimeGreen


//---- input parameters
extern int SVPeriod=100;
//---- buffers
double Buffer[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
   //---- 1 additional buffer used for counting.
   IndicatorBuffers(1);
   //IndicatorDigits(Digits);
//---- indicator line
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,Buffer);
  
   
//---- name for DataWindow and indicator subwindow label
   short_name="Simple Volume - -by MT-Coder@hotmail.com";
   IndicatorShortName(short_name);
   SetIndexLabel(0,"Simple Volume");
  
//----
   SetIndexDrawBegin(0,SVPeriod);


//----
   return(0);
  }
//+------------------------------------------------------------------+
//| FAC low n high                                                   |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
//----
   if(Bars<SVPeriod) return(0);

//----
   i=Bars-SVPeriod-1;
   if(counted_bars>SVPeriod) i=Bars-counted_bars-1;
   while(i>0)
     {
     
Buffer[i] = Open[i] * Volume[i] ;


      
      i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+