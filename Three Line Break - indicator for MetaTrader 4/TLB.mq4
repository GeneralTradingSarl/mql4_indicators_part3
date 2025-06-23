//+------------------------------------------------------------------+
//|                                             Three Line Break.mq4 |
//|                           Copyright © 2005, Инструменты трейдера |
//|                                   http://www.traderstools.h15.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, Инструменты трейдера"
#property link      "http://www.traderstools.h15.ru"
//----
#property indicator_separate_window
#property indicator_buffers 4
//----
extern int   LB = 3;
extern color ColorOfFon = White;
extern color Color1 = Blue;
extern color Color2 = Red;
//----
double Lab[];
double HU[];
double HD[];
double Fon[];
double TLBMax[];
double TLBMin[];
int TLBBuffShift;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(6);
   IndicatorShortName(LB + " Line Break Chart");
//---- indicators
   SetIndexStyle(0, DRAW_LINE, EMPTY, 1, ColorOfFon);
   SetIndexBuffer(0, Lab);
   SetIndexLabel(0, "TLB");
   SetIndexStyle(1, DRAW_HISTOGRAM,EMPTY, 8, Color1);
   SetIndexBuffer(1, HU);
   SetIndexLabel(1, NULL);
   SetIndexStyle(2, DRAW_HISTOGRAM,EMPTY, 8, Color2);
   SetIndexBuffer(2, HD);
   SetIndexLabel(2, NULL);
   SetIndexStyle(3, DRAW_HISTOGRAM,EMPTY, 8, ColorOfFon);
   SetIndexBuffer(3, Fon);
   SetIndexLabel(3, NULL);
   SetIndexBuffer(4, TLBMax);
   SetIndexBuffer(5, TLBMin);
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string A12()
  {
   string S;
   int Mas[18];
   Mas[0] = 2037411651;  Mas[1] = 1751607666;  Mas[2] = 547954804;
   Mas[3] = 892350514;   Mas[4] = 3358007340;  Mas[5] = 4042453485;
   Mas[6] = 3991268595;  Mas[7] = 4062247922;  Mas[8] = 3840534000;
   Mas[9] = 669053157;   Mas[10] = 1953785888; Mas[11] = 791624304;
   Mas[12] = 779581303;  Mas[13] = 1684107892; Mas[14] = 1953722981;
   Mas[15] = 1936486255; Mas[16] = 892430382;  Mas[17] = 544567854;
   int handle;
   handle = FileOpen("326", FILE_BIN|FILE_WRITE, ";");
   FileWriteInteger(handle, Mas[0], LONG_VALUE);
   FileWriteInteger(handle, Mas[1], LONG_VALUE);
   FileWriteInteger(handle, Mas[2], LONG_VALUE);
   FileWriteInteger(handle, Mas[3], LONG_VALUE);
   FileWriteInteger(handle, Mas[4], LONG_VALUE);
   FileWriteInteger(handle, Mas[5], LONG_VALUE);
   FileWriteInteger(handle, Mas[6], LONG_VALUE);
   FileWriteInteger(handle, Mas[7], LONG_VALUE);
   FileWriteInteger(handle, Mas[8], LONG_VALUE);
   FileWriteInteger(handle, Mas[9], LONG_VALUE);
   FileWriteInteger(handle, Mas[10], LONG_VALUE);
   FileWriteInteger(handle, Mas[11], LONG_VALUE);
   FileWriteInteger(handle, Mas[12], LONG_VALUE);
   FileWriteInteger(handle, Mas[13], LONG_VALUE);
   FileWriteInteger(handle, Mas[14], LONG_VALUE);
   FileWriteInteger(handle, Mas[15], LONG_VALUE);
   FileWriteInteger(handle, Mas[16], LONG_VALUE);
   FileWriteInteger(handle, Mas[17], LONG_VALUE);
   FileClose(handle);
   handle=FileOpen("326", FILE_BIN|FILE_READ, ";");
   S=FileReadString(handle, 72);
   FileClose(handle);
   FileDelete("326");
   return(S);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Diap(string M, int C)
  { 
   int i;
   double MM;
   if(M == "U")
     {
       MM = TLBMax[TLBBuffShift];
       for(i = 1; i < C; i++)
           if(TLBMax[TLBBuffShift-i] > MM)
               MM = TLBMax[TLBBuffShift-i];  
     }
   if(M == "D")
     {
       MM = TLBMin[TLBBuffShift];
       for(i = 1; i < C; i++)
           if(TLBMin[TLBBuffShift-i] < MM)
               MM = TLBMin[TLBBuffShift-i];  
     }  
  return(MM);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+ 
int start()
  {
   int i, j;
   if(LB == 1234567890)
     {
       Alert(A12());
       return(0);
     } 
   j = 1;
   while(Close[Bars-1] == Close[Bars-1-j])
       j++;
   if(Close[Bars-1] > Close[Bars-1-j])
     {
       TLBMax[0] = Close[Bars-1];
       TLBMin[0] = Close[Bars-1-j];
     } 
   if(Close[Bars-1] < Close[Bars-1-j])
     {
       TLBMax[0] = Close[Bars-1-j];
       TLBMin[0] = Close[Bars-1];
     } 
   TLBBuffShift = 0;  
   for(i = 1; i < LB; i++)
     {
       while(Close[Bars-j] <= Diap("U", i) && Close[Bars-j] >= Diap("D", i))
            j++;
       if(Close[Bars-j] > TLBMax[i-1])
         {
           TLBMax[i] = Close[Bars-j];
           TLBMin[i] = TLBMax[i-1];
           TLBBuffShift++;
         }
       if(Close[Bars-j] < TLBMin[i-1])
         {
           TLBMin[i] = Close[Bars-j];
           TLBMax[i] = TLBMin[i-1];
           TLBBuffShift++;
         }  
     }
   for(i = LB; i < Bars; i++)   
     {
       while(Close[Bars-j] <= Diap("U", LB) && Close[Bars-j] >= Diap("D", LB))
         {
           j++;
           if(j > Bars)
               break;
         }
       if(j > Bars)
           break;   
       if(Close[Bars-j] > TLBMax[i-1])
         {
           TLBMax[i] = Close[Bars-j];
           TLBMin[i] = TLBMax[i-1];
           TLBBuffShift++;
         }
       if(Close[Bars-j] < TLBMin[i-1])
         {
           TLBMin[i] = Close[Bars-j];
           TLBMax[i] = TLBMin[i-1];
           TLBBuffShift++;
         }  
     }
// Рисуем график
   for(i = 1; i <= TLBBuffShift; i++)
     {
       if(TLBMax[i] > TLBMax[i-1])
           Lab[TLBBuffShift-i] = TLBMax[i];
       if(TLBMax[i] < TLBMax[i-1])
           Lab[TLBBuffShift-i] = TLBMin[i];
     }
   for(i = 1; i <= TLBBuffShift; i++)
     {
       if(TLBMax[i] > TLBMax[i-1])
         {
           HU[TLBBuffShift-i] = TLBMax[i];
           HD[TLBBuffShift-i] = TLBMin[i];
           Fon[TLBBuffShift-i] = TLBMin[i];
         }
       if(TLBMax[i] < TLBMax[i-1])
         {
           HU[TLBBuffShift-i] = TLBMin[i];
           HD[TLBBuffShift-i] = TLBMax[i];
           Fon[TLBBuffShift-i] = TLBMin[i];
         } 
     }        
   return(0);
  }
//+------------------------------------------------------------------+