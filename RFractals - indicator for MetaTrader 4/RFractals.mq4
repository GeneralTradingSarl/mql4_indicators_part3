//+------------------------------------------------------------------+
//|                                                    RFractals.mq4 |
//|                                                       Lizhniyk E |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Lizhniyk E"
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_width1 1
#property indicator_width2 1
#property indicator_color1 Blue
#property indicator_color2 Red
//---- input parameters
//extern int       rpoint=150;
extern int       range_fractal=5; //ранг фрактала (нечётные числа не менее 3)
//---- buffers
double Ext1[];
double Ext2[];
int center=0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   if(range_fractal % 2 == 0) range_fractal++;
   if(range_fractal<3) range_fractal=3;
   center=range_fractal/2 + 1 ;
   //scenter=range_fractal/2;
   SetIndexStyle(0,DRAW_ARROW);
   SetIndexArrow(0,217);
   SetIndexBuffer(0,Ext1);
   SetIndexEmptyValue(0,0.0);
   SetIndexStyle(1,DRAW_ARROW);
   SetIndexArrow(1,218);
   SetIndexBuffer(1,Ext2);
   SetIndexEmptyValue(1,0.0);
   SetIndexLabel(0,"Fractal Up");
   SetIndexLabel(1,"Fractal Down");
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
double cur=0;
bool found=false;
int start()
  {
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+range_fractal;   
   
//----
   for(int i=limit;i>=0;i--)
    {
    //*******create history******
    //*******fractal up**********
    found=false;
    cur=High[i+center];
    if(cur>High[i+1] && cur>High[i+range_fractal]) found=true;
    else found=false; 
    if(found) 
     {
     for(int j=1;j<center;j++)
       {
       if(cur>=High[i+center-j] && cur>=High[i+center+j]) found=true;
       else {found=false; break;}
       }  
      } 
    if(found) {Ext1[i+center]=cur; Ext1[i+center+1]=0;}
    //*************fractal down************* 
    found=false;
    cur=Low[i+center]; 
    if(cur<Low[i+1] && cur<Low[i+range_fractal]) found=true;
    else found=false; 
    if(found) 
     {
     for(int k=1;k<center;k++)
       {
       if(cur<=Low[i+center-k] && cur<=Low[i+center+k]) found=true;
       else {found=false; break;}
       }  
      } 
    if(found) {Ext2[i+center]=cur; Ext2[i+center+1]=0;}
    }
//----
   return(0);
  }
//+------------------------------------------------------------------+