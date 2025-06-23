//+------------------------------------------------------------------+
//| TimeZones Six v2 Copyright © 2013, File45 (Phylo)  
//|                   
//| http://www.forexfactory.com/showthread.php?t=280525              
//| http://codebase.mql4.com/en/author/file45                        
//+------------------------------------------------------------------+
#property indicator_chart_window

// ++++++++++++++++++++++++++++++++ START OF DEFAULT OPTIONS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++

extern string  TIME_ZONES;
extern bool    Show_Time_Zone_1    = true;
extern string  Time_Zone_1_Label   = "SER";
//extern int     Time_Zone_1_Offset  = 2;

extern bool    Show_Time_Zone_2   = true;
extern string  Time_Zone_2_Label  = "LND";
extern int     Time_Zone_2_Offset = -1;

extern bool    Show_Time_Zone_3   = true;
extern string  Time_Zone_3_Label  = "NYC";
extern int     Time_Zone_3_Offset = -6;

extern bool    Show_Time_Zone_4   = true;
extern string  Time_Zone_4_Label  = "TOK";
extern int     Time_Zone_4_Offset = -17;

extern bool    Show_Time_Zone_5   = false;
extern string  Time_Zone_5_Label  = "ABC";
extern int     Time_Zone_5_Offset = -17;

extern bool    Show_Time_Zone_6   = false;
extern string  Time_Zone_6_Label  = "XYZ";
extern int     Time_Zone_6_Offset   = -17;

extern bool    Show_Seconds       = false;

extern string  LABELS_and_POSITION;
extern int     Font_Size          = 11;
extern bool    Font_Bold          = false;
extern color   Font_Color         = SlateGray;
extern int     Label_Corner       = 3;
extern int     Left_Right         = 20;
extern int     Up_Down            = -20;

// ++++++++++++++++++++++++++++++++ END OF DEFAULT OPTIONS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

string FT, TMz;
string Bld; 
double MorS;
int LC;
int y_Line_1;
int y_Line_2;
int y_Line_3;
int y_Line_4;
int y_Line_5;
int y_Line_6;

int init()
{
   switch(Period())
   {    
      case 1:     TMz = "M1";  break;
      case 5:     TMz = "M5";  break;
      case 15:    TMz = "H15"; break;
      case 30:    TMz = "M30"; break;
      case 60:    TMz = "H1";  break;
      case 240:   TMz = "H4";  break;
      case 1440:  TMz = "D1";  break;
      case 10080: TMz = "W1";  break;
      case 43200: TMz = "M4";  break;
   }     
    
   switch(Font_Bold)
   {
      case 1: FT = "Arial Bold"; break;
      case 0: FT = "Arial";      break;
   }
   
   switch(Label_Corner)
   {    
      case 0: LC = 0; break;
      case 1: LC = 1; break;
      case 2: LC = 2; break;
      case 3: LC = 3; break;
      default: Alert(Symbol()+ " - " + TMz + " : " + "Please enter 0 (TL), 1 (TR), 2 (BL) or 3 (BR)"); LC = 3;
   }
   
   if (LC == 0 || LC ==1)
   {
      y_Line_1 = Up_Down;
      y_Line_2 = Up_Down + Font_Size*2;
      y_Line_3 = Up_Down + Font_Size*4;
      y_Line_4 = Up_Down + Font_Size*6;
      y_Line_5 = Up_Down + Font_Size*8;
      y_Line_6 = Up_Down + Font_Size*10;
   }
   else if (LC == 2 || LC == 3)
   { 
      y_Line_1 = Up_Down + Font_Size*10;
      y_Line_2 = Up_Down + Font_Size*8;
      y_Line_3 = Up_Down + Font_Size*6;
      y_Line_4 = Up_Down + Font_Size*4;
      y_Line_5 = Up_Down + Font_Size*1.5;
      y_Line_6 = Up_Down;
   }
   
   if (Show_Seconds == true)
   {
      MorS = TIME_SECONDS;
   }   
   else
   {
     MorS = TIME_MINUTES;
   }  
 
   return(0);
}
//+------------------------------------------------------------------+
int deinit()
{
   ObjectDelete("TZ1");
   ObjectDelete("TZ2");
   ObjectDelete("TZ3");
   ObjectDelete("TZ4");
   ObjectDelete("TZ5");
   ObjectDelete("TZ6");
   
   return(0);
}
//+------------------------------------------------------------------+
int start()
{
   string TZ_1 = TimeToStr((TimeCurrent() + ((0) * 3600)), MorS);
   
   if (Show_Time_Zone_1 == true)
   {
      ObjectCreate("TZ1", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("TZ1", Time_Zone_1_Label + " " + TZ_1 , Font_Size, FT, Font_Color);
      ObjectSet("TZ1", OBJPROP_CORNER, LC);
      ObjectSet("TZ1", OBJPROP_XDISTANCE, Left_Right);
      ObjectSet("TZ1", OBJPROP_YDISTANCE, y_Line_1);
   }
   
   string TZ_2 = TimeToStr((TimeCurrent() + ((Time_Zone_2_Offset) * 3600)), MorS);
 
   if (Show_Time_Zone_2 == true)
   {
      ObjectCreate("TZ2", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("TZ2", Time_Zone_2_Label + " " + TZ_2 , Font_Size, FT, Font_Color);
      ObjectSet("TZ2", OBJPROP_CORNER, LC);
      ObjectSet("TZ2", OBJPROP_XDISTANCE, Left_Right);
      ObjectSet("TZ2", OBJPROP_YDISTANCE, y_Line_2);
   }
   
   string TZ_3 = TimeToStr((TimeCurrent() + ((Time_Zone_3_Offset) * 3600)), MorS);
 
   if (Show_Time_Zone_3 == true)
   {
      ObjectCreate("TZ3", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("TZ3", Time_Zone_3_Label + " " + TZ_3 , Font_Size, FT, Font_Color);
      ObjectSet("TZ3", OBJPROP_CORNER, LC);
      ObjectSet("TZ3", OBJPROP_XDISTANCE, Left_Right);
      ObjectSet("TZ3", OBJPROP_YDISTANCE, y_Line_3);
   }
   
   string TZ_4 = TimeToStr((TimeCurrent() + ((Time_Zone_4_Offset) * 3600)), MorS);
   
   if (Show_Time_Zone_4 == true)
   {
      ObjectCreate("TZ4", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("TZ4", Time_Zone_4_Label + " " + TZ_4 , Font_Size, FT, Font_Color);
      ObjectSet("TZ4", OBJPROP_CORNER, LC);
      ObjectSet("TZ4", OBJPROP_XDISTANCE, Left_Right);
      ObjectSet("TZ4", OBJPROP_YDISTANCE, y_Line_4);
   }   
   
   string TZ_5 = TimeToStr((TimeCurrent() + ((Time_Zone_5_Offset) * 3600)), MorS);
   
   if (Show_Time_Zone_5 == true)
   {
      ObjectCreate("TZ5", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("TZ5", Time_Zone_5_Label + " " + TZ_5 , Font_Size, FT, Font_Color);
      ObjectSet("TZ5", OBJPROP_CORNER, LC);
      ObjectSet("TZ5", OBJPROP_XDISTANCE, Left_Right);
      ObjectSet("TZ5", OBJPROP_YDISTANCE, y_Line_5);
   }   
   
   string TZ_6 = TimeToStr((TimeCurrent() + ((Time_Zone_6_Offset) * 3600)), MorS);
   
   if (Show_Time_Zone_6 == true)
   {
      ObjectCreate("TZ6", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("TZ6", Time_Zone_6_Label + " " + TZ_6 , Font_Size, FT + Bld, Font_Color);
      ObjectSet("TZ6", OBJPROP_CORNER, LC);
      ObjectSet("TZ6", OBJPROP_XDISTANCE, Left_Right);
      ObjectSet("TZ6", OBJPROP_YDISTANCE, y_Line_6);
   }   
   
   return(0);
}

