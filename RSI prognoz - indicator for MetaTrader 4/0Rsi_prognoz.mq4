//+------------------------------------------------------------------+
//|                                                 !Rsi prognoz.mq4 |
//|                                                       Lizhniyk E |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Lizhniyk E"
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_minimum 0
#property indicator_maximum 100

//---- input parameters
extern datetime  start=D'2008.10.01';
extern int       period=24;
extern int       pr_period=24;
extern int       progn=3;
extern double    err=10;
extern int       glubina=500;
extern bool      exp=false;
//extern bool      std_err=false;

//---- buffers
double Real[];
double Prognoz[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int st,handle;
double dat[100000][100];
int dat_cnt=0;
double res_mas[1000];
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   if(pr_period>98) pr_period=98;
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,Real);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,159);
   SetIndexBuffer(1,Prognoz);
   SetIndexLabel(0,"Real");
   SetIndexLabel(1,"Prognoz");
   SetIndexShift(1,progn);

// handle=FileOpen(Symbol()+" RSI pattern.csv",FILE_CSV|FILE_WRITE);

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
double res=0;
int res_cnt=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
//int    counted_bars=IndicatorCounted();
//int limit=Bars-counted_bars;
//if(counted_bars==0)
//{
//limit=iBarShift(NULL,0,start);
//}
   int counted_bars=IndicatorCounted();
   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   if(counted_bars==0) limit-=1+MathMax(pr_period+progn,period);
//----

   int i,j,k;
//*************** 
   for(i=limit;i>0;i--)
     {
      //***************
      double sump=0;
      double sumn=0;
      for(j=0;j<period;j++)
        {
         double r=(Close[i+j]-Close[i+j+1])/Point;
         if(r>0) sump+=r;
         else sumn-=r;
        }
      double sum=sump+sumn;
      if(sum==0) {Real[i]=0; continue;}
      Real[i]=(sump/sum)*100;
      //***************
      double stat=EMPTY_VALUE;
      //***
      for(j=0;j<pr_period;j++)
        {
         dat[dat_cnt][j]=Real[i+j+progn];
        }
      dat[dat_cnt][99]=Real[i];
      dat_cnt++;
      //***
      res=0; res_cnt=0;
      int g=dat_cnt;
      if(glubina>0 && dat_cnt>=glubina) g=glubina;
      for(k=g-1;k>=0;k--)
        {
         double nerr=0,nerr_cnt=0;
         for(j=0;j<pr_period;j++)
           {
            nerr+=MathAbs(dat[k][j]-Real[i+j]);
            nerr_cnt++;
           }
         nerr/=nerr_cnt;
         if(nerr<=err) {res_mas[res_cnt]=dat[k][99]; res_cnt++;}
        }
      if(res_cnt>0)
        {
         if(exp) stat=calc_res_exp(res_cnt);
         else stat=calc_res(res_cnt);
        }
      //*** 
      Prognoz[i]=stat;
     }
//**************
/*if(std_err)
    {
    double serr=0, secnt=0;
    for(i=limit-pr_period-progn;i>0;i--)
     {
     if(Prognoz[i+progn]!=EMPTY_VALUE)
      {
      serr+=MathAbs(Real[i]-Prognoz[i+progn]);
      secnt++;
      }
     }
    Alert("ошибка прогнозирования = ",serr/secnt); 
    }*/

//----
   return(0);
  }
//+------------------------------------------------------------------+
double sigmoid(double val,double a)
  {
   double res=1.0/(1.0+MathExp(-1.0*a*(val-50.0)));
   return(res*100);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double calc_res_exp(int cnt)
  {
   double val=2.0/cnt;
   double inc=2.0;
   double rr=0;
   for(int i=0;i<cnt;i++)
     {
      rr+=res_mas[i]*inc;
      inc-=val;
     }
//if(sigm) return(sigmoid(rr/cnt,alpha));
   return(rr/cnt);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double calc_res(int cnt)
  {
   double rr=0;
   for(int i=0;i<cnt;i++)
     {
      rr+=res_mas[i];
     }
//if(sigm) return(sigmoid(rr/cnt,alpha));
   return(rr/cnt);
  }
//+------------------------------------------------------------------+
