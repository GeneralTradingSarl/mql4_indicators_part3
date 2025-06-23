//+------------------------------------------------------------------+
//|                                             Premium-Pivot-V2.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, KSforex."
#property link      "https://www.mql5.com/en/code/25188/"
#property version   "2.00"
#property description "FREE PIVOT INDICATOR"
#property strict
#property indicator_chart_window
#property indicator_buffers 21


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// extern
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// extern
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// extern

enum aperiod{M1=1,M5=5,M15=15,M30=30,H1=60,H4=240,D1=1440,W1=10080,MN=43200,};
enum edrawing{Yes = 0 , No = 12 ,} ;
enum ewidth {w_1=1,w_2=2,w_3=3,w_4=4,w_5=5,} ;

extern ENUM_TIMEFRAMES PivotRefresh = PERIOD_M15; // Refresh Period (To save CPU)
extern string Displaylines991 = "_____<Pivot_1>_____"; // ___________________________________________________________________________
extern bool P1_enable = true;  // Enable Pivot 1 ?
extern aperiod period_1 = D1;                    // Period
extern edrawing drawing_P_1=Yes; // Display Lines P
extern edrawing drawing_SR_1=Yes; // Display Lines S / R
extern ENUM_LINE_STYLE Line_style_P_1 = STYLE_SOLID; // STYLE Lines P 
extern ENUM_LINE_STYLE Line_style_SR_1 = STYLE_SOLID; // STYLE Lines S / R 
extern ewidth Line_width_P_1 = w_2;    // Width Lines P 
extern ewidth Line_width_SR_1 = w_1;    // Width Lines S/R 
extern color Line_pivot_Color_1 = Maroon;              // Line P
extern color Line_S_Color_1 = C'70,0,0';       // Line S
extern color Line_R_Color_1 = C'70,0,0';         // Line R
extern bool Display_Lable_P_1 = false; // Display Lable P
extern bool Display_Lable_SR_1 = false; // Display Lables S / R

extern string Displaylines992 = "_____<Pivot_2>_____"; // ___________________________________________________________________________
extern bool P2_enable = true;  // Enable Pivot 2 ?
extern aperiod period_2 = W1;                    // Period
extern edrawing drawing_P_2=Yes; // Display Lines P
extern edrawing drawing_SR_2=No; // Display Lines S / R
extern ENUM_LINE_STYLE Line_style_P_2 = STYLE_SOLID; // STYLE Lines P 
extern ENUM_LINE_STYLE Line_style_SR_2 = STYLE_SOLID; // STYLE Lines S / R 
extern ewidth Line_width_P_2 = w_2;    // Width Lines P 
extern ewidth Line_width_SR_2 = w_1;    // Width Lines S/R 
extern color Line_pivot_Color_2 = C'91,0,91';              // Line P
extern color Line_S_Color_2 = C'91,0,91';       // Line S
extern color Line_R_Color_2 = C'91,0,91';         // Line R
extern bool Display_Lable_P_2 = false; // Display Lable P
extern bool Display_Lable_SR_2 = false; // Display Lables S / R

extern string Displaylines993 = "_____<Pivot_3>_____"; // ___________________________________________________________________________
extern bool P3_enable = true;  // Enable Pivot 3 ?
extern aperiod period_3 = MN;                    // Period
extern edrawing drawing_P_3=Yes; // Display Lines P
extern edrawing drawing_SR_3=No; // Display Lines S / R
extern ENUM_LINE_STYLE Line_style_P_3 = STYLE_SOLID; // STYLE Lines P 
extern ENUM_LINE_STYLE Line_style_SR_3 = STYLE_SOLID; // STYLE Lines S / R 
extern ewidth Line_width_P_3 = w_2;    // Width Lines P 
extern ewidth Line_width_SR_3 = w_1;    // Width Lines S/R 
extern color Line_pivot_Color_3 = Teal;              // Line P
extern color Line_S_Color_3 = Teal;       // Line S
extern color Line_R_Color_3 = Teal;         // Line R
extern bool Display_Lable_P_3 = false; // Display Lable P
extern bool Display_Lable_SR_3 = false; // Display Lables S / R

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// extern
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// extern
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// extern

double PBuffer_1[];
double S1Buffer_1[];
double R1Buffer_1[];
double S2Buffer_1[];
double R2Buffer_1[];
double S3Buffer_1[];
double R3Buffer_1[];
double PBuffer_2[];
double S1Buffer_2[];
double R1Buffer_2[];
double S2Buffer_2[];
double R2Buffer_2[];
double S3Buffer_2[];
double R3Buffer_2[];
double PBuffer_3[];
double S1Buffer_3[];
double R1Buffer_3[];
double S2Buffer_3[];
double R2Buffer_3[];
double S3Buffer_3[];
double R3Buffer_3[];

string Pv, S, SS, SSS;
string R, RR, RRR;
string Pivot, Sup1, Sup2, Sup3, Res1, Res2, Res3, txtPivot, txtSup1, txtSup2, txtSup3, txtRes1, txtRes2, txtRes3;
string Pivot1, Sup11, Sup21, Sup31, Res11, Res21, Res31, txtPivot1, txtSup11, txtSup21, txtSup31, txtRes11, txtRes21, txtRes31;
string Pivot2, Sup12, Sup22, Sup32, Res12, Res22, Res32, txtPivot2, txtSup12, txtSup22, txtSup32, txtRes12, txtRes22, txtRes32;
string Pivot3, Sup13, Sup23, Sup33, Res13, Res23, Res33, txtPivot3, txtSup13, txtSup23, txtSup33, txtRes13, txtRes23, txtRes33;
double P,S1,R1,S2,R2,S3,R3;
double Q,x;
datetime LastActiontime;


//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//---- TODO: add your code here
remove_obj (1);
remove_obj (2);
remove_obj (3);
}
  
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {

string short_name;
//---- indicator line

if ((Line_style_P_1!=0)&&P1_enable) Line_width_P_1=1 ;
if ((Line_style_SR_1!=0)&&P1_enable) Line_width_SR_1=1 ;
if ((Line_style_P_2!=0)&&P2_enable) Line_width_P_2=1 ;
if ((Line_style_SR_2!=0)&&P2_enable) Line_width_SR_2=1 ;
if ((Line_style_P_3!=0)&&P2_enable) Line_width_P_3=1 ;
if ((Line_style_SR_3!=0)&&P2_enable) Line_width_SR_3=1 ;

if (P1_enable)
{
   SetIndexStyle(0,drawing_P_1,Line_style_P_1,Line_width_P_1,Line_pivot_Color_1);
   SetIndexStyle(1,drawing_SR_1,Line_style_SR_1,Line_width_SR_1,Line_S_Color_1);
   SetIndexStyle(2,drawing_SR_1,Line_style_SR_1,Line_width_SR_1,Line_R_Color_1);
   SetIndexStyle(3,drawing_SR_1,Line_style_SR_1,Line_width_SR_1,Line_S_Color_1);
   SetIndexStyle(4,drawing_SR_1,Line_style_SR_1,Line_width_SR_1,Line_R_Color_1);
   SetIndexStyle(5,drawing_SR_1,Line_style_SR_1,Line_width_SR_1,Line_S_Color_1);
   SetIndexStyle(6,drawing_SR_1,Line_style_SR_1,Line_width_SR_1,Line_R_Color_1);
   SetIndexBuffer(0,PBuffer_1);
   SetIndexBuffer(1,S1Buffer_1);
   SetIndexBuffer(2,R1Buffer_1);
   SetIndexBuffer(3,S2Buffer_1);
   SetIndexBuffer(4,R2Buffer_1);
   SetIndexBuffer(5,S3Buffer_1);
   SetIndexBuffer(6,R3Buffer_1);
}
if (P2_enable)
{
   SetIndexStyle(7,drawing_P_2,Line_style_P_2,Line_width_P_2,Line_pivot_Color_2);
   SetIndexStyle(8,drawing_SR_2,Line_style_SR_2,Line_width_SR_2,Line_S_Color_2);
   SetIndexStyle(9,drawing_SR_2,Line_style_SR_2,Line_width_SR_2,Line_R_Color_2);
   SetIndexStyle(10,drawing_SR_2,Line_style_SR_2,Line_width_SR_2,Line_S_Color_2);
   SetIndexStyle(11,drawing_SR_2,Line_style_SR_2,Line_width_SR_2,Line_R_Color_2);
   SetIndexStyle(12,drawing_SR_2,Line_style_SR_2,Line_width_SR_2,Line_S_Color_2);
   SetIndexStyle(13,drawing_SR_2,Line_style_SR_2,Line_width_SR_2,Line_R_Color_2);
   SetIndexBuffer(7,PBuffer_2);
   SetIndexBuffer(8,S1Buffer_2);
   SetIndexBuffer(9,R1Buffer_2);
   SetIndexBuffer(10,S2Buffer_2);
   SetIndexBuffer(11,R2Buffer_2);
   SetIndexBuffer(12,S3Buffer_2);
   SetIndexBuffer(13,R3Buffer_2);
}
if (P3_enable)
{
   SetIndexStyle(14,drawing_P_3,Line_style_P_3,Line_width_P_3,Line_pivot_Color_3);
   SetIndexStyle(15,drawing_SR_3,Line_style_SR_3,Line_width_SR_3,Line_S_Color_3);
   SetIndexStyle(16,drawing_SR_3,Line_style_SR_3,Line_width_SR_3,Line_R_Color_3);
   SetIndexStyle(17,drawing_SR_3,Line_style_SR_3,Line_width_SR_3,Line_S_Color_3);
   SetIndexStyle(18,drawing_SR_3,Line_style_SR_3,Line_width_SR_3,Line_R_Color_3);
   SetIndexStyle(19,drawing_SR_3,Line_style_SR_3,Line_width_SR_3,Line_S_Color_3);
   SetIndexStyle(20,drawing_SR_3,Line_style_SR_3,Line_width_SR_3,Line_R_Color_3);
   SetIndexBuffer(14,PBuffer_3);
   SetIndexBuffer(15,S1Buffer_3);
   SetIndexBuffer(16,R1Buffer_3);
   SetIndexBuffer(17,S2Buffer_3);
   SetIndexBuffer(18,R2Buffer_3);
   SetIndexBuffer(19,S3Buffer_3);
   SetIndexBuffer(20,R3Buffer_3);
}

//---- name for DataWindow and indicator subwindow label
   short_name="Pivot_Multi";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
//----
   SetIndexDrawBegin(0,1);
//----
//----
   return(0);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, // total bars
                const int prev_calculated, // calculated bars by indicator
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
  

   ObjectDelete(Pivot1);
   ObjectDelete(Sup11);
   ObjectDelete(Res11);
   ObjectDelete(Sup21);
   ObjectDelete(Res21);
   ObjectDelete(Sup31);
   ObjectDelete(Res31);
   ObjectDelete(txtPivot1);
   ObjectDelete(txtSup11);
   ObjectDelete(txtRes11);
   ObjectDelete(txtSup21);
   ObjectDelete(txtRes21);
   ObjectDelete(txtSup31);
   ObjectDelete(txtRes31);

   ObjectDelete(Pivot2);
   ObjectDelete(Sup12);
   ObjectDelete(Res12);
   ObjectDelete(Sup22);
   ObjectDelete(Res22);
   ObjectDelete(Sup32);
   ObjectDelete(Res32);
   ObjectDelete(txtPivot2);
   ObjectDelete(txtSup12);
   ObjectDelete(txtRes12);
   ObjectDelete(txtSup22);
   ObjectDelete(txtRes22);
   ObjectDelete(txtSup32);
   ObjectDelete(txtRes32);
   
   ObjectDelete(Pivot3);
   ObjectDelete(Sup13);
   ObjectDelete(Res13);
   ObjectDelete(Sup23);
   ObjectDelete(Res23);
   ObjectDelete(Sup33);
   ObjectDelete(Res33);
   ObjectDelete(txtPivot3);
   ObjectDelete(txtSup13);
   ObjectDelete(txtRes13);
   ObjectDelete(txtSup23);
   ObjectDelete(txtRes23);
   ObjectDelete(txtSup33);
   ObjectDelete(txtRes33);





   ///////////////////////
   
   int limit = rates_total;
   int count=prev_calculated;
   int    i,counted_bars=IndicatorCounted();;
   //---- indicator calculation
   if (counted_bars==0)
     {
      x=Period();
      if (x>240) return(-1);
      
     }
   if(counted_bars<0) return(-1);
   //---- last counted bar will be recounted
   //   if(counted_bars>0) counted_bars--;
   limit=(Bars-counted_bars)-1;
   // if (Max_Bars>0)   limit=Max_Bars;




for( i=limit-count; i>=1;i--)  
{
if(LastActiontime!=iTime(NULL,PivotRefresh,i))
{
LastActiontime=iTime(NULL,PivotRefresh,i);

   if (P1_enable) pivot (1 , period_1 , i , Line_pivot_Color_1, Line_S_Color_1, Line_R_Color_1, Display_Lable_P_1, Display_Lable_SR_1);
   if (P2_enable) pivot (2 , period_2 , i , Line_pivot_Color_2, Line_S_Color_2, Line_R_Color_2, Display_Lable_P_2, Display_Lable_SR_2);
   if (P3_enable) pivot (3 , period_3 , i , Line_pivot_Color_3, Line_S_Color_3, Line_R_Color_3, Display_Lable_P_3, Display_Lable_SR_3);



} // Main loob
} // Run per bar

//+------------------------------------------------------------------+
  return(0);
}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                           Functions                              |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+


int pivot ( int n, int Fperiod , int i ,color Flable_pivot_Color, color Flable_S_Color, color Flable_R_Color , bool FDisplay_Lable_P , bool FDisplay_Lable_SR )
{      
    int dayi;
    dayi = iBarShift(Symbol(), Fperiod, Time[i], false);
    Q = (iHigh(Symbol(), Fperiod,dayi + 1) - iLow(Symbol(), Fperiod, dayi + 1));
    P = (iHigh(Symbol(), Fperiod, dayi + 1) + iLow(Symbol(), Fperiod, dayi + 1) + iClose(Symbol(), Fperiod, dayi + 1)) / 3; 
    
    //---
      R1=(2*P)-iLow(Symbol(), Fperiod, dayi + 1);
      S1=(2*P)-iHigh(Symbol(), Fperiod,dayi + 1);
      R2=P+(iHigh(Symbol(), Fperiod,dayi + 1) - iLow(Symbol(), Fperiod, dayi + 1));
      S2=P-(iHigh(Symbol(), Fperiod,dayi + 1) - iLow(Symbol(), Fperiod, dayi + 1));
      R3=(2*P)+(iHigh(Symbol(), Fperiod,dayi + 1)-(2*iLow(Symbol(), Fperiod, dayi + 1)));
      S3=(2*P)-((2* iHigh(Symbol(), Fperiod,dayi + 1))-iLow(Symbol(), Fperiod, dayi + 1));
    //---
   if (Fperiod < 60)
   {  
    Pv = "Pivot";
    S = "S 1"; SS = "S 2"; SSS = "S 3";
    R = "R 1"; RR = "R 2"; RRR = "R 3";
    Pivot = "Pivot"; Sup1 = "Sup1"; Sup2 = "Sup2"; Sup3 = "Sup3";
    Res1 = "Res1"; Res2 = "Res2"; Res3 = "Res3";
    txtPivot = "txtPivot"; txtSup1 = "txtSup1"; txtSup2 = "txtSup2";  txtSup3 = "txtSup3";
    txtRes1 = "txtRes1"; txtRes2 = "txtRes2"; txtRes3 = "txtRes3";
    } 
      if (Fperiod == 60)
      {  
        Pv = "Hour Pivot";
        S = "S 1 Hour"; SS = "S 2 Hour"; SSS = "S 3 Hour";
        R = "R 1 Hour"; RR = "R 2 Hour"; RRR = "R 3 Hour";
        Pivot = "1HPivot"; Sup1 = "1HSup1"; Sup2 = "1HSup2"; Sup3 = "1HSup3";
        Res1 = "1HRes1"; Res2 = "1HRes2"; Res3 = "1HRes3";
        txtPivot = "txt1HPivot"; txtSup1 = "txt1HSup1"; txtSup2 = "txt1HSup2";  txtSup3 = "txt1HSup3";
        txtRes1 = "txt1HRes1"; txtRes2 = "txt1HRes2"; txtRes3 = "txt1HRes3";
        } 
          if (Fperiod == 240)
          {  
            Pv = "4Hour Pivot"; S = "S 1 4Hour"; SS = "S 2 4Hour"; SSS = "S 3 4Hour";
            R = "R 1 4Hour"; RR = "R 2 4Hour"; RRR = "R 3 4Hour";
            Pivot = "4HPivot"; Sup1 = "4HSup1"; Sup2 = "4HSup2"; Sup3 = "4HSup3";
            Res1 = "4HRes1"; Res2 = "4HRes2"; Res3 = "4HRes3";
            txtPivot = "txt4HPivot"; txtSup1 = "txt4HSup1"; txtSup2 = "txt4HSup2";  txtSup3 = "txt4HSup3";
            txtRes1 = "txt4HRes1"; txtRes2 = "txt4HRes2"; txtRes3 = "txt4HRes3";
            }
              if (Fperiod == 1440)
              {
                Pv = "Day Pivot"; S = "S 1 Day"; SS = "S 2 Day"; SSS = "S 3 Day";
                R = "R 1 Day"; RR = "R 2 Day"; RRR = "R 3 Day";
                Pivot = "DPivot"; Sup1 = "DSup1"; Sup2 = "DSup2"; Sup3 = "DSup3";
                Res1 = "DRes1"; Res2 = "DRes2"; Res3 = "DRes3";
                txtPivot = "txtDPivot"; txtSup1 = "txtDSup1"; txtSup2 = "txtDSup2";  txtSup3 = "txtDSup3";
                txtRes1 = "txtDRes1"; txtRes2 = "txtDRes2"; txtRes3 = "txtDRes3";
                }
                  if (Fperiod == 10080)
                  {  
                    Pv = "Weekly Pivot"; S = "S 1 Weekly"; SS = "S 2 Weekly"; SSS = "S 3 Weekly";
                    R = "R 1 Weekly"; RR = "R 2 Weekly"; RRR = "R 3 Weekly"; 
                    Pivot = "WPivot"; Sup1 = "WSup1"; Sup2 = "WSup2"; Sup3 = "WSup3";
                    Res1 = "WRes1"; Res2 = "WRes2"; Res3 = "WRes3";
                    txtPivot = "txtWPivot"; txtSup1 = "txtWSup1"; txtSup2 = "txtWSup2";  txtSup3 = "txtWSup3";
                    txtRes1 = "txtWRes1"; txtRes2 = "txtWRes2"; txtRes3 = "txtWRes3";
                    }
                      if (Fperiod == 43200)
                      {  
                        Pv = "Mounth Pivot"; S = "S 1 Mounth"; SS = "S 2 Mounth"; SSS = "S 3 Mounth";
                        R = "R 1 Mounth"; RR = "R 2 Mounth"; RRR = "R 3 Mounth";
                        Pivot = "MNPivot"; Sup1 = "MNSup1"; Sup2 = "MNSup2"; Sup3 = "MNSup3";
                        Res1 = "MNRes1"; Res2 = "MNRes2"; Res3 = "MNRes3";
                        txtPivot = "txtMNPivot"; txtSup1 = "txtMNSup1"; txtSup2 = "txtMNSup2";  txtSup3 = "txtMNSup3";
                        txtRes1 = "txtMNRes1"; txtRes2 = "txtMNRes2"; txtRes3 = "txtMNRes3";
                        }
   //--
   //--
   if (n==1) {PBuffer_1[i]=P; S1Buffer_1[i]=S1; S2Buffer_1[i]=S2; S3Buffer_1[i]=S3; R1Buffer_1[i]=R1; R2Buffer_1[i]=R2; R3Buffer_1[i]=R3;}
   if (n==2) {PBuffer_2[i]=P; S1Buffer_2[i]=S1; S2Buffer_2[i]=S2; S3Buffer_2[i]=S3; R1Buffer_2[i]=R1; R2Buffer_2[i]=R2; R3Buffer_2[i]=R3;}
   if (n==3) {PBuffer_3[i]=P; S1Buffer_3[i]=S1; S2Buffer_3[i]=S2; S3Buffer_3[i]=S3; R1Buffer_3[i]=R1; R2Buffer_3[i]=R2; R3Buffer_3[i]=R3;}
   
   
   
   remove_obj (n);

   if (FDisplay_Lable_P) 
   {
         //SetPrice(Pivot, Time[i], P, Flable_pivot_Color);
         SetText(txtPivot+(string)n, Pv, Time[i], P, Flable_pivot_Color);
   }
   if (FDisplay_Lable_SR) 
   {    
         //SetPrice(Sup1, Time[i], S1, Flable_S_Color);
         SetText(txtSup1+(string)n, S, Time[i], S1, Flable_S_Color);
         //SetPrice(Sup2, Time[i], S2, Flable_S_Color );
         SetText(txtSup2+(string)n, SS, Time[i], S2, Flable_S_Color );
         //SetPrice(Sup3, Time[i], S3, Flable_S_Color );
         SetText(txtSup3+(string)n, SSS, Time[i], S3, Flable_S_Color );
         //SetPrice(Res1, Time[i], R1, Flable_R_Color );
         SetText(txtRes1+(string)n, R, Time[i], R1, Flable_R_Color );
         //SetPrice(Res2, Time[i], R2, Flable_R_Color );
         SetText(txtRes2+(string)n, RR, Time[i], R2, Flable_R_Color );
         //SetPrice(Res3, Time[i], R3, Flable_R_Color );
         SetText(txtRes3+(string)n, RRR, Time[i], R3, Flable_R_Color );
   }
   
return (0);
}




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetText(string name, string txt, datetime Tm, double Prc, color clr)
  {
   if(ObjectFind(name) == -1)
     {
       ObjectCreate(name, OBJ_TEXT, 0, Tm, Prc);
       ObjectSetText(name, txt, 10, "Times New Roman", clr);
       ObjectSet(name, OBJPROP_CORNER, 2);
       ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
       ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
     }
   else
     {
       ObjectSet(name, OBJPROP_TIME1, Tm);
       ObjectSet(name, OBJPROP_PRICE1, Prc);
       ObjectSetText(name, txt, 10, "Times New Roman", clr);
       ObjectSet(name, OBJPROP_CORNER, 2);
       ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
       ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
     } 
  }
  
  
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
  
void remove_obj ( int n )
{
         ObjectDelete(txtPivot+(string)n);
         ObjectDelete(txtSup1+(string)n);
         ObjectDelete(txtSup2+(string)n);
         ObjectDelete(txtSup3+(string)n);
         ObjectDelete(txtRes1+(string)n);
         ObjectDelete(txtRes2+(string)n);
         ObjectDelete(txtRes3+(string)n);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
/*void SetPrice(string name, datetime Tm, double Prc, color clr)
  {
   if(ObjectFind(name) == -1)
     {
       ObjectCreate(name, OBJ_ARROW, 0, Tm, Prc);
       ObjectSet(name, OBJPROP_COLOR, clr);
       ObjectSet(name, OBJPROP_WIDTH, 1);
       ObjectSet(name, OBJPROP_ARROWCODE, SYMBOL_RIGHTPRICE);
     }
   else
     {
       ObjectSet(name, OBJPROP_TIME1, Tm);
       ObjectSet(name, OBJPROP_PRICE1, Prc);
       ObjectSet(name, OBJPROP_COLOR, clr);
       ObjectSet(name, OBJPROP_WIDTH, 1);
       ObjectSet(name, OBJPROP_ARROWCODE, SYMBOL_RIGHTPRICE);
     } 
  }*/
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                           Functions                              |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+