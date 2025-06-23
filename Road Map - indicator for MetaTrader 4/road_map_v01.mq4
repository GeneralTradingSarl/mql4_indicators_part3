//+------------------------------------------------------------------+
//|                                                 Road_Map_v01.mq4 |
//|  нач. 05/09/2015                                                 |
//+------------------------------------------------------------------+
#property copyright "Inkov Evgeni"
#property link      "ew123@mail.ru"
//---
#property version   "1.00"
#property strict
#property indicator_chart_window
//---
#define           Razm_Mas_Prizn         7
//---
input int   Max_Bars       = 300;
input color clr_Series_Up  = clrBlue;
input color clr_Series_Dw  = clrPurple;
input color clr_Tail_ZZ    = clrGreen;
input color clr_Fibo       = clrDarkOrange;
input color clr_Prob_UP    = clrGreen;
input color clr_Prob_DW    = clrRed;
input bool  On_Nom_Series  = true;
input bool  On_Fibo        = true;
input bool  Sound          = true;
//---
int Mas_Fract[];
int M_Bars;
int Sgat_ZZ_0[][Razm_Mas_Prizn];
string pref="ZZ_";
datetime time_end_urov;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(Max_Bars>0)
      M_Bars=MathMin(Max_Bars,iBars(_Symbol,0));
   else
      M_Bars=iBars(_Symbol,0);

   ArrayResize(Mas_Fract,M_Bars);
   ArrayResize(Sgat_ZZ_0,M_Bars);

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   remove_objects(pref);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   Form_ZZ(Period(),Sgat_ZZ_0);

   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Form_ZZ(int TF,int &mas_sgat[][])
  {
   int n_sgat=0;

   Find_Fractal(TF);
   Dorab_Fract(TF,mas_sgat,n_sgat);
   Opred_Impuls_Wave(TF,mas_sgat,n_sgat);
   Opred_Corr_wave(TF,mas_sgat,n_sgat);
   Opred_Series_Wave(TF,mas_sgat,n_sgat);

   Out_ZZ(TF,mas_sgat,n_sgat);
   if(On_Nom_Series)Out_Nom_Series(TF,mas_sgat,n_sgat);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Opred_Series_Wave(int TF,int &mas_sgat[][],int kol_sgat)
  {  // найти серии волн
   int imp,impS=0,impS_beg=0,tek_series=0,kol_wave=0,b1,b0,b1S=0,b0S=0,b1S_beg=0,b0S_beg=0;
   double H,L,HS=0,LS=0;
   double HS_beg=0,LS_beg=0;

   int n=0,m=0;

   for(int i=kol_sgat-1;i>=1;i--)
     {
      imp=mas_sgat[i][2];   // текущая импульсная/корр. волна; 1 - имп.волна вверх, -1 - имп.волна вниз, 0 - корр.волна

      if(imp!=0) // найдена импульсная волна
        {
         b0=mas_sgat[i][0];
         b1=mas_sgat[i-1][0];

         if(imp>0)
           {
            L=iLow (_Symbol,TF,b0);
            H=iHigh(_Symbol,TF,b1);
           }
         else
           {
            L=iLow (_Symbol,TF,b1);
            H=iHigh(_Symbol,TF,b0);
           }
         bool prob_up=impS<0 && ND(H)>ND(HS);  // пробой вверх
         bool prob_dw=impS>0 && ND(L)<ND(LS);  // пробой вниз

         if(prob_up)
           {
            Out_TL(n,iTime(_Symbol,TF,b0S),HS,iTime(_Symbol,TF,b1)+2*TF*60,HS,"prob_U",clr_Prob_UP,TF,1,2);
            if(Sound && iTime(_Symbol,TF,b0S)>time_end_urov)
              {
               time_end_urov=iTime(_Symbol,TF,b0S);
               PlaySound("alert.wav");
              }
            n++;
           }
         if(prob_dw)
           {
            Out_TL(m,iTime(_Symbol,TF,b0S),LS,iTime(_Symbol,TF,b1)+2*TF*60,LS,"prob_D",clr_Prob_DW,TF,1,2);
            if(Sound && iTime(_Symbol,TF,b0S)>time_end_urov)
              {
               time_end_urov=iTime(_Symbol,TF,b0S);
               PlaySound("email.wav");
              }
            m++;
           }

         if(HS==0 || prob_up || prob_dw) // или волн ещё не было или пробой вверх/вниз
           {
            HS=H;
            LS=L;
            b0S=b0;
            b1S=b1;
            impS=imp;

            HS_beg=H;
            LS_beg=L;
            b0S_beg=b0;
            b1S_beg=b1;
            impS_beg=imp;

            tek_series=imp; // 1 или -1
            kol_wave=0;
           }
         else
            if((impS>0 && ND(H)>ND(HS)) || 
               (impS<0 && ND(L)<ND(LS)))// превышение вверх или вниз
              {  // обновляем исходную волну
               HS=H;
               LS=L;
               b0S=b0;
               b1S=b1;
              }
        }

      kol_wave++;
      mas_sgat[i][4]=tek_series*kol_wave;
     }
/*
   if (impS>0)
   {
      Out_TL(n,iTime(_Symbol,TF,b1S), HS, iTime(_Symbol,TF,0)+2*TF*60, HS, "gran_U", clr_Prob_UP, TF, 0,2);
      Out_TL(m,iTime(_Symbol,TF,b0S), LS, iTime(_Symbol,TF,0)+2*TF*60, LS, "gran_D", clr_Prob_DW, TF, 0,2);
   }
   else
   {
      Out_TL(n,iTime(_Symbol,TF,b0S), HS, iTime(_Symbol,TF,0)+2*TF*60, HS, "gran_U", clr_Prob_UP, TF, 0,2);
      Out_TL(m,iTime(_Symbol,TF,b1S), LS, iTime(_Symbol,TF,0)+2*TF*60, LS, "gran_D", clr_Prob_DW, TF, 0,2);
   }
   */
   Del_extra_obj(TF,"prob_U",n+1);
   Del_extra_obj(TF,"prob_D",m+1);

   if(On_Fibo)Out_Fibo(TF,impS_beg,b0S_beg,b1S_beg,LS_beg,HS_beg);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Out_Fibo(int TF,int dir,int b0,int b1,double L,double H)
  {
   if(dir>0)
     {
      double p=L;
      L=H;
      H=p;
     }
   string name=pref+"_Fibo";
   if(ObjectFind(name))ObjectCreate(name,OBJ_FIBO,0,iTime(_Symbol,TF,b1),L,iTime(_Symbol,TF,b0),H);

   ObjectSet(name,OBJPROP_TIME1,iTime(_Symbol,TF,b1));
   ObjectSet(name,OBJPROP_PRICE1,L);
   b0=(int)(0.1*b1)+b1+3;
   ObjectSet(name,OBJPROP_TIME2,iTime(_Symbol,TF,b0));
   ObjectSet(name,OBJPROP_PRICE2,H);
   ObjectSet(name,OBJPROP_COLOR,clr_Fibo);
   ObjectSet(name,OBJPROP_WIDTH,1);
   ObjectSetInteger(0,name,OBJPROP_RAY_RIGHT,false);
   ObjectSetInteger(0,name,OBJPROP_LEVELCOLOR,0,clr_Fibo);
   ObjectSetInteger(0,name,OBJPROP_LEVELS,13);
   ObjectSetDouble(0,name,OBJPROP_LEVELVALUE,0,0);
   ObjectSetDouble(0,name,OBJPROP_LEVELVALUE,1,0.236);
   ObjectSetDouble(0,name,OBJPROP_LEVELVALUE,2,0.382);
   ObjectSetDouble(0,name,OBJPROP_LEVELVALUE,3,0.5);
   ObjectSetDouble(0,name,OBJPROP_LEVELVALUE,4,0.618);
   ObjectSetDouble(0,name,OBJPROP_LEVELVALUE,5,0.764);
   ObjectSetDouble(0,name,OBJPROP_LEVELVALUE,6,1.0);
   ObjectSetDouble(0,name,OBJPROP_LEVELVALUE,7,1.382);
   ObjectSetDouble(0,name,OBJPROP_LEVELVALUE,8,1.618);
   ObjectSetDouble(0,name,OBJPROP_LEVELVALUE,9,2.0);
   ObjectSetDouble(0,name,OBJPROP_LEVELVALUE,10,2.618);
   ObjectSetDouble(0,name,OBJPROP_LEVELVALUE,11,3.0);
   ObjectSetDouble(0,name,OBJPROP_LEVELVALUE,12,4.0);
   ObjectSetString(0,name,OBJPROP_LEVELTEXT,0,"0.0");
   ObjectSetString(0,name,OBJPROP_LEVELTEXT,1,"23.6");
   ObjectSetString(0,name,OBJPROP_LEVELTEXT,2,"38.2");
   ObjectSetString(0,name,OBJPROP_LEVELTEXT,3,"50.0");
   ObjectSetString(0,name,OBJPROP_LEVELTEXT,4,"61.8");
   ObjectSetString(0,name,OBJPROP_LEVELTEXT,5,"76.4");
   ObjectSetString(0,name,OBJPROP_LEVELTEXT,6,"100.0");
   ObjectSetString(0,name,OBJPROP_LEVELTEXT,7,"138.2");
   ObjectSetString(0,name,OBJPROP_LEVELTEXT,8,"161.8");
   ObjectSetString(0,name,OBJPROP_LEVELTEXT,9,"200.0");
   ObjectSetString(0,name,OBJPROP_LEVELTEXT,10,"261.8");
   ObjectSetString(0,name,OBJPROP_LEVELTEXT,11,"300.0");
   ObjectSetString(0,name,OBJPROP_LEVELTEXT,12,"400.0");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Find_Fractal(int TF)
  {
   int up,dw;
   ArrayInitialize(Mas_Fract,0);
   for(int i=M_Bars-4;i>=2;i--)
     {
      up=0;
      dw=0;
      double H_2=iHigh(_Symbol,TF,i-2);
      double H_1=iHigh(_Symbol,TF,i-1);
      double H0 =iHigh(_Symbol,TF,i);
      double H1 =iHigh(_Symbol,TF,i+1);
      double H2 =iHigh(_Symbol,TF,i+2);
      double H3 =iHigh(_Symbol,TF,i+3);
      if(((ND(H0)>ND(H1) && ND(H0)>ND(H2)) || 
         (ND(H0)==ND(H1) && ND(H0)>ND(H2)) || 
         (ND(H0)>ND(H1) && ND(H0)==ND(H2)) || 
         (ND(H0)==ND(H1) && ND(H0)==ND(H2) && ND(H0)>ND(H3))) && 
         ND(H0)>ND(H_1) && ND(H0)>ND(H_2))
         up=1;
      //---
      double L_2=iLow(_Symbol,TF,i-2);
      double L_1=iLow(_Symbol,TF,i-1);
      double L0 =iLow(_Symbol,TF,i);
      double L1 =iLow(_Symbol,TF,i+1);
      double L2 =iLow(_Symbol,TF,i+2);
      double L3 =iLow(_Symbol,TF,i+3);
      if(((ND(L0)<ND(L1) && ND(L0)<ND(L2)) || 
         (ND(L0)==ND(L1) && ND(L0)<ND(L2)) || 
         (ND(L0)<ND(L1) && ND(L0)==ND(L2)) || 
         (ND(L0)==ND(L1) && ND(L0)==ND(L2) && ND(L0)<ND(L3))) && 
         ND(L0)<ND(L_1) && ND(L0)<ND(L_2))dw=1;
      //---
      if(up==1 && dw==0)
         Mas_Fract[i]=1;
      else
      if(up==0 && dw==1)
         Mas_Fract[i]=-1;
      else
      if(up==1 && dw==1)
        {
         double op0=iOpen (_Symbol,TF,i);
         double cl0=iClose(_Symbol,TF,i);
         if(ND(cl0)>=ND(op0))
            Mas_Fract[i]=4;
         else
            Mas_Fract[i]=-4;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Dorab_Fract(int TF,int &mas_sgat[][],int &kol_sgat)
  {
   obrab_begin_ZZ(TF,Mas_Fract);  // обработать начало зиг-зага
//---
   int Sgat_ZZ[][2]; // 0 - ном бара, 1 - знач.
   ArrayResize(Sgat_ZZ,2*M_Bars);
   int n=0;
   szhat_mas_ZZ(Mas_Fract,Sgat_ZZ,n);  // сжать массив ZZ
   Find_promezh_point(TF,Mas_Fract,Sgat_ZZ,n); // найти точки между одинаковыми вершинами
   szhat_mas_ZZ(Mas_Fract,Sgat_ZZ,n);  // сжать массив ZZ
   ubrat_iskagen_ZZ(TF,Mas_Fract,Sgat_ZZ,n); // убрать искажения ZZ
//---
   ArrayInitialize(mas_sgat,0);
   szhat_mas_ZZ(Mas_Fract,mas_sgat,kol_sgat);  // сжать массив ZZ
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void obrab_begin_ZZ(int TF,int &mas_Fr[])
  {
   int k,i;
   for(i=0;i<M_Bars;i++) // найти начало масива ZZ (i)
      if(mas_Fr[i]!=0)break;
//---
   if(i>0) // найдено начало фракталов
      //--- смотрим на каком баре стоит начальный фрактал (i).
      //--- 1. Если на i-ом баре - вершина UP
      //--- 1.1. Если на 0-м баре High >  UP, то High[0]= 3
      //--- 1.2. Если на 0-м баре High <= UP, то Low [0]=-3
      //--- 2. (для DW - наоборот)
      if(mas_Fr[i]>0) // в начале линейки фракталов - максимум (UP)
        {
         if(iHigh(_Symbol,TF,0)>iHigh(_Symbol,TF,i)) // на 0-м баре High >  UP
           {
            k=iHighest(_Symbol,TF,MODE_HIGH,i-1,1);
            if(iHigh(_Symbol,TF,k)>iHigh(_Symbol,TF,0))
              {
               mas_Fr[k]=3; // минимум между вершинами найдется автоматом
               mas_Fr[0]=-3;
              }
            else
               mas_Fr[0]=3; // минимум между вершинами найдется автоматом
           }
         else
           {
            k=iLowest(_Symbol,TF,MODE_LOW,i-1,1);
            if(iLow(_Symbol,TF,k)<iLow(_Symbol,TF,0))
              {
               mas_Fr[k]=-3;
               mas_Fr[0]= 3;
              }
            else
               mas_Fr[0]=-3;
           }
        }
   else
   if(mas_Fr[i]<0) // в начале линейки фракталов - минимум
     {
      if(iLow(_Symbol,TF,0)<iLow(_Symbol,TF,i))
        {
         k=iLowest(_Symbol,TF,MODE_LOW,i-1,1);
         if(iLow(_Symbol,TF,k)<iLow(_Symbol,TF,0))
           {
            mas_Fr[k]=-3; // минимум между вершинами найдется автоматом
            mas_Fr[0]= 3;
           }
         else
            mas_Fr[0]=-3; // минимум между вершинами найдется автоматом
        }
      else
        {
         k=iHighest(_Symbol,TF,MODE_HIGH,i-1,1);
         if(iHigh(_Symbol,TF,k)>iHigh(_Symbol,TF,0))
           {
            mas_Fr[1]= 3;
            mas_Fr[0]=-3;
           }
         else
            mas_Fr[0]=3;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Find_promezh_point(int TF,int &mas_ish_ZZ[],int &mas_Szt[][],int kol_szt)
  { // найти точки между одинаковыми вершинами
   int k,b0,b1,z0,z1;
   for(int i=1;i<kol_szt;i++)
     {
      b0=mas_Szt[i-1][0];
      b1=mas_Szt[i]  [0];
      z0=mas_Szt[i-1][1];
      z1=mas_Szt[i]  [1];
      if(z0*z1>0) // на вершинах одинаковые направления
         if(b1-b0-1>1)
            if(z1>0)
              {
               k=Main_iLowest(TF,b1-b0-1,b0+1);
               mas_ish_ZZ[k]=-2;
              }
      else
        {
         k=Main_iHighest(TF,b1-b0-1,b0+1);
         mas_ish_ZZ[k]=2;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ubrat_iskagen_ZZ(int TF,int &mas_ish_ZZ[],int &mas_Szt[][],int kol_szt)
  {   // убрать искажения ZZ: если максимум ниже пред. минимума и наоборот
   int i,b0,b1;
   double p0,p1;
   int f0,f1;
   for(i=1;i<kol_szt;i++)
     {
      b1=mas_Szt[i][0]; // тек.
      f1=mas_Szt[i]  [1];
      b0=mas_Szt[i-1][0]; // справа
      f0=mas_Szt[i-1][1];

      p1=iLow (_Symbol,TF,b1);
      p0=iHigh(_Symbol,TF,b0);
      if(f1<0 && f0>0 && ND(p1)>=ND(p0))
        {
         mas_ish_ZZ[b0]=0;
         mas_ish_ZZ[b1]=0;
         continue;
        }
      p1=iHigh(_Symbol,TF,b1);
      p0=iLow (_Symbol,TF,b0);
      if(f1>0 && f0<0 && ND(p1)<=ND(p0))
        {
         mas_ish_ZZ[b0]=0;
         mas_ish_ZZ[b1]=0;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void szhat_mas_ZZ(int &masZZ_inp[],int &masZZ_out[][],int &kol_out)
  {  // сжать массив ZZ
   kol_out=0;
   int n;
   for(int i=0;i<M_Bars;i++)
     {
      n=masZZ_inp[i];
      if(n!=0)
        {
         if(MathAbs(n)<4)
           {
            masZZ_out[kol_out][0]=i;
            masZZ_out[kol_out][1]=n;
            kol_out++;
           }
         else // двойной фрактал
         if(n==4)
           {
            masZZ_out[kol_out][0]=i;
            masZZ_out[kol_out][1]=1;
            kol_out++;
            masZZ_out[kol_out][0]=i;
            masZZ_out[kol_out][1]=-1;
            kol_out++;
           }
         else
           {
            masZZ_out[kol_out][0]=i;
            masZZ_out[kol_out][1]=-1;
            kol_out++;
            masZZ_out[kol_out][0]=i;
            masZZ_out[kol_out][1]=1;
            kol_out++;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Opred_Impuls_Wave(int TF,int &mas_sgat[][],int kol_sgat)
  {   // выделить импульсные волны
   int z1,z0,z_1,b1,b0,b_1;
   double p1,p_1;
   for(int i=kol_sgat-2;i>=1;i--)
     {
      z1 =mas_sgat[i+1][1];   // левый   фрактал
      z0 =mas_sgat[i]  [1];   // текущий фрактал
      z_1=mas_sgat[i-1][1];   // правый  фрактал

      b1 =mas_sgat[i+1][0];
      b0 =mas_sgat[i]  [0];
      b_1=mas_sgat[i-1][0];

      if(z0<0 && z_1>0) // линия вверх
        {
         p1 =iHigh(_Symbol,TF,b1);
         p_1=iHigh(_Symbol,TF,b_1);
         if(ND(p_1)>ND(p1))mas_sgat[i][2]=1;
        }
      else
      if(z0>0 && z_1<0) // линия вниз
        {
         p1 =iLow(_Symbol,TF,b1);
         p_1=iLow(_Symbol,TF,b_1);
         if(ND(p_1)<ND(p1))mas_sgat[i][2]=-1;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Opred_Corr_wave(int TF,int &mas_sgat[][],int kol_sgat)
  {  // найти сложные корректирующие волны
   int z1,z0,b0,b1;
   double p0,d0;
   int i=kol_sgat-2;
   int n_k;

   while(i>=1)
     {
      z1 =mas_sgat[i+1][1];   // левый   фрактал
      z0 =mas_sgat[i]  [1];   // текущий фрактал

      b0=mas_sgat[i][0]; // текущий бар
      p0 =iHigh(_Symbol,TF,b0);
      d0 =iLow (_Symbol,TF,b0);

      //--- корр. волны вниз
      if(z1<0 && z0>0 && mas_sgat[i+1][2]>0 && mas_sgat[i][2]==0) // пред.линия импульс вверх, тек -корр.
        {
         mas_sgat[i][3]=-1; // обозначить начало сложной корр. линиии
         if(i>=2 && mas_sgat[i-1][2]==0) // след.-корр.
           {
            i--;
            mas_sgat[i][3]=-2;
            i--;
            n_k=3;
            while(i>0 && mas_sgat[i][2]==0)
              {
               mas_sgat[i][3]=-n_k;
               i--;
               n_k++;
               if(i<1)break;
               b1=mas_sgat[i-1][0];
               if(ND(iHigh(_Symbol,TF,b1))>ND(p0))break; // превысили основной верхний фрактал
               mas_sgat[i][3]=-n_k;
               i--;
               n_k++;
              }
           }
         else
           {
            i--;
            continue;
           }
        }
      else // корр. волны вверх
      if(z1>0 && z0<0 && mas_sgat[i+1][2]<0 && mas_sgat[i][2]==0) // пред.линия импульс вниз, тек -корр.
        {
         mas_sgat[i][3]=1; // обозначить начало сложной корр. линиии
         if(i>=2 && mas_sgat[i-1][2]==0) // след.-корр.
           {
            i--;
            mas_sgat[i][3]=2;
            i--;
            n_k=3;
            while(i>0 && mas_sgat[i][2]==0)
              {
               mas_sgat[i][3]=n_k;
               i--;
               n_k++;
               if(i<1)break;
               b1=mas_sgat[i-1][0];
               if(ND(iLow(_Symbol,TF,b1))<ND(d0))break; // превысили основной нижний фрактал
               mas_sgat[i][3]=n_k;
               i--;
               n_k++;
              }
           }
         else
           {
            i--;
            continue;
           }
        }
      else
         i--;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Out_ZZ(int TF,int &mas_sgat[][],int kol_sgat)
  {   // Вывести ZZ       
   int z0,z1,b0,b1,m0=0,m1=0;
   double L0,H0,L1,H1;
   datetime t0,t1;

   for(int i=1;i<kol_sgat;i++)
     {
      z1=mas_sgat[i][1]; // левый  фр.
      b1=mas_sgat[i][0];
      L1=iLow (_Symbol,TF,b1);
      H1=iHigh(_Symbol,TF,b1);
      t1=iTime(_Symbol,TF,b1);

      z0=mas_sgat[i-1][1]; // правый фр.
      b0=mas_sgat[i-1][0];
      L0=iLow (_Symbol,TF,b0);
      H0=iHigh(_Symbol,TF,b0);
      t0=iTime(_Symbol,TF,b0);
      //---
      if(z1>0 && z0<0) // линия вниз
        {
         Out_TL(m0,t0,L0,t1,H1,"T_D",mas_sgat[i][4]>0?clr_Series_Up:clr_Series_Dw,TF,mas_sgat[i][2]!=0,4);
         m0++;
        }
      else
      if(z1<0 && z0>0) // линия вверх
        {
         Out_TL(m1,t0,H0,t1,L1,"T_U",mas_sgat[i][4]>0?clr_Series_Up:clr_Series_Dw,TF,mas_sgat[i][2]!=0,4);
         m1++;
        }
     }
   Del_extra_obj(TF,"T_U",m0);
   Del_extra_obj(TF,"T_D",m1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Del_extra_obj(int tf,string s,int n)
  {
   string name;
   bool F;
   do
     {
      name=pref+str_TF(tf)+"_"+s+(string)n;
      F=ObjectFind(name)>=0;
      if(F)ObjectDelete(name);
      n++;
     }
   while(F);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Main_iHighest(int tf,int n,int beg)
  {
   double pr,pr_max=0.0;
   int n_max=beg;
   for(int i=beg;i<beg+n;i++)
     {
      pr=iHigh(_Symbol,tf,i);
      if(pr>pr_max)
        {
         pr_max=pr;
         n_max=i;
        }
     }
   return(n_max);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Main_iLowest(int tf,int n,int beg)
  {
   double pr,pr_min=999999.0;
   int n_min=beg;
   for(int i=beg;i<beg+n;i++)
     {
      pr=iLow(_Symbol,tf,i);
      if(pr<pr_min)
        {
         pr_min=pr;
         n_min=i;
        }
     }
   return(n_min);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Out_Nom_Series(int TF,int &mas_sgat[][],int kol_sgat)
  {   // вывести фракталы
   int m=0,n=0,b,k;
   color clr;

   for(int i=0;i<kol_sgat-1;i++)
     {
      int z=mas_sgat[i][1];
      b=mas_sgat[i][0];
      k=mas_sgat[i+1][4];
      if(k!=0)
        {
         if(b>=Bars)break;

         if(b<=2 && i<=2)
            clr=clr_Tail_ZZ;
         else
         if(mas_sgat[i+1][4]>0)
            clr=clr_Series_Up;
         else
            clr=clr_Series_Dw;

         if(z>0){Out_txt(n,iTime(_Symbol,TF,b),iHigh(_Symbol,TF,b),"N_U",clr,TF,ANCHOR_LOWER, k);n++;}
         if(z<0){Out_txt(m,iTime(_Symbol,TF,b),iLow (_Symbol,TF,b),"N_D",clr,TF,ANCHOR_UPPER, k);m++;}
        }
     }
   Del_extra_obj(TF,"N_U",n);
   Del_extra_obj(TF,"N_D",m);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string str_TF(int n)
  {
   if(n==0)n=Period();
   switch(n)
     {
      case PERIOD_M1:  return ("M1 ");
      case PERIOD_M5:  return ("M5");
      case PERIOD_M15: return ("M15");
      case PERIOD_M30: return ("M30");
      case PERIOD_H1:  return ("H1");
      case PERIOD_H4:  return ("H4");
      case PERIOD_D1:  return ("D1");
      case PERIOD_W1:  return ("W1");
      case PERIOD_MN1: return ("MN1");
     }
   return("TF?");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void remove_objects(string PreName)
  {
   string Obj_Name,Head;
   for(int k=ObjectsTotal()-1; k>=0; k--)
     {
      Obj_Name=ObjectName(k);
      Head=StringSubstr(Obj_Name,0,StringLen(PreName));
      if(Head==PreName)ObjectDelete(Obj_Name);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ND(double n)
  {
   return(NormalizeDouble(n,Digits));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Out_TL(int i,datetime t1,double pr1,datetime t2,double pr2,string s,color col,int TF,bool impuls,int width)
  {
   string name=pref+str_TF(TF)+"_"+s+(string)i;
   if(ObjectFind(name))ObjectCreate(name,OBJ_TREND,0,0,0,0,0);

   ObjectSet(name,OBJPROP_TIME1,t1);
   ObjectSet(name,OBJPROP_TIME2,t2);
   ObjectSet(name,OBJPROP_PRICE1,pr1);
   ObjectSet(name,OBJPROP_PRICE2,pr2);
   ObjectSet(name,OBJPROP_COLOR,col);
   ObjectSet(name,OBJPROP_RAY,0);
   if(impuls)
     {
      ObjectSet(name,OBJPROP_WIDTH,width);
      ObjectSet(name,OBJPROP_STYLE,STYLE_SOLID);
     }
   else
     {
      ObjectSet(name,OBJPROP_WIDTH,1);
      ObjectSet(name,OBJPROP_STYLE,STYLE_SOLID);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Out_Arrow(int i,datetime t,double pr,string s,color col,int cod,int TF,int anchor)
  {
   string name=pref+str_TF(TF)+"_"+s+(string)i;
   if(ObjectFind(name))ObjectCreate(name,OBJ_ARROW,0,0,0);

   ObjectSet(name,OBJPROP_TIME1,t);
   ObjectSet(name,OBJPROP_PRICE1,pr);
   ObjectSet(name,OBJPROP_COLOR,col);
   ObjectSet(name,OBJPROP_WIDTH,1);
   ObjectSet(name,OBJPROP_ARROWCODE,cod);
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,anchor);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Out_txt(int i,datetime t,double pr,string s,color col,int TF,int anchor,int n)
  {
   string name=pref+str_TF(TF)+"_"+s+(string)i;
   if(ObjectFind(name))ObjectCreate(name,OBJ_TEXT,0,0,0);

   ObjectSetText(name,IntegerToString(n),10,"Arial Black");
   ObjectSet(name,OBJPROP_TIME1,t);
   ObjectSet(name,OBJPROP_PRICE1,pr);
   ObjectSet(name,OBJPROP_COLOR,col);
   ObjectSet(name,OBJPROP_WIDTH,1);
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,anchor);
  }
//+------------------------------------------------------------------+
