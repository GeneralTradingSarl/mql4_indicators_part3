//+------------------------------------------------------------------+
//|                                       WPRSIsignal(SoundAlarm).mq4|
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link "http://www.metaquotes.net"


#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 DodgerBlue
#property indicator_color2 Red
//---- input parameters
extern int WPRSIperiod=27;
extern int filterUP     =10;
extern int filterDN     =10; 
extern bool UseSound   =false;
//---- buffers
extern string SoundFile  ="Alert.wav";
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double alert;

//----


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0, DRAW_ARROW, 0, 1);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, ExtMapBuffer1);
//----
   SetIndexStyle(1, DRAW_ARROW, 0, 1);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, ExtMapBuffer2);
//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("WPRSI");
   SetIndexLabel(0, "wprsiUP" + WPRSIperiod + "");
   SetIndexLabel(1, "wprsiDN" + WPRSIperiod + "");
//----
  
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
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
   if(counted_bars < 0)
      return(-1);
//---- last counted bar will be recounted
   if(counted_bars > 0)
      counted_bars--;
   limit=Bars - counted_bars;
//----
   for(int i=1; i < limit; i++)
     {
   
      //----
      if( (iWPR(NULL,0,WPRSIperiod,i)>-20)&&(iWPR(NULL,0,WPRSIperiod,i+1)<-20)&&(iRSI(NULL,0,WPRSIperiod,PRICE_MEDIAN,i)>50)           )
         {
         double z=0;
         for(int k=2;k<=filterUP+2;k++)
         {
         
         if(iWPR(NULL,0,WPRSIperiod,k+i)>-20){z=1;  }
         
         }
         
         if(z==0)
         {
         ExtMapBuffer1[i]=Low[i] - (High[i]-Low[i])/2;
               if(i==1&&(alert!=Time[1]))
               {
            if(UseSound){PlaySound(SoundFile);Alert("Start Long");}
            }
               alert=Time[1];

         }

         }



      //----
      if( (iWPR(NULL,0,WPRSIperiod,i+1)>-80)&&(iWPR(NULL,0,WPRSIperiod,i)<-80)&&(iRSI(NULL,0,WPRSIperiod,PRICE_MEDIAN,i)<50)           )

{
         double h=0;
         for(int c=2;c<=filterDN+2;c++)
         {
         
         if(iWPR(NULL,0,WPRSIperiod,c+i)<-80){h=1;  }
         
         }
         
         if(h==0)
         {
         
         ExtMapBuffer2[i]=High[i] +(High[i]-Low[i])/2;
               if(i==1&&(alert!=Time[1]))
               {
              if(UseSound){PlaySound(SoundFile);Alert("Start Short");}
               } 
               alert=Time[1];
         }
}         







     }
//----
   return(0);
  }
//+------------------------------------------------------------------+