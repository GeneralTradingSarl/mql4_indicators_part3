//+------------------------------------------------------------------+
//|                                                   EA_Profits.mq4 |
//|                                Copyright © 2011, Tjipke de Vries |
//|           http://www.donnaforex.com/forum/index.php?topic=3938.0 |
//|                                                                  |
//| 10-07-2011                                                       |
//| This is made to see how your EA has performed at a specific      | 
//| time. Put in the Magicnumber(s) of your EA(s) and you can see    |
//| the results of your EA..  for all pairs or for only the chart    |
//| Symbol. Profits closed trades and open trades.                   |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, Tjipke de Vries"
#property link      "http://www.metaquotes.net"
#include <WinUser32.mqh>
#include <stdlib.mqh>

#property indicator_separate_window
#property indicator_buffers 1


#define MAGICS_MAX 1024
#define DEALS          0
#define BUY_LOTS       1
#define BUY_ORDERS     2
#define SELL_LOTS      3
#define SELL_ORDERS    4
#define TOTAL_LOTS     5
#define GPROFIT        6
#define GLOSS          7
#define PROFIT         8
#define NET_PIPS       9 
#define OPEN_DEALS     10 
#define OPEN_GPROFIT   11 
#define OPEN_GLOSS     12 
#define OPEN_PROFIT    13 
#define OPEN_NET_PIPS  14 

extern string  startdate="2010.01.01";
extern string  enddate  ="2012.11.01";
   extern string Profit_All_Pairs= "True: All Pairs    -- False: Chart Symbol()";
   extern bool Profit_All_pairs= True;
   extern int Magic1 = 0;
   extern int Magic2 = 0;
   extern int Magic3 = 0;
   extern int Magic4 = 0;
   extern int Magic5 = 0;
   extern int Magic6 = 0;
   extern int Magic7 = 0;
   extern int Magic8 = 0;      
extern color   HeaderColor=Green;
extern color   MAGICSColor=Red;
extern color   TextColor=MediumBlue;
extern int     TextSize=12;
extern int     RowSpacing=14;

string Name="© 2011 deVries, EA Profits 1.0";
string MAGICNR[MAGICS_MAX];
int    MagicsTotal=0;
double MagicsSummaries[MAGICS_MAX][15];
int    Lines=-1;
string Cols[16]={"MagicNr",
                   "Deals",
                   "Buy L",
                   "Buy 's",
                   "Sell L",
                   "Shorts",
                   "Total lots",
                   "Profit",
                   "Loss",
                   "Net P/L",
                   "Pips",
                   "Op.Tr",
                   "Op.Profit",
                   "Op.Loss",
                   "Op.P/L",
                   "Op.Pips"};

                   
int    Shifts[15]={ 10, 70, 115, 155, 195, 245, 300, 370, 440, 510, 580, 655, 710, 770, 840, 910};

double MapBuffer[];
double Tprofit,Tloss,Tpl,Tpips,Tdeals,OPTprofit,OPTloss,OPTpl,OPTpips,OPTdeals;
datetime sdate,edate;
double multiplier;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void init()
  {
	IndicatorShortName(Name);
   SetIndexBuffer(0,MapBuffer);
   SetIndexStyle(0,DRAW_NONE);
   IndicatorDigits(0);
	SetIndexEmptyValue(0,0.0);
	sdate=StrToTime(startdate);
	edate=StrToTime(enddate);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void deinit()
  {
   int windex=WindowFind(Name);
   if(windex>0) ObjectsDeleteAll(windex);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void start()
  {
   string name;
   int    i,col,line,windex=WindowFind(Name);
//----
   if(windex<0) return;
//---- header line
   if(Lines<0)
     {
      for(col=0; col<16; col++)
        {
         name="Head_"+col;
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
           {
            ObjectSet(name,OBJPROP_XDISTANCE,Shifts[col]);
            ObjectSet(name,OBJPROP_YDISTANCE,RowSpacing);
            ObjectSetText(name,Cols[col],9,"Arial",HeaderColor);
           }
        }
      Lines=0;
     }
//----

   ArrayInitialize(MagicsSummaries,0.0);
   int total=Analyze();
   int total1=AnalyzeOpenTrades();
   SortTables(MAGICNR);
   if(total>0||total1>0)
     {
      line=0;
      for(i=0; i<MagicsTotal; i++)
        {
         if(MagicsSummaries[i][DEALS]<=0&&MagicsSummaries[i][OPEN_DEALS]<=0) continue;
         line++;
         //---- add line
         if(line>Lines)
           {
            int y_dist=RowSpacing*(line+1)+1;
            for(col=0; col<16; col++)
              {
               name="Line_"+line+"_"+col;
               if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
                 {
                  ObjectSet(name,OBJPROP_XDISTANCE,Shifts[col]);
                  ObjectSet(name,OBJPROP_YDISTANCE,y_dist);
                 }
              }
            Lines++;
           }

         //---- set line
         name="Line_"+line+"_0";
         ObjectSetText(name,MAGICNR[i],9,"Arial",MAGICSColor);
         name="Line_"+line+"_1";
         ObjectSetText(name,DoubleToStr(MagicsSummaries[i][DEALS],0),TextSize,"Arial",TextColor);
         name="Line_"+line+"_2";
         ObjectSetText(name,DoubleToStr(MagicsSummaries[i][BUY_LOTS],2),TextSize,"Arial",TextColor);
         name="Line_"+line+"_3";
         ObjectSetText(name,DoubleToStr(MagicsSummaries[i][BUY_ORDERS],0),TextSize,"Arial",TextColor);
         name="Line_"+line+"_4";
         ObjectSetText(name,DoubleToStr(MagicsSummaries[i][SELL_LOTS],2),TextSize,"Arial",TextColor);
         name="Line_"+line+"_5";
         ObjectSetText(name,DoubleToStr(MagicsSummaries[i][SELL_ORDERS],0),TextSize,"Arial",TextColor);
         name="Line_"+line+"_6";
         ObjectSetText(name,DoubleToStr(MagicsSummaries[i][BUY_LOTS]+MagicsSummaries[i][SELL_LOTS],2),TextSize,"Arial",TextColor);
         name="Line_"+line+"_7";
         ObjectSetText(name,DoubleToStr(MagicsSummaries[i][GPROFIT],2),TextSize,"Arial",TextColor);
         name="Line_"+line+"_8";
         ObjectSetText(name,DoubleToStr(MagicsSummaries[i][GLOSS],2),TextSize,"Arial",TextColor);
         name="Line_"+line+"_9";
         ObjectSetText(name,DoubleToStr(MagicsSummaries[i][PROFIT],2),TextSize,"Arial",TextColor);
         name="Line_"+line+"_10";
         ObjectSetText(name,DoubleToStr(MagicsSummaries[i][NET_PIPS],0),TextSize,"Arial",TextColor);         
         name="Line_"+line+"_11";
         ObjectSetText(name,DoubleToStr(MagicsSummaries[i][OPEN_DEALS],0),TextSize,"Arial",TextColor);         
         name="Line_"+line+"_12";
         ObjectSetText(name,DoubleToStr(MagicsSummaries[i][OPEN_GPROFIT],2),TextSize,"Arial",TextColor);         
         name="Line_"+line+"_13";
         ObjectSetText(name,DoubleToStr(MagicsSummaries[i][OPEN_GLOSS],2),TextSize,"Arial",TextColor);         
         name="Line_"+line+"_14";
         ObjectSetText(name,DoubleToStr(MagicsSummaries[i][OPEN_PROFIT],2),TextSize,"Arial",TextColor);         
         name="Line_"+line+"_15";
         ObjectSetText(name,DoubleToStr(MagicsSummaries[i][OPEN_NET_PIPS],0),TextSize,"Arial",TextColor);         
        }
     }
DrawTotals();
WindowRedraw();  

//---- to avoid minimum==maximum
   MapBuffer[Bars-1]=-1;
//----

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Analyze()
  {
   double profit,bprofit,sprofit;
   int    i,index,type,total=OrdersHistoryTotal();
//----


   for(i=0; i<total; i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)) continue;
      type=OrderType();
      if(type!=OP_BUY && type!=OP_SELL) continue;
      if(Profit_All_pairs != True && OrderSymbol()!= Symbol()) {continue;}
      if (OrderMagicNumber() == 0) continue;
      if (OrderMagicNumber() != Magic1 && OrderMagicNumber() != Magic2 &&OrderMagicNumber() != Magic3 && OrderMagicNumber() != Magic4 && 
          OrderMagicNumber() != Magic5 && OrderMagicNumber() != Magic6 && OrderMagicNumber() != Magic7 &&OrderMagicNumber() != Magic8)continue;
      index=MAGICSIndex(OrderMagicNumber());
      if(index<0 || index>=MAGICS_MAX) continue;
      if (OrderOpenTime()<sdate) continue;
      if (OrderOpenTime()>edate) continue;
      

      //----
      //MagicsSummaries[index][DEALS]++;
double PIPS;
GetMultiplier();
if(OrderType() == OP_BUY) {PIPS=((OrderClosePrice()-OrderOpenPrice())/MarketInfo(OrderSymbol(),MODE_POINT)*multiplier);}
if(OrderType() == OP_SELL) {PIPS=((OrderOpenPrice()-OrderClosePrice())/MarketInfo(OrderSymbol(),MODE_POINT)*multiplier);}
MagicsSummaries[index][NET_PIPS]+= PIPS;


      profit=OrderProfit()+OrderCommission()+OrderSwap();
      if(profit>=0)MagicsSummaries[index][GPROFIT]+=profit;
      else MagicsSummaries[index][GLOSS]+=profit;
      MagicsSummaries[index][PROFIT]=MagicsSummaries[index][GPROFIT]+MagicsSummaries[index][GLOSS];
      if(type==OP_BUY)
        {
         MagicsSummaries[index][BUY_LOTS]+=OrderLots();
         MagicsSummaries[index][BUY_ORDERS]++;
        }
      if(type==OP_SELL)
        {
         MagicsSummaries[index][SELL_LOTS]+=OrderLots();
         MagicsSummaries[index][SELL_ORDERS]++;
        }
        
        MagicsSummaries[index][DEALS]=MagicsSummaries[index][SELL_ORDERS]+MagicsSummaries[index][BUY_ORDERS];
     }
//----
   total=0;
   Tpl=0;Tpips=0;Tdeals=0;Tprofit=0;Tloss=0;
   for(i=0; i<MagicsTotal; i++)
     {
      if(MagicsSummaries[i][DEALS]>0) total++;
      Tpl+=MagicsSummaries[i][PROFIT];
      Tpips+=MagicsSummaries[i][NET_PIPS];
      Tdeals+=MagicsSummaries[i][DEALS];
      Tprofit+=MagicsSummaries[i][GPROFIT];
      Tloss+=MagicsSummaries[i][GLOSS];
     }
//----
   return(total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int AnalyzeOpenTrades()
  {
   double profit,bprofit,sprofit;
   int    i,index,type,total=OrdersTotal();
//----


   for(i=0; i<total; i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) continue;
      type=OrderType();
      if(type!=OP_BUY && type!=OP_SELL) continue;
      if(Profit_All_pairs != True && OrderSymbol()!= Symbol()) {continue;}
      if (OrderMagicNumber() == 0) continue;
      if (OrderMagicNumber() != Magic1 && OrderMagicNumber() != Magic2 &&OrderMagicNumber() != Magic3 && OrderMagicNumber() != Magic4 && 
          OrderMagicNumber() != Magic5 && OrderMagicNumber() != Magic6 && OrderMagicNumber() != Magic7 &&OrderMagicNumber() != Magic8)continue;      
      index=MAGICSIndex(OrderMagicNumber());
      if(index<0 || index>=MAGICS_MAX) continue;
      if (OrderOpenTime()<sdate) continue;
      if (OrderOpenTime()>edate) continue;
      //----
      //MagicsSummaries[index][DEALS]++;
double PIPS;
GetMultiplier();
if(OrderType() == OP_BUY) {PIPS=((OrderClosePrice()-OrderOpenPrice())/MarketInfo(OrderSymbol(),MODE_POINT)*multiplier);}
if(OrderType() == OP_SELL) {PIPS=((OrderOpenPrice()-OrderClosePrice())/MarketInfo(OrderSymbol(),MODE_POINT)*multiplier);}
MagicsSummaries[index][OPEN_NET_PIPS]+= PIPS;


      profit=OrderProfit()+OrderCommission()+OrderSwap();
      if(profit>=0)MagicsSummaries[index][OPEN_GPROFIT]+=profit;
      else MagicsSummaries[index][OPEN_GLOSS]+=profit;
      MagicsSummaries[index][OPEN_PROFIT]=MagicsSummaries[index][OPEN_GPROFIT]+MagicsSummaries[index][OPEN_GLOSS];
      /*
      if(type==OP_BUY)
        {
         MagicsSummaries[index][BUY_LOTS]+=OrderLots();
         MagicsSummaries[index][BUY_ORDERS]++;
        }
      if(type==OP_SELL)
        {
         MagicsSummaries[index][SELL_LOTS]+=OrderLots();
         MagicsSummaries[index][SELL_ORDERS]++;
        }
        */
        //MagicsSummaries[index][DEALS]=MagicsSummaries[index][SELL_ORDERS]+MagicsSummaries[index][BUY_ORDERS];
        MagicsSummaries[index][OPEN_DEALS]++;
     }
//----
   total=0;
   OPTpl=0;OPTpips=0;OPTdeals=0;OPTprofit=0;OPTloss=0;OPTpips=0;
   for(i=0; i<MagicsTotal; i++)
     {
      if(MagicsSummaries[i][OPEN_DEALS]>0) total++;
      OPTpl+=MagicsSummaries[i][OPEN_PROFIT];
      OPTpips+=MagicsSummaries[i][OPEN_NET_PIPS];
      OPTdeals+=MagicsSummaries[i][OPEN_DEALS];
      OPTprofit+=MagicsSummaries[i][OPEN_GPROFIT];
      OPTloss+=MagicsSummaries[i][OPEN_GLOSS];
     }
//----
   return(total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int MAGICSIndex(string MagicName)
  {
   bool found=false;
//----
   for(int i=0; i<MagicsTotal; i++)
     {
      if(MagicName==MAGICNR[i])
        {
         found=true;
         break;
        }
     }
//----
   if(found) return(i);
   if(MagicsTotal>=MAGICS_MAX) return(-1);
//----
   i=MagicsTotal;
   MagicsTotal++;
   MAGICNR[i]=MagicName;
   MagicsSummaries[i][DEALS]=0;
   MagicsSummaries[i][BUY_LOTS]=0;
   MagicsSummaries[i][BUY_ORDERS]=0;
   MagicsSummaries[i][SELL_LOTS]=0;
   MagicsSummaries[i][SELL_ORDERS]=0;
   MagicsSummaries[i][TOTAL_LOTS]=0;
   MagicsSummaries[i][GPROFIT]=0;
   MagicsSummaries[i][GLOSS]=0;
   MagicsSummaries[i][PROFIT]=0;
   MagicsSummaries[i][NET_PIPS]=0;
   MagicsSummaries[i][OPEN_DEALS]=0;
   MagicsSummaries[i][OPEN_GPROFIT]=0;
   MagicsSummaries[i][OPEN_GLOSS]=0;
   MagicsSummaries[i][OPEN_PROFIT]=0;
   MagicsSummaries[i][OPEN_NET_PIPS]=0;

//----
   return(i);
  }
void SortTables(string &a[])
{
string tmp;
double tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8,tmp9,tmp10,tmp11,tmp12,tmp13,tmp14,tmp15;
  for (int i = 0; i < MagicsTotal; i++) 
  {
    for (int j = i + 1; j < MagicsTotal; j++) 
    {
      if( a[i]>a[j] ) 
      {
        tmp = a[i];
        tmp0=MagicsSummaries[i][0];
        tmp1=MagicsSummaries[i][1];
        tmp2=MagicsSummaries[i][2];
        tmp3=MagicsSummaries[i][3];
        tmp4=MagicsSummaries[i][4];
        tmp5=MagicsSummaries[i][5];
        tmp6=MagicsSummaries[i][6];
        tmp7=MagicsSummaries[i][7];
        tmp8=MagicsSummaries[i][8];
        tmp9=MagicsSummaries[i][9];
        tmp10=MagicsSummaries[i][10];
        tmp11=MagicsSummaries[i][11];
        tmp12=MagicsSummaries[i][12];
        tmp13=MagicsSummaries[i][13];
        tmp14=MagicsSummaries[i][14];
        a[i] = a[j];
        MagicsSummaries[i][0]=MagicsSummaries[j][0];
        MagicsSummaries[i][1]=MagicsSummaries[j][1];
        MagicsSummaries[i][2]=MagicsSummaries[j][2];
        MagicsSummaries[i][3]=MagicsSummaries[j][3];
        MagicsSummaries[i][4]=MagicsSummaries[j][4];
        MagicsSummaries[i][5]=MagicsSummaries[j][5];
        MagicsSummaries[i][6]=MagicsSummaries[j][6];
        MagicsSummaries[i][7]=MagicsSummaries[j][7];
        MagicsSummaries[i][8]=MagicsSummaries[j][8];
        MagicsSummaries[i][9]=MagicsSummaries[j][9];
        MagicsSummaries[i][10]=MagicsSummaries[j][10];
        MagicsSummaries[i][11]=MagicsSummaries[j][11];
        MagicsSummaries[i][12]=MagicsSummaries[j][12];
        MagicsSummaries[i][13]=MagicsSummaries[j][13];
        MagicsSummaries[i][14]=MagicsSummaries[j][14];
        a[j] = tmp;
        MagicsSummaries[j][0]=tmp0;
        MagicsSummaries[j][1]=tmp1;
        MagicsSummaries[j][2]=tmp2;
        MagicsSummaries[j][3]=tmp3;
        MagicsSummaries[j][4]=tmp4;
        MagicsSummaries[j][5]=tmp5;
        MagicsSummaries[j][6]=tmp6;
        MagicsSummaries[j][7]=tmp7;
        MagicsSummaries[j][8]=tmp8;
        MagicsSummaries[j][9]=tmp9;
        MagicsSummaries[j][10]=tmp10;
        MagicsSummaries[j][11]=tmp11;
        MagicsSummaries[j][12]=tmp12;
        MagicsSummaries[j][13]=tmp13;
        MagicsSummaries[j][14]=tmp14;

      }
    }
  }
}
//+------------------------------------------------------------------+
void DrawTotals()
{
int windex=WindowFind(Name);
string name;
ObjectDelete("Totals-OPENdeals");ObjectDelete("Totals-OPENtprofit");ObjectDelete("Totals-OPENtloss");ObjectDelete("Totals-OPENnetpl");ObjectDelete("Totals-OPENpips");
ObjectDelete("Totals-TXT");ObjectDelete("Totals-Deals");ObjectDelete("Totals-Symbols");ObjectDelete("Totals-Profit");ObjectDelete("Totals-Loss");ObjectDelete("Totals-PL");
ObjectDelete("Totals-pips");ObjectDelete("From-Date-text");ObjectDelete("From-Date");ObjectDelete("To-Date-text");ObjectDelete("To-Date");
         int y=RowSpacing*(Lines+3)+3;
         name="Totals-TXT";
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
           {
            ObjectSet(name,OBJPROP_XDISTANCE,Shifts[0]);
            ObjectSet(name,OBJPROP_YDISTANCE,y);
            ObjectSetText(name,"TOTALS:",9,"Arial",HeaderColor);
           }
         name="Totals-Deals";
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
           {
            ObjectSet(name,OBJPROP_XDISTANCE,Shifts[1]);
            ObjectSet(name,OBJPROP_YDISTANCE,y);
            ObjectSetText(name,DoubleToStr(Tdeals,0),9,"Arial",HeaderColor);
           }//---- remove lines
         if(Profit_All_pairs){  
            name="Totals-Symbols";
            if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
              {
               ObjectSet(name,OBJPROP_XDISTANCE,Shifts[2]);
               ObjectSet(name,OBJPROP_YDISTANCE,y);
               ObjectSetText(name,"Profit  All  Symbols  traded",9,"Arial",HeaderColor);
              }           
            }
         if(!Profit_All_pairs){  
            name="Totals-Symbols";
            if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
              {
               ObjectSet(name,OBJPROP_XDISTANCE,Shifts[2]);
               ObjectSet(name,OBJPROP_YDISTANCE,y);
               ObjectSetText(name,"Profit  chart  Symbol  pair",9,"Arial",HeaderColor);
              }           
            }               
         name="Totals-Profit";
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
           {
            ObjectSet(name,OBJPROP_XDISTANCE,Shifts[7]);
            ObjectSet(name,OBJPROP_YDISTANCE,y);
            ObjectSetText(name,DoubleToStr(Tprofit,2),9,"Arial",HeaderColor);
           }//---- remove lines 
         name="Totals-Loss";
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
           {
            ObjectSet(name,OBJPROP_XDISTANCE,Shifts[8]);
            ObjectSet(name,OBJPROP_YDISTANCE,y);
            ObjectSetText(name,DoubleToStr(Tloss,2),9,"Arial",HeaderColor);
           }//---- remove lines              
         name="Totals-PL";
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
           {
            ObjectSet(name,OBJPROP_XDISTANCE,Shifts[9]);
            ObjectSet(name,OBJPROP_YDISTANCE,y);
            ObjectSetText(name,DoubleToStr(Tpl,2),9,"Arial",HeaderColor);
           }//---- remove lines
         name="Totals-pips";
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
           {
            ObjectSet(name,OBJPROP_XDISTANCE,Shifts[10]);
            ObjectSet(name,OBJPROP_YDISTANCE,y);
            ObjectSetText(name,DoubleToStr(Tpips,0),9,"Arial",HeaderColor);
           }//---- remove lines
         name="Totals-OPENdeals";
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
           {
            ObjectSet(name,OBJPROP_XDISTANCE,Shifts[11]);
            ObjectSet(name,OBJPROP_YDISTANCE,y);
            ObjectSetText(name,DoubleToStr(OPTdeals,0),9,"Arial",HeaderColor);
           }//---- remove lines
         name="Totals-OPENtprofit";
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
           {
            ObjectSet(name,OBJPROP_XDISTANCE,Shifts[12]);
            ObjectSet(name,OBJPROP_YDISTANCE,y);
            ObjectSetText(name,DoubleToStr(OPTprofit,2),9,"Arial",HeaderColor);
           }//---- remove lines
         name="Totals-OPENtloss";
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
           {
            ObjectSet(name,OBJPROP_XDISTANCE,Shifts[13]);
            ObjectSet(name,OBJPROP_YDISTANCE,y);
            ObjectSetText(name,DoubleToStr(OPTloss,2),9,"Arial",HeaderColor);
           }//---- remove lines
         name="Totals-OPENnetpl";
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
           {
            ObjectSet(name,OBJPROP_XDISTANCE,Shifts[14]);
            ObjectSet(name,OBJPROP_YDISTANCE,y);
            ObjectSetText(name,DoubleToStr(OPTpl,2),9,"Arial",HeaderColor);
           }//---- remove lines
         name="Totals-OPENpips";
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
           {
            ObjectSet(name,OBJPROP_XDISTANCE,Shifts[15]);
            ObjectSet(name,OBJPROP_YDISTANCE,y);
            ObjectSetText(name,DoubleToStr(OPTpips,0),9,"Arial",HeaderColor);
           }//---- remove lines

         int x=10;
         name="From-Date-text";
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
           {
            ObjectSet(name,OBJPROP_XDISTANCE,x);
            ObjectSet(name,OBJPROP_YDISTANCE,y+RowSpacing);
            ObjectSetText(name,"This Report is From:",9,"Arial",HeaderColor);
           }//---- remove lines
         name="From-Date";
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
           {
            ObjectSet(name,OBJPROP_XDISTANCE,x+120);
            ObjectSet(name,OBJPROP_YDISTANCE,y+RowSpacing);
            ObjectSetText(name,TimeToStr(sdate,TIME_DATE),9,"Arial",HeaderColor);
           }//---- remove lines 
         name="To-Date-text";
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
           {
            ObjectSet(name,OBJPROP_XDISTANCE,x+190);
            ObjectSet(name,OBJPROP_YDISTANCE,y+RowSpacing);
            ObjectSetText(name,"Until:",9,"Arial",HeaderColor);
           }//---- remove lines 
         name="To-Date";
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
           {
            ObjectSet(name,OBJPROP_XDISTANCE,x+230);
            ObjectSet(name,OBJPROP_YDISTANCE,y+RowSpacing);
            ObjectSetText(name,TimeToStr(edate,TIME_DATE),9,"Arial",HeaderColor);
           }//---- remove lines 
    }

void GetMultiplier()
{
   int digits=MarketInfo(OrderSymbol(),MODE_DIGITS);
   if(digits == 2 || digits == 4)   multiplier = 1;
   if(digits == 3 || digits == 5)   multiplier = 0.1;
   if(digits == 6)                  multiplier = 0.01;  
   if(digits == 7)                  multiplier = 0.001;  
}