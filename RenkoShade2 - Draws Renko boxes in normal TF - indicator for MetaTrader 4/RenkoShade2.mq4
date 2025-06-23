//+------------------------------------------------------------------+
//|                                                  RenkoShade2.mq4 |
//|   Draws renko on normal tf main window                           |
//|   main algo ripped from renkolivechart_v32                       |
//|   plus minor modification to make it work                        |
//|   and make sense to the coder himself                            |
//|                                                     , Doztronics |
//|                                        http://www.doztronics.com |
//+------------------------------------------------------------------+
#property copyright ", Doztronics"
#property link      "http://www.doztronics.com"
// email: regfrea.k@gmail.com

#property indicator_chart_window
#include <stdlib.mqh>
//+------------------------------------------------------------------+
extern color RenkoBodyUp=DarkGreen;
extern color RenkoBodyDn=Maroon;
extern color RenkoHead=PaleTurquoise;
extern color RenkoTail=Wheat;

extern int debugIdx=0;

int rsBoxIdx=1;
bool rsBoxUp=true;

double p=0;
double RenkoSizeP=0;

double rso,rsc,rsh,rsl,rst,rsv;
//+------------------------------------------------------------------+
extern int RenkoBoxSize = 5;
extern int RenkoBoxOffset = 0;
extern bool ShowWicks = true;
extern int BarsCount=500;
//+------------------------------------------------------------------+
int HstHandle = -1, MT4InternalMsg = 0;
string SymbolName;



//+------------------------------------------------------------------+
int start() {
 
    static double BoxPoints, UpWick, DnWick;
    static double PrevLow, PrevHigh, PrevOpen, PrevClose, CurVolume, CurLow, CurHigh, CurOpen, CurClose;
    static datetime PrevTime;
       
    //+------------------------------------------------------------------+
    // This is only executed ones, then the first tick arives.
    if(HstHandle < 0) {
        // Init
        HstHandle=0;
        // Error checking    
        if(MathAbs(RenkoBoxOffset) >= RenkoBoxSize) {
            Print("Error: |RenkoBoxOffset| should be less then RenkoBoxSize!");
            return(-1);
        }
        //
        
        int BoxSize = RenkoBoxSize;
        int BoxOffset = RenkoBoxOffset;
        if(Digits == 5 || (Digits == 3 && StringFind(Symbol(), "JPY") != -1)) {
            BoxSize = BoxSize*10;
            BoxOffset = BoxOffset*10;
        }
        if(Digits == 6 || (Digits == 4 && StringFind(Symbol(), "JPY") != -1)) {
            BoxSize = BoxSize*100;        
            BoxOffset = BoxOffset*100;
        }
        
        SymbolName = Symbol();
        BoxPoints = NormalizeDouble(BoxSize*Point, Digits);
        
//        PrevLow = NormalizeDouble(BoxOffset*Point + MathFloor(Close[Bars-1]/BoxPoints)*BoxPoints, Digits);
        PrevLow = NormalizeDouble(BoxOffset*Point + MathFloor(Close[BarsCount-1]/BoxPoints)*BoxPoints, Digits);
        DnWick = PrevLow;
        PrevHigh = PrevLow + BoxPoints;
        UpWick = PrevHigh;
        PrevOpen = PrevLow;
        PrevClose = PrevHigh;
        CurVolume = 1;
//        PrevTime = Time[Bars-1];
        PrevTime = Time[BarsCount-1];
    
        //
       
         // process historical data
          //int i = Bars-2;
          int i = BarsCount-2;
        //Print(Symbol() + " " + High[i] + " " + Low[i] + " " + Open[i] + " " + Close[i]);
        //---------------------------------------------------------------------------
          while(i >= 0) {
          
            CurVolume = CurVolume + Volume[i];
        
            UpWick = MathMax(UpWick, High[i]);
            DnWick = MathMin(DnWick, Low[i]);
 
            // update low before high or the revers depending on is closest to prev. bar
            bool UpTrend = High[i]+Low[i] > High[i+1]+Low[i+1];
        
            while(UpTrend && (Low[i] < PrevLow-BoxPoints || CompareDoubles(Low[i], PrevLow-BoxPoints))) {
                  PrevHigh = PrevHigh - BoxPoints;
                  PrevLow = PrevLow - BoxPoints;
                  PrevOpen = PrevHigh;
                  PrevClose = PrevLow;
 
                rst=PrevTime;
                rso=PrevOpen;
                rsl=PrevLow;
 
                if(ShowWicks && UpWick > PrevHigh) rsh=UpWick;
                else rsh=PrevHigh;
                                                
                rsc=PrevClose;
                rsv=CurVolume;
                
                UpWick = 0;
                DnWick = EMPTY_VALUE;
                CurVolume = 0;
                CurHigh = PrevLow;
                CurLow = PrevLow;  
                
                if(PrevTime < Time[i]) PrevTime = Time[i];
                else PrevTime=PrevTime+60*Period();

               ObjectDelete("rsBox"+rsBoxIdx);
               ObjectDelete("rsHead"+rsBoxIdx);
               ObjectDelete("rsTail"+rsBoxIdx);
               ObjectCreate("rsBox"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rso,PrevTime,rsc);
               ObjectCreate("rsHead"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rsc,PrevTime,rsh);
               ObjectCreate("rsTail"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rso,PrevTime,rsl);
               ObjectSet("rsBox"+rsBoxIdx,OBJPROP_COLOR,RenkoBodyUp);
               ObjectSet("rsHead"+rsBoxIdx,OBJPROP_COLOR,RenkoHead);
               ObjectSet("rsTail"+rsBoxIdx,OBJPROP_COLOR,RenkoTail);

                     if(rsBoxIdx==debugIdx){
                        Print("2010.01.15 16:10 --**",rsBoxIdx);
                        Print(rso);
                        Print(rsh);
                        Print(rsl);
                        Print(rsc);
                        Print(rst);
                     }
         
               rsBoxIdx++;
                               
            }     // while(UpTrend && (Low[i] < PrevLow
        
            while(High[i] > PrevHigh+BoxPoints || CompareDoubles(High[i], PrevHigh+BoxPoints)) {
                  PrevHigh = PrevHigh + BoxPoints;
                  PrevLow = PrevLow + BoxPoints;
                  PrevOpen = PrevLow;
                  PrevClose = PrevHigh;
              
                rst=PrevTime;
                rso=PrevOpen;
 
                    if(ShowWicks && DnWick < PrevLow) rsl=DnWick;
                else rsl=PrevLow;
                                
                rsh=PrevHigh;
                rsc=PrevClose;
                rsv=CurVolume;
                
                UpWick = High[i];
                DnWick = EMPTY_VALUE;
                CurVolume = 0;
                CurHigh = PrevHigh;
                CurLow = PrevHigh;  
                
                if(PrevTime < Time[i]) PrevTime = Time[i];
                else PrevTime=PrevTime+60*Period();
                
               ObjectDelete("rsBox"+rsBoxIdx);
               ObjectDelete("rsHead"+rsBoxIdx);
               ObjectDelete("rsTail"+rsBoxIdx);
               ObjectCreate("rsBox"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rso,PrevTime,rsc);
               ObjectCreate("rsHead"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rsc,PrevTime,rsh);
               ObjectCreate("rsTail"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rso,PrevTime,rsl);
               ObjectSet("rsBox"+rsBoxIdx,OBJPROP_COLOR,RenkoBodyUp);
               ObjectSet("rsHead"+rsBoxIdx,OBJPROP_COLOR,RenkoHead);
               ObjectSet("rsTail"+rsBoxIdx,OBJPROP_COLOR,RenkoTail);
               
                  if(rsBoxIdx==debugIdx){
                     Print("2010.01.15 16:10 --##",rsBoxIdx);
                     Print(rso);
                     Print(rsh);
                     Print(rsl);
                     Print(rsc);
                     Print(rst);
                  }

               rsBoxIdx++;

            }     // while(High[i] > PrevHigh+BoxPoints || CompareDoubles
        
            while(!UpTrend && (Low[i] < PrevLow-BoxPoints || CompareDoubles(Low[i], PrevLow-BoxPoints))) {
                  PrevHigh = PrevHigh - BoxPoints;
                  PrevLow = PrevLow - BoxPoints;
                  PrevOpen = PrevHigh;
                  PrevClose = PrevLow;
              
                rst=PrevTime;
                rso=PrevOpen;
                rsl=PrevLow;
                
                if(ShowWicks && UpWick > PrevHigh) rsh=UpWick;
                else rsh=PrevHigh;
                
                rsc=PrevClose;
                rsv=CurVolume;
 
                UpWick = 0;
//                DnWick = EMPTY_VALUE;
                DnWick = Low[i];
                CurVolume = 0;
                CurHigh = PrevLow;
                CurLow = PrevLow;  
                                
                if(PrevTime < Time[i]) PrevTime = Time[i];
                else PrevTime=PrevTime+60*Period();
                
               ObjectDelete("rsBox"+rsBoxIdx);
               ObjectDelete("rsHead"+rsBoxIdx);
               ObjectDelete("rsTail"+rsBoxIdx);
               ObjectCreate("rsBox"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rso,PrevTime,rsc);
               ObjectCreate("rsHead"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rso,PrevTime,rsh);
               ObjectCreate("rsTail"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rsc,PrevTime,rsl);
               ObjectSet("rsBox"+rsBoxIdx,OBJPROP_COLOR,RenkoBodyDn);
               ObjectSet("rsHead"+rsBoxIdx,OBJPROP_COLOR,RenkoHead);
               ObjectSet("rsTail"+rsBoxIdx,OBJPROP_COLOR,RenkoTail);

                  if(rsBoxIdx==debugIdx){
                     Print("2010.01.15 16:10 --$$",rsBoxIdx);
                     Print(rso);
                     Print(rsh);
                     Print(rsl);
                     Print(rsc);
                     Print(rst);
                  }
            
               rsBoxIdx++;

            }        
            i--;
        } 
        //
            
//        Comment("RenkoLiveChart(" + RenkoBoxSize + "): Open Offline ", SymbolName, ",M", RenkoTimeFrame, " to view chart");
        
        if(Close[0] > MathMax(PrevClose, PrevOpen)) CurOpen = MathMax(PrevClose, PrevOpen);
        else if (Close[0] < MathMin(PrevClose, PrevOpen)) CurOpen = MathMin(PrevClose, PrevOpen);
        else CurOpen = Close[0];
        
        CurClose = Close[0];
                
        if(UpWick > PrevHigh) CurHigh = UpWick;
        if(DnWick < PrevLow) CurLow = DnWick;
      
        rst=PrevTime;
        rso=CurOpen;
        rsl=CurLow;
        rsh=CurHigh;
        rsc=CurClose;
        rsv=CurVolume;

//ZDO still in the making
        if(rso<rsc) { // UP
               ObjectDelete("rsBox"+rsBoxIdx);
               ObjectDelete("rsHead"+rsBoxIdx);
               ObjectDelete("rsTail"+rsBoxIdx);
               ObjectCreate("rsBox"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rso,PrevTime,rsc);
               ObjectCreate("rsHead"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rsc,PrevTime,rsh);
               ObjectCreate("rsTail"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rso,PrevTime,rsl);
               ObjectSet("rsBox"+rsBoxIdx,OBJPROP_COLOR,RenkoBodyUp);
               ObjectSet("rsHead"+rsBoxIdx,OBJPROP_COLOR,RenkoHead);
               ObjectSet("rsTail"+rsBoxIdx,OBJPROP_COLOR,RenkoTail);
        } else {  // DOWN
               ObjectDelete("rsBox"+rsBoxIdx);
               ObjectDelete("rsHead"+rsBoxIdx);
               ObjectDelete("rsTail"+rsBoxIdx);
               ObjectCreate("rsBox"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rso,PrevTime,rsc);
               ObjectCreate("rsHead"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rso,PrevTime,rsh);
               ObjectCreate("rsTail"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rsc,PrevTime,rsl);
               ObjectSet("rsBox"+rsBoxIdx,OBJPROP_COLOR,RenkoBodyDn);
               ObjectSet("rsHead"+rsBoxIdx,OBJPROP_COLOR,RenkoHead);
               ObjectSet("rsTail"+rsBoxIdx,OBJPROP_COLOR,RenkoTail);
        }
        
         if(rsBoxIdx==debugIdx){
                Print("2010.01.15 16:10 --^^",rsBoxIdx);
                Print(rso);
                Print(rsh);
                Print(rsl);
                Print(rsc);
                Print(rst);
             }
            
         rsBoxIdx++;


        return(0);
         // End historical data / Init        
    }         
    //----------------------------------------------------------------------------
     // HstHandle not < 0 so we always enter here after history done
    // Begin live data feed
               
    UpWick = MathMax(UpWick, Bid);
    DnWick = MathMin(DnWick, Bid);
 
    CurVolume++;               
 
     //-------------------------------------------------------------------------                       
     // up box                       
       if(Bid > PrevHigh+BoxPoints || CompareDoubles(Bid, PrevHigh+BoxPoints)) {
        PrevHigh = PrevHigh + BoxPoints;
        PrevLow = PrevLow + BoxPoints;
          PrevOpen = PrevLow;
          PrevClose = PrevHigh;
                                
        rst=PrevTime;
        rso=PrevOpen;
 
        if (ShowWicks && DnWick < PrevLow) rsl=DnWick;
        else rsl=PrevLow;
                      
        rsh=PrevHigh;
        rsc=PrevClose;
        rsv=CurVolume;
          
        if(PrevTime < TimeCurrent()) PrevTime = TimeCurrent();
        else PrevTime=PrevTime+60*Period();
                    
         ObjectDelete("rsBox"+rsBoxIdx);
         ObjectDelete("rsHead"+rsBoxIdx);
         ObjectDelete("rsTail"+rsBoxIdx);
         ObjectCreate("rsBox"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rso,PrevTime,rsc);
         ObjectCreate("rsHead"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rsc,PrevTime,rsh);
         ObjectCreate("rsTail"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rso,PrevTime,rsl);
         ObjectSet("rsBox"+rsBoxIdx,OBJPROP_COLOR,RenkoBodyUp);
         ObjectSet("rsHead"+rsBoxIdx,OBJPROP_COLOR,RenkoHead);
         ObjectSet("rsTail"+rsBoxIdx,OBJPROP_COLOR,RenkoTail);
         
         if(rsBoxIdx==debugIdx){
            Print("2010.01.15 16:10 --@@",rsBoxIdx);
            Print(rso);
            Print(rsh);
            Print(rsl);
            Print(rsc);
            Print(rst);
         }

         rsBoxIdx++;
               
        CurVolume = 0;
        CurHigh = PrevHigh;
        CurLow = PrevHigh;  
        
        UpWick = 0;
        DnWick = EMPTY_VALUE;        
        
      }
     //-------------------------------------------------------------------------                       
     // down box
    else if(Bid < PrevLow-BoxPoints || CompareDoubles(Bid,PrevLow-BoxPoints)) {
          PrevHigh = PrevHigh - BoxPoints;
          PrevLow = PrevLow - BoxPoints;
          PrevOpen = PrevHigh;
          PrevClose = PrevLow;
                                
        rst=PrevTime;
        rso=PrevOpen;
        rsl=PrevLow;
 
        if(ShowWicks && UpWick > PrevHigh) rsh=UpWick;
        else rsh=PrevHigh;
                              
        rsc=PrevClose;
        rsv=CurVolume;
          
        if(PrevTime < TimeCurrent()) PrevTime = TimeCurrent();
        else PrevTime=PrevTime+60*Period();
                    
         ObjectDelete("rsBox"+rsBoxIdx);
         ObjectDelete("rsHead"+rsBoxIdx);
         ObjectDelete("rsTail"+rsBoxIdx);
         ObjectCreate("rsBox"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rso,PrevTime,rsc);
         ObjectCreate("rsHead"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rso,PrevTime,rsh);
         ObjectCreate("rsTail"+rsBoxIdx,OBJ_RECTANGLE,0,rst,rsc,PrevTime,rsl);
         ObjectSet("rsBox"+rsBoxIdx,OBJPROP_COLOR,RenkoBodyDn);
         ObjectSet("rsHead"+rsBoxIdx,OBJPROP_COLOR,RenkoHead);
         ObjectSet("rsTail"+rsBoxIdx,OBJPROP_COLOR,RenkoTail);

         if(rsBoxIdx==debugIdx){
            Print("2010.01.15 16:10 --%%",rsBoxIdx);
            Print(rso);
            Print(rsh);
            Print(rsl);
            Print(rsc);
            Print(rst);
         }

         rsBoxIdx++;

          CurVolume = 0;
        CurHigh = PrevLow;
        CurLow = PrevLow;  
        
        UpWick = 0;
        DnWick = EMPTY_VALUE;        
        
         } 
     //-------------------------------------------------------------------------                       
       // no box - high/low not hit                
    else {
        if(Bid > CurHigh) CurHigh = Bid;
        if(Bid < CurLow) CurLow = Bid;
        
        if(PrevHigh <= Bid) CurOpen = PrevHigh;
        else if(PrevLow >= Bid) CurOpen = PrevLow;
        else CurOpen = Bid;
        
        CurClose = Bid;
        
/*        FileWriteInteger(HstHandle, PrevTime, LONG_VALUE);        // Time
        FileWriteDouble(HstHandle, CurOpen, DOUBLE_VALUE);             // Open
        FileWriteDouble(HstHandle, CurLow, DOUBLE_VALUE);        // Low
        FileWriteDouble(HstHandle, CurHigh, DOUBLE_VALUE);        // High
        FileWriteDouble(HstHandle, CurClose, DOUBLE_VALUE);        // Close
        FileWriteDouble(HstHandle, CurVolume, DOUBLE_VALUE);        // Volume                
            FileFlush(HstHandle);
            
        UpdateChartWindow();            
*/
         }
         return(0);
}
//+------------------------------------------------------------------+
int deinit() {
  int    obj_total=ObjectsTotal();
  string name;
  for(int i=obj_total;i>=0;i--)
    {
     name=ObjectName(i);
     if(StringSubstr(name,0,2)=="rs") {
      ObjectDelete(name);
     }
    }

    Comment("");
    return(0);
}
//+------------------------------------------------------------------+
int init() {
  int    obj_total=ObjectsTotal();
  string name;
  for(int i=obj_total;i>=0;i--)
    {
     name=ObjectName(i);
     if(StringSubstr(name,0,2)=="rs") {
      ObjectDelete(name);
     }
    }

    Comment("");
    return(0);
}
//+------------------------------------------------------------------+