//-------------------------------------------------------------------
//                                                TrendLinearReg.mq4
//                                 Copyright © 2008 Sergej Solujanov 
//--------------------------------------------------------------------
#property copyright "Copyright © 2008 Sergej Solujanov"
#property link      "irasol@bk.ru"
#property indicator_separate_window

#property indicator_buffers 2
#property indicator_color1 LimeGreen
#property indicator_color2 Red

extern int barsToCount=34;    // Период 
extern int CountBars = 500;   // Количество баров для прорисовки 

double     buffer0[];
double     buffer1[];
//--------------------------------------------------------------------
int init()
{
   IndicatorShortName(StringConcatenate("TrendLR (",barsToCount,")"));
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,buffer0);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexBuffer(1,buffer1);
   return(0);
}

//--------------------------------------------------------------------
int deinit()
{  
   return(0);
}

//--------------------------------------------------------------------
int start()
{
// 
int     counted_bars = IndicatorCounted(); 
double  a, b, c, sumy, sumx, sumxy, sumx2;
double  prev; 
double  current; 
if(Bars <= CountBars + barsToCount+1) return(0);
int   limit=Bars-counted_bars-1;
if (limit>CountBars) limit=CountBars;

for(int shift = limit; shift >= 0; shift--) 
  {
   sumy=0.0; sumx=0.0; sumxy=0.0; sumx2=0.0;

   for(int i=0; i<barsToCount; i++)
   {
      sumy+=Close[i+shift];
      sumxy+=Close[i+shift]*i;
      sumx+=i;
      sumx2+=i*i;
   }
   
   c=sumx2*barsToCount-sumx*sumx;
 if (c==0) c=0.1;
   b=(sumxy*barsToCount-sumx*sumy)/c;
//   a=(sumy-sumx*b)/barsToCount;
   current=-1000*b; 
   prev=current;

   if ((buffer0[shift+1] !=EMPTY_VALUE) || (buffer1[shift+1] !=EMPTY_VALUE))  
      if (buffer1[shift+1] !=EMPTY_VALUE) prev=buffer1[shift+1]; 
       else prev=buffer0[shift+1];
 
   if (current>=prev)  
       {
        buffer0[shift]= current; 
        buffer1[shift]= EMPTY_VALUE;
       }
   else
   if(current<prev)  
      {
       buffer1[shift]= current; 
       buffer0[shift]= EMPTY_VALUE;     
      }
   }
   return(0);
}

