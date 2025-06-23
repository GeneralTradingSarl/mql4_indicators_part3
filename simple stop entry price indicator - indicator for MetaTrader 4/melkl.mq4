//5/7/09
//+------------------------------------------------------------------+
//|	myentrylines.mq4 |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2009,KurlFX"
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_color3 Green
#property indicator_color4 Red
#define GP 15
//--buffers
double BE[];
double SE[];
double BB[];
double SS[];
//rev
int PAP;
color Bcol=Green,Scol=Red,Col=Gray;
string Unq="melkl-",nmBE,nmSE,nmRisk;
//+------------------------------------------------------------------+
//| init                                                  |
//+------------------------------------------------------------------+
int init()
{
	SetIndexBuffer(0, BE);
	SetIndexBuffer(1, SE);

	SetIndexLabel(0,NULL);
	SetIndexLabel(1,NULL);

   SetIndexStyle(0, DRAW_ARROW);
   SetIndexArrow(0,225);
   SetIndexStyle(1, DRAW_ARROW);
   SetIndexArrow(1,226);

//--rev
	SetIndexBuffer(2, BB);
	SetIndexBuffer(3, SS);

	SetIndexLabel(2,"BuyEntry");
	SetIndexLabel(3,"SellEntry");

	if(MathMod(Digits,2)==0)PAP=1;else PAP=10;

	nmBE=Unq+"BuyEntry";Dlbl(nmBE," ",1,2,2,Bcol,9);
	nmSE=Unq+"SellEntry";Dlbl(nmSE," ",1,2,14,Scol,9);
	nmRisk=Unq+"Risk";Dlbl(nmRisk," ",1,2,26,Col,9);

	return(0);
}
//+------------------------------------------------------------------+
//| deinit                                                  |
//+------------------------------------------------------------------+
int deinit()
{
	int obj_total=ObjectsTotal();
	string name;
	int ln=StringLen(Unq);
	for(int i=0;i<obj_total;i++)
	{
		name=ObjectName(obj_total-1-i);
		if(StringSubstr(name,0,ln)==Unq)ObjectDelete(name);
	}
	Comment("");
	return(0);	
}
//+------------------------------------------------------------------+
//| main|
//+------------------------------------------------------------------+
int start()
{
	int cntbar=IndicatorCounted();
	int limit=Bars-cntbar;
	if(cntbar==0){limit-=3;BB[limit]=EMPTY_VALUE;SS[limit]=EMPTY_VALUE;}
	for(int i=limit-1;i>=0;i--)
	{
		BE[i] = EMPTY_VALUE;
		SE[i] = EMPTY_VALUE;

		if(High[i+3]>High[i+2]&&High[i+2]>High[i+1]&&Low[i+3]<Low[i+2]&&Low[i+2]<Low[i+1])
		{
			double be,se;
			be= High[i+2]+GP*PAP*Point;
			se=Low[i+2]-GP*PAP*Point;
			BE[i]=be;be+=Ask-Bid;
			SE[i]=se;
			ObjectSetText(nmBE,"buy(Ask): > "+DoubleToStr(be,Digits));
			ObjectSetText(nmSE,"sell(Bid): < "+DoubleToStr(se,Digits));
			ObjectSetText(nmRisk,"risk-: "+DoubleToStr((be-se)/Point/PAP,0)+"pips");
		}
		
		if(BE[i]!=EMPTY_VALUE)BB[i]=BE[i];else BB[i]=BB[i+1];
		if(SE[i]!=EMPTY_VALUE)SS[i]=SE[i];else SS[i]=SS[i+1];
	}
	return(0);
}
//+------------------------------------------------------------------+
//|	Create Objects				|
//+------------------------------------------------------------------+
void Dlbl(string name,string txt,int corner,int x,int y,color col,int fontsz)
{
	ObjectCreate(name,OBJ_LABEL,0,0,0);
	ObjectSetText(name,txt,fontsz,"Arial",col);
	ObjectSet(name,OBJPROP_CORNER,corner);
	ObjectSet(name,OBJPROP_YDISTANCE,y);
	ObjectSet(name,OBJPROP_XDISTANCE,x);
}
//+------------------------------------------------------------------