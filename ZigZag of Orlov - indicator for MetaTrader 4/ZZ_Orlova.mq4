//+------------------------------------------------------------------+
//|                                                    ZZ_Orlova.mq4 |
//|                       Denis Orlov, http://denis-or-love.narod.ru |
//|                                    http://denis-or-love.narod.ru |
/*
ZigZag Орлова
ЗигЗаг с простым, понятным и естественным принципом работы. По ценам закрытия. Без перерисовки.
Подробно: http://codebase.mql4.com/7277


ZigZag of Orlov
Zigzag with a simple, clear and natural principle of work. By the Close prices. Without redrawing.
In detail: http://codebase.mql4.com/7278
*/
//+------------------------------------------------------------------+
#property copyright "Denis Orlov, http://denis-or-love.narod.ru"
#property link      "http://denis-or-love.narod.ru"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 Red
#property indicator_width1 2
//---- input parameters
extern double MinRatio=0.33;
extern int MinPoints=20;
extern int ForcePoints=50;

extern bool ByClose=False;
extern int History=5000; 
//---- buffers
double ZZ_Orlova[];

double LastUp;
double LastDn;

bool LastIsUp;

datetime LastPicTime=0;

int Zbar[3]; //номер бара с перегибом
double Zval[3]; //значение зигзага в точке перегиба Zval[1] - в точке 1 и тд. 
int ZObar[6]; //номер бара с перегибом
double ZOval[6]; //значение зигзага в точке перегиба Zval[1] - в точке 1 и тд. 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_SECTION);
   SetIndexBuffer(0,ZZ_Orlova);
   SetIndexEmptyValue(0,0.0);
//----
   if(ForcePoints<MinPoints) ForcePoints=MinPoints;
      
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
    if(ByClose)
    {
   static datetime perB;  
     if (perB== Time[0]) return(0); // один раз в бар
         perB = Time[0];
     }
         
      double upPrice, dnPrice;   
         
     int limit;
     int counted_bars=IndicatorCounted();
  //---- последний посчитанный бар будет пересчитан
    // if(counted_bars>0) counted_bars--;
     limit=Bars-counted_bars-1;
     if (History>0 && limit>History) 
     limit=History;
     
     int fstBar=0; if(ByClose)fstBar=1;

     for(int i =limit; i>=fstBar; i--)
       { 
         if (LastPicTime==0)//находим самые первые точки по ст ЗЗ, просто чтобы начать...
         {
            FindZigZag(i, 3);
            if(Zval[0]==Low[Zbar[0]])
               {
                  LastIsUp=False;
                  LastUp=Zval[1]; LastDn=Zval[0];
               }    
            else
               {
                  LastIsUp=True;
                  LastUp=Zval[0]; LastDn=Zval[1];
               } 
            
            //LastIsUp=Zval[1]==High[Zbar[1]];
            ZZ_Orlova[Zbar[1]]=Zval[1]; 
            ZZ_Orlova[Zbar[0]]=Zval[0]; 

            LastPicTime=Time[Zbar[0]]; //Alert("расставили!");
           // continue;
         }
         
         int LastBar=iBarShift(NULL,0,LastPicTime);//индекс(бар) последнего пика
         
         if(ByClose)//определяем режим цены по экстремумам или по закрытию
         {
            upPrice=Close[i]; dnPrice=Close[i];  
         }
         else {upPrice=High[i]; dnPrice=Low[i]; }
         //----------------------------
         
         if(LastIsUp)
         {
            if(upPrice>=LastUp)
            {
              LastUp=upPrice;
                ZZ_Orlova[LastBar]=0.0;
              ZZ_Orlova[i]=upPrice;
              LastPicTime=Time[i];
            }
            else
            if(
            (dnPrice<=LastUp-(LastUp-LastDn)*MinRatio 
            && (LastUp-dnPrice)/Point>=MinPoints
            )
            || (LastUp-dnPrice)/Point>=ForcePoints
            )
            {
               LastDn=dnPrice;
               LastIsUp=False;
               ZZ_Orlova[i]=dnPrice;
               LastPicTime=Time[i];
            }
            
         } //if(LastIsUp)
         else
         if(!LastIsUp)
         {
            if(dnPrice<=LastDn)
            {
              LastDn=dnPrice;
                ZZ_Orlova[LastBar]=0.0; 
              ZZ_Orlova[i]=dnPrice;
              LastPicTime=Time[i];
            }
            else
            if(
            (upPrice>=LastDn+(LastUp-LastDn)*MinRatio
            && (upPrice-LastDn)/Point>=MinPoints
            )
            || (upPrice-LastDn)/Point>=ForcePoints
            )
            {
               LastUp=upPrice;
               LastIsUp=True;
               ZZ_Orlova[i]=upPrice;
               LastPicTime=Time[i];
            }
         }// if(!LastIsUp)
         
       }
//----
   return(0);
  }
//+------------------------------------------------------------------+
datetime FindZigZag(int bar, int nP )
  {
  int ExtDepth=12;
 int ExtDeviation=5;
 int ExtBackstep=3;
 
   int n; datetime res;
   for(int i=bar;i<Bars;i++)
      {
         double zz=iCustom(NULL,0,"ZigZag",ExtDepth,ExtDeviation,ExtBackstep,0,i);
           if(zz!=0 && zz!=EMPTY_VALUE)
           {
              Zbar[n]=i;
              Zval[n]=zz;
              if(n==1) res=Time[Zbar[n]];//iTime(NULL, 0 , Zbar[n]);
              
              n++;
                 if(n>=nP)break;
           }
      }
      
      return(res);
  }
//+------------------------------------------------------------------+
int FindZZO(int bar, int nP )
  {
 
   int n; datetime res;
   for(int i=bar;i<Bars;i++)
      {
         double zz=ZZ_Orlova[i];
           if(zz!=0 && zz!=EMPTY_VALUE)
           {
              ZObar[n]=i;
              ZOval[n]=zz;  
              n++;
                 if(n>=nP)break;
           }
      }
      
      return(n);
  }
//+------------------------------------------------------------------+