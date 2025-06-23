//--  Original Author : yangshu --//
//--  copyright YangShu 2011    --//
//--  Email:yangshu@yangshu.net --//
//--  Web: http://yangshu.net   --//
#property copyright "杨树创于2011年1月9日，2011年6月25日再修改" 
#property link      "http://yangshu.net" 
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1  DeepSkyBlue

#property indicator_level1 15
#property indicator_level2 35
#property indicator_level3 80
#property indicator_levelcolor Gray

#property indicator_minimum 0
#property indicator_maximum 100
extern int TimeWindow=34;
extern int Sensitive=8;
double buf[];
double buf2[];

int init()
  {
   SetIndexBuffer(0,buf);
   ArraySetAsSeries(buf,true);
   SetIndexStyle(0,DRAW_LINE);
   IndicatorShortName("YangTrader (13,21,34,55,89,144) - http://yangshu.net");
   return(0);
  }

int start()
  {
   int limit=Bars;

   ArrayResize(buf2,limit); 
   ArraySetAsSeries(buf2,true);
   for(int i=0; i<limit; i++)
    {
       double HHV=High[iHighest(NULL,0,MODE_HIGH,TimeWindow,i)];
       double LLV=Low[iLowest(NULL,0,MODE_LOW,TimeWindow,i)]; 
       buf2[i]=100*(Close[i]-LLV)/(HHV-LLV);
    }
   ArrayResize(buf,limit); 
   ArraySetAsSeries(buf,true);
   for(i=0; i<limit; i++) buf[i]=iMAOnArray(buf2,limit,Sensitive,0,MODE_LWMA,i);  
   return(0);
  }