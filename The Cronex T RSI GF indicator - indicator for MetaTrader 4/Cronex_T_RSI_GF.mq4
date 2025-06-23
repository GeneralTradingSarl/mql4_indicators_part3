//+------------------------------------------------------------------+
//|                                              Cronex T RSI GF.mq4 |
//|                                        Copyright © 2008, Cronex. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property  copyright "Copyright © 2008, Cronex"
#property  link      "http://www.metaquotes.net/"
//----
//#property indicator_chart_window
#property  indicator_separate_window
#property indicator_buffers 8
#property indicator_color1 DarkOrange
#property indicator_color2 SteelBlue
#property indicator_color3 Blue
#property indicator_color4 Black
#property indicator_color5 Black
#property indicator_color6 Blue
#property indicator_color7 Red
#property indicator_color8 Black


#property indicator_width1 2
#property indicator_width6 1
#property indicator_width7 1
//-----Level lines   
#property  indicator_level1  10
#property  indicator_level2 -10
//#property  indicator_level3 -10
//----
extern int     RSIPeriod=16;
extern double  TCurvature=0.618;
extern int     MAPeriod=10;
extern int     BandsPeriod=20;
extern int     BandsDeviations=2;
extern int     BandsShift=0;


//extern int       RightMore=4;
//extern int       RightLess=15;
//extern int       LeftMore=20;

//----
double RSITArray[];
double RSIArray[];
double BBMDArray[];
double BBUPArray[];
double BBDNArray[];
double MaxArray[];
double MinArray[];
double MAArray[];

double e1,e2,e3,e4,e5,e6;
double c1,c2,c3,c4;
double n,w1,w2,b2,b3;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators setting

   SetIndexBuffer(0,RSITArray);
   SetIndexBuffer(1,RSIArray);
   SetIndexBuffer(2,BBMDArray);
   SetIndexBuffer(3,BBUPArray);
   SetIndexBuffer(4,BBDNArray);
   SetIndexBuffer(5,MaxArray);
   SetIndexBuffer(6,MinArray);
   SetIndexBuffer(7,MAArray);
   
//---- drawing settings
   SetIndexStyle(0,DRAW_LINE);
   SetIndexStyle(1,DRAW_LINE);
   
   SetIndexStyle(2,DRAW_LINE);   
   SetIndexStyle(3,DRAW_LINE);
   SetIndexStyle(4,DRAW_LINE);

   SetIndexStyle(5,DRAW_ARROW);  
   SetIndexStyle(6,DRAW_ARROW);
   SetIndexStyle(7,DRAW_LINE);
   
   SetIndexArrow(5,174);
   SetIndexArrow(6,174);
   
   SetIndexEmptyValue(5,0.0);
   SetIndexEmptyValue(6,0.0);
//---- name for DataWindow and indicator subwindow label
   SetIndexLabel(0,"RSI T");
   SetIndexLabel(1,"RSI");
   SetIndexLabel(2,"BB Middle");
   SetIndexLabel(3,"BB Upper");
   SetIndexLabel(4,"BB Lower");
   SetIndexLabel(5,"Max Point");   
   SetIndexLabel(6,"Min Point");  
   SetIndexLabel(7,"MA");
   //
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS));
   IndicatorShortName("Cronex T RSI GF("+RSIPeriod+")");   
   
//---- variable reset
   e1=0; e2=0; e3=0; e4=0; e5=0; e6=0;
   c1=0; c2=0; c3=0; c4=0;
   n=0;
   w1=0; w2=0;
   b2=0; b3=0;
   //
   b2=TCurvature*TCurvature;
   b3=b2*TCurvature;
   c1=-b3;
   c2=(3*(b2+b3));
   c3=-3*(2*b2+TCurvature+b3);
   c4=(1+3*TCurvature+b3+3*b2);
   n=RSIPeriod;
   //
   if (n<1) n=1;
   n=1 + 0.5*(n-1);
   w1=2/(n + 1);
   w2=1 - w1;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int Limit=300;
   double Max;
   int MaxB;
//---- indicator calculation
   for(int i=Limit; i>=0; i--)
     {
//      RSIArray[i]=iRSI(NULL,0,RSIPeriod,PRICE_WEIGHTED,i);
      RSIArray[i]=(
                    iRSI(NULL,0,RSIPeriod+4*0,PRICE_WEIGHTED,i)+
                    iRSI(NULL,0,RSIPeriod+4*1,PRICE_WEIGHTED,i)+
                    iRSI(NULL,0,RSIPeriod+4*2,PRICE_WEIGHTED,i)+
                    iRSI(NULL,0,RSIPeriod+4*3,PRICE_WEIGHTED,i))/4-50;      

      e1=w1*RSIArray[i] + w2*e1;
      e2=w1*e1 + w2*e2;
      e3=w1*e2 + w2*e3;
      e4=w1*e3 + w2*e4;
      e5=w1*e4 + w2*e5;
      e6=w1*e5 + w2*e6;
//=====================================================
      RSITArray[i]=c1*e6 + c2*e5 + c3*e4 + c4*e3;
//=====================================================      


     }

//================================================================================================ 
    for(int j=Limit-1;j>=0;j--)
      {

      BBMDArray[j]=iBandsOnArray(RSITArray,0,BandsPeriod,BandsDeviations,BandsShift,MODE_MAIN,j);
      BBUPArray[j]=iBandsOnArray(RSITArray,0,BandsPeriod,BandsDeviations,BandsShift,MODE_UPPER,j);
      BBDNArray[j]=iBandsOnArray(RSITArray,0,BandsPeriod,BandsDeviations,BandsShift,MODE_LOWER,j);

       if(RSITArray[j+1]<= 1  &&   1 < RSITArray[j])MaxArray[j]=RSITArray[j];
       if(RSIArray[j+1]>= 25 &&  25 > RSIArray[j])MaxArray[j]=RSITArray[j];
       if(RSITArray[j+1]<=-10 && -10 < RSITArray[j])MaxArray[j]=RSITArray[j];       

       if(RSITArray[j+1]>=-1  &&  -1 > RSITArray[j])MinArray[j]=RSITArray[j];       
       if(RSIArray[j+1]<=-25 && -25 < RSIArray[j])MinArray[j]=RSITArray[j];
       if(RSITArray[j+1]>= 10 &&  10 > RSITArray[j])MinArray[j]=RSITArray[j];
      }
      
      
      for(i=0; i<=Limit; i++)
       {
         if(RSITArray[0]>0)
             if(RSITArray[i]<=0) break;

         if(RSITArray[0]<0)
             if(RSITArray[i]>=0)break;
       }       

      double LastWaveArray[];
      int LWACount=ArrayResize(LastWaveArray,i);
      
      ArrayCopy(LastWaveArray,RSITArray,0,0,i);


      if(RSITArray[0]>0)
      {
        int Ind=ArrayMaximum(LastWaveArray);
        if (Ind!=0 && RSITArray[Ind]>5)MaxArray[Ind]=RSITArray[Ind];       
      }
      
           
      
      if(RSITArray[0]<0)
      {
        Ind=ArrayMinimum(LastWaveArray);
        if (Ind!=0 && RSITArray[Ind]<-5)MinArray[Ind]=RSITArray[Ind]; 
      }
     
      
//----
   return(0);
  }
//+------------------------------------------------------------------+