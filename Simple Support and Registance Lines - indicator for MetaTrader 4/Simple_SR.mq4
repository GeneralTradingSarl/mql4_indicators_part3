//+------------------------------------------------------------------+
//|                                                    Simple_SR.mq4 |
//|                                        Copyright © 2013, Isotope |
//|                                    https://twitter.com/IsotopeFX |
//+------------------------------------------------------------------+

#property indicator_chart_window
#property indicator_buffers 2
 
extern int Per=1;
 
double Registance[],
       Support[];
       
extern int    Rwid = 2,
              Swid = 2,
              Rstyl = 2,
              Sstyl = 2;
extern color  Rcol = DodgerBlue,
              Scol = Tomato;

int init()
  {
   SetIndexBuffer(0, Registance);
   SetIndexBuffer(1, Support);
   
   SetIndexStyle(0,DRAW_NONE);
   SetIndexStyle(1,DRAW_NONE);
   
   SetIndexLabel(0,NULL); 
   SetIndexLabel(1,NULL); 
   
//---- initialization done
   return(0);
  }
int deinit()
  {ObjectDelete("Registance");
   ObjectDelete("Support");
   return(0);
  }

int start()
  {
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+1;
   
   for(int i=limit; i>=0; i--)
   {double H = High[iHighest(NULL,0,MODE_HIGH,Per,i+1)],
           L = Low[iLowest(NULL,0,MODE_LOW,Per,i+1)];
      Registance[i]=H*2-L;
      Support[i]=L*2-H;
   }
       if(ObjectFind("Registance") != 0) 
        {ObjectCreate("Registance",OBJ_HLINE,0,Time[0],Registance[0]);
         ObjectSet("Registance",OBJPROP_BACK,true);
         ObjectSet("Registance",OBJPROP_COLOR,Rcol);
         ObjectSet("Registance",OBJPROP_WIDTH,Rwid);
         ObjectSet("Registance",OBJPROP_STYLE,Rstyl);}
         else{ObjectMove("Registance", 0,Time[0],Registance[0]);}
         
       if(ObjectFind("Support") != 0) 
        {ObjectCreate("Support",OBJ_HLINE,0,Time[0],Support[0]);
         ObjectSet("Support",OBJPROP_BACK,true);
         ObjectSet("Support",OBJPROP_COLOR,Scol);
         ObjectSet("Support",OBJPROP_WIDTH,Swid);
         ObjectSet("Support",OBJPROP_STYLE,Sstyl);}
         else{ObjectMove("Support", 0,Time[0],Support[0]);}

   return(0);
  }
//+------------------------------------------------------------------+