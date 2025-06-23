//+------------------------------------------------------------------+
//|                                                  ZigzagFr_v1.mq4 |
//|                               Copyright © 2010, Vladimir Hlystov |
//|                                                cmillion@narod.ru |
//|Zigzag по фракталам                                               |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, Vladimir Hlystov"
#property link      "http://cmillion.narod.ru"
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_width1 3
#property indicator_color1 Blue

extern int Fractal = 10;  //сколько фракталов с каждой стороны используется для определения нужного фрактала

double up,dn;
double Buffer[];
datetime TimednBar,TimeupBar;
//+------------------------------------------------------------------+
int init()
  {
   Comment("ZigzagFr_v1","\n","Copyright © 2010, Vladimir Hlystov","\n","http://cmillion.narod.ru");
   IndicatorBuffers(1);
   SetIndexStyle(0,DRAW_SECTION);
   SetIndexBuffer(0,Buffer);

   return(0);
  }
//+------------------------------------------------------------------+
int start()
{
   int counted_bars=IndicatorCounted();
   int limit=Bars-counted_bars;
   int dnBar = iBarShift(NULL,0,TimednBar,true);
   int upBar = iBarShift(NULL,0,TimeupBar,true);
   if (limit<MathMax(upBar,dnBar)) limit=MathMax(dnBar,upBar);
   double fr;
//   string Name;
   for(int i=limit; i>0; i--)
   {
      fr = Fractal(MODE_LOWER,i);
      if (fr!=0 && (fr<dn || dn==0)) 
      {
         if (dn!=0) 
         {
            dnBar = iBarShift(NULL,0,TimednBar,true);
            Buffer[dnBar]=EMPTY_VALUE; 
/*            Name="dnBar"+Time[0];
            ObjectDelete(Name);
            ObjectCreate(Name, OBJ_ARROW,0,Time[dnBar],Low[dnBar],0,0,0,0);
            ObjectSet   (Name, OBJPROP_WIDTH, 3);
            ObjectSet   (Name, OBJPROP_ARROWCODE,218);
            ObjectSet   (Name, OBJPROP_COLOR, Blue);*/
         }
         Buffer[i]=fr; up=0; dn=fr; TimednBar=Time[i];
      }
      else
      {
         fr = Fractal(MODE_UPPER,i);
         if (fr!=0 && fr>up) 
         {
            if (up!=0) 
            {
               upBar = iBarShift(NULL,0,TimeupBar,true);
               Buffer[upBar]=EMPTY_VALUE; 
/*               Name="upBar"+Time[0];
               ObjectDelete(Name);
               ObjectCreate(Name, OBJ_ARROW,0,Time[upBar],High[upBar],0,0,0,0);
               ObjectSet   (Name, OBJPROP_WIDTH, 3);
               ObjectSet   (Name, OBJPROP_ARROWCODE,217);
               ObjectSet   (Name, OBJPROP_COLOR, Blue);*/
            }
            Buffer[i]=fr; up=fr; dn=0; TimeupBar=Time[i];
         }
         else Buffer[i]=EMPTY_VALUE;
      }
   }
   return(0);
}
//+------------------------------------------------------------------+
double Fractal(int tip,int bar)
{
   int i,n;
   double fr,fr1;
   if (tip==MODE_UPPER)
   {
      fr1 = iFractals(NULL,0,MODE_UPPER,bar);
      if (fr1==0) return(0);
      i=bar;n=0;
      while (true)
      {
         i++; 
         if (i>Bars) return(0);
         fr = iFractals(NULL,0,MODE_UPPER,i);
         if (fr==0) continue; else n++;
         if (n>=Fractal) break;
         if (fr>fr1) return(0);
      }
      i=bar;n=0;
      while (true)
      {
         i--;
         if (i==0) return(0);
         fr = iFractals(NULL,0,MODE_UPPER,i);
         if (fr==0) continue; else n++;
         if (n>=Fractal) break;
         if (fr>fr1) return(0);
      }
      return(fr1);
   }
   if (tip==MODE_LOWER)
   {
      fr1 = iFractals(NULL,0,MODE_LOWER,bar);
      if (fr1==0) return(0);
      i=bar;n=0;
      while (true)
      {
         i++; 
         if (i>Bars) return(0);
         fr = iFractals(NULL,0,MODE_LOWER,i);
         if (fr==0) continue; else n++;
         if (n>=Fractal) break;
         if (fr<fr1) return(0);
      }
      i=bar;n=0;
      while (true)
      {
         i--; 
         if (i==0) return(0);
         fr = iFractals(NULL,0,MODE_LOWER,i);
         if (fr==0) continue; else n++;
         if (n>=Fractal) break;
         if (fr<fr1) return(0);
      }
      return(fr1);
   }
}
//+------------------------------------------------------------------+

rn(0);
         fr = iFractals(NULL,0,MODE_LOWER,i);
         if (fr==0) continue; else n++;
         if (n>=Fractal) break;
         if (fr<fr1) return(0);
      }
      return(fr1);
   }
}
//+------------------------------------------------------------------+

