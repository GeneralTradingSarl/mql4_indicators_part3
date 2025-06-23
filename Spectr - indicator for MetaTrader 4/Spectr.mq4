//+------------------------------------------------------------------+
//|                                                       Spectr.mq4 |
//|                                                     Yuriy Tokman |
//|                                            yuriytokman@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman"
#property link      "yuriytokman@gmail.com"

#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Red
#property indicator_color2 Orange
#property indicator_color3 Yellow
#property indicator_color4 Lime
#property indicator_color5 Blue
#property indicator_color6 DodgerBlue
#property indicator_color7 DarkViolet
#property indicator_color8 DimGray

//---- input parameters

extern int       iPeriod=240;
extern int       iStartFrom=1;
extern int       VV = 1;  //Высота волны
extern int       pm = 1;  //Период усреднения для вычисления скользящего среднего.

double A[],B[],R[],F[];

//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double ExtMapBuffer7[];
double ExtMapBuffer8[];


int LastLeftBar;
int LastRightBar;
int LastLeftTime;
int LastRightTime;
int LastStartFrom;
int LastiStartFrom;
int LastiPeriod;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
SetIndexStyle(0,DRAW_LINE,DRAW_LINE,1);
   SetIndexBuffer(0,ExtMapBuffer1);
   
   SetIndexStyle(1,DRAW_LINE,DRAW_LINE,1);
   SetIndexBuffer(1,ExtMapBuffer2);   
   
   SetIndexStyle(2,DRAW_LINE,DRAW_LINE,1);
   SetIndexBuffer(2,ExtMapBuffer3);      
   
   SetIndexStyle(3,DRAW_LINE,DRAW_LINE,1);
   SetIndexBuffer(3,ExtMapBuffer4);   
   
   SetIndexStyle(4,DRAW_LINE,DRAW_LINE,1);
   SetIndexBuffer(4,ExtMapBuffer5);     
   
   SetIndexStyle(5,DRAW_LINE,DRAW_LINE,1);
   SetIndexBuffer(5,ExtMapBuffer6);        
   
   SetIndexStyle(6,DRAW_LINE,DRAW_LINE,1);
   SetIndexBuffer(6,ExtMapBuffer7);
   
   SetIndexStyle(7,DRAW_LINE,DRAW_LINE,1);
   SetIndexBuffer(7,ExtMapBuffer8);
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
   //=====================================================================================================    

      static int LastBars=0;

      if(iStartFrom==LastiStartFrom && iPeriod==LastiPeriod)if(Bars<LastBars+1)return(0);
      LastiStartFrom=iStartFrom;
      LastiPeriod=iPeriod;
      LastBars=Bars;
         
      ArrayInitialize(ExtMapBuffer1,EMPTY_VALUE);
      ArrayInitialize(ExtMapBuffer2,EMPTY_VALUE);
      ArrayInitialize(ExtMapBuffer3,EMPTY_VALUE);
      ArrayInitialize(ExtMapBuffer4,EMPTY_VALUE);
      ArrayInitialize(ExtMapBuffer5,EMPTY_VALUE);
      ArrayInitialize(ExtMapBuffer6,EMPTY_VALUE);
      ArrayInitialize(ExtMapBuffer7,EMPTY_VALUE);
      ArrayInitialize(ExtMapBuffer8,EMPTY_VALUE);
   
   //=====================================================================================================    

      int tPeriod; 
      double tVal_0;
      double tVal_1;
      double tB;
      double tMaxDev;
      double tStdError; 
      double tRSquared;
      double Arr[];

      fLinearRegressionAll2(iStartFrom,iStartFrom+iPeriod-1,0,tPeriod,tVal_0,tVal_1,tB,tMaxDev,tStdError,tRSquared,Arr);
                
   //======================================================================================================      
         
      fFurie(Arr,A,B,R,F);
   //======================================================================================================      
         
      int N=ArraySize(Arr);
         for(int i=0;i<N;i++){
            int ii=i+iStartFrom;
            double MA = iMA(NULL,0,pm,0,0,4,ii);
            ExtMapBuffer1[ii]=MA+(A[1]*MathSin(1*6.28*i/(N-1))+B[1]*MathCos(1*6.28*i/(N-1)))*VV;
            ExtMapBuffer2[ii]=MA+(A[2]*MathSin(2*6.28*i/(N-1))+B[2]*MathCos(2*6.28*i/(N-1)))*VV;               
            ExtMapBuffer3[ii]=MA+(A[3]*MathSin(3*6.28*i/(N-1))+B[3]*MathCos(3*6.28*i/(N-1)))*VV;
            ExtMapBuffer4[ii]=MA+(A[4]*MathSin(4*6.28*i/(N-1))+B[4]*MathCos(4*6.28*i/(N-1)))*VV;               
            ExtMapBuffer5[ii]=MA+(A[5]*MathSin(5*6.28*i/(N-1))+B[5]*MathCos(5*6.28*i/(N-1)))*VV;               
            ExtMapBuffer6[ii]=MA+(A[6]*MathSin(6*6.28*i/(N-1))+B[6]*MathCos(6*6.28*i/(N-1)))*VV;
            ExtMapBuffer7[ii]=MA+(A[7]*MathSin(7*6.28*i/(N-1))+B[7]*MathCos(7*6.28*i/(N-1)))*VV;               
            ExtMapBuffer8[ii]=MA+(A[8]*MathSin(8*6.28*i/(N-1))+B[8]*MathCos(8*6.28*i/(N-1)))*VV;                 
         }
   
//----
   return(0);
  }
//+------------------------------------------------------------------+

int fLinearRegressionAll2(int i0,int i1, int aPrice, int & aPeriod, double & aVal_0, double & aVal_1, double & aB, double & aMaxDev, double & aStdError, double & aRSquared,double & aArr[]){
   int rRetError=0;
   double x,y,y1,y2,sumy,sumx,sumxy,sumx2,sumy2,sumx22,sumy22,div1,div2;   
   aPeriod=i1-i0+1;
   sumy=0.0;sumx=0.0;sumxy=0.0;sumx2=0.0;sumy2=0.0;
      for(int i=0; i<aPeriod; i++){
         y=iMA(NULL,0,1,0,0,aPrice,i0+i);
         x=i;
         sumy+=y;
         sumxy+=y*i;
         sumx+=x;
         sumx2+=MathPow(x,2);  
         sumy2+=MathPow(y,2);         
      } 
   sumx22=MathPow(sumx,2);  
   sumy22=MathPow(sumy,2);      
   div1=sumx2*aPeriod-sumx22;
   div2=MathSqrt((aPeriod*sumx2-sumx22)*(aPeriod*sumy2-sumy22));   

   //---- regression line ----
   
      if(div1!=0.0){
         aB=(sumxy*aPeriod-sumx*sumy)/div1;
         aVal_0=(sumy-sumx*aB)/aPeriod;
         aVal_1=aVal_0+aB*(aPeriod-1);
         rRetError+=-1;
      }
      else{
         rRetError+=-1;      
      }

   //--- stderr & maxdev

   aMaxDev=0;aStdError=0;
   
      for(i=0;i<aPeriod;i++){
         y1=iMA(NULL,0,1,0,0,aPrice,i0+i);
         y2=aVal_0+aB*i;
         aMaxDev=MathMax(MathAbs(y1-y2),aMaxDev);
         aStdError+=MathPow(y1-y2,2);
      }
      
   aStdError=MathSqrt(aStdError/aPeriod);

   //--- rsquared ---

      if(div2!=0){
         aRSquared=MathPow((aPeriod*sumxy-sumx*sumy)/div2,2);   
      }   
      else{
         rRetError+=-2;
      }
   
   //----
   
   ArrayResize(aArr,aPeriod);
      for(i=0; i<aPeriod; i++){
         y=iMA(NULL,0,1,0,0,aPrice,i0+i);
         x=aVal_0+i*(aVal_1-aVal_0)/aPeriod;
         aArr[i]=y-x;
      } 
   return(rRetError);   
}

void fFurie(double aArr[],double & aA[],double & aB[],double & aR[], double & aF[]){
   int tN=ArraySize(aArr);
   int tM=tN/2;
   
   ArrayResize(aA,tM);
   ArrayResize(aB,tM);  
   ArrayResize(aR,tM); 
   ArrayResize(aF,tM);                            
   
      for (int ti=1;ti<tM;ti++){
         aA[ti]=0;
         aB[ti]=0;
            for(int tj=0;tj<tN;tj++){
               aA[ti]+=aArr[tj]*MathSin(ti*6.28*tj/tN);
               aB[ti]+=aArr[tj]*MathCos(ti*6.28*tj/tN);
            }
         aA[ti]=2*aA[ti]/tN;
         aB[ti]=2*aB[ti]/tN;  
         aR[ti]=MathSqrt(MathPow(aA[ti],2)+MathPow(aB[ti],2));
         aF[ti]=fMyArcTan(aB[ti],aA[ti]);
      }
            
}

double fMyArcTan(double aS,double aC){
   if(aS==0){
      return(0);   
   }
   if(aC==0){
      if(aS>0){
         return(MathArctan(1)*2);
      }
      else{
         if(aS<0){
            return(MathArctan(1)*6);         
         }
      }
   }
   else{
      if(aS>0){
         if(aC>0){
            return(MathArctan(aS/aC));  
         }
         else{
            return(MathArctan(aS/aC)+MathArctan(1)*4);          
         }   
      }
      else{
         if(aC>0){
            return(MathArctan(aS/aC)+MathArctan(1)*8);           
         }
         else{
            return(MathArctan(aS/aC)+MathArctan(1)*4);           
         }      
      }
   }
}