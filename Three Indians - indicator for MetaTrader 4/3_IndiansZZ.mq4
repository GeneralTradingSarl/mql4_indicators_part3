//+------------------------------------------------------------------+
//|                                                 3_indiansZZ.mq4 |
//|                                                      Denis Orlov |
/*
      Detection of a pattern "three Indians" on the basis of the ZigZag.
      http://codebase.mql4.com/6624
      
      Обнаружение паттерна "три индейца" на основе вершин Зигзага.
      http://codebase.mql4.com/6625
      
      "ПОЛЬЗУЙТЕСЬ И ПРОЦВЕТАЙТЕ!"
      
      Все мои индикаторы 
      All my indicators :
      
      http://codebase.mql4.com/author/denis_orlov
      
      */
//|                                    http://denis-or-love.narod.ru |
//+------------------------------------------------------------------+
#property copyright "Denis Orlov, http://denis-or-love.narod.ru"
#property link      "http://denis-or-love.narod.ru"

#property indicator_chart_window

#define Pref "3_Ind_ZZ "

extern int ExtDepth=10;
extern int ExtDeviation=5;
extern int ExtBackstep=3;
extern double K_MinWave=0.6;
extern int Depth=3;
extern int History=5000;
extern bool Show_ZigZag=True;
extern color ColorUp=Red;
extern color ColorDn=Green;
extern int Width=2;

#define ZZP 21

#property indicator_buffers 1
#property indicator_color1 Red

double ZZ[];

int Zbar[ZZP]; //номер бара с перегибом
double Zval[ZZP]; //значение зигзага в точке перегиба Zval[1] - в точке 1 и тд. 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexBuffer(0,ZZ);
   SetIndexStyle(0,DRAW_SECTION);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   Delete_My_Obj(Pref);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {

   int counted_bars=IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars>0) counted_bars--;
   int i=Bars-counted_bars;
   if(counted_bars==0) i-=1+Depth*2+1;

   if(History>0 && i>History) // Если много баров то ..      
      i=History;
   while(i>=0)
     {
      FindZigZag(i,ZZP);
      int nBar1;
      datetime time1,time2;
      string nameUp,nameDn;

      if((Zbar[1]>=0) && (Zbar[1]<Bars))
        {
         if(Zval[1]==High[Zbar[1]])//верхний
           {
            nBar1=0;
            if(Zval[3]<Zval[1])
              {
               nBar1=3;
               for(int j=3+2;j<=Depth*2+1;j=j+2)
                 {
                  if(
                     Zval[nBar1]-Zval[nBar1-1]<(Zval[1]-Zval[2])*K_MinWave && 
                     Zval[j-2]<Zval[j] && Zval[j]<Zval[1])
                    {
                     nBar1=j;
                    }
                 }
              }
           }

         if(nBar1!=0 && Zval[nBar1]-Zval[nBar1-1]>=(Zval[1]-Zval[2])*K_MinWave)
           {
            int DiffB=Zbar[nBar1]-Zbar[1];
            int barEnd=Zbar[1]-DiffB;
            if(barEnd<0) time1=Time[0]+MathAbs(barEnd)*Period()*60;
            else  time1=Time[barEnd];

            nameUp=Pref+"Up "+TimeToStr(Time[Zbar[1]]);

            DrawTrends(nameUp,Time[Zbar[nBar1]],Zval[nBar1],time1,Zval[1]+(Zval[1]-Zval[nBar1]),ColorUp,Width,
                       ""// Zbar[nBar1]+";"+Zbar[1]+";"+DiffB+";"+barEnd
                       );//, bool ray=false, int Win=0
           }

        }

      if(Zval[1]==Low[Zbar[1]]
         )//нижний
        {

         nBar1=0;
         if(Zval[3]>Zval[1])
           {
            nBar1=3;
            for(j=3+2;j<=Depth*2+1;j=j+2)
              {
               if(
                  Zval[nBar1-1]-Zval[nBar1]<(Zval[2]-Zval[1])*K_MinWave && 
                  Zval[j-2]>Zval[j] && Zval[j]>Zval[1])
                 {
                  nBar1=j;
                 }

              }

           }

         if(nBar1!=0 && Zval[nBar1-1]-Zval[nBar1]>=(Zval[2]-Zval[1])*K_MinWave)
           {

            DiffB=Zbar[nBar1]-Zbar[1];
            barEnd=Zbar[1]-DiffB;
            if(barEnd<0) time2=Time[0]+MathAbs(barEnd)*Period()*60;
            else  time2=Time[barEnd];

            nameDn=Pref+"Dn "+TimeToStr(Time[Zbar[1]]);
            DrawTrends(nameDn,Time[Zbar[nBar1]],Zval[nBar1],time2,Zval[1]+(Zval[1]-Zval[nBar1]),ColorDn,Width,
                       "");
           }

        }

      j=Zbar[1];
      if(Show_ZigZag)
         while(j>=i)
           {
            ZZ[j]=EMPTY_VALUE;
            double zz=iCustom(NULL,0,"ZigZag",ExtDepth,ExtDeviation,ExtBackstep,0,j);
            if(zz!=0) ZZ[j]=zz;
            j--;
           }

      i--;

     }
//----
   return(0);
  }
//+------------------------------------------------------------------+
datetime FindZigZag(int bar,int nP)
  {
   int n; datetime res;
   for(int i=bar;i<Bars;i++)
     {
      double zz=iCustom(NULL,0,"ZigZag",ExtDepth,ExtDeviation,ExtBackstep,0,i);
      if(zz!=0 && zz!=EMPTY_VALUE)
        {
         Zbar[n]=i;
         Zval[n]=zz;
         if((Zbar[n]>=0) && (Zbar[n]<Bars))
           {
            if(n==1) res=Time[Zbar[n]];//iTime(NULL, 0 , Zbar[n]);
           }
         n++;
         if(n>=nP)break;
        }
     }

//for( i=0;i<nP;i++)
// string str=str+i+" Вершина="+DoubleToStr(Zval[i] , Digits)+"/n";
// Comment(str);

   return(res);
  }
//___________________
int DrawTrends(string name,datetime T1,double P1,datetime T2,double P2,color Clr,int W=1,string Text="",bool ray=false,int Win=0)
  {
   int Error=ObjectFind(name);// Запрос 
   if(Error!=Win)// Если объекта в ук. окне нет :(
     {
      ObjectCreate(name,OBJ_TREND,Win,T1,P1,T2,P2);//создание трендовой линии
     }

   ObjectSet(name,OBJPROP_TIME1,T1);
   ObjectSet(name,OBJPROP_PRICE1,P1);
   ObjectSet(name,OBJPROP_TIME2,T2);
   ObjectSet(name,OBJPROP_PRICE2,P2);
   ObjectSet(name,OBJPROP_RAY,ray);
   ObjectSet(name,OBJPROP_COLOR,Clr);
   ObjectSet(name,OBJPROP_WIDTH,W);
   ObjectSetText(name,Text);
// WindowRedraw();
   return(0);
  }
//-------------------------------------
void Delete_My_Obj(string Prefix)
  {//Alert(ObjectsTotal());
   for(int k=ObjectsTotal()-1; k>=0; k--) // По количеству всех объектов 
     {
      string Obj_Name=ObjectName(k);   // Запрашиваем имя объекта
      string Head=StringSubstr(Obj_Name,0,StringLen(Prefix));// Извлекаем первые сим

      if(Head==Prefix)// Найден объект, ..
        {
         ObjectDelete(Obj_Name);
         //Alert(Head+";"+Prefix);
        }

     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LineToValue(datetime T_2,datetime T_1,double P2,double P1,datetime TBarSH,string Symb="",int TF=0)
  {
   if(Symb=="")Symb=Symbol();
   int B2=iBarShift(Symb,TF,T_2);
   int B1=iBarShift(Symb,TF,T_1);
//Comment("B2="+B2+"; B1="+B1);
   int Bar=iBarShift(Symb,TF,TBarSH,true);
   if(Bar<0)
     {
      datetime TBar=iTime(Symb,TF,0)-(TBarSH-iTime(Symb,TF,0));
      Bar=-iBarShift(NULL,0,TBar);
     }

   double Step=(P2-P1)/(B2-B1),
   Res=P1+((Bar-B1)*Step);
   return(Res);
  }
//====================
