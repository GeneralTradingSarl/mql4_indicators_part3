/*------------------------------------------------------------------+
 |                                               Ticks-MilSec-2.mq4 |
 |                           Copyright © 2013, basisforex@gmail.com |
 +------------------------------------------------------------------*/ 
#property  copyright "Copyright © 2012, basisforex@gmail.com"
#property  link      "basisforex@gmail.com"
//+-----------------------------------------------------------------+   
#property indicator_chart_window
//------------------------------
int j, start, cnt;
double ar;
string S;
//--------   
int init()
 {
   return(0);
 }
//+------------------------------------------------------------------+
int deinit()
 {
   Comment("");
   ObjectDelete("txt");  
   return(0);
 }
//+------------------------------------------------------------------+
int start()
 {
   if (Period() != 1)
    {
		Comment("Not a right Period!!! It should be M1");
		return(0);	
	 }
   string t[60];  
   //==========
   if(Volume[0] == 0)
    {
      cnt = 0;
      ar = 0;
    }
   for(j = 0; j <= 59; j++)
    {
      if(Minute() == j)
       {
         if(start == 0) start = GetTickCount();
         if(GetTickCount() - start > 0) 
          {
            cnt = cnt + 1;
            ar = ar + (GetTickCount() - start);
            start = 0;
          }
         if(cnt > 0)  t[j] = "Minute: " + DoubleToStr(j, 0) + "  Ticks #: "+  DoubleToStr(cnt, 0) + "    Avg= " + DoubleToStr(ar/cnt, 2) + " milliseconds" + "\n";  
       }
    }        
   //------
   Comment(t[0], t[1], t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], t[11], t[12], t[13], t[14], t[15], t[16], t[17], t[18], t[19],
           t[20], t[21], t[22], t[23], t[24], t[25], t[26], t[27], t[28], t[29], t[30], t[31], t[32], t[33], t[34], t[35], t[36], t[37], t[38], t[39],
           t[40], t[41], t[42], t[43], t[44], t[45], t[46], t[47], t[48], t[49], t[50], t[51], t[52], t[53], t[54], t[55], t[56], t[57], t[58], t[59]);
   //------
   ObjectCreate("txt",OBJ_TEXT,0,TimeCurrent()- 60, Close[0] + 8 * Point);   
   ObjectSetText("txt", DoubleToStr(Minute(), 0), 16, "Times New Roman", Orange);
   ObjectMove("txt", 0, TimeCurrent()- 60, Close[0] + 8 * Point);
   //------
   return(0);
 }
//+------------------------------------------------------------------+