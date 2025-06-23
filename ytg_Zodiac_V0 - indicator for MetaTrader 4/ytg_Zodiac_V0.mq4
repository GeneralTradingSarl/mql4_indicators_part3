//+------------------------------------------------------------------+
//|                                                ytg_Zodiac_V0.mq4 |
//|                                                     Yuriy Tokman |
//|                                            yuriytokman@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman"
#property link      "yuriytokman@gmail.com"

#property indicator_chart_window

extern color Zodiac         = Yellow;
extern color Name           = Gold;
extern color Zodiac_current = Lime;

int arrow[]={105,104,103,102,101,100,99,98,97,96,95,94};
string name[]={"Рыбы","Водолей","Козерог","Стрелец","Скорпион","Весы","Дева","Лев","Рак","Близнецы","Телец","Овен"};

int count = 0;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   int x;
   for(x=0;x<12;x++)SetText("Zodiac_txt"+x,name[x],1,(x+11)*30,33,9,"Tahoma",Name,45);
   for(x=0;x<12;x++)SetText("Zodiac_arrow"+x,CharToStr(arrow[x]),1,(x+11)*29,10,18, "Wingdings", Zodiac);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   string vName;
   for(int i=ObjectsTotal()-1; i>=0;i--)
    {
     vName = ObjectName(i);
     if (StringFind(vName,"Zodiac_") !=-1) ObjectDelete(vName);
    }   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//----
  count++;
  if(count>5)count=0; 
//----11
   if((Month()==3 && Day()>=21 && Day()<=31) ||
      (Month()==4 && Day()>=1 && Day()<=20))
      {
       SetText("Zodiac_arrow"+11,CharToStr(arrow[11]),1,(11+11)*29,10,18+count,"Wingdings",Zodiac_current);
      }
//----10
   if((Month()==4 && Day()>=21 && Day()<=31) ||
      (Month()==5 && Day()>=1 && Day()<=21))
      {
       SetText("Zodiac_arrow"+10,CharToStr(arrow[10]),1,(10+11)*29,10,18+count,"Wingdings",Zodiac_current);
      }      
//----9
   if((Month()==5 && Day()>=22 && Day()<=31) ||
      (Month()==6 && Day()>=1 && Day()<=21))
      {
       SetText("Zodiac_arrow"+9,CharToStr(arrow[9]),1,(9+11)*29,10,18+count,"Wingdings",Zodiac_current);
      }      
//----8
   if((Month()==6 && Day()>=22 && Day()<=31) ||
      (Month()==7 && Day()>=1 && Day()<=22))
      {
       SetText("Zodiac_arrow"+8,CharToStr(arrow[8]),1,(8+11)*29,10,18+count,"Wingdings",Zodiac_current);
      }
//----7
   if((Month()==7 && Day()>=23 && Day()<=31) ||
      (Month()==8 && Day()>=1 && Day()<=23))
      {
       SetText("Zodiac_arrow"+7,CharToStr(arrow[7]),1,(7+11)*29,10,18+count,"Wingdings",Zodiac_current);
      }      
//----6
   if((Month()==8 && Day()>=24 && Day()<=31) ||
      (Month()==9 && Day()>=1 && Day()<=23))
      {
       SetText("Zodiac_arrow"+6,CharToStr(arrow[6]),1,(6+11)*29,10,18+count,"Wingdings",Zodiac_current);
      }
//----5
   if((Month()==9 && Day()>=24 && Day()<=31) ||
      (Month()==10 && Day()>=1 && Day()<=23))
      {
       SetText("Zodiac_arrow"+5,CharToStr(arrow[5]),1,(5+11)*29,10,18+count,"Wingdings",Zodiac_current);
      }      
//----4
   if((Month()==10 && Day()>=24 && Day()<=31) ||
      (Month()==11 && Day()>=1 && Day()<=22))
      {
       SetText("Zodiac_arrow"+4,CharToStr(arrow[4]),1,(4+11)*29,10,18+count,"Wingdings",Zodiac_current);
      }      
//----3
   if((Month()==11 && Day()>=23 && Day()<=31) ||
      (Month()==12 && Day()>=1 && Day()<=21))
      {
       SetText("Zodiac_arrow"+3,CharToStr(arrow[3]),1,(3+11)*29,10,18+count,"Wingdings",Zodiac_current);
      }      
//----2
   if((Month()==12 && Day()>=22 && Day()<=31) ||
      (Month()==1 && Day()>=1 && Day()<=20))
      {
       SetText("Zodiac_arrow"+2,CharToStr(arrow[2]),1,(2+11)*29,10,18+count,"Wingdings",Zodiac_current);
      }      
//----1
   if((Month()==1 && Day()>=21 && Day()<=31) ||
      (Month()==2 && Day()>=1 && Day()<=18))
      {
       SetText("Zodiac_arrow"+1,CharToStr(arrow[1]),1,(1+11)*29,10,18+count,"Wingdings",Zodiac_current);
      }
//----0
   if((Month()==2 && Day()>=19 && Day()<=31) ||
      (Month()==3 && Day()>=1 && Day()<=20))
      {
       SetText("Zodiac_arrow"+0,CharToStr(arrow[0]),1,(0+11)*29,10,18+count,"Wingdings",Zodiac_current);
      }                          
//----
   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void SetText(string name,string text,int CORNER,int XDISTANCE,int YDISTANCE, 
             int font_size, string font_name, color text_color=CLR_NONE, double ANGLE = 0)
 {
  if (ObjectFind(name)!=-1) ObjectDelete(name);
  ObjectCreate(name,OBJ_LABEL,0,0,0,0,0);         
  ObjectSet(name,OBJPROP_CORNER,CORNER);
  ObjectSet(name,OBJPROP_XDISTANCE,XDISTANCE);
  ObjectSet(name,OBJPROP_YDISTANCE,YDISTANCE);
  ObjectSet(name, OBJPROP_ANGLE , ANGLE);
  ObjectSetText(name,text,font_size,font_name,text_color);
 }