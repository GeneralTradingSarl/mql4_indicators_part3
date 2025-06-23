#property copyright "2012, ovo.cz"
#property link "ovo.cz/#"

/**
* Displays upper and lower marks, where current range or renko bar is supposed to close.
* Displays info about the chart range.
*/

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Red
#property indicator_color2 Red
//--- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];

extern int ARROW_CODE=215; // try 203, 204, 214, 215, 219, 220, 223, 224, 231,232, 239, 240, 243, 249, 250, 251
extern string _="(33 through 255)";
extern bool SHOW_RANGE_INFO=true;

double nothing;
double hlRange = EMPTY;
double ocRange = EMPTY;
double stepRange=EMPTY;

int startIdx=1;
int endIdx=10;

int type=EMPTY;

#define RANGEBAR 1
#define RENKO 2
#define MEAN_RENKO 3
//----
#define TF_LABEL "tf label"
int CORNER=1;
int FONT_SIZE=7;
color COLOR=DarkGray;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init() 
  {

   nothing=Point/100.0;

   IndicatorBuffers(2);

   SetIndexArrow(0,ARROW_CODE);
   SetIndexArrow(1,ARROW_CODE);

   SetIndexStyle(0,DRAW_ARROW);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexEmptyValue(0,EMPTY_VALUE);

   SetIndexStyle(1,DRAW_ARROW);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexEmptyValue(1,EMPTY_VALUE);

   SetIndexShift(0,1);
   SetIndexShift(1,1);

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/** returns true if processed with enough bars 
*/
bool resolveRanges() 
  {
   int i,j;
   if(Bars<endIdx) 
     {
      return(false);
     }

// check ocurrence of equal HL (rangebar)
   for(j=0; j<3; j++) 
     {
      int hlRangeMatch= 0;
      double hlRange1 = High[startIdx+j]-Low[startIdx+j];
      for(i=startIdx; i<=endIdx; i++) 
        {
         double hlRange2=High[i]-Low[i];
         if(MathAbs(hlRange2-hlRange1)<nothing) 
           { // range1 == range2
            hlRangeMatch++;
           }
        }
      if(hlRangeMatch>(endIdx-startIdx)*0.6) 
        {
         hlRange=hlRange1;
        }
     }

// check ocurrence of equal OC (renko)
   for(j=0; j<3; j++) 
     {
      int ocRangeMatch= 0;
      double ocRange1 = MathAbs(Close[startIdx+j]-Open[startIdx+j]);
      for(i=startIdx; i<=endIdx; i++) 
        {
         double ocRange2=MathAbs(Close[i]-Open[i]);
         if(MathAbs(ocRange2-ocRange1)<nothing) 
           { // range1 == range2
            ocRangeMatch++;
           }
        }
      if(ocRangeMatch>(endIdx-startIdx)*0.6) 
        {
         ocRange=ocRange1;
        }
     }

// check ocurrence of  equal O-O distance (renko)
   for(j=0; j<3; j++) 
     {
      int stepRangeMatch= 0;
      double stepRange1 = MathAbs(Close[startIdx+j]+Open[startIdx+j]-Close[startIdx+j+1]-Open[startIdx+j+1]);
      for(i=startIdx; i<=endIdx; i++) 
        {
         double stepRange2=MathAbs(Close[i]+Open[i]-Close[i+1]-Open[i+1]);
         if(MathAbs(stepRange2-stepRange1)<nothing) 
           { // range1 == range2
            stepRangeMatch++;
           }
        }
      if(stepRangeMatch>(endIdx-startIdx)*0.6) 
        {
         stepRange=stepRange1/2.0;
        }
     }

   if(stepRange>EMPTY) 
     { //renko or meanrenko
      if((MathAbs(stepRange-ocRange))<nothing) 
        { // renko
         type=RENKO;
           } else { // meanrenko
         type=MEAN_RENKO;
        }
        } else if(hlRange>EMPTY) { // rangebar
      type=RANGEBAR;
     }

   return (true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit() 
  {
   ObjectDelete(TF_LABEL);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start() 
  {

   if(Bars<endIdx) 
     {
      return(false);
     }
   static datetime refBarTime;
   if(Time[1]!=refBarTime) 
     {
      // clear buffers
      ArrayInitialize(ExtMapBuffer1,EMPTY_VALUE);
      ArrayInitialize(ExtMapBuffer2,EMPTY_VALUE);
      resolveRanges();
     }
   switch(type) 
     {
      case RANGEBAR:
         double current=hlRange-High[0]+Low[0];
         ExtMapBuffer1[0] = Low[0] - current;
         ExtMapBuffer2[0] = High[0] + current;
         int tickHlRange=MathRound(hlRange/Point);
         displayRangeInfo("RANGEBAR "+tickHlRange);
         break;
      case RENKO:
      case MEAN_RENKO:
         if(Time[1]!=refBarTime) 
           { // change only on a new bar
            ExtMapBuffer1[0] = MathMin( Open[1], Close[1]) - stepRange;
            ExtMapBuffer2[0] = MathMax( Open[1], Close[1]) + stepRange;
           }
         int tickStepRange=MathRound(stepRange/Point);
         int tickOcRange=MathRound(ocRange/Point);
         string text="RENKO "+tickOcRange;
         if(tickOcRange!=tickStepRange) 
           { // mean renko step info
            text=text+" ("+tickStepRange+")";
           }
         displayRangeInfo(text);
         break;
      default:
         break;
     }

   if(Time[1]!=refBarTime) 
     {
      refBarTime=Time[1];
     }

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void displayRangeInfo(string tfstring) 
  {
   if(SHOW_RANGE_INFO) 
     {
      if(ObjectCreate(TF_LABEL,OBJ_LABEL,0,0,0)) 
        {
         ObjectSet(TF_LABEL,OBJPROP_BACK,true);
         ObjectSet(TF_LABEL,OBJPROP_XDISTANCE,3);
         if(CORNER<2)
            ObjectSet(TF_LABEL,OBJPROP_YDISTANCE,17);
         else
            ObjectSet(TF_LABEL,OBJPROP_YDISTANCE,1);
         ObjectSet(TF_LABEL,OBJPROP_CORNER,CORNER);
        }
      tfstring=tfstring+" ";
      ObjectSetText(TF_LABEL,tfstring,FONT_SIZE,"",COLOR);
     }
  }
//+------------------------------------------------------------------+
