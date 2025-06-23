//+------------------------------------------------------------------+ 
//|           XAOS PATTERNS EXPLORER                                 | 
//|                                            bY Edward Samokhvalov | 
//|                                             (c) 9.4.2007         | 
//+------------------------------------------------------------------+ 
#property copyright "Edward Samokhvalov"
#property indicator_separate_window
#property indicator_buffers 6
//----
#property indicator_color1 LightBlue
#property indicator_color2 White
#property indicator_color3 White
#property indicator_color4 Black
#property indicator_color5 Tomato
#property indicator_color6 LimeGreen
//#property indicator_level1 1.0010  // I believe playing around with these constants 
//#property indicator_level2 0.999   // can make patterns appear more vivid as well as unvivid. 
//+------------------------------------------------------------------+ 
//| Custom indicator initialization function                         | 
//+------------------------------------------------------------------+ 
extern int Separation=15;
extern int AlarmOn=false;
extern int SHOW_SIGNALS=true;
extern double indicator_lev1 =1.0023;  // I believe playing around with these constants 
extern double indicator_lev2= 0.9979; // can make patterns appear more vivid as well as unvivid. 
//----
double buff2[];
double buff3[];
double buff4[];
double buff1[];
double buy[];
double sell[];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators 
//---- 
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,3);
   SetIndexBuffer(0,buff1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,buff2);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,buff3);
   SetIndexStyle(3,DRAW_LINE);
   SetIndexBuffer(3,buff4);
//----
   SetIndexStyle(4,DRAW_ARROW,0,1);
   SetIndexBuffer(4,buy);
   SetIndexArrow(4,119);
//----
   SetIndexStyle(5,DRAW_ARROW,0,1);
   SetIndexBuffer(5,sell);
   SetIndexArrow(5,119);
   IndicatorShortName(" "+Separation+" ");
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
   int counted_bars=IndicatorCounted();
   if(Bars<=Separation) return(0);
   int pos=0;
   int barsToCount=Bars - counted_bars;
//---- initial zero 
   if(counted_bars<1)
      for(int i=1;i<=Separation;i++)
        {
         buff1[Bars-i]=0.0;
         buff2[Bars-i]=0.0;
         buff3[Bars-i]=0.0;
         buff4[Bars-i]=0.0;
         buy[Bars-i]=0.0;
         sell[Bars-i]=0.0;
        }
//---- 
   pos=Bars-Separation-1;
   if(counted_bars>=Separation) pos=Bars-counted_bars-1;
   while(pos>=0)
     {
      buff1[pos]=Close[pos+Separation]/Close[pos];
      buff2[pos]=indicator_lev1;//Open[pos+Separation]/Open[pos]; 
      buff3[pos]=indicator_lev2;//High[pos+Separation]/High[pos]; 
      buff4[pos]=Low[pos+Separation]/Low[pos];
      if (SHOW_SIGNALS==true)
        {
         // SELL SIGNAL 
         if (buff1[pos] > indicator_lev1)
           {
            buy[pos]=buff1[pos];
            sig("["+TimeToStr(CurTime())+"] " + Symbol() + ": BUY!)",pos);
           }
         else if (buff2[pos] > indicator_lev1)
              {
               buy[pos]=buff2[pos];
               sig("["+TimeToStr(CurTime())+"] " + Symbol() + ": BUY!)",pos);
              }
            else if(buff3[pos] > indicator_lev1)
                 {
                  buy[pos]= buff3[pos];
                  sig("["+TimeToStr(CurTime())+"] " + Symbol() + ": BUY!)",pos);
                 }
               else if (buff4[pos] > indicator_lev1)
                    {
                     buy[pos]=buff4[pos];
                     sig("["+TimeToStr(CurTime())+"] " + Symbol() + ": BUY!)",pos);
                    }
         // BUY SIGNAL 
                  else if (buff1[pos] < indicator_lev2)
                       {
                        sell[pos]=buff1[pos];
                        sig("["+TimeToStr(CurTime())+"] " + Symbol() + ": SELL!)",pos);
                       }
                     else if (buff2[pos] < indicator_lev2)
                          {
                           sell[pos]=buff2[pos];
                           sig("["+TimeToStr(CurTime())+"] " + Symbol() + ": SELL!)",pos);
                          }
                        else if(buff3[pos] < indicator_lev2)
                             {
                              sell[pos]= buff3[pos];
                              sig("["+TimeToStr(CurTime())+"] " + Symbol() + ": SELL!)",pos);
                             }
                           else if (buff4[pos] < indicator_lev2)
                                {
                                 sell[pos]=buff4[pos];
                                 sig("["+TimeToStr(CurTime())+"] " + Symbol() + ": SELL!)",pos);
                                }
        }
      pos--;
     }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void sig(string msg, int p)
  {
   if (AlarmOn==true && TimeToStr(Time[p])==TimeToStr(CurTime()))Alert(msg);
  }
//+------------------------------------------------------------------+  

