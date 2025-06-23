//+--------------------------------------------------------------------------------------------------+
//|                                                                     b_Regression_Analysis_v2.mq4 |
//|                                                                    Copyright © 2011, barmenteros |
//|                                                            http://www.mql4.com/users/barmenteros |
//+--------------------------------------------------------------------------------------------------+
//| This version:                                                                                    |
//|    -corrects error in calculating the standard deviation;                                        |
//|    -makes more use of the indicators of MQL4 standard library;                                   |
//|    -improves the functions of calculation of the regressions;                                    |
//|    -frees a buffer. It only uses 3 buffers now;                                                  |
//|    -adds a Comment parameter to enable/disable comments on the screen.                           |
//| The changes do not affect the indicator from the visual point of view, however, the values shown |
//| on screen are corrected.                                                                         |
//+--------------------------------------------------------------------------------------------------+
#property copyright "barmenteros"
#property link      "barmenteros.fx@gmail.com"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Magenta
#property indicator_color2 Blue
#property indicator_color3 Blue

// ---- inputs
// dp_limiter  It should be >2 . If not it will be autoset to default value
// endpos      Last value position to the right. It should be >0. If not it will be autoset to
//             default value
// record      [true] - record on; [false] - record off
extern int       dp_limiter   =100;             // Number of data points
extern int       endpos       =0;               // Last value position
extern double    multStdDev   =1.96;            // Bands separation
extern bool      comments     =true;            // Comment on/off
extern bool      record       =false;           // Record info into a file text
// ---- buffers
double RegBfr[];
double BandUpBfr[];
double BandDwBfr[];
// ---- global variables
int      c_handle,p_handle,
         current_day,previous_day;
double   errorstddev[4],
         data[1],
         regression[1],
         regressionerror[1];

//+--------------------------------------------------------------------------------------------------+
//| Custom indicator initialization function                                                         |
//+--------------------------------------------------------------------------------------------------+
int init()
  {
// ---- checking inputs
   if(dp_limiter<3) {dp_limiter=100; Alert("dp_limiter readjusted");}                        
   if(endpos<0) {endpos=0; Alert("endpos readjusted");}                        
// ---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexLabel(1,"UpperBand");
   SetIndexStyle(2,DRAW_LINE);
   SetIndexLabel(2,"LowerBand");
// ---- mapping
   SetIndexBuffer(0,RegBfr);
   SetIndexBuffer(1,BandUpBfr);
   SetIndexBuffer(2,BandDwBfr);
// ---- resize arrays
   ArrayResize(data,dp_limiter);
   ArrayResize(regression,dp_limiter);
   ArrayResize(regressionerror,dp_limiter);
// ---- done
   return(0);
  }

//+--------------------------------------------------------------------------------------------------+
//| Custom indicator iteration function                                                              |
//+--------------------------------------------------------------------------------------------------+
int start()
  {
   int i;
// ---- file recording   
   if(record)
      {
       previous_day=current_day;
       current_day=TimeDay(TimeCurrent());
       if(current_day!=previous_day)
         {
          p_handle=c_handle;
          c_handle=FileOpen(StringConcatenate(TimeYear(TimeCurrent()),"-",
                            TimeMonth(TimeCurrent()),"-",current_day,"-",
                            Symbol(),"-b_Regression_Analysis.txt"),
                            FILE_CSV|FILE_READ|FILE_WRITE);
          if(c_handle>0 && c_handle!=p_handle)
            {
             if(p_handle>0)
               FileClose(p_handle);
             FileWrite(c_handle,"time","error[LinReg]","error[QuadReg]",
                       "error[LogReg]","error[ExpReg]");
            }
         }
      }
// ----   
   ArrayInitialize(data,EMPTY_VALUE);
   for(i=0;i<dp_limiter;i++)
      data[i]=iClose(NULL,0,i+endpos);
   // ----   
   ArrayInitialize(regression,EMPTY_VALUE);
   iPolReg(dp_limiter, 1, data, regression);
   ArrayInitialize(regressionerror,EMPTY_VALUE);
   for(i=0;i<dp_limiter;i++)
      regressionerror[i]=MathAbs(data[i]-regression[i]);
   errorstddev[0]=iStdDevOnArray(regressionerror,0,dp_limiter,0,MODE_SMA,0);
   // ----
   ArrayInitialize(regression,EMPTY_VALUE);
   iPolReg(dp_limiter, 2, data, regression);
   for(i=0;i<dp_limiter;i++)
      regressionerror[i]=MathAbs(data[i]-regression[i]);
   errorstddev[1]=iStdDevOnArray(regressionerror,0,dp_limiter,0,MODE_SMA,0);
   // ----
   ArrayInitialize(regression,EMPTY_VALUE);
   iLogReg(dp_limiter, data, regression);
   for(i=0;i<dp_limiter;i++)
      regressionerror[i]=MathAbs(data[i]-regression[i]);
   errorstddev[2]=iStdDevOnArray(regressionerror,0,dp_limiter,0,MODE_SMA,0);
   // ----
   ArrayInitialize(regression,EMPTY_VALUE);
   iExpReg(dp_limiter, data, regression);
   for(i=0;i<dp_limiter;i++)
      regressionerror[i]=MathAbs(data[i]-regression[i]);
   errorstddev[3]=iStdDevOnArray(regressionerror,0,dp_limiter,0,MODE_SMA,0);
// ----
   if(record)
      if(c_handle>0)
         FileWrite(c_handle,StringConcatenate(TimeHour(TimeCurrent()),":",
                   TimeMinute(TimeCurrent()),":",TimeSeconds(TimeCurrent())),
                   errorstddev[0],errorstddev[1],errorstddev[2],errorstddev[3]);
// ----
   BestReg();
   ConfidenceBands();
// ----
   return(0);
  }

//+--------------------------------------------------------------------------------------------------+
//| Custom indicator deinitialization function                                                       |
//+--------------------------------------------------------------------------------------------------+
int deinit()
  {
   if(comments)
      Comment("");
   if(c_handle>0)
      FileClose(c_handle);
// ----
   return(0);
  }

void iPolReg(int datapoints, int grade, double& array1[], double& array2[])
   {
    // y=c0+c1x+c2x^2+c3x^3...cnx^n
    // grade+1    número de funciones y de coeficientes a calcular
    // 2*grade    valor del mayor exponente
    // datapoints número de valores a considerar
    // pos        first value position (left to right direction)
    int     pos,exp,k,row,col,
            initialrow,initialcol,
            loop,i,j;
    double  sumx,sumyx,sum;
    double  sumxvalues[1],
            sumyxvalues[1],
            matrix[1][10],
            constant[1];
    pos=datapoints-1;
    ArrayResize(sumxvalues,2*grade+1);
    ArrayResize(sumyxvalues,grade+1);
    ArrayInitialize(sumxvalues,0.0);
    ArrayInitialize(sumyxvalues,0.0);
    sumxvalues[0]=datapoints;
    for(exp=1;exp<=2*grade;exp++)
      {
       sumx=0.0;
       sumyx=0.0;
       for(k=1;k<=datapoints;k++)
         {
          sumx+=MathPow(k,exp);
          if(exp==1)
            sumyx+=array1[pos-k+1];
          else if(exp<=grade+1)
            sumyx+=array1[pos-k+1]*MathPow(k,exp-1);
         }
       sumxvalues[exp]=sumx;
       if(sumyx!=0.0)
         sumyxvalues[exp-1]=sumyx;
      }
    ArrayResize(matrix,grade+1);
    ArrayInitialize(matrix,0.0);
    for(row=0;row<=grade;row++)
      for(col=0;col<=grade;col++)
         matrix[row][col]=sumxvalues[row+col];
    initialrow=1;
    initialcol=1;
    for(loop=1;loop<=grade;loop++)
      {
       for(row=initialrow;row<=grade;row++)
         {
          sumyxvalues[row]=sumyxvalues[row]-(matrix[row][loop-1]/matrix[loop-1][loop-1])*sumyxvalues[loop-1];
          for(col=initialcol;col<=grade;col++)
            matrix[row][col]=matrix[row][col]-(matrix[row][loop-1]/matrix[loop-1][loop-1])*matrix[loop-1][col];
         }
       initialrow++;
       initialcol++;
      }
    ArrayResize(constant,grade+1);
    ArrayInitialize(constant,0.0);
    j=0;
    for(i=grade;i>=0;i--)
      {
       if(j==0)
          constant[i]=sumyxvalues[i]/matrix[i][i];
       else
         {
          sum=0.0;
          for(k=j;k>0;k--)
            sum+=constant[i+k]*matrix[i][i+k];
          constant[i]=(sumyxvalues[i]-sum)/matrix[i][i];
         }
       j++;
      }
    ArrayResize(array2,datapoints);
    ArrayInitialize(array2,EMPTY_VALUE);
    k=1;
    for(i=datapoints-1;i>=0;i--)
      {
       sum=0.0;
       for(j=0;j<=grade;j++)
         sum+=constant[j]*MathPow(k,j);
       array2[i]=sum;
       k++;
      }
   }

void iLogReg(int datapoints, double& array1[], double& array2[])
   {
    // y=c0*x^c1
    // lny=lnc0+c1lnx <=> y=a+bx
    // c0=e^a
    // c1=b
    int     pos,exp,k,row,col,
            initialrow,initialcol,
            loop,i,j;
    double  sumx,sumyx,
            lnx,a;
    double  sumxvalues[1],
            sumyxvalues[1],
            matrix[1][10],
            constant[1];
    pos=datapoints-1;
    ArrayResize(sumxvalues,3);
    ArrayResize(sumyxvalues,2);
    ArrayInitialize(sumxvalues,0.0);
    ArrayInitialize(sumyxvalues,0.0);
    sumxvalues[0]=datapoints;
    for(exp=1;exp<=2;exp++)
      {
       sumx=0.0;
       sumyx=0.0;
       for(k=1;k<=datapoints;k++)
         {
          lnx=MathLog(k);
          sumx+=MathPow(lnx,exp);
          if(exp==1)
            sumyx+=MathLog(array1[pos-k+1]);
          else
            sumyx+=MathLog(array1[pos-k+1])*MathPow(lnx,exp-1);
         }
       sumxvalues[exp]=sumx;
       if(sumyx!=0.0)
         sumyxvalues[exp-1]=sumyx;
      }
    ArrayResize(matrix,2);
    ArrayInitialize(matrix,0.0);
    for(row=0;row<=1;row++)
      for(col=0;col<=1;col++)
         matrix[row][col]=sumxvalues[row+col];
    sumyxvalues[1]=sumyxvalues[1]-(matrix[1][0]/matrix[0][0])*sumyxvalues[0];
    matrix[1][1]=matrix[1][1]-(matrix[1][0]/matrix[0][0])*matrix[0][1];
    ArrayResize(constant,2);
    ArrayInitialize(constant,0.0);
    constant[1]=sumyxvalues[1]/matrix[1][1];
    a=(sumyxvalues[0]-(constant[1]*matrix[0][1]))/matrix[0][0];
    constant[0]=MathExp(a);
    ArrayResize(array2,datapoints);
    ArrayInitialize(array2,EMPTY_VALUE);
    k=1;
    for(i=datapoints-1;i>=0;i--)
      {
       array2[i]=constant[0]*MathPow(k,constant[1]);
       k++;
      }
   }

void iExpReg(int datapoints, double& array1[], double& array2[])
   {
    // y=c0*e^(xc1)
    // lny=lnc0+c1x <=> y=a+bx
    // c0=e^a
    // c1=b
    int     pos,exp,k,row,col,
            initialrow,initialcol,
            loop,i,j;
    double  sumx,sumyx,a;
    double  sumxvalues[1],
            sumyxvalues[1],
            matrix[1][10],
            constant[1];
    pos=datapoints-1;
    ArrayResize(sumxvalues,3);
    ArrayResize(sumyxvalues,2);
    ArrayInitialize(sumxvalues,0.0);
    ArrayInitialize(sumyxvalues,0.0);
    sumxvalues[0]=datapoints;
    for(exp=1;exp<=2;exp++)
      {
       sumx=0.0;
       sumyx=0.0;
       for(k=1;k<=datapoints;k++)
         {
          sumx+=MathPow(k,exp);
          if(exp==1)
            sumyx+=MathLog(array1[pos-k+1]);
          else
            sumyx+=MathLog(array1[pos-k+1])*MathPow(k,exp-1);
         }
       sumxvalues[exp]=sumx;
       if(sumyx!=0.0)
         sumyxvalues[exp-1]=sumyx;
      }
    ArrayResize(matrix,2);
    ArrayInitialize(matrix,0.0);
    for(row=0;row<=1;row++)
      for(col=0;col<=1;col++)
         matrix[row][col]=sumxvalues[row+col];
    sumyxvalues[1]=sumyxvalues[1]-(matrix[1][0]/matrix[0][0])*sumyxvalues[0];
    matrix[1][1]=matrix[1][1]-(matrix[1][0]/matrix[0][0])*matrix[0][1];
    ArrayResize(constant,2);
    ArrayInitialize(constant,0.0);
    constant[1]=sumyxvalues[1]/matrix[1][1];
    a=(sumyxvalues[0]-(constant[1]*matrix[0][1]))/matrix[0][0];
    constant[0]=MathExp(a);
    ArrayResize(array2,datapoints);
    ArrayInitialize(array2,EMPTY_VALUE);
    k=1;
    for(i=datapoints-1;i>=0;i--)
      {
       array2[i]=constant[0]*MathExp(k*constant[1]);
       k++;
      }
   }

void BestReg()
   {
    string  short_name;
    double  currentstddev;
    int     c_stddevindex,i;
    if(comments)   
       Comment("LinReg=",errorstddev[0]," || QuadReg=",errorstddev[1],
               " || LogReg=",errorstddev[2]," || ExpReg=",errorstddev[3]);
    currentstddev=errorstddev[0];
    c_stddevindex=0;
    for(i=1;i<=3;i++)
      {
       if(errorstddev[i]<currentstddev)
         {
          currentstddev=errorstddev[i];
          c_stddevindex=i;
         }
      }
    switch(c_stddevindex)
      {
       case 0 : iPolReg(dp_limiter, 1, data, regression); short_name="LinReg";  break;
       case 1 : iPolReg(dp_limiter, 2, data, regression); short_name="QuadReg"; break;
       case 2 : iLogReg(dp_limiter, data, regression);    short_name="LogReg";  break;
       case 3 : iExpReg(dp_limiter, data, regression);    short_name="ExpReg";  break;
       default :iPolReg(dp_limiter, 1, data, regression); short_name="LinReg";
      }
    SetIndexLabel(0,short_name);
    IndicatorShortName(short_name+"("+dp_limiter+")");
    ArrayInitialize(RegBfr,EMPTY_VALUE);
    for(i=dp_limiter-1;i>=0;i--)
      RegBfr[i+endpos]=regression[i];
   }

void ConfidenceBands()
   {
    int     i;
    double  sum,variance;
    sum=0.0;
    for(i=dp_limiter-1;i>=0;i--)
      sum+=(data[i]-RegBfr[i+endpos])*(data[i]-RegBfr[i+endpos]);
    variance=MathSqrt(sum/dp_limiter);
    ArrayInitialize(BandUpBfr,EMPTY_VALUE);
    ArrayInitialize(BandDwBfr,EMPTY_VALUE);
    for(i=dp_limiter-1;i>=0;i--)
      {
       BandUpBfr[i+endpos]=RegBfr[i+endpos]+(multStdDev*variance);
       BandDwBfr[i+endpos]=RegBfr[i+endpos]-(multStdDev*variance);
      }
   }

