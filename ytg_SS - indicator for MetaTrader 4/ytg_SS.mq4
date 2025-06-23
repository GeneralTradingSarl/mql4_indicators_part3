//+------------------------------------------------------------------+
//|                                                       ytg_SS.mq4 |
//|                                                     Yuriy Tokman |
//|                                            yuriytokman@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman"
#property link      "yuriytokman@gmail.com"

#property indicator_chart_window

#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_width1 2
#property indicator_color2 Lime 
#property indicator_width2 2

extern string UpSoundFileName     = "news.wav";
extern string DownSoundFileName   = "alert2.wav";
extern int arows_1_code           = 242; 
extern int arows_2_code           = 241; 
extern int arows_1_width          = 2; 
extern int arows_2_width          = 2;
extern int font_size              = 16;
extern string font_name           = "Arial Black";
extern color color_on             = Lime;
extern color color_off            = Red; 

double buf_0[];
double buf_1[];

int vX = 25;

string text_1 = "Alert_OFF";     
string text_2 = "PlaySound_OFF"; 
string text_3 = "SendMail_OFF";
  
color colir_1   = Blue;
color colir_2   = Blue;
color colir_3   = Blue;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators

      SetIndexStyle(0,DRAW_ARROW,STYLE_SOLID,arows_1_width);
      SetIndexArrow(0,arows_1_code);
      SetIndexBuffer(0,buf_0);   
   
      SetIndexStyle(1,DRAW_ARROW,STYLE_SOLID,arows_2_width);
      SetIndexArrow(1,arows_2_code);
      SetIndexBuffer(1,buf_1);
//----
      if(GlobalVariableCheck("name_1"))
       {
        if(GlobalVariableGet("name_1")>0)
         {text_1 = "Alert_ON";colir_1=color_on;} 
        else {text_1 = "Alert_OFF";colir_1=color_off;}
       }       

      if(GlobalVariableCheck("name_2"))
       {
        if(GlobalVariableGet("name_2")>0)
         {text_2 = "PlaySound_ON";colir_2=color_on;} 
        else {text_2 = "PlaySound_OFF";colir_2=color_off;}
       }

      if(GlobalVariableCheck("name_3"))
       {
        if(GlobalVariableGet("name_3")>0)
         {text_3 = "SendMail_ON";colir_3=color_on;} 
        else {text_3 = "SendMail_OFF";colir_3=color_off;}
       }

      ObjectCreate("text_1",OBJ_LABEL,0,0,0,0,0);         
      ObjectSet("text_1",OBJPROP_CORNER,1);
      ObjectSet("text_1",OBJPROP_XDISTANCE,vX);
      ObjectSet("text_1",OBJPROP_YDISTANCE,18);
      ObjectSetText("text_1",text_1,font_size,font_name,colir_1);
      
      ObjectCreate("text_2",OBJ_LABEL,0,0,0,0,0);         
      ObjectSet("text_2",OBJPROP_CORNER,1);
      ObjectSet("text_2",OBJPROP_XDISTANCE,vX);
      ObjectSet("text_2",OBJPROP_YDISTANCE,42);
      ObjectSetText("text_2",text_2,font_size,font_name,colir_2);
      
      ObjectCreate("text_3",OBJ_LABEL,0,0,0,0,0);         
      ObjectSet("text_3",OBJPROP_CORNER,1);
      ObjectSet("text_3",OBJPROP_XDISTANCE,vX);
      ObjectSet("text_3",OBJPROP_YDISTANCE,68);
      ObjectSetText("text_3",text_3,font_size,font_name,colir_3);
      
      Comment("yuriytokman@gmail.com");            
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
     ObjectDelete ("text_1");
     ObjectDelete ("text_2");
     ObjectDelete ("text_3");     
     Comment("");   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
//----
   int k;
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)  return(-1);
   if(counted_bars > 0)   counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=1+24;

   if (limit>2) ShowHistory(limit);
   else ShowRealTime(0);  
//----
   int newX_1 = ObjectGet( "text_1",OBJPROP_XDISTANCE);
   int newX_2 = ObjectGet( "text_2",OBJPROP_XDISTANCE);
   int newX_3 = ObjectGet( "text_3",OBJPROP_XDISTANCE);
   
   if(newX_1 != vX)
     {
      if(ObjectDescription("text_1") == "Alert_OFF")
        {
         text_1 = "Alert_ON";
         colir_1  = color_on;
         GlobalVariableSet( "name_1", 1);
        }
      else{ text_1 = "Alert_OFF"; colir_1  = color_off;GlobalVariableSet( "name_1", 0);}
     }
//------
   if(newX_2 != vX)
     {
      if(ObjectDescription("text_2") == "PlaySound_OFF")
        {
         text_2 = "PlaySound_ON";
         colir_2  = color_on;
         GlobalVariableSet( "name_2", 1);
        }
      else{ text_2 = "PlaySound_OFF"; colir_2  = color_off;GlobalVariableSet( "name_2",0);}
     }
//------     
   if(newX_3 != vX)
     {
      if(ObjectDescription("text_3") == "SendMail_OFF")
        {
         text_3 = "SendMail_ON";
         colir_3  = color_on;
         GlobalVariableSet( "name_3", 1);
        }
      else{ text_3 = "SendMail_OFF"; colir_3  = color_off;GlobalVariableSet( "name_3",0);}
     }   
//--------   
   if (ObjectFind("text_1")!=-1) ObjectDelete("text_1");
      ObjectCreate("text_1",OBJ_LABEL,0,0,0,0,0);         
      ObjectSet("text_1",OBJPROP_CORNER,1);
      ObjectSet("text_1",OBJPROP_XDISTANCE,vX);
      ObjectSet("text_1",OBJPROP_YDISTANCE,18);
      ObjectSetText("text_1",text_1,font_size,font_name,colir_1);
         
   if (ObjectFind("text_2")!=-1) ObjectDelete("text_2");
      ObjectCreate("text_2",OBJ_LABEL,0,0,0,0,0);         
      ObjectSet("text_2",OBJPROP_CORNER,1);
      ObjectSet("text_2",OBJPROP_XDISTANCE,vX);
      ObjectSet("text_2",OBJPROP_YDISTANCE,42);
      ObjectSetText("text_2",text_2,font_size,font_name,colir_2);
   
   if (ObjectFind("text_3")!=-1) ObjectDelete("text_3");
      ObjectCreate("text_3",OBJ_LABEL,0,0,0,0,0);         
      ObjectSet("text_3",OBJPROP_CORNER,1);
      ObjectSet("text_3",OBJPROP_XDISTANCE,vX);
      ObjectSet("text_3",OBJPROP_YDISTANCE,68);
      ObjectSetText("text_3",text_3,font_size,font_name,colir_3);         
         
//----
   return(0);
  }
//+------------------------------------------------------------------+

void ShowHistory(int limit)
   {
    for(int i=limit; i>=0; i--)
   {
//=====================================================================================
     if(High[i]>High[i+1]  &&High[i]>High[i+2]  &&High[i]>High[i+3]  &&High[i]>High[i+4] 
      &&High[i]>High[i+5]  &&High[i]>High[i+6]  &&High[i]>High[i+7]  &&High[i]>High[i+8] 
      &&High[i]>High[i+9]  &&High[i]>High[i+10] &&High[i]>High[i+11] &&High[i]>High[i+12] 
      &&High[i]>High[i+13] &&High[i]>High[i+14] &&High[i]>High[i+15] &&High[i]>High[i+16]
      &&High[i]>High[i+17] &&High[i]>High[i+18] &&High[i]>High[i+19] &&High[i]>High[i+20]
      &&High[i]>High[i+21] &&High[i]>High[i+22] &&High[i]>High[i+23] &&High[i]>High[i+24])     
           
     buf_0[i]= High[i] + GetDeltaTF(Period()) * Point;
     else buf_0[i] = 0;
//=====================================================================================
     if(Low[i]<Low[i+1] &&Low[i]<Low[i+2]  &&Low[i]<Low[i+3]  &&Low[i]<Low[i+4] 
      &&Low[i]<Low[i+5] &&Low[i]<Low[i+6]  &&Low[i]<Low[i+7]  &&Low[i]<Low[i+8] 
      &&Low[i]<Low[i+9] &&Low[i]<Low[i+10] &&Low[i]<Low[i+11] &&Low[i]<Low[i+12] 
      &&Low[i]<Low[i+13]&&Low[i]<Low[i+14] &&Low[i]<Low[i+15] &&Low[i]<Low[i+16]
      &&Low[i]<Low[i+17]&&Low[i]<Low[i+18] &&Low[i]<Low[i+19] &&Low[i]<Low[i+20]
      &&Low[i]<Low[i+21]&&Low[i]<Low[i+22] &&Low[i]<Low[i+23] &&Low[i]<Low[i+24])
 
     buf_1[i]= Low[i] - GetDeltaTF(Period()) * Point;
     else buf_1[i] = 0;
     }
     }   
//========================================================================================
void ShowRealTime(int limit)
   {
   for(int i=limit; i>=0; i--)
   {
//=====================================================================================
     if(High[i+1]>High[i+2]  &&High[i+1]>High[i+3]  &&High[i+1]>High[i+4] 
      &&High[i+1]>High[i+5]  &&High[i+1]>High[i+6]  &&High[i+1]>High[i+7]  &&High[i+1]>High[i+8] 
      &&High[i+1]>High[i+9]  &&High[i+1]>High[i+10] &&High[i+1]>High[i+11] &&High[i+1]>High[i+12] 
      &&High[i+1]>High[i+13] &&High[i+1]>High[i+14] &&High[i+1]>High[i+15] &&High[i+1]>High[i+16]
      &&High[i+1]>High[i+17] &&High[i+1]>High[i+18] &&High[i+1]>High[i+19] &&High[i+1]>High[i+20]
      &&High[i+1]>High[i+21] &&High[i+1]>High[i+22] &&High[i+1]>High[i+23] &&High[i+1]>High[i+24])
     {     
     if(NevBar())
     {
     if(ObjectDescription("text_1") == "Alert_ON")Alert("SS Up; Symbol =",Symbol(),"; Time Frame =",GetNameTF());
     if(ObjectDescription("text_2") == "PlaySound_ON")PlaySound(DownSoundFileName);
     if(ObjectDescription("text_3") == "SendMail_ON")SendMail("ytg_SS ","SS Up; Symbol ="+Symbol()+"; Time Frame ="+GetNameTF());
     }
     }     
//=====================================================================================
     if(Low[i+1]<Low[i+2] &&Low[i+1]<Low[i+3]  &&Low[i+1]<Low[i+4] 
      &&Low[i+1]<Low[i+5] &&Low[i+1]<Low[i+6]  &&Low[i+1]<Low[i+7]  &&Low[i+1]<Low[i+8] 
      &&Low[i+1]<Low[i+9] &&Low[i+1]<Low[i+10] &&Low[i+1]<Low[i+11] &&Low[i+1]<Low[i+12] 
      &&Low[i+1]<Low[i+13]&&Low[i+1]<Low[i+14] &&Low[i+1]<Low[i+15] &&Low[i+1]<Low[i+16]
      &&Low[i+1]<Low[i+17]&&Low[i+1]<Low[i+18] &&Low[i+1]<Low[i+19] &&Low[i+1]<Low[i+20]
      &&Low[i+1]<Low[i+21]&&Low[i+1]<Low[i+22] &&Low[i+1]<Low[i+23] &&Low[i+1]<Low[i+24])
     {     
     if(NevBar()){
     if(ObjectDescription("text_1") == "Alert_ON")Alert("SS Down; Symbol =",Symbol(),"; Time Frame =",GetNameTF());
     if(ObjectDescription("text_2") == "PlaySound_ON")PlaySound(UpSoundFileName);}
     if(ObjectDescription("text_3") == "SendMail_ON")SendMail("ytg_SS ","SS Down; Symbol ="+Symbol()+"; Time Frame ="+GetNameTF());
     }     
     }
   }
//+----------------------------------------------------------------------------+
// Функция контроля нового бара                                                |
//-----------------------------------------------------------------------------+
bool NevBar(){
   static int PrevTime=0;
   if (PrevTime==Time[0]) return(false);
   PrevTime=Time[0];
   return(true);}
//+----------------------------------------------------------------------------+
//|  Версия   : 01.09.2005                                                     |
//|  Описание : Возвращает наименование таймфрейма                             |
//+----------------------------------------------------------------------------+
//|  Параметры:                                                                |
//|    TimeFrame - таймфрейм (количество секунд)      (0 - текущий ТФ)         |
//+----------------------------------------------------------------------------+
string GetNameTF(int TimeFrame=0) {
  if (TimeFrame==0) TimeFrame=Period();
  switch (TimeFrame) {
    case PERIOD_M1:  return("M1");
    case PERIOD_M5:  return("M5");
    case PERIOD_M15: return("M15");
    case PERIOD_M30: return("M30");
    case PERIOD_H1:  return("H1");
    case PERIOD_H4:  return("H4");
    case PERIOD_D1:  return("Daily");
    case PERIOD_W1:  return("Weekly");
    case PERIOD_MN1: return("Monthly");
    default:         return("UnknownPeriod");
  }
}
//=====================================
int GetDeltaTF(int TimeFrame=0) {
  if (TimeFrame==0) TimeFrame=Period();
  switch (TimeFrame) {
    case PERIOD_M1:  return(2);
    case PERIOD_M5:  return(3);
    case PERIOD_M15: return(5);
    case PERIOD_M30: return(8);
    case PERIOD_H1:  return(10);
    case PERIOD_H4:  return(20);
    case PERIOD_D1:  return(30);
    case PERIOD_W1:  return(80);
    case PERIOD_MN1: return(150);
    default:         return(100);
  }
}
//======================================