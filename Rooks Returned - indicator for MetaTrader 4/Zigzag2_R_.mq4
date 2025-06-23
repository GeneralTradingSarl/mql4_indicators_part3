//+------------------------------------------------------------------+
//|                                                   Zigzag2_R_.mq4 |
//|                 Copyright © 2005-2007, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
/* В стандартном индикаторе http://codebase.mql4.com/ru/238 для      |
рисования использовался стиль DRAW_SECTION. Этот стиль позволяет     |
рисовать отрезками только между точками, находящимимся на разных     |
барах. Стиль отрисовки DRAW_ZIGZAG позволяет снять это ограничение,  |
для этого используются два буфера вместо одного. Для иллюстрации     |
этого стиля и был написан Zigzag2_R_.mq4.                            |
В код добавлена обработка внешнего  бара (outside bar), когда  High  |
текущего бара выше предыдущих, а Low текущего бара ниже предыдущих.  |
Код также демонстрирует, что цвет определяется цветом первого из     |
двух буферов.                                                        |
#property indicator_chart_window                                     |
#property indicator_buffers 2                                        |
#property indicator_color1 Blue                                      |
#property indicator_color2 Red                                       |
Для вызова этого индикатора из других программ на mql4 теперь        |
необходимо использовать две конструкции:                             |
iCustom(NULL, 0, "Zigzag2_R_", 12, 5, 3, 0, index) - пички           |
iCustom(NULL, 0, "Zigzag2_R_", 12, 5, 3, 1, index) - донышки         |
Блок обработки внешнего бара дан как пример. Вы можете использовать  |
свой алгоритм для такой ситуации.                                    |
//+------------------------------------------------------------------+
*/
#property copyright "Copyright © 2007, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"
//----
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
//---- indicator parameters
extern int ExtDepth = 12;
extern int ExtDeviation = 5;
extern int ExtBackstep = 3;
//---- indicator buffers
double ZigzagPeakBuffer[];
double ZigzagLawnBuffer[];
double HighMapBuffer[];
double LowMapBuffer[];
int level = 3; // recounting's depth 
bool downloadhistory = false;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(4);
//---- drawing settings
   SetIndexStyle(0, DRAW_ZIGZAG);
   SetIndexStyle(1, DRAW_ZIGZAG);
//---- indicator buffers mapping
   SetIndexBuffer(0, ZigzagPeakBuffer);
   SetIndexBuffer(1, ZigzagLawnBuffer);
   SetIndexLabel(0, "ZigzafPeak");
   SetIndexLabel(1, "ZigzafLawn");
//----
   SetIndexBuffer(2, HighMapBuffer);
   SetIndexBuffer(3, LowMapBuffer);
//----
   SetIndexEmptyValue(0, 0.0);
   SetIndexEmptyValue(1, 0.0);
//---- indicator short name
   IndicatorShortName("ZigZag(" + ExtDepth + "," + ExtDeviation + "," + 
                      ExtBackstep + ")");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int i, counted_bars = IndicatorCounted();
   int limit, counterZ, whatlookfor;
   int shift, back, lasthighpos, lastlowpos;
   double val, res;
   double curlow, curhigh, lasthigh, lastlow;
// history was downloaded
   if(counted_bars == 0 && downloadhistory) 
     {
       ArrayInitialize(ZigzagPeakBuffer, 0.0);
       ArrayInitialize(ZigzagLawnBuffer, 0.0);
       ArrayInitialize(HighMapBuffer, 0.0);
       ArrayInitialize(LowMapBuffer, 0.0);
     }
//----
   if(counted_bars == 0) 
     {
       limit = Bars - ExtDepth;
       downloadhistory = true;
     }
//----
   if(counted_bars > 0) 
     {
       //----
       while(counterZ < level && i < 100)
         {
           res = (ZigzagPeakBuffer[i] + ZigzagLawnBuffer[i]);
           //----
           if(res != 0) 
               counterZ++;
           i++;
         }
       i--;
       limit = i;
       //----
       if(LowMapBuffer[i] != 0) 
         {
           curlow = LowMapBuffer[i];
           whatlookfor = 1;
         }
       else
         {
           curhigh = HighMapBuffer[i];
           whatlookfor = -1;
         }
       //----
       for(i = limit - 1; i >= 0; i--)  
         {
           ZigzagPeakBuffer[i] = 0.0;  
           ZigzagLawnBuffer[i] = 0.0;  
           LowMapBuffer[i] = 0.0;
           HighMapBuffer[i] = 0.0;
         }
     } 
//----
   for(shift = limit; shift >= 0; shift--)
     {
       val = Low[iLowest(NULL, 0, MODE_LOW, ExtDepth, shift)];
       //----
       if(val == lastlow) 
           val = 0.0;
       else 
         { 
           lastlow = val; 
           //----
           if((Low[shift] - val) > (ExtDeviation*Point)) 
               val = 0.0;
           else
             {
               //----
               for(back = 1; back <= ExtBackstep; back++)
                 {
                   res = LowMapBuffer[shift+back];
                   //----
                   if((res != 0) && (res > val)) 
                       LowMapBuffer[shift+back] = 0.0; 
                 }
             }
         } 
       //----
       if(Low[shift] == val) 
           LowMapBuffer[shift] = val; 
       else 
           LowMapBuffer[shift] = 0.0;
       //--- high
       val = High[iHighest(NULL, 0, MODE_HIGH, ExtDepth, shift)];
       //----
       if(val == lasthigh) 
           val = 0.0;
       else 
         {
           lasthigh = val;
           //----
           if((val - High[shift]) > (ExtDeviation*Point)) 
               val = 0.0;
           else
             {
               //----
               for(back = 1; back <= ExtBackstep; back++)
                 {
                   res = HighMapBuffer[shift+back];
                   //----
                   if((res != 0) && (res < val)) 
                       HighMapBuffer[shift+back] = 0.0; 
                 } 
             }
         }
       //----
       if(High[shift] == val) 
           HighMapBuffer[shift] = val; 
       else 
           HighMapBuffer[shift] = 0.0;
     }
// final cutting 
   if(whatlookfor == 0)
     {
       lastlow = 0;
       lasthigh = 0;  
     }
   else
     {
       lastlow = curlow;
       lasthigh = curhigh;
     }
//----
   for(shift = limit; shift >= 0; shift--)
     {
       res = 0.0;
       switch(whatlookfor)
         {
           // look for peak or lawn 
           case 0: if(lastlow == 0 && lasthigh == 0)
                     {
                       if(HighMapBuffer[shift] != 0)
                         {
                           lasthigh = High[shift];
                           lasthighpos = shift;
                           whatlookfor = -1;
                           ZigzagPeakBuffer[shift] = lasthigh;
                           res = 1;
                         }
                       if(LowMapBuffer[shift] != 0)
                         {
                           lastlow = Low[shift];
                           lastlowpos = shift;
                           whatlookfor = 1;
                           ZigzagLawnBuffer[shift] = lastlow;
                           res = 1;
                         }
                     }
                   break;  
           // look for peak
           case 1: if(LowMapBuffer[shift] != 0.0 && LowMapBuffer[shift] < lastlow &&
                      HighMapBuffer[shift] == 0.0)
                     {
                       ZigzagLawnBuffer[lastlowpos] = 0.0;
                       lastlowpos = shift;
                       lastlow = LowMapBuffer[shift];
                       ZigzagLawnBuffer[shift] = lastlow;
                       res = 1;
                     }
                   if(HighMapBuffer[shift] != 0.0 && LowMapBuffer[shift] == 0.0)
                     {
                       lasthigh = HighMapBuffer[shift];
                       lasthighpos = shift;
                       ZigzagPeakBuffer[shift] = lasthigh;
                       whatlookfor = -1;
                       res = 1;
                     }   
                   break;               
           // look for lawn
           case -1:  if(HighMapBuffer[shift] != 0.0 && 
                        HighMapBuffer[shift] > lasthigh && 
                        LowMapBuffer[shift] == 0.0)
                       {
                         ZigzagPeakBuffer[lasthighpos] = 0.0;
                         lasthighpos = shift;
                         lasthigh = HighMapBuffer[shift];
                         ZigzagPeakBuffer[shift] = lasthigh;
                       }
                     if(LowMapBuffer[shift] != 0.0 && HighMapBuffer[shift] == 0.0)
                       {
                         lastlow = LowMapBuffer[shift];
                         lastlowpos = shift;
                         ZigzagLawnBuffer[shift] = lastlow;
                         whatlookfor = 1;
                       }   
                     break;               
           default: return; 
         }
     }

//--------------------------   
//----
   return(0);
  }
//+------------------------------------------------------------------+