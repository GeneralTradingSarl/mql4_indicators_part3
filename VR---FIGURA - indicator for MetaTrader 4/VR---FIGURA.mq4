//+------------------------------------------------------------------+
//|                            VR---FIGURA                           |
//|                                                                  |
//|                  http://www.trading-go.ru                        |
//+------------------------------------------------------------------+

#property copyright " Trading-go "
#property link      " www.trading-go.ru "
#property indicator_chart_window

extern int   Days  = 20  ;               
extern int   WIDTH =  3  ;                
int deinit ()
{ for(int x=1;x<=Days;x++)  
 {
ObjectDelete("opma"+x);
ObjectDelete("opmu"+x);                
ObjectDelete("opmq"+x);
ObjectDelete("opms"+x);
 }
}
int start()
  {

int timup=0;
int timdw=0;
if (Period()!=60)
{
Comment("SET THE TIME PERIOD 1H ");
for(int P=1;P<=Days;P++)  
 {
ObjectDelete("opma"+P);
ObjectDelete("opmu"+P);                       
ObjectDelete("opmq"+P);
ObjectDelete("opms"+P);
 }
return(0);}
 for(int x=1;x<=Days;x++)  
 {
 
double opp = NormalizeDouble(iOpen (Symbol(),1440,x-1),Digits);
double cl  = NormalizeDouble(iOpen (Symbol(),1440,x  ),Digits); 

int  timcl = iTime(Symbol(),1440,x);  
int  timop = timcl+86400;             

double max=0;
double min=0;
 int t =24*x;
 for(int i=t-24+Hour();i<=t+Hour();i++)  
 {
 if (High[i]>max)
 {
 max  =High[i];    
 timup=Time[i];   
 }
 if (min==0||Low[i]<min)
 {
 min=Low[i];    
 timdw=Time[i];   
 }
 }
if (Period()==60){ 
ObjectCreate("opma"+x,OBJ_TREND,0,timop,opp,timup,max); 
ObjectSet   ("opma"+x,OBJPROP_RAY,false);
ObjectSet   ("opma"+x,OBJPROP_COLOR,Blue);
ObjectSet   ("opma"+x,OBJPROP_WIDTH,WIDTH);

ObjectCreate("opmu"+x,OBJ_TREND,0,timup,max,timcl,cl);
ObjectSet   ("opmu"+x,OBJPROP_RAY,false);
ObjectSet   ("opmu"+x,OBJPROP_COLOR,Red);
ObjectSet   ("opmu"+x,OBJPROP_WIDTH,WIDTH);

ObjectCreate("opmq"+x,OBJ_TREND,0,timop,opp,timdw,min);
ObjectSet   ("opmq"+x,OBJPROP_RAY,false);
ObjectSet   ("opmq"+x,OBJPROP_COLOR,LawnGreen);
ObjectSet   ("opmq"+x,OBJPROP_WIDTH,WIDTH);

ObjectCreate("opms"+x,OBJ_TREND,0,timdw,min,timcl,cl);
ObjectSet   ("opms"+x,OBJPROP_RAY,false);
ObjectSet   ("opms"+x,OBJPROP_COLOR,Blue);
ObjectSet   ("opms"+x,OBJPROP_WIDTH,WIDTH);
}
 }
}

[i];    //Время максимума внутри дня
 }
 if (min==0||Low[i]<min)
 {
 min=Low[i];      //Поиск минимума в нутри дня
 timdw=Time[i];   //Время минимума внутри дня
 }
 }
if (Period()==60){ 
ObjectCreate("opma"+x,OBJ_TREND,0,timop,opp,timup,max);  //Отрисовка линий
ObjectSet   ("opma"+x,OBJPROP_RAY,false);
ObjectSet   ("opma"+x,OBJPROP_COLOR,Blue);
ObjectSet   ("opma"+x,OBJPROP_WIDTH,WIDTH);

ObjectCreate("opmu"+x,OBJ_TREND,0,timup,max,timcl,cl);
ObjectSet   ("opmu"+x,OBJPROP_RAY,false);
ObjectSet   ("opmu"+x,OBJPROP_COLOR,Red);
ObjectSet   ("opmu"+x,OBJPROP_WIDTH,WIDTH);

ObjectCreate("opmq"+x,OBJ_TREND,0,timop,opp,timdw,min);
ObjectSet   ("opmq"+x,OBJPROP_RAY,false);
ObjectSet   ("opmq"+x,OBJPROP_COLOR,LawnGreen);
ObjectSet   ("opmq"+x,OBJPROP_WIDTH,WIDTH);

ObjectCreate("opms"+x,OBJ_TREND,0,timdw,min,timcl,cl);
ObjectSet   ("opms"+x,OBJPROP_RAY,false);
ObjectSet   ("opms"+x,OBJPROP_COLOR,Blue);
ObjectSet   ("opms"+x,OBJPROP_WIDTH,WIDTH);
}
 }
}

