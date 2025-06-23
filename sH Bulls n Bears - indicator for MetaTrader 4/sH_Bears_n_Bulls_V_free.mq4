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
//|        This indicator shows both powers of the Bull and Bear     |
//|            the market volume excluded                            |
//+------------------------------------------------------------------+


#property copyright "Copyright © 2009, MT-Coder."
#property link      "http://mt-coder.110mb.com/"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 DodgerBlue
#property indicator_color2 DarkOrange


//---- input parameters
int sHPeriod=100;
//---- buffers
double BullsBuffer[];
double BearsBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   string short_name;
   //---- 1 additional buffer used for counting.
   IndicatorBuffers(2);
   IndicatorDigits(Digits);
//---- indicator line
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,BullsBuffer);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexBuffer(1,BearsBuffer);
  
   
//---- name for DataWindow and indicator subwindow label
   short_name="Bears n Bulls V free - by MT-Coder@hotmail.com" ;
   IndicatorShortName(short_name);
   SetIndexLabel(0,"Bulls");
   SetIndexLabel(1,"Bears");

  
//----
   SetIndexDrawBegin(0,sHPeriod);


//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                 |
//+------------------------------------------------------------------+
int start()
  {
   int i,counted_bars=IndicatorCounted();
//----
   if(Bars<=sHPeriod) return(0);
//---- initial zero
   if(counted_bars<1)
      for(i=1;i<=sHPeriod;i++) BullsBuffer[Bars-i]=0.0;
//----
//----


//----
   i=Bars-sHPeriod-1;
   if(counted_bars>=sHPeriod) i=Bars-counted_bars-1;
   while(i>=1)
     {

if(Close[i]>Open[i])
{
BullsBuffer[i] = (High[i]-Open[i])/Volume[i];
BearsBuffer[i] = (Close[i] - High[i] + Low[i] - Open[i])/Volume[i];

}

if(Close[i]<Open[i])
{
BullsBuffer[i] = (High[i]-Open[i] + Close[i] - Low[i])/Volume[i];
BearsBuffer[i] = (Low[i] - Open[i])/Volume[i];
}      
      i--;
     }
   return(0);
  }
//+------------------------------------------------------------------+