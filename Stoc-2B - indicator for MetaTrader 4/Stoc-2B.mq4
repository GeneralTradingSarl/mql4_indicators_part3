/*------------------------------------------------------------------+
 |                                                      Stoc-2B.mq4 |
 |                                                 Copyright © 2011 |
 |                                             basisforex@gmail.com |
 +------------------------------------------------------------------*/
#property copyright "Copyright © 2011, basisforex@gmail.com"
#property link      "basisforex@gmail.com"
//----------------------------------------
#property indicator_separate_window
#property indicator_buffers 8
#property indicator_color1 White
#property indicator_color2 Red
#property indicator_color3 Yellow
#property indicator_color4 Red
#property indicator_color5 Green
#property indicator_color6 Red
#property indicator_color7 Blue
#property indicator_color8 Red
//-------------------------------------
extern bool       TimeFrame2     = true;
extern bool       TimeFrame3     = true;
extern bool       TimeFrame4     = true;
//-----
extern int        KPeriod        = 5;
extern int        DPeriod        = 3;
extern int        Slowing        = 3;
//-----
double s1[];
double s2[];
double s3[];
double s4[];
double s5[];
double s6[];
double s7[];
double s8[];
//+------------------------------------------------------------------+
int init()
 {
   SetIndexBuffer(0, s1);
   SetIndexBuffer(1, s2);
   SetIndexBuffer(2, s3);
   SetIndexBuffer(3, s4);
   SetIndexBuffer(4, s5);
   SetIndexBuffer(5, s6);
   SetIndexBuffer(6, s7);
   SetIndexBuffer(7, s8);
   //-----
   SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE, STYLE_DOT);
   SetIndexStyle(2, DRAW_LINE);
   SetIndexStyle(3, DRAW_LINE, STYLE_DOT);
   SetIndexStyle(4, DRAW_LINE);
   SetIndexStyle(5, DRAW_LINE, STYLE_DOT);
   SetIndexStyle(6, DRAW_LINE);
   SetIndexStyle(7, DRAW_LINE, STYLE_DOT);
   //-----
   return(0);
 }
//+------------------------------------------------------------------+
string GetNextTF(int curTF)
 {
   switch(curTF)
    {
      case 1:
        return("5=15#30");
        break;
      case 5:
        return("15=30#60");
        break; 
      case 15:
        return("30=60#240");
        break;
      case 30:
        return("60=240#1440");
        break;
      case 60:
        return("240=1440#10080");
        break;
      case 240:
        return("1440=10080#43200");
        break;        
    }
 }
//+------------------------------------------------------------------+ 
int start()
 {
   int limit;
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0) return(-1);
   if(counted_bars > 0) counted_bars--;
   limit = Bars - counted_bars;
   //-----
   string T = GetNextTF(Period());
   int tf2 = StrToDouble(StringSubstr(T, 0, StringFind(T, "=", 0)));
   int tf3 = StrToDouble(StringSubstr(T, StringFind(T, "=", 0) + 1, StringFind(T, "#", 0)));
   int tf4 = StrToDouble(StringSubstr(T, StringFind(T, "#", 0) + 1, StringLen(T)));
   //-----
   for(int i = limit - 1; i >= 0; i--)
    {
         //===============================================         __________________________________________________   st1  &  st2  &  st3  & st4
         if(TimeFrame2 == true && TimeFrame3 == true && TimeFrame4 == true)
          {
            Comment(Period(), " White", "\n", tf2, " Yellow", "\n", tf3, " Green", "\n", tf4, " Blue");
            s1[i]  = iStochastic(NULL, 0, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i);
            s2[i]  = iStochastic(NULL, 0, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_SIGNAL, i);
            if (tf2>0) s3[i]  = iStochastic(NULL, tf2, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i / (tf2 / Period()));
            if (tf3>0) s5[i]  = iStochastic(NULL, tf3, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i / (tf3 / Period()));
            if (tf4>0) s7[i]  = iStochastic(NULL, tf4, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i / (tf4 / Period()));
            
          }
          //===============================================         __________________________________________________   st1  &  st2  &  st3   
         else if(TimeFrame2 == true && TimeFrame3 == true && TimeFrame4 == false)
          {     
            Comment(Period(), " White", "\n", tf2, " Yellow", "\n", tf3, " Green");
            s1[i]  = iStochastic(NULL, 0, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i);
            s2[i]  = iStochastic(NULL, 0, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_SIGNAL, i);
            s3[i]  = iStochastic(NULL, tf2, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i / (tf2 / Period()));
            s5[i]  = iStochastic(NULL, tf3, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i / (tf3 / Period()));
          }
         //===============================================         __________________________________________________   st1  &  st2  &  st4    
         else if(TimeFrame2 == true && TimeFrame3 == false && TimeFrame4 == true)
          {     
            Comment(Period(), " White", "\n", tf2, " Yellow", "\n", tf4, " Blue");
            s1[i]  = iStochastic(NULL, Period(), KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i);
            s2[i]  = iStochastic(NULL, Period(), KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_SIGNAL, i);
            s3[i]  = iStochastic(NULL, tf2, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i / (tf2 / Period()));            
            s7[i]  = iStochastic(NULL, tf4, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i / (tf4 / Period()));
          }
         //===============================================         __________________________________________________   st1  &  st3  &  st4    
         else if(TimeFrame2 == false && TimeFrame3 == true && TimeFrame4 == true)
          {     
            Comment(Period(), " White", "\n", tf3, " Green", "\n", tf4, " Blue");
            s1[i]  = iStochastic(NULL, Period(), KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i);
            s2[i]  = iStochastic(NULL, Period(), KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_SIGNAL, i);
            s5[i]  = iStochastic(NULL, tf3, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i / (tf3 / Period()));
            s7[i]  = iStochastic(NULL, tf4, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i / (tf4 / Period()));
          } 
         //===============================================         __________________________________________________   st1  &  st2    
         else if(TimeFrame2 == true && TimeFrame3 == false && TimeFrame4 == false)
          {     
            Comment(Period(), " White", "\n", tf2, " Yellow");
            s1[i]  = iStochastic(NULL, Period(), KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i);
            s2[i]  = iStochastic(NULL, Period(), KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_SIGNAL, i);
            s3[i]  = iStochastic(NULL, tf2, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i / (tf2 / Period()));
            s4[i]  = iStochastic(NULL, tf2, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_SIGNAL, i/ (tf2 / Period()));
          } 
         //===============================================         __________________________________________________   st1  &  st3    
         else if(TimeFrame2 == false && TimeFrame3 == true && TimeFrame4 == false)
          {     
            Comment(Period(), " White", "\n", tf3, " Green");
            s1[i]  = iStochastic(NULL, Period(), KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i);
            s2[i]  = iStochastic(NULL, Period(), KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_SIGNAL, i);
            s5[i]  = iStochastic(NULL, tf3, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i / (tf3 / Period()));
            s6[i]  = iStochastic(NULL, tf3, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_SIGNAL, i/ (tf3 / Period()));
          } 
         //===============================================         __________________________________________________   st1  &  st4    
         else if(TimeFrame2 == false && TimeFrame3 == false && TimeFrame4 == true)
          {     
            Comment(Period(), " White", "\n", tf4, " Blue");
            s1[i]  = iStochastic(NULL, 0, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i);
            s2[i]  = iStochastic(NULL, 0, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_SIGNAL, i);
            s7[i]  = iStochastic(NULL, tf4, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i / (tf4 / Period()));
            s8[i]  = iStochastic(NULL, tf4, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_SIGNAL, i/ (tf4 / Period()));
          }
         //===============================================          __________________________________________________   st1
         else if(TimeFrame2 == false && TimeFrame3 == false && TimeFrame4 == false)
          {
            Comment(Period(), " White");
             s1[i]  = iStochastic(NULL, 0, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_MAIN, i);
             s2[i]  = iStochastic(NULL, 0, KPeriod, DPeriod, Slowing, MODE_SMA,0,MODE_SIGNAL, i);
          }        
    }  
   //==============================================================================================================================================
   return(0);
 }

