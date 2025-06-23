#property link      "lightsites@gmail.com"

/**
Louis Christian Stoltz

               	        _____
               	      /  ___  \
               	    /  /  _  \  \
               	  /( /( /(_)\ )\ )\
               	 (  \  \ ___ /  /  )
               	 (    \ _____ /    )
               	 /(               )\
               	|  \             /  |
               	|    \ _______ /    |
               	 \    / \   / \    /
               	   \/    | |    \/
               	         | |
               	         | |
               	         |_|
**/

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Yellow
#property indicator_color2 Yellow
#property indicator_color3 Yellow
#property indicator_color4 Yellow

/**
  Extern variables
**/ 
extern double sar1 = 0.002;
extern double sar2 = 0.2;

extern int profit = 30; //In Pips
extern int loss = 100; //In Pips

/**
  MAX Spread, Important for accurate trading.
**/ 
extern double  spread = 5; //In Pips

/**
  Star
**/
extern int  Star_Body_Length = 15;

/**
  Start Date
**/ 
extern string year = "2014";
extern string month = "01";
extern string day = "01";

color Color_Text = White;

/**
  Arrows
**/ 
double upArrow[];
double downArrow[];
double sArrow[];
double bArrow[];

int init() {
   
   ObjectsDeleteAll(0, OBJ_TEXT);
   ObjectsDeleteAll(0, OBJ_TREND);
   ObjectsDeleteAll(0, DRAW_ARROW);  
   
   SetIndexStyle(0,DRAW_ARROW, EMPTY);
   SetIndexArrow(0,234);
   SetIndexBuffer(0, downArrow);
      
   SetIndexStyle(1,DRAW_ARROW, EMPTY);
   SetIndexArrow(1,233);
   SetIndexBuffer(1, upArrow);
 
   SetIndexStyle(2,DRAW_ARROW, EMPTY);
   SetIndexArrow(2,231);
   SetIndexBuffer(2, bArrow); 

   SetIndexStyle(3,DRAW_ARROW, EMPTY);
   SetIndexArrow(3,231);
   SetIndexBuffer(3, sArrow);
         
   return(0);
}

int deinit() {

   ObjectsDeleteAll(0, OBJ_TEXT);
   ObjectsDeleteAll(0, OBJ_TREND);
   ObjectsDeleteAll(0, DRAW_ARROW);   
   return(0);
}

int start(){

   datetime back_date = StrToTime(year+"."+month+"."+day+" 00:00");
   
   int counter, sc,bc, sh=0, bh=0;
   static datetime prevtime = 0;
   int shift;
   int shift1;
   

   int h=0,n=0;
   
   int lcounter=0, scounter=0;
   double swon=0 ,slossed=0,lwon=0, llossed=0, ll=0, ss=0, S=0;
                                   
   if(prevtime == Time[0]) {
      return(0);
   }
   prevtime = Time[0];

   
   for (shift = 0; shift < Bars; shift++) {

      if(iTime(Symbol(),Period(),shift)<back_date)break;      
      h++;
      
      counter=shift;

      shift1 = shift + 1;

/**
  Signal prediction
**/        
         downArrow[shift1] = 0;
         upArrow[shift1] = 0;
         
         double end;
         
         double setprofit = profit+spread;
         double setloss   = loss+spread;
         
           if(ObjectGet(GetName("line",shift1), OBJPROP_TIME1) > 0)continue;  
                  
              //Buy Signal
              if(BUYSIGNAL(shift1) == TRUE){
                n=1;
                while(n<1000) { 
                  if(shift-n-1 < 0)break;                   
                 
                  end = Open[shift-n-1];

                  bArrow[shift-n] = 0;

                  if(Low[shift-n] == 0)break;      
                  if(shift == 0)break;           
                  if ( Close[shift-n] - Close[shift1]  >= setprofit*Point )
                  {

                    S = end - (Open[shift1-1]+spread*Point);
                    S = S/Point;
                                            
                    lwon = lwon+S;

                    bArrow[shift-n] = Close[shift-n]; 
                    
                    ObjectDelete(GetName("line",shift1));
                    ObjectCreate(GetName("line",shift1), OBJ_TREND, 0, Time[shift1], Close[shift1], Time[shift-n], Close[shift-n]);
                    SetObject(GetName("line",shift1), Time[shift1], Close[shift1], Time[shift-n], Close[shift-n], White);
                    
                    ObjectDelete(GetName("Star",shift1));
                    ObjectCreate(GetName("Star",shift1), OBJ_TEXT, 0, Time[shift-n], Low[shift-n] - 100*Point);
                    ObjectSetText(GetName("Star",shift1), DoubleToStr(S,2), 8, "Times New Roman", Color_Text); 
                                                
                    break;
                  }                  
                  if( Close[shift1] - Close[shift-n] >= setloss*Point ) 
                  {
                  
                    S = ( Open[shift1-1]+spread*Point ) - end;
                    S = S/Point;   
                
                    llossed = llossed+S;

                    bArrow[shift-n] = Close[shift-n];
                    
                    ObjectDelete(GetName("line",shift1));
                    ObjectCreate(GetName("line",shift1), OBJ_TREND, 0, Time[shift1], Close[shift1], Time[shift-n], Close[shift-n]);
                    SetObject(GetName("line",shift1), Time[shift1], Close[shift1], Time[shift-n], Close[shift-n], White);
                    
                    ObjectDelete(GetName("Star",shift1));
                    ObjectCreate(GetName("Star",shift1), OBJ_TEXT, 0, Time[shift-n], Low[shift-n] - 100*Point);
                    ObjectSetText(GetName("Star",shift1), "-"+DoubleToStr(S,2), 8, "Times New Roman", Color_Text);      
                    ll++;                
                    break;
                  }

                  n++;
                }
                
                lcounter++;

                upArrow[shift1] = Close[shift1]; 
                
                if(bh != 0)bc = shift-bh;
                bh = shift;
                ObjectCreate(GetName("Star",shift), OBJ_TEXT, 0, Time[shift1], Low[shift1] - 100*Point);
                ObjectSetText(GetName("Star",shift), "B", 8, "Times New Roman", Color_Text); 
                  
              }
              
              //Sell Signal
              if(SELLSIGNAL(shift1) == TRUE){
                
                n=1;
                while(n<1000) { 
                  if(shift-n-1 < 0)break;    
                                  
                  end = Open[shift-n-1];
   
                  if(end == 0)end = Open[shift-n-1]; 
                           
                  sArrow[shift-n] = 0;
                  
                  if(Low[shift-n] == 0)break;
                  if(shift == 0)break;  
                  if( Close[shift1] - Close[shift-n] >= setprofit*Point ) 
                  {

                    S = ( Open[shift1-1]-spread*Point ) - end;
                    S = S/Point; 

                    swon = swon+S;                    

                    sArrow[shift-n] = Close[shift-n];   
                    
                    ObjectDelete(GetName("line",shift1));
                    ObjectCreate(GetName("line",shift1), OBJ_TREND, 0, Time[shift1], Close[shift1], Time[shift-n], Close[shift-n]);
                    SetObject(GetName("line",shift1), Time[shift1], Close[shift1], Time[shift-n], Close[shift-n], White);
                    
                    ObjectDelete(GetName("Star",shift1));
                    ObjectCreate(GetName("Star",shift1), OBJ_TEXT, 0, Time[shift-n], Low[shift-n] - 100*Point);
                    ObjectSetText(GetName("Star",shift1), DoubleToStr(S,2), 8, "Times New Roman", Color_Text); 
                    
                    break;
                  }
                  if ( Close[shift-n] - Close[shift1] >= setloss*Point )
                  {

                    S = end - ( Open[shift1-1]-spread*Point );
                    S = S/Point;

                    slossed = slossed+S;
                                        
                    sArrow[shift-n] = Close[shift-n]; 
                    
                    ObjectDelete(GetName("line",shift1));
                    ObjectCreate(GetName("line",shift1), OBJ_TREND, 0, Time[shift1], Close[shift1], Time[shift-n], Close[shift-n]);
                    SetObject(GetName("line",shift1), Time[shift1], Close[shift1], Time[shift-n], Close[shift-n], White);
                    
                    ObjectDelete(GetName("Star",shift1));
                    ObjectCreate(GetName("Star",shift1), OBJ_TEXT, 0, Time[shift-n], Low[shift-n] - 100*Point);
                    ObjectSetText(GetName("Star",shift1), "-"+DoubleToStr(S,2), 8, "Times New Roman", Color_Text); 
                     
                    ss++;                   
                    break;
                  } 
                  
                  n++;
                }        
                scounter++;

                downArrow[shift1] = Close[shift1];      
                
                if(sh != 0)sc = shift-sh;
                sh = shift;
                ObjectCreate(GetName("Star",shift), OBJ_TEXT, 0, Time[shift1], Low[shift1] - 100*Point);
                ObjectSetText(GetName("Star",shift), "S", 8, "Times New Roman", Color_Text);
                   
              }
  
   } // End of for loop
      
/**
  Comments
**/       
   double total = (swon-slossed)+(lwon-llossed);
   
   if(total == 0)return(0);
   
   Comment("\n","Stats from ",  TimeToStr(iTime(Symbol(),Period(),h-1),TIME_DATE|TIME_SECONDS), 
      "\n", "Short Trades : ",scounter, " (", ss , ")",
      "\n", "pips : ",DoubleToStr(swon,2), 
      "\n", "loss : ",DoubleToStr(slossed,2), 
      "\n", "total: ",DoubleToStr(swon-slossed,2), 
      "\n",
      "\n", "Long Trades : ",lcounter, " (", ll , ")", 
      "\n", "pips : ", DoubleToStr(lwon,2),
      "\n", "loss : ", DoubleToStr(llossed,2),
      "\n", "total : ", DoubleToStr(lwon-llossed,2),
      "\n",
      "\n", "TOTAL : ", DoubleToStr(total,2),
      
      "\n","\n","Please donate to paypal lightsites@gmail.com");
           
   return(0);
}

string GetName(string aName,int shift)
{
  return(aName+TimeToStr(Time[shift]));
}

void SetObject(string name,datetime T1,double P1,datetime T2,double P2,color clr)
{

  ObjectCreate(name, OBJ_TREND, 0, T1, P1, T2, P2);
  ObjectSet(name, OBJPROP_COLOR, clr);
  ObjectSet(name, OBJPROP_STYLE, STYLE_DOT);
  ObjectSet(name, OBJPROP_RAY, FALSE);

}

/**
  BUYSIGNAL
**/ 
bool BUYSIGNAL(int s) {

    double star;
    int n=0, shift=s-1,z=0,x=0; 
    while(n<11) {  
     
     if(Open[shift+n]>Close[shift+n]){
       star = Open[shift+n]-Close[shift+n];
     }   
     else {
       star = Close[shift+n]-Open[shift+n];
     } 
  
     if( star < (Star_Body_Length*Point) )z=1;
  
    n++;   
    }

    n=0;
    while(n<5) {  
    
     if( iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,shift+n) < 25 )x=1;
  
    n++;   
    } 
    
  if ((iSAR(NULL, 0,sar1,sar2, s)<iClose(NULL,0,s)) && (iSAR(NULL, 0,sar1,sar2, s+1)>iOpen(NULL,0, s+1)))
  {
    return(TRUE);
  }
  return(FALSE);
}

/**
  SELLSIGNAL
**/ 
bool SELLSIGNAL(int s) {
    
    double star;
    int n=0, shift=s-1,z=0,x=0; 
    while(n<11) {  
     
     if(Open[shift+n]>Close[shift+n]){
       star = Open[shift+n]-Close[shift+n];
     }   
     else {
       star = Close[shift+n]-Open[shift+n];
     } 
  
   
     if( star < (Star_Body_Length*Point) )z=1;
  
    n++;   
    }
 
    n=0;
    while(n<5) {  
    
      if( iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,shift+n) > 70 )x=1;
      n++;   
      
    } 
    
  if ((iSAR(NULL, 0,sar1,sar2, s)>iClose(NULL,0,s))&&(iSAR(NULL, 0,sar1,sar2, s+1)<iOpen(NULL,0,s+1)))  //Signal Sell
  {
    return(TRUE);
  }
  return(FALSE);
}