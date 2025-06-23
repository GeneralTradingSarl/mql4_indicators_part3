#define OP_ALL 10
#define OP_OPENED 11
#define OP_PENDING 12

#property copyright "Copyright © 2014, Matus German www.MTexperts.net"
#property link      "http://www.mtexperts.net"

#property indicator_separate_window
#property strict

extern string MNdescription = "ALL = all magic numbers; 0 = manual trades; 1,5846,214 = 3 selected magics";
extern string MagicNumber = "ALL";
extern string SymbolDescription = "ALL = all symbols; EURUSD,USDJPY,GBPUSD = 3 selected symbols";
extern string Symbols =  "EURUSD,GBPUSD";
extern bool   SortBySymbols = true;
extern color Clr_1 = White;
extern color Clr_2 = Green;
extern color Clr_3 = Red;
extern string  Font     ="Arial";
extern int     FontSize     =12;
extern int     Correction = 7;

string IndicatorName = "ProfitInfo"+"_"+IntegerToString(SortBySymbols)+"_"+MagicNumber+"_"+Symbols;

//int columns;
int mNumbers[];
string sSymbols[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   IndicatorShortName(IndicatorName); 
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{  
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   int total  = OrdersTotal(), rows=0;
   bool newMN, newSymbol;
   ArrayResize(mNumbers,0);
   ArrayResize(sSymbols,0);
   for (int cnt = total-1 ; cnt >=0 ; cnt--)
   {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) return(0);
      if(SelectedSymbol(OrderSymbol()) && (OrderMagicNumber()==StringToInteger(MagicNumber) || SelectedMagic(MagicNumber)))
      {
         if(SortBySymbols)
         {
            newSymbol=true;
            for(int i=0;i<ArraySize(sSymbols);i++)
               if(sSymbols[i]==OrderSymbol()) newSymbol=false;  // not a new magic number
               
            if(newSymbol)
               AppendS(sSymbols, OrderSymbol());
               
         }
         else
         {
            newMN=true;
            for(int i=0;i<ArraySize(mNumbers);i++)
               if(mNumbers[i]==OrderMagicNumber()) newMN=false;  // not a new magic number
               
            if(newMN)
               AppendI(mNumbers, OrderMagicNumber());
         }
      }
   }

   if(SortBySymbols)
   {
      ArrayResize(mNumbers,ArraySize(sSymbols));
      if(ArraySize(sSymbols)>0)
         ArraySort(sSymbols,WHOLE_ARRAY,0,MODE_DESCEND);
      UpdateTable(ArraySize(sSymbols));
   }
   else
   {
      ArrayResize(sSymbols,ArraySize(mNumbers));
      if(ArraySize(mNumbers)>0)
         ArraySort(mNumbers,WHOLE_ARRAY,0,MODE_DESCEND);
      UpdateTable(ArraySize(mNumbers));
   }
   return(0);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void AppendI(int& myArray[], int append)
{
   ArrayResize(myArray, ArraySize(myArray)+1);
   myArray[ArraySize(myArray)-1]=append;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void AppendS(string& myArray[], string append)
{
   ArrayResize(myArray, ArraySize(myArray)+1);
   myArray[ArraySize(myArray)-1]=append;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool SelectedMagic(string magic)
{
	if ( MagicNumber == "" )						return(true);
	if ( MagicNumber == "ALL" )					return(true);
	
	string to_split=MagicNumber;
	string sep=","; 
	ushort u_sep;                 
   string result[];
   u_sep=StringGetCharacter(sep,0);
   
   int k=StringSplit(to_split,u_sep,result);

   for(int i=0;i<k;i++)
      if(magic==result[i]) return(true);

	return(false);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool SelectedSymbol( string symbol )
{
	if ( Symbols == "" )								return(true);
	if ( symbol == "ALL" )						   return(true);
	if ( StringFind( Symbols, symbol ) >= 0 )	return(true);

	return(false);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void SetTableVal(int row, int col, string text, color colorCustom=White)
{
   int space=5;
	string name = StringConcatenate(IndicatorName, "_", row , "_", col );
   int Table_MaxDescription = 35;

	int columns_width[6] = {5, 6, 6, 6, 5, 8};  // magicNumber, profit, profit buy, profit sell, opened buy, opened sell
   
	int x = space;
	for ( int c = 0; c < col; c ++ ) x += columns_width[c]*(FontSize+Correction);

	int y = row*(FontSize+Correction)+5;

	if ( col == 3 )
	{
		if ( StringLen( text ) > Table_MaxDescription ) text = StringSubstr( text, 0, Table_MaxDescription);
	}

	if ( ObjectFind( name ) < 0 )
	{
		ObjectCreate( name, OBJ_LABEL, WindowFind(IndicatorName), Time[0], Ask );
		ObjectSet	( name, OBJPROP_CORNER, 1);
		ObjectSet	( name, OBJPROP_BACK, false );
	}

	ObjectSet	( name, OBJPROP_COLOR, colorCustom);
	ObjectSet	( name, OBJPROP_XDISTANCE, x );
	ObjectSet	( name, OBJPROP_YDISTANCE, y );

	ObjectSetText( name, text, FontSize, Font, colorCustom);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void UpdateTable(int rows)
{
   int row=0, total, openedBuy=0, openedSell=0, openedBuy_all=0, openedSell_all=0;
   double profit=0, profitBuy=0, profitSell=0, profit_all=0, profitBuy_all=0, profitSell_all=0;
   
   if(SortBySymbols)
      SetTableVal(row, 5, "Symbol", Clr_1);
   else
      SetTableVal(row, 5, "Magic Number", Clr_1);
   SetTableVal(row, 4, "Opened buy", Clr_1);
   SetTableVal(row, 3, "Profit buy", Clr_1);
   SetTableVal(row, 2, "Opened sell", Clr_1);
   SetTableVal(row, 1, "Profit sell", Clr_1);
   SetTableVal(row, 0, "Profit", Clr_1);
   
   row++;
   for(int i=rows-1; i>=0; i--)
   {
      openedBuy=0; openedSell=0; profitBuy=0; profitSell=0; profit=0;
      total  = OrdersTotal();
      openedBuy=0;
      openedSell=0;
      profit=0;
      profitBuy=0;
      profitSell=0;
      for (int cnt = total-1 ; cnt >=0 ; cnt--)
      {
         if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES)) return;
         if(((SelectedSymbol(OrderSymbol()) && !SortBySymbols) || (SelectedMagic(IntegerToString(OrderMagicNumber())) && SortBySymbols)) 
         && ((OrderMagicNumber()==mNumbers[i] && !SortBySymbols) || (OrderSymbol()==sSymbols[i] && SortBySymbols)))
         {
            if(OrderType()==OP_BUY)
            {
               openedBuy++;
               openedBuy_all++;
               profitBuy+=OrderProfit()+OrderSwap()+OrderCommission();
               profitBuy_all+=OrderProfit()+OrderSwap()+OrderCommission();
            }
            if(OrderType()==OP_SELL)
            {
               openedSell++;
               openedSell_all++;
               profitSell+=OrderProfit()+OrderSwap()+OrderCommission();
               profitSell_all+=OrderProfit()+OrderSwap()+OrderCommission();
            }
            
            profit+=OrderProfit()+OrderSwap()+OrderCommission();
            profit_all+=OrderProfit()+OrderSwap()+OrderCommission();
         }
      }
      if(SortBySymbols)
         SetTableVal(row, 5, sSymbols[i], Clr_1);
      else
         SetTableVal(row, 5, IntegerToString(mNumbers[i]), Clr_1);
      SetTableVal(row, 4, IntegerToString(openedBuy), Clr_1);
      if(profitBuy>=0)
         SetTableVal(row, 3, DoubleToStr(profitBuy,2), Clr_2);
      else
         SetTableVal(row, 3, DoubleToStr(profitBuy,2), Clr_3);
      SetTableVal(row, 2, IntegerToString(openedSell), Clr_1);
      if(profitSell>=0)
         SetTableVal(row, 1, DoubleToStr(profitSell,2), Clr_2);
      else
         SetTableVal(row, 1, DoubleToStr(profitSell,2), Clr_3);
      if(profit>=0)
         SetTableVal(row, 0, DoubleToStr(profit,2), Clr_2);
      else
         SetTableVal(row, 0, DoubleToStr(profit,2), Clr_3);
         
      row++;
   }
   
   SetTableVal(row, 5, "--------", Clr_1);
   SetTableVal(row, 4, "--------", Clr_1);
   SetTableVal(row, 3, "--------", Clr_1);
   SetTableVal(row, 2, "--------", Clr_1);
   SetTableVal(row, 1, "--------", Clr_1);
   SetTableVal(row, 0, "--------", Clr_1);
   row++;
   
   SetTableVal(row, 5, "Summary", Clr_1);
   SetTableVal(row, 4, IntegerToString(openedBuy_all), Clr_1);
   if(profitBuy_all>=0)
      SetTableVal(row, 3, DoubleToStr(profitBuy_all,2), Clr_2);
   else
      SetTableVal(row, 3, DoubleToStr(profitBuy_all,2), Clr_3);
   SetTableVal(row, 2, IntegerToString(openedSell_all), Clr_1);
   if(profitSell_all>=0)
      SetTableVal(row, 1, DoubleToStr(profitSell_all,2), Clr_2);
   else
      SetTableVal(row, 1, DoubleToStr(profitSell_all,2), Clr_3);
   if(profit_all>=0)
      SetTableVal(row, 0, DoubleToStr(profit_all,2), Clr_2);
   else
      SetTableVal(row, 0, DoubleToStr(profit_all,2), Clr_3);
   row++;
   
   while(ObjectFind(StringConcatenate(IndicatorName,"_",row,"_",0))!=-1)
   {
      for(int j=0;j<6;j++)
         ObjectDelete(StringConcatenate(IndicatorName,"_",row,"_",j));
      row++;
   }
}
//+------------------------------------------------------------------+