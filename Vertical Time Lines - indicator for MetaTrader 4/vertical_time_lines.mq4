//+------------------------------------------------------------------+
//|                                          Vertical Time Lines.mq4 |
//|                        Copyright 2014, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com 
//|
//| Author: File45
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window


enum LW
{
   One = 1,
   Two = 2,
   Three = 3,
   Four = 4,
   Five = 5,
};   

// DEFAULT INPUTS : START
//-----------------------------------------------------
input int Historical_Days = 50; // Historical days
  
input color  Line_1_Color = DodgerBlue; // Line 1  Color 
input bool   Line_1_Visible = true;     // Line 1  Visible
input string Line_1_Time = "08:00";     // Line 1  Time
input LW     Line_1_Width = 1;          // Line 1  Width
input ENUM_LINE_STYLE Line_1_Style = 2; // Line 1  Style

input color  Line_2_Color = DodgerBlue; // Line 2  Color
input bool   Line_2_Visible = true;     // Line 2  Visible
input string Line_2_Time = "09:00";     // Line 2  Time 
input LW     Line_2_Width = 1;          // Line 2  Width
input ENUM_LINE_STYLE Line_2_Style = 2; // Line 2  Style

input color  Line_3_Color = Magenta;    // Line 3  Color
input bool   Line_3_Visible = false;    // Line 3  Visible
input string Line_3_Time = "10:00";     // Line 3  Time
input LW     Line_3_Width = 1;          // Line 3  Width
input ENUM_LINE_STYLE Line_3_Style = 2; // Line 3  Style

input color  Line_4_Color = Magenta;    // Line 4  Color
input bool   Line_4_Visible = false;    // Line 4  Visible
input string Line_4_Time = "11:00";     // Line 4  Time
input LW     Line_4_Width = 1;          // Line 4  Width
input ENUM_LINE_STYLE Line_4_Style = 2; // Line 4  Style

input color  Line_5_Color = DarkOrange; // Line 5  Color
input bool   Line_5_Visible = false;    // Line 5  Visible
input string Line_5_Time = "12:00";     // Line 5  Time
input LW     Line_5_Width = 1;          // Line 5  Width
input ENUM_LINE_STYLE Line_5_Style = 2; // Line 5  Style

input color  Line_6_Color = DarkOrange; // Line 6  Color
input bool   Line_6_Visible = false;    // Line 6  Visible 
input string Line_6_Time = "13:00";     // Line 6  Time
input LW     Line_6_Width = 1;          // Line 6  Width
input ENUM_LINE_STYLE Line_6_Style = 2; // Line 6  Style  
//----------------------------------------------------- 
// DEFAULT INPUTS : END 

string T1_End = "Time_Line_1"; 
string T2_End = "Time_Line_2"; 
string T3_End = "Time_Line_3";  
string T4_End = "Time_Line_4"; 
string T5_End = "Time_Line_5";  
string T6_End = "Time_Line_6";    
 

int OnInit()
{
   DeleteObjects();
  for (int i=0; i<Historical_Days; i++) 
  {
     CreateObjects("T1"+ IntegerToString(i), Line_1_Color);
     ObjectSet("T1"+IntegerToString(i), OBJPROP_WIDTH, Line_1_Width);
     ObjectSet("T1"+IntegerToString(i), OBJPROP_STYLE, Line_1_Style);
     
     CreateObjects("T2"+IntegerToString(i), Line_2_Color);
     ObjectSet("T2"+IntegerToString(i), OBJPROP_WIDTH, Line_2_Width);
     ObjectSet("T2"+IntegerToString(i), OBJPROP_STYLE, Line_2_Style);
     
     CreateObjects("T3"+IntegerToString(i), Line_3_Color);
     ObjectSet("T3"+IntegerToString(i), OBJPROP_WIDTH, Line_3_Width);
     ObjectSet("T3"+IntegerToString(i), OBJPROP_STYLE, Line_3_Style);
     
     CreateObjects("T4"+IntegerToString(i), Line_4_Color);
     ObjectSet("T4"+IntegerToString(i), OBJPROP_WIDTH, Line_4_Width);
     ObjectSet("T4"+IntegerToString(i), OBJPROP_STYLE, Line_4_Style);
     
     CreateObjects("T5"+IntegerToString(i), Line_5_Color);
     ObjectSet("T5"+IntegerToString(i), OBJPROP_WIDTH, Line_5_Width);
     ObjectSet("T5"+IntegerToString(i), OBJPROP_STYLE, Line_5_Style);
     
     CreateObjects("T6"+IntegerToString(i), Line_6_Color);
     ObjectSet("T6"+IntegerToString(i), OBJPROP_WIDTH, Line_6_Width);
     ObjectSet("T6"+IntegerToString(i), OBJPROP_STYLE, Line_6_Style);
  }

   return(INIT_SUCCEEDED);
}

void deinit() 
{
  DeleteObjects();
}

void CreateObjects(string no, color cl)
{
  ObjectCreate(no, OBJ_VLINE, 0, 0,0, 0,0);
 // ObjectSet(no, OBJPROP_WIDTH, Line_Width_1_2_3_4_or_5);
 // ObjectSet(no, OBJPROP_STYLE, Line_Style);
  ObjectSet(no, OBJPROP_COLOR, cl);
  ObjectSet(no, OBJPROP_BACK, false);
}

void DeleteObjects() 
{
  for (int i=0; i<Historical_Days; i++) 
  {
    ObjectDelete("T1"+IntegerToString(i));
    ObjectDelete("T2"+IntegerToString(i));
    ObjectDelete("T3"+IntegerToString(i));
    ObjectDelete("T4"+IntegerToString(i));
    ObjectDelete("T5"+IntegerToString(i));
    ObjectDelete("T6"+IntegerToString(i));
  }
}

void DrawObjects(datetime dt, string no, string tb, string te) 
{
  datetime t1, t2;
  double   p1, p2;
  int      b1, b2;

  t1=StrToTime(TimeToStr(dt, TIME_DATE)+" "+tb);
  t2=StrToTime(TimeToStr(dt, TIME_DATE)+" "+te);
  b1=iBarShift(NULL, 0, t1);
  b2=iBarShift(NULL, 0, t2);
  p1=High[Highest(NULL, 0, MODE_HIGH, b1-b2, b2)];
  p2=Low [Lowest (NULL, 0, MODE_LOW , b1-b2, b2)];
  ObjectSet(no, OBJPROP_TIME1 , t1);
  ObjectSet(no, OBJPROP_PRICE1, p1);
  ObjectSet(no, OBJPROP_TIME2 , t2);
  ObjectSet(no, OBJPROP_PRICE2, p2);
}

datetime decDateTradeDay (datetime dt) 
{
  int ty=TimeYear(dt);
  int tm=TimeMonth(dt);
  int td=TimeDay(dt);
  int th=TimeHour(dt);
  int ti=TimeMinute(dt);

  td--;
  if (td==0) 
  {
    tm--;
    if (tm==0) 
    {
      ty--;
      tm=12;
    }
    if (tm==1 || tm==3 || tm==5 || tm==7 || tm==8 || tm==10 || tm==12) td=31;
    if (tm==2) if (MathMod(ty, 4)==0) td=29; else td=28;
    if (tm==4 || tm==6 || tm==9 || tm==11) td=30;
  }
  return(StrToTime(IntegerToString(ty)+"."+IntegerToString(tm)+"."+IntegerToString(td)+" "+IntegerToString(th)+":"+IntegerToString(ti)));
}




int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
 {

   datetime dt=CurTime();

   for (int i=0; i<Historical_Days; i++) 
   {
      if(Line_1_Visible == true)
      {
         DrawObjects(dt, "T1"+IntegerToString(i), Line_1_Time, T1_End);
      }
      if(Line_2_Visible == true)
      {
         DrawObjects(dt, "T2"+IntegerToString(i), Line_2_Time, T2_End);
      }
      if(Line_3_Visible == true)
      {
         DrawObjects(dt, "T3"+IntegerToString(i), Line_3_Time, T3_End);
      }
      if(Line_4_Visible == true)
      {
         DrawObjects(dt, "T4"+IntegerToString(i), Line_4_Time, T4_End);
      }
      if(Line_5_Visible == true)
      {
         DrawObjects(dt, "T5"+IntegerToString(i), Line_5_Time, T5_End);
      }
      if(Line_6_Visible == true)
      {
         DrawObjects(dt, "T6"+IntegerToString(i), Line_6_Time, T6_End);
      }
        
      dt=decDateTradeDay(dt);
      while (TimeDayOfWeek(dt)>5) dt=decDateTradeDay(dt);
      
   }

   return(rates_total);
}

