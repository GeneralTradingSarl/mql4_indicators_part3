//+------------------------------------------------------------------+
//|                                                                  
//|                       ZMFX All pivot levels.mq4              
//|                                         
//|                       ZoomInForex.com              
//|                                                                  
//+------------------------------------------------------------------+

#property indicator_chart_window
#property link "http://www.ZoomInForex.com/"

   extern bool Use_Sunday_Data   = True;
   extern bool Daily             = True;
   extern bool Daily_SR_Levels   = True;
   extern bool Weekly            = True;
   extern bool Weekly_SR_Levels  = true;
   extern bool Monthly           = true;
   extern bool Monthly_SR_Levels = true;
   
extern double D_label_pos=1;
extern double W_label_pos=1.5;
extern double M_label_pos=5;

extern int pivot_line_type=1;
extern int resist_line_type=2;
extern int support_line_type=2;
extern int pivot_width=2;
extern int resist_width=1;
extern int support_width=1;

extern string Daily_Colors;   
   extern color cdpivot=Black;
   extern color cds1=LimeGreen;
   extern color cds2=LimeGreen;
   extern color cds3=LimeGreen;
   extern color cdr1=DarkOrange;
   extern color cdr2=DarkOrange;
   extern color cdr3=DarkOrange;

extern string Weekly_Colors; 
   extern color cwpivot=Black;
   extern color cws1=Green;
   extern color cws2=Green;
   extern color cws3=Green;
   extern color cwr1=Red;
   extern color cwr2=Red;
   extern color cwr3=Red;

extern string Monthly_Colors;   
   extern color cmpivot=Black;
   extern color cms1=DarkGreen;
   extern color cms2=DarkGreen;
   extern color cms3=DarkGreen;
   extern color cmr1=FireBrick;
   extern color cmr2=FireBrick;
   extern color cmr3=FireBrick;
   

   double YesterdayHigh;
   double YesterdayLow;
   double YesterdayClose;
   double Day_Price[][6];
   double Pivot,S1,S2,S3,R1,R2,R3;
      
   double WeekHigh;
   double WeekLow;
   double WeekClose;
   double Weekly_Price[][6];
   double WeekPivot,WS1,WS2,WS3,WR1,WR2,WR3;
   
   double MonthHigh;
   double MonthLow;
   double MonthClose;
   double Month_Price[][6];
   double MonthPivot,MS1,MS2,MS3,MR1,MR2,MR3;
   
int init()
  {
   return(0);
  }
  
//-------------------------------------------------------- 
  
int deinit()
  {
ObjectDelete("PivotLine");
ObjectDelete("R1_Line");
ObjectDelete("R2_Line");
ObjectDelete("R3_Line");
ObjectDelete("S1_Line");
ObjectDelete("S2_Line");
ObjectDelete("S3_Line");  

//--------------------------------

ObjectDelete("PivotLabel");
ObjectDelete("R1_Label");
ObjectDelete("R2_Label");
ObjectDelete("R3_Label");
ObjectDelete("S1_Label");
ObjectDelete("S2_Label");
ObjectDelete("S3_Label"); 

//--------------------------------------------------------

ObjectDelete("WeekPivotLine");
ObjectDelete("WR1_Line");
ObjectDelete("WR2_Line");
ObjectDelete("WR3_Line");
ObjectDelete("WS1_Line");
ObjectDelete("WS2_Line");
ObjectDelete("WS3_Line");  

//--------------------------------

ObjectDelete("WeekPivotLabel");
ObjectDelete("WR1_Label");
ObjectDelete("WR2_Label");
ObjectDelete("WR3_Label");
ObjectDelete("WS1_Label");
ObjectDelete("WS2_Label");
ObjectDelete("WS3_Label");  

//--------------------------------------------------------

ObjectDelete("MonthPivotLine");
ObjectDelete("MR1_Line");
ObjectDelete("MR2_Line");
ObjectDelete("MR3_Line");
ObjectDelete("MS1_Line");
ObjectDelete("MS2_Line");
ObjectDelete("MS3_Line");  

//--------------------------------

ObjectDelete("MonthPivotLabel");
ObjectDelete("MR1_Label");
ObjectDelete("MR2_Label");
ObjectDelete("MR3_Label");
ObjectDelete("MS1_Label");
ObjectDelete("MS2_Label");
ObjectDelete("MS3_Label");

return(0);
}
//--------------------------------------------------------- 

int start()
{

ArrayCopyRates(Day_Price,(Symbol()), 1440);

   YesterdayHigh  = Day_Price[1][3];
   YesterdayLow   = Day_Price[1][2];
   YesterdayClose = Day_Price[1][4];
   
   Pivot = ((YesterdayHigh + YesterdayLow + YesterdayClose)/3);

   R1 = (2*Pivot)-YesterdayLow;
   S1 = (2*Pivot)-YesterdayHigh;

   R2 = Pivot+(R1-S1);
   S2 = Pivot-(R1-S1);
   
   R3 = (YesterdayHigh + (2*(Pivot-YesterdayLow)));
   S3 = (YesterdayLow - (2*(YesterdayHigh-Pivot)));  
  
  
if (Use_Sunday_Data == false)
 {   
   while (DayOfWeek() == 1)
      {      
       YesterdayHigh  = Day_Price[2][3];
       YesterdayLow   = Day_Price[2][2];
       YesterdayClose = Day_Price[2][4];
   
       Pivot = ((YesterdayHigh + YesterdayLow + YesterdayClose)/3);

       R1 = (2*Pivot)-YesterdayLow;
       S1 = (2*Pivot)-YesterdayHigh;

       R2 = Pivot+(R1-S1);
       S2 = Pivot-(R1-S1);
   
       R3 = (YesterdayHigh + (2*(Pivot-YesterdayLow)));
       S3 = (YesterdayLow - (2*(YesterdayHigh-Pivot)));
       break;
      }
 }
  
//--------------------------------------------------------
//--------------------------------------------------------


ArrayCopyRates(Weekly_Price, Symbol(), 10080);

WeekHigh  = Weekly_Price[1][3];
WeekLow   = Weekly_Price[1][2];
WeekClose = Weekly_Price[1][4];

WeekPivot = ((WeekHigh + WeekLow + WeekClose)/3);

      WR1 = (2*WeekPivot)-WeekLow;
      WS1 = (2*WeekPivot)-WeekHigh;

      WR2 = WeekPivot+(WR1-WS1);
      WS2 = WeekPivot-(WR1-WS1);

      WS3 = (WeekLow - (2*(WeekHigh-WeekPivot)));
      WR3 = (WeekHigh + (2*(WeekPivot-WeekLow)));

//--------------------------------------------------------
//--------------------------------------------------------


ArrayCopyRates(Month_Price, Symbol(), 43200);

MonthHigh  = Month_Price[1][3];
MonthLow   = Month_Price[1][2];
MonthClose = Month_Price[1][4];

MonthPivot = ((MonthHigh + MonthLow + MonthClose)/3);

      MR1 = (2*MonthPivot)-MonthLow;
      MS1 = (2*MonthPivot)-MonthHigh;

      MR2 = MonthPivot+(MR1-MS1);
      MS2 = MonthPivot-(MR1-MS1);

      MS3 = (MonthLow - (2*(MonthHigh-MonthPivot)));
      MR3 = (MonthHigh + (2*(MonthPivot-MonthLow)));

//--------------------------------------------------------
datetime dopen=iTime(Symbol(),PERIOD_D1,0);

if (Daily==true)
 {
  TimeToStr(CurTime());
  ObjectCreate("PivotLine", OBJ_TREND, 0, dopen, Pivot, CurTime(), Pivot);
  ObjectSet("PivotLine", OBJPROP_COLOR, cdpivot);
  ObjectSet("PivotLine", OBJPROP_STYLE, pivot_line_type);
  ObjectSet("PivotLine", OBJPROP_WIDTH, pivot_width);

 if(ObjectFind("PivotLabel") != 0)
  {
   ObjectCreate("PivotLabel", OBJ_TEXT, 0, CurTime()+(240*60)*D_label_pos, Pivot);
   ObjectSetText("PivotLabel", ("D Pivot"), 8, "Arial", cdpivot);
  }
 else
  {
   ObjectMove("PivotLabel", 0, CurTime()+(240*60)*D_label_pos, Pivot);
  }
ObjectsRedraw();

//--------------------------------------------------------

if (Daily_SR_Levels==true)
 {
  ObjectCreate("R1_Line", OBJ_TREND,0, dopen, R1, CurTime(),R1);
  ObjectSet("R1_Line", OBJPROP_COLOR, cdr1);
  ObjectSet("R1_Line", OBJPROP_STYLE, resist_line_type);
  ObjectSet("R1_Line", OBJPROP_WIDTH, resist_width);

 if(ObjectFind("R1_Label") != 0)
  {
   ObjectCreate("R1_Label", OBJ_TEXT, 0, CurTime()+(240*60)*D_label_pos, R1);
   ObjectSetText("R1_Label", "D R1", 8, "Arial", cdr1);
  }
 else
  {
   ObjectMove("R1_Label", 0, CurTime()+(240*60)*D_label_pos, R1);
  }

//--------------------------------------------------------

   ObjectCreate("R2_Line", OBJ_TREND,0, dopen, R2, CurTime(),R2);
   ObjectSet("R2_Line", OBJPROP_COLOR, cdr2);
   ObjectSet("R2_Line", OBJPROP_STYLE, resist_line_type);
   ObjectSet("R2_Line", OBJPROP_WIDTH, resist_width);
 if(ObjectFind("R2_Label") != 0)
  {
   ObjectCreate("R2_Label", OBJ_TEXT, 0, CurTime()+(240*60)*D_label_pos, R2);
   ObjectSetText("R2_Label", "D R2", 8, "Arial", cdr2);
  }
 else
  {
   ObjectMove("R2_Label", 0, CurTime()+(240*60)*D_label_pos, R2);
  }

//---------------------------------------------------------

   ObjectCreate("R3_Line", OBJ_TREND,0, dopen, R3, CurTime(),R3);
   ObjectSet("R3_Line", OBJPROP_COLOR, cdr3);
   ObjectSet("R3_Line", OBJPROP_STYLE, resist_line_type);
   ObjectSet("R3_Line", OBJPROP_WIDTH, resist_width);

 if(ObjectFind("R3_Label") != 0)
  {
   ObjectCreate("R3_Label", OBJ_TEXT, 0, CurTime()+(240*60)*D_label_pos, R3);
   ObjectSetText("R3_Label", "D R3", 8, "Arial", cdr3);
  }
 else
  {
   ObjectMove("R3_Label", 0, CurTime()+(240*60)*D_label_pos, R3);
  }

//---------------------------------------------------------

   ObjectCreate("S1_Line", OBJ_TREND,0, dopen, S1, CurTime(),S1);
   ObjectSet("S1_Line", OBJPROP_COLOR, cds1);
   ObjectSet("S1_Line", OBJPROP_STYLE, support_line_type);
   ObjectSet("S1_Line", OBJPROP_WIDTH, support_width);
 if(ObjectFind("S1_Label") != 0)
  {
   ObjectCreate("S1_Label", OBJ_TEXT, 0, CurTime()+(240*60)*D_label_pos, S1);
   ObjectSetText("S1_Label", "D S1", 8, "Arial", cds1);
  }
 else
  {
   ObjectMove("S1_Label", 0, CurTime()+(240*60)*D_label_pos, S1);
  }

//---------------------------------------------------------

   ObjectCreate("S2_Line", OBJ_TREND,0, dopen, S2, CurTime(),S2);
   ObjectSet("S2_Line", OBJPROP_COLOR, cds2);
   ObjectSet("S2_Line", OBJPROP_STYLE, support_line_type);
   ObjectSet("S2_Line", OBJPROP_WIDTH, support_width);
 if(ObjectFind("S2_Label") != 0)
  {
   ObjectCreate("S2_Label", OBJ_TEXT, 0, CurTime()+(240*60)*D_label_pos, S2);
   ObjectSetText("S2_Label", "D S2", 8, "Arial", cds2);
  }
 else
  {
   ObjectMove("S2_Label", 0, CurTime()+(240*60)*D_label_pos, S2);
  }

//---------------------------------------------------------

   ObjectCreate("S3_Line", OBJ_TREND,0, dopen, S3, CurTime(),S3);
   ObjectSet("S3_Line", OBJPROP_COLOR, cds3);
   ObjectSet("S3_Line", OBJPROP_STYLE, support_line_type);
   ObjectSet("S3 _Line", OBJPROP_WIDTH, support_width);
 if(ObjectFind("S3_Label") != 0)
  {
   ObjectCreate("S3_Label", OBJ_TEXT, 0, CurTime()+(240*60)*D_label_pos, S3);
   ObjectSetText("S3_Label", "D S3", 8, "Arial", cds3);
  }
 else
  {
   ObjectMove("S3_Label", 0, CurTime()+(240*60)*D_label_pos, S3);
  }
 }
ObjectsRedraw();
}

//---------------------------------------------------------
//---------------------------------------------------------
//---------------------------------------------------------
datetime wopen=iTime(Symbol(),PERIOD_W1,0);

if (Weekly==true)
 {
  ObjectCreate("WeekPivotLine", OBJ_TREND,0, wopen,WeekPivot,CurTime(),WeekPivot);
  ObjectSet("WeekPivotLine", OBJPROP_COLOR, cwpivot);
  ObjectSet("WeekPivotLine", OBJPROP_STYLE, pivot_line_type);
  ObjectSet("WeekPivotLine", OBJPROP_WIDTH, pivot_width);
 if(ObjectFind("WeekPivotLabel") != 0)
  {
   ObjectCreate("WeekPivotLabel", OBJ_TEXT, 0, CurTime()+(240*60)*W_label_pos, WeekPivot);
   ObjectSetText("WeekPivotLabel", "W Pivot", 8, "Arial", cwpivot);
  }
 else
  {
   ObjectMove("WeekPivotLabel", 0, CurTime()+(240*60)*W_label_pos, WeekPivot);
  }

//--------------------------------------------------------

if (Weekly_SR_Levels==true)
 {
  ObjectCreate("WR1_Line", OBJ_TREND,0, wopen, WR1, CurTime(),WR1);
  ObjectSet("WR1_Line", OBJPROP_COLOR, cwr1);
  ObjectSet("WR1_Line", OBJPROP_STYLE, resist_line_type);
  ObjectSet("WR1_Line", OBJPROP_WIDTH, resist_width);
 if(ObjectFind("WR1_Label") != 0)
  {
   ObjectCreate("WR1_Label", OBJ_TEXT, 0, CurTime()+(240*60)*W_label_pos, WR1);
   ObjectSetText("WR1_Label", "W R1", 8, "Arial", cwr1);
  }
 else
  {
   ObjectMove("WR1_Label", 0, CurTime()+(240*60)*W_label_pos, WR1);
  }

//--------------------------------------------------------

   ObjectCreate("WR2_Line", OBJ_TREND,0, wopen,WR2,CurTime(),WR2);
   ObjectSet("WR2_Line", OBJPROP_COLOR, cwr2);
   ObjectSet("WR2_Line", OBJPROP_STYLE, resist_line_type);
   ObjectSet("WR2_Line", OBJPROP_WIDTH, resist_width);
 if(ObjectFind("WR2_Label") != 0)
  {
   ObjectCreate("WR2_Label", OBJ_TEXT, 0, CurTime()+(240*60)*W_label_pos, WR2);
   ObjectSetText("WR2_Label", " W R2", 8, "Arial", cwr2);
  }
 else
  {
   ObjectMove("WR2_Label", 0, CurTime()+(240*60)*W_label_pos, WR2);
  }

//---------------------------------------------------------

   ObjectCreate("WR3_Line", OBJ_TREND,0, wopen,WR3, CurTime(),WR3);
   ObjectSet("WR3_Line", OBJPROP_COLOR, cwr3);
   ObjectSet("WR3_Line", OBJPROP_STYLE, resist_line_type);
   ObjectSet("WR3_Line", OBJPROP_WIDTH, resist_width);
 if(ObjectFind("WR3_Label") != 0)
  {
   ObjectCreate("WR3_Label", OBJ_TEXT, 0, CurTime()+(240*60)*W_label_pos, WR3);
   ObjectSetText("WR3_Label", " W R3", 8, "Arial", cwr3);
  }
 else
  {
   ObjectMove("WR3_Label", 0, CurTime()+(240*60)*W_label_pos, WR3);
  }

//---------------------------------------------------------

   ObjectCreate("WS1_Line", OBJ_TREND,0, wopen,WS1, CurTime(),WS1);
   ObjectSet("WS1_Line", OBJPROP_COLOR, cws1);
   ObjectSet("WS1_Line", OBJPROP_STYLE, support_line_type);
   ObjectSet("WS1_Line", OBJPROP_WIDTH, support_width);
 if(ObjectFind("WS1_Label") != 0)
  {
   ObjectCreate("WS1_Label", OBJ_TEXT, 0, CurTime()+(240*60)*W_label_pos, WS1);
   ObjectSetText("WS1_Label", "W S1", 8, "Arial", cws1);
  }
 else
  {
   ObjectMove("WS1_Label", 0, CurTime()+(240*60)*W_label_pos, WS1);
  }

//---------------------------------------------------------

   ObjectCreate("WS2_Line", OBJ_TREND,0, wopen,WS2, CurTime(),WS2);
   ObjectSet("WS2_Line", OBJPROP_COLOR, cws2);
   ObjectSet("WS2_Line", OBJPROP_STYLE, support_line_type);
   ObjectSet("WS2_Line", OBJPROP_WIDTH, support_width);
 if(ObjectFind("WS2_Label") != 0)
  {
   ObjectCreate("WS2_Label", OBJ_TEXT, 0, CurTime()+(240*60)*W_label_pos, WS2);
   ObjectSetText("WS2_Label", "W S2", 8, "Arial", cws2);
  }
 else
  {
   ObjectMove("WS2_Label", 0, CurTime()+(240*60)*W_label_pos, WS2);
  }

//---------------------------------------------------------

   ObjectCreate("WS3_Line", OBJ_TREND,0, wopen,WS3, CurTime(),WS3);
   ObjectSet("WS3_Line", OBJPROP_COLOR, cws3);
   ObjectSet("WS3_Line", OBJPROP_STYLE, support_line_type);
   ObjectSet("WS3_Line", OBJPROP_WIDTH, support_width);
 if(ObjectFind("WS3_Label") != 0)
  {
   ObjectCreate("WS3_Label", OBJ_TEXT, 0, CurTime()+(240*60)*W_label_pos, WS3);
   ObjectSetText("WS3_Label", "W S3", 8, "Arial", cws3);
  }
 else
  {
   ObjectMove("WS3_Label", 0, CurTime()+(240*60)*M_label_pos, WS3);
  }
 }
}

//---------------------------------------------------------
//---------------------------------------------------------
//---------------------------------------------------------
datetime mopen=iTime(Symbol(),PERIOD_MN1,0);


if (Monthly==true)
 {
  ObjectCreate("MonthPivotLine", OBJ_TREND,0, mopen, MonthPivot, CurTime(),MonthPivot);
  ObjectSet("MonthPivotLine", OBJPROP_COLOR, cmpivot);
  ObjectSet("MonthPivotLine", OBJPROP_STYLE, pivot_line_type);
  ObjectSet("MonthPivotLine", OBJPROP_WIDTH, pivot_width);
 if(ObjectFind("MonthPivotLabel") != 0)
  {
   ObjectCreate("MonthPivotLabel", OBJ_TEXT, 0, CurTime()+(240*60)*M_label_pos, MonthPivot);
   ObjectSetText("MonthPivotLabel", "M Pivot", 8, "Arial", cmpivot);
  }
 else
  {
   ObjectMove("MonthPivotLabel", 0, CurTime()+(240*60)*M_label_pos, MonthPivot);
  }

//--------------------------------------------------------

if (Monthly_SR_Levels==true)
 {
  ObjectCreate("MR1_Line", OBJ_TREND,0, mopen, MR1, CurTime(),MR1);
  ObjectSet("MR1_Line", OBJPROP_COLOR, cmr1);
  ObjectSet("MR1_Line", OBJPROP_STYLE, resist_line_type);
  ObjectSet("MR1_Line", OBJPROP_WIDTH, resist_width);
 if(ObjectFind("MR1_Label") != 0)
  {
   ObjectCreate("MR1_Label", OBJ_TEXT, 0, CurTime()+(240*60)*M_label_pos, MR1);
   ObjectSetText("MR1_Label", " M R1", 8, "Arial", cmr1);
  }
 else
  {
   ObjectMove("MR1_Label", 0, CurTime()+(240*60)*M_label_pos, MR1);
  }

//--------------------------------------------------------

   ObjectCreate("MR2_Line", OBJ_TREND,0, mopen, MR2, CurTime(),MR2);
   ObjectSet("MR2_Line", OBJPROP_COLOR, cmr2);
   ObjectSet("MR2_Line", OBJPROP_STYLE, resist_line_type);
   ObjectSet("MR2_Line", OBJPROP_WIDTH, resist_width);
 if(ObjectFind("MR2_Label") != 0)
  {
   ObjectCreate("MR2_Label", OBJ_TEXT, 0, CurTime()+(240*60)*M_label_pos, MR2);
   ObjectSetText("MR2_Label", " M R2", 8, "Arial", cmr2);
  }
 else
  {
   ObjectMove("MR2_Label", 0, CurTime()+(240*60)*M_label_pos, MR2);
  }

//---------------------------------------------------------

   ObjectCreate("MR3_Line", OBJ_TREND,0, mopen, MR3, CurTime(),MR3);
   ObjectSet("MR3_Line", OBJPROP_COLOR, cmr3);
   ObjectSet("MR3_Line", OBJPROP_STYLE, resist_line_type);
   ObjectSet("MR3_Line", OBJPROP_WIDTH, resist_width);
 if(ObjectFind("MR3_Label") != 0)
  {
   ObjectCreate("MR3_Label", OBJ_TEXT, 0, CurTime()+(240*60)*M_label_pos, MR3);
   ObjectSetText("MR3_Label", " M R3", 8, "Arial", cmr3);
  }
 else
  {
   ObjectMove("MR3_Label", 0, CurTime()+(240*60)*M_label_pos, MR3);
  }

//---------------------------------------------------------

   ObjectCreate("MS1_Line", OBJ_TREND,0, mopen, MS1, CurTime(),MS1);
   ObjectSet("MS1_Line", OBJPROP_COLOR, cms1);
   ObjectSet("MS1_Line", OBJPROP_STYLE, support_line_type);
   ObjectSet("MS1_Line", OBJPROP_WIDTH, support_width);

 if(ObjectFind("MS1_Label") != 0)
  {
   ObjectCreate("MS1_Label", OBJ_TEXT, 0, CurTime()+(240*60)*M_label_pos, MS1);
   ObjectSetText("MS1_Label", "M S1", 8, "Arial", cms1);
  }
 else
  {
   ObjectMove("MS1_Label", 0, CurTime()+(240*60)*M_label_pos, MS1);
  }

//---------------------------------------------------------

   ObjectCreate("MS2_Line", OBJ_TREND,0, mopen, MS2, CurTime(),MS2);
   ObjectSet("MS2_Line", OBJPROP_COLOR, cms2);
   ObjectSet("MS2_Line", OBJPROP_STYLE, support_line_type);
   ObjectSet("MS2_Line", OBJPROP_WIDTH, support_width);
 if(ObjectFind("MS2_Label") != 0)
  {
   ObjectCreate("MS2_Label", OBJ_TEXT, 0, CurTime()+(240*60)*M_label_pos, MS2);
   ObjectSetText("MS2_Label", "M S2", 8, "Arial", cms2);
  }
 else
  {
   ObjectMove("MS2_Label", 0, CurTime()+(240*60)*M_label_pos, MS2);
  }

//---------------------------------------------------------

   ObjectCreate("MS3_Line", OBJ_TREND,0, mopen, MS3, CurTime(),MS3);
   ObjectSet("MS3_Line", OBJPROP_COLOR, cms3);
   ObjectSet("MS3_Line", OBJPROP_STYLE, support_line_type);
   ObjectSet("MS3_Line", OBJPROP_WIDTH, support_width);
 if(ObjectFind("MS3_Label") != 0)
  {
   ObjectCreate("MS3_Label", OBJ_TEXT, 0, CurTime()+(240*60)*M_label_pos, MS3);
   ObjectSetText("MS3_Label", "M S3", 8, "Arial", cms3);
  }
 else
  {
   ObjectMove("MS3_Label", 0, CurTime()+(240*60)*M_label_pos, MS3);
  }
 }
}
//---------------------------------------------------------

ObjectsRedraw();

   return(0);
}   