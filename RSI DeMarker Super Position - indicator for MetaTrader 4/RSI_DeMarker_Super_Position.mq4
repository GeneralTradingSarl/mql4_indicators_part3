//+------------------------------------------------------------------+
//|                                        Cronex Super Position.mq4 |
//|                                        Copyright © 2007, Cronex. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2007, Cronex"
#property  link      "http://www.metaquotes.net/"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 6
#property  indicator_color1  Silver
#property  indicator_color2  DarkOrange
#property  indicator_color3  Black
#property  indicator_color4  Red
#property  indicator_color5  Blue
#property  indicator_color6  SteelBlue

#property indicator_width4 2
#property indicator_width5 2

//-----Level lines   
#property  indicator_level1 -0.20
#property  indicator_level2  0.20
#property  indicator_level3  0.50
#property  indicator_level4  0.80
//---- indicator parameters
extern int RSI=10;
extern int DeMarker=10;
extern int SPStep=4;
extern int FastMA=10;
extern int SlowMA=18;
//---- indicator buffers
double     RSIBuffer[];
double     DeMarkerBuffer[];
double     SPBuffer[];
double     FastMABuffer[];
double     SlowMABuffer[];
double     TmpDiverBuff[];
double     DiverBuffer[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
  IndicatorBuffers(7);
//---- indicator buffers mapping
   SetIndexBuffer(0,RSIBuffer);
   SetIndexBuffer(1,DeMarkerBuffer);
   SetIndexBuffer(2,SPBuffer);
   SetIndexBuffer(3,FastMABuffer);
   SetIndexBuffer(4,SlowMABuffer);
   SetIndexBuffer(5,DiverBuffer);
   SetIndexBuffer(6,TmpDiverBuff);

//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);   
   SetIndexStyle(3,DRAW_LINE,EMPTY,2,Red);
   SetIndexStyle(4,DRAW_LINE,EMPTY,2,Blue);
   SetIndexStyle(5,DRAW_HISTOGRAM);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("RSI DeMarker Super Position");
   SetIndexLabel(0,"RSI Super Position");
   SetIndexLabel(1,"DeMarker Super Position");  
   SetIndexLabel(2,"Cronex Super Position");
   SetIndexLabel(3,"Fast Signal Line");
   SetIndexLabel(4,"Slow Signal Line");
   SetIndexLabel(5,"Super Position Divergence");
   
//   SetIndexShift(3,-2);

//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| Cronex RSI Super Position                                        |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- RSI counted in the 1-st buffer
   for(int i=0; i<limit; i++)
   {
      RSIBuffer[i]=(iRSI(NULL,0,RSI+SPStep*0,PRICE_WEIGHTED,i)+
                    iRSI(NULL,0,RSI+SPStep*1,PRICE_WEIGHTED,i)+
                    iRSI(NULL,0,RSI+SPStep*2,PRICE_WEIGHTED,i)+
                    iRSI(NULL,0,RSI+SPStep*3,PRICE_WEIGHTED,i))/400;
      DeMarkerBuffer[i]=(
                    iDeMarker(NULL,0,DeMarker+SPStep*0,i)+
                    iDeMarker(NULL,0,DeMarker+SPStep*1,i)+
                    iDeMarker(NULL,0,DeMarker+SPStep*2,i)+
                    iDeMarker(NULL,0,DeMarker+SPStep*3,i))/4;
    
      SPBuffer[i]=(RSIBuffer[i]+DeMarkerBuffer[i])/2;
      TmpDiverBuff[i]=DeMarkerBuffer[i]-RSIBuffer[i];
   }
                
//---- signal line counted in the 2-nd buffer
   for(i=0; i<limit; i++)
    {  
      FastMABuffer[i]=iMAOnArray(SPBuffer,Bars,FastMA,0,MODE_LWMA,i);
      SlowMABuffer[i]=iMAOnArray(SPBuffer,Bars,SlowMA,0,MODE_LWMA,i);
      DiverBuffer[i]=iMAOnArray(TmpDiverBuff,Bars,FastMA,0,MODE_LWMA,i)*2;
    } 
//---- done
   return(0);
  }
//+------------------------------------------------------------------+