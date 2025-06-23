#property copyright "Copyright 2012, YangShu.net"
#property link      "http://yangshu.net"
#property indicator_chart_window

int now;//define a time variant
extern int Cycle=144;

int init()
  {
   DropAllAngleLine();
   return(0);
  }

int deinit()
  {
   DropAllAngleLine();
   return(0);
  }

void DrawAngleLine(string lname,int bar,double value,int angle)
  { 
     int   style;
     color linecolor;

      if (angle>0)
        {
         linecolor=Aqua;
         if (angle==85 || angle==25) style=STYLE_DASHDOT;else style=STYLE_DOT; 
        }
      else 
        {
         linecolor=Red;
         if (angle==-85 || angle==-25) style=STYLE_DASHDOT;else style=STYLE_DOT;
        } 
      ObjectCreate(lname,OBJ_TRENDBYANGLE,0,bar,value); 
      ObjectSet(lname,OBJPROP_COLOR,linecolor);
      ObjectSet(lname,OBJPROP_STYLE,style);
      ObjectSet(lname,OBJPROP_WIDTH,1);
      ObjectSet(lname,OBJPROP_ANGLE,angle);     
  }
  
void DropAllAngleLine()
  {
   int obj_total=ObjectsTotal();
   string obj_name;
  for(int i=0;i<obj_total;i++)
    {
     obj_name=ObjectName(i);
     if (StringFind(obj_name,"Angle",0)>0) ObjectDelete(obj_name);
    }
  }
  
int start()
  { 
  if (Bars<Cycle) return;
   if (now!=Minute()) //every minute refresh once
      {
       now=Minute();
       double HighValue,LowValue;
       int    HstBar,LstBar;
       DropAllAngleLine(); 
       DropAllAngleLine(); //twice delete
    
       HighValue=High[iHighest(NULL,0,MODE_HIGH,Cycle,1)]; 
       LowValue= Low[iLowest(NULL,0,MODE_LOW,Cycle,1)];
       HstBar=Time[iHighest(NULL,0,MODE_HIGH,Cycle,1)];
       LstBar=Time[iLowest(NULL,0,MODE_LOW,Cycle,1)];    
   
       DrawAngleLine("UpAngleA",LstBar,LowValue,25);
       DrawAngleLine("UpAngleB",LstBar,LowValue,45);
       DrawAngleLine("UpAngleC",LstBar,LowValue,65);
       DrawAngleLine("UpAngleD",LstBar,LowValue,85);
       
       DrawAngleLine("DownAngleA",HstBar,HighValue,-25);
       DrawAngleLine("DownAngleB",HstBar,HighValue,-45);
       DrawAngleLine("DownAngleC",HstBar,HighValue,-65);
       DrawAngleLine("DownAngleD",HstBar,HighValue,-85);
      }
    return(0);
  }