//+------------------------------------------------------------------+
//|                                                    RunMedian.mq4 |
//|                                     Copyright © 2012, HindmostFr |
//|                                              http://hindmost.fr/ |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2012, HindmostFr http://hindmost.fr/"
#property  link      "http://hindmost.fr/"

/*
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.
 
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/licenses/.
*/

#include <stdlib.mqh>
// indicator settings
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 White

// indicator parameters
extern int period=13;
extern string comment="period must be odd - or +1 will be added";

// indicator buffers
double Median[];

void runmedian(int limit) {
   double tab[];
   int i,cursor,count,oldpos,sortedpos;
   double value, oldvalue;
      
   ArrayResize(tab,period);
   count=0;
   for (cursor=limit;cursor>=0;cursor--) {
        value=(High[cursor]+Low[cursor])/2;
        if (count<period) {

            // Initial median (slow)
            tab[count]=value;
            if (count==(period-1)) {
               ArraySort(tab);
               Median[cursor]=tab[(period-1)/2];
            }
        } else {
        
           // Incremental algorithm (fast)

           // Remove old value
           oldpos=cursor+period;
	        oldvalue=(High[oldpos]+Low[oldpos])/2;
	        sortedpos=ArrayBsearch(tab,oldvalue);
           for (i=sortedpos;i<(period-1);i++) tab[i]=tab[i+1];
           tab[period-1]=EMPTY_VALUE;

           // Add new value at the right sorted place
	        sortedpos=ArrayBsearch(tab,value);
	        if (tab[sortedpos]<value) sortedpos++;
           for (i=period-1;i>sortedpos;i--) tab[i]=tab[i-1];
           tab[sortedpos]=value;
           
           // tab is now sorted
           Median[cursor]=tab[(period-1)/2];
        }
        count++;
   }
}

int init()
{
   if (MathMod(period,2)==0) period=period+1;

   IndicatorBuffers(1);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,Median);
   SetIndexLabel(0,"Median ("+DoubleToStr(period,0)+")");

   return(0);
}
   
int deinit()
{
   return(0); 
}

int start()
{
   int counted_bars=IndicatorCounted();
// last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit--;
// function call
   runmedian(limit);

//  done
   return(0);   
}   