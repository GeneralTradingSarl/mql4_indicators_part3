#property copyright "Copyright © 2007, Waddah Attar"
#property link      "waddahattar@hotmail.com"

#property indicator_chart_window

#property indicator_buffers 0

extern int DaysShift = 0;
extern double Step = 5;
extern int SupportRange = 400;
extern int ResistanceRange = 400;
extern bool ShowMorePowerOnly = true;
extern double  PowerPercent=80;
extern bool AutoSupRes=false;
extern bool StrongLevel=true;
extern bool HiddenLevel=true;
extern bool RSILevel=true;
extern bool PivotLevel=true;
extern bool CamarillaLevel=true;
extern bool HiLoLevel=true;
extern bool PercentageLevel=true;


double OpenDay;

int init()
{
  return(0);
}

int deinit()
{
  ObjectsDeleteAll(0,OBJ_RECTANGLE);
  return(0);
}

int start()
{
  double DayTime=iTime(Symbol(),PERIOD_D1,DaysShift);
  double i;
  int j;
  
  if(AutoSupRes)
  {
    OpenDay=(Bid+Ask)/2;
  }
  else
  {
    OpenDay=iOpen(Symbol(),PERIOD_D1,DaysShift);
  }

  if(DaysShift>0)
  {
    OpenDay=iOpen(Symbol(),PERIOD_D1,DaysShift);
  }

  ObjectsDeleteAll(0,OBJ_RECTANGLE);
  
  for(i=OpenDay-(Step/2)*Point;i>=OpenDay-SupportRange*Point;i=i-Step*Point)
  {
    DrawRect("sup"+DaysShift+"-"+j,DayTime,i,DayTime+86400,i-Step*Point,White);
    j++;
  }
  
  j=0;
  for(i=OpenDay+(Step/2)*Point;i<=OpenDay+ResistanceRange*Point;i=i+Step*Point)
  {
    DrawRect("res"+DaysShift+"-"+j,DayTime,i,DayTime+86400,i-Step*Point,White);
    j++;
  }
  
  if(StrongLevel)
  {
    AddStrongLevel(PERIOD_D1,15); //21
    AddStrongLevel(PERIOD_W1,30); //21
    AddStrongLevel(PERIOD_MN1,60); //21 //63
  }

  if(HiddenLevel)
  {
    AddHiddenLevel(PERIOD_D1,15); //7
    AddHiddenLevel(PERIOD_W1,30); //7
    AddHiddenLevel(PERIOD_MN1,60); //7 //21
  }

  if(RSILevel)
  {
    AddRSILevel(30); //11 //11
  }

  if(PivotLevel)
  {
    AddPivotLevel(PERIOD_D1,15); //11
    AddPivotLevel(PERIOD_W1,30); //11
    AddPivotLevel(PERIOD_MN1,60); //11 //33
  }

  if(CamarillaLevel)
  {
    AddCamarillaLevel(PERIOD_D1,15); //8
    AddCamarillaLevel(PERIOD_W1,30); //8
    AddCamarillaLevel(PERIOD_MN1,60); //8 //24
  }

  if(HiLoLevel)
  {
    AddHiLoLevel(PERIOD_D1,15); //3
    AddHiLoLevel(PERIOD_W1,30); //3
    AddHiLoLevel(PERIOD_MN1,60); //3 //9
  }

  if(PercentageLevel)
  {
    AddPercentageLevel(PERIOD_D1,15); //3
    AddPercentageLevel(PERIOD_W1,30); //3
    AddPercentageLevel(PERIOD_MN1,60); //3 //9
  }

  if(ShowMorePowerOnly) SetColorWhite(PowerPercent/100*255);
  
  DelColorWhite(White);
  //SmallRect();
}

void DrawRect(string name,datetime x1,double y1,datetime x2,double y2,double clr)
{
  ObjectCreate(name,OBJ_RECTANGLE,0,x1,y1,x2,y2);
  ObjectSet(name,OBJPROP_COLOR,clr);
}

void AddStrongLevel(int period,double clr)
{
  int i,j,ii;
  double c1, c2, dc, L1, L2, DefDay;
  double y1,y2;
  
  ii = iBarShift(Symbol(), period, Time[DaysShift],true);
  if(ii != -1)
  {
    c1 = iClose(Symbol(), period, ii + 1 + DaysShift);
    c2 = iClose(Symbol(), period, ii + 2 + DaysShift);
    dc = c1 - c2;
    if(dc == 0)
    {
      c2 = iClose(Symbol(), period, ii + 3 + DaysShift);
      dc = c1 - c2;
    }
    if(dc == 0) dc = c1;
    L1=c1-dc;
    L2=c1+dc;
    DefDay=MathAbs(2*dc);
    SetColorLevel(L1,2*clr);
    SetColorLevel(L2,2*clr);
    if (L1<L2)
    {
      SetColorLevel(L1+DefDay*0.236,clr);
      SetColorLevel(L1+DefDay*0.382,clr);
      SetColorLevel(L1+DefDay*0.5,clr);
      SetColorLevel(L1+DefDay*0.618,clr);
      SetColorLevel(L1+DefDay*0.764,clr);

      SetColorLevel(L1-DefDay*0.236,clr);
      SetColorLevel(L1-DefDay*0.382,clr);
      SetColorLevel(L1-DefDay*0.5,clr);
      SetColorLevel(L1-DefDay*0.618,clr);
      SetColorLevel(L1-DefDay*1,clr);
      SetColorLevel(L1-DefDay*1.618,clr);
      SetColorLevel(L1-DefDay*2.618,clr);
      SetColorLevel(L1-DefDay*3.618,clr);

      SetColorLevel(L2+DefDay*0.236,clr);
      SetColorLevel(L2+DefDay*0.382,clr);
      SetColorLevel(L2+DefDay*0.5,clr);
      SetColorLevel(L2+DefDay*0.618,clr);
      SetColorLevel(L2+DefDay*1,clr);
      SetColorLevel(L2+DefDay*1.618,clr);
      SetColorLevel(L2+DefDay*2.618,clr);
      SetColorLevel(L2+DefDay*3.618,clr);
    }
    else
    {
      SetColorLevel(L1-DefDay*0.236,clr);
      SetColorLevel(L1-DefDay*0.382,clr);
      SetColorLevel(L1-DefDay*0.5,clr);
      SetColorLevel(L1-DefDay*0.618,clr);
      SetColorLevel(L1-DefDay*0.764,clr);

      SetColorLevel(L1+DefDay*0.236,clr);
      SetColorLevel(L1+DefDay*0.382,clr);
      SetColorLevel(L1+DefDay*0.5,clr);
      SetColorLevel(L1+DefDay*0.618,clr);
      SetColorLevel(L1+DefDay*1,clr);
      SetColorLevel(L1+DefDay*1.618,clr);
      SetColorLevel(L1+DefDay*2.618,clr);
      SetColorLevel(L1+DefDay*3.618,clr);

      SetColorLevel(L2-DefDay*0.236,clr);
      SetColorLevel(L2-DefDay*0.382,clr);
      SetColorLevel(L2-DefDay*0.5,clr);
      SetColorLevel(L2-DefDay*0.618,clr);
      SetColorLevel(L2-DefDay*1,clr);
      SetColorLevel(L2-DefDay*1.618,clr);
      SetColorLevel(L2-DefDay*2.618,clr);
      SetColorLevel(L2-DefDay*3.618,clr);
    }
  }
}

void AddHiddenLevel(int period,double clr)
{
  int ii;
  double c1, c2, dc;
  
  ii = iBarShift(Symbol(), period, Time[DaysShift],true);
  if(ii != -1)
  {
    if(iClose(Symbol(), period, ii + 1 + DaysShift)>=iOpen(Symbol(), period, ii + 1 + DaysShift))
    {
      c1 = (iHigh(Symbol(), period, ii + 1 + DaysShift)-iClose(Symbol(), period, ii + 1 + DaysShift))/2+iClose(Symbol(), period, ii + 1 + DaysShift);
      c2 = (iOpen(Symbol(), period, ii + 1 + DaysShift)-iLow(Symbol(), period, ii + 1 + DaysShift))/2+iLow(Symbol(), period, ii + 1 + DaysShift);
    }
    else
    {
      c1 = (iHigh(Symbol(), period, ii + 1 + DaysShift)-iOpen(Symbol(), period, ii + 1 + DaysShift))/2+iOpen(Symbol(), period, ii + 1 + DaysShift);
      c2 = (iClose(Symbol(), period, ii + 1 + DaysShift)-iLow(Symbol(), period, ii + 1 + DaysShift))/2+iLow(Symbol(), period, ii + 1 + DaysShift);
    }
  
    SetColorLevel(c1,2*clr);
    SetColorLevel(c2,2*clr);
    SetColorLevel((c1+c2)/2,clr);
    SetColorLevel(c1+(c1-c2)*0.618,clr);
    SetColorLevel(c2-(c1-c2)*0.618,clr);
    SetColorLevel(c1+(c1-c2)*1.618,clr);
    SetColorLevel(c2-(c1-c2)*1.618,clr);
  }
}

void AddRSILevel(double clr)
{
  int ii;
  double c1, c2, dc;
  double rsi1, rsi2, drsi;
  
  ii = iBarShift(Symbol(), PERIOD_D1, Time[DaysShift],true);
  if(ii != -1)
  {
    rsi1 = iRSI(Symbol(), PERIOD_D1, 5, PRICE_CLOSE, ii + 1 + DaysShift);
    rsi2 = iRSI(Symbol(), PERIOD_D1, 5, PRICE_CLOSE, ii + 2 + DaysShift);
    c1 = iClose(Symbol(), PERIOD_D1, ii + 1 + DaysShift);
    c2 = iClose(Symbol(), PERIOD_D1, ii + 2 + DaysShift);
    drsi = rsi1 - rsi2;
    if(drsi == 0)
    {
      rsi2 = iRSI(Symbol(), PERIOD_D1, 5, PRICE_CLOSE, ii + 3 + DaysShift);
    }
    drsi = rsi1 - rsi2;
    if(drsi == 0)
    {
      drsi = rsi1;
    }
    dc = c1 - c2;
    if(dc == 0)
    {
      c2 = iClose(Symbol(), PERIOD_D1, ii + 3);
    }
    dc = c1 - c2;
    if(dc == 0)
    {
      dc = c1;
    }
    SetColorLevel((((0 - rsi1)*dc) / drsi) + c1,clr);
    SetColorLevel((((10 - rsi1)*dc) / drsi) + c1,clr);
    SetColorLevel((((20 - rsi1)*dc) / drsi) + c1,clr);
    SetColorLevel((((30 - rsi1)*dc) / drsi) + c1,clr);
    SetColorLevel((((40 - rsi1)*dc) / drsi) + c1,clr);
    SetColorLevel((((50 - rsi1)*dc) / drsi) + c1,clr);
    SetColorLevel((((60 - rsi1)*dc) / drsi) + c1,clr);
    SetColorLevel((((70 - rsi1)*dc) / drsi) + c1,clr);
    SetColorLevel((((80 - rsi1)*dc) / drsi) + c1,clr);
    SetColorLevel((((90 - rsi1)*dc) / drsi) + c1,clr);
    SetColorLevel((((100 - rsi1)*dc) / drsi) + c1,clr);
  }
}

void AddPivotLevel(int period, double clr)
{
  int ii;
  double Q, PP;

  ii = iBarShift(Symbol(), period, Time[DaysShift], false);
  if(ii != -1)
  {
    Q = (iHigh(Symbol(), period,ii + 1+DaysShift) - iLow(Symbol(), period, ii + 1+DaysShift));
    PP =(iHigh(Symbol(), period,ii + 1+DaysShift) + iLow(Symbol(), period, ii + 1+DaysShift) + iClose(Symbol(), period, ii + 1+DaysShift)) / 3;    
    SetColorLevel(PP,clr);
    SetColorLevel(PP + (Q * 0.23),clr);
    SetColorLevel(PP - (Q * 0.23),clr);
    SetColorLevel(PP + (Q * 0.38),clr);
    SetColorLevel(PP - (Q * 0.38),clr);
    SetColorLevel(PP + (Q * 0.50),clr);
    SetColorLevel(PP - (Q * 0.50),clr);
    SetColorLevel(PP + (Q * 0.618),clr);
    SetColorLevel(PP - (Q * 0.618),clr);
    SetColorLevel(PP + (Q * 1),clr);
    SetColorLevel(PP - (Q * 1),clr);
  }
}


void AddCamarillaLevel(int period, double clr)
{
  int ii;
  double Q, cc;

  ii = iBarShift(Symbol(), period, Time[DaysShift], false);
  if(ii != -1)
  {
    Q = (iHigh(Symbol(), period,ii+1+DaysShift) - iLow(Symbol(), period, ii + 1+DaysShift));
    cc=iClose(Symbol(), period,ii+1+DaysShift);
    SetColorLevel(cc + (Q * 0.09),clr);
    SetColorLevel(cc - (Q * 0.09),clr);
    SetColorLevel(cc + (Q * 0.18),clr);
    SetColorLevel(cc - (Q * 0.18),clr);
    SetColorLevel(cc + (Q * 0.27),clr);
    SetColorLevel(cc - (Q * 0.27),clr);
    SetColorLevel(cc + (Q * 0.55),clr);
    SetColorLevel(cc - (Q * 0.55),clr);
  }
}

void AddHiLoLevel(int period, double clr)
{
  int ii;
  double h,l;
  
  ii = iBarShift(Symbol(), period, Time[DaysShift], false);
  if(ii != -1)
  {
    h=iHigh(Symbol(),period,ii+1+DaysShift);
    l=iLow(Symbol(),period,ii+1+DaysShift);
    SetColorLevel(h,clr);
    SetColorLevel(l,clr);
    SetColorLevel((h+l)/2,clr);
  }
}

void AddPercentageLevel(int period, double clr)
{
  int ii;
  double c1;

  ii = iBarShift(Symbol(), period, Time[DaysShift], false);
  if(ii != -1)
  {
    c1=iClose(Symbol(), period, ii+1+DaysShift);    
    SetColorLevel(c1+(c1*0.005),clr);
    SetColorLevel(c1+(c1*0.01),clr);
    SetColorLevel(c1+(c1*0.015),clr);
    SetColorLevel(c1-(c1*0.005),clr);
    SetColorLevel(c1-(c1*0.01),clr);
    SetColorLevel(c1-(c1*0.015),clr);
  }
}

void AddRedColor(string name,double clr)
{
  double objclr;
  datetime objtime1;
  datetime objtime2;
  int r,g,b;
  
  objclr=ObjectGet(name,OBJPROP_COLOR);
  objtime1=ObjectGet(name,OBJPROP_TIME1);
  objtime2=ObjectGet(name,OBJPROP_TIME2);
  
  r =MathMod(objclr,0x100);
  objclr = MathFloor(objclr/0x100);
  g = MathMod(objclr,0x100);
  objclr = MathFloor(objclr/0x100);
  b = MathMod(objclr,0x100);

  g=g-clr;
  if(g<0)
  {
    MinusRedColor(g);
    g=0;
  }
  b=b-clr;
  if(b<0) b=0;
  if(g>255) g=255;
  if(b>255) b=255;
  
  objclr=r+g*256+b*65536;
  
  ObjectSet(name,OBJPROP_COLOR,objclr);
  ObjectSet(name,OBJPROP_TIME1,objtime1-clr*300);
  ObjectSet(name,OBJPROP_TIME2,objtime2+clr*300);
}

void AddGreenColor(string name,double clr)
{
  double objclr;
  datetime objtime1;
  datetime objtime2;
  int r,g,b;
  
  objclr=ObjectGet(name,OBJPROP_COLOR);
  objtime1=ObjectGet(name,OBJPROP_TIME1);
  objtime2=ObjectGet(name,OBJPROP_TIME2);
  
  r =MathMod(objclr,0x100);
  objclr = MathFloor(objclr/0x100);
  g = MathMod(objclr,0x100);
  objclr = MathFloor(objclr/0x100);
  b = MathMod(objclr,0x100);

  r=r-clr;
  if(r<0)
  {
    MinusGreenColor(r);
    r=0;
  }
  b=b-clr;
  if(b<0) b=0;
  if(r>255) r=255;
  if(b>255) b=255;
  
  objclr=r+g*256+b*65536;
  
  ObjectSet(name,OBJPROP_COLOR,objclr);
  ObjectSet(name,OBJPROP_TIME1,objtime1-clr*300);
  ObjectSet(name,OBJPROP_TIME2,objtime2+clr*300);
}

void SetColorLevel(double val,double clr)
{
  double y1,y2;
  
  for(int j=0;j<ObjectsTotal(OBJ_RECTANGLE);j++)
  {
    y1=ObjectGet(ObjectName(j),OBJPROP_PRICE1);
    y2=ObjectGet(ObjectName(j),OBJPROP_PRICE2);
    if(val<y1 && val>=y2)
    {
      if(StringFind(ObjectName(j),"res",0)>=0)
      {
        AddRedColor(ObjectName(j),clr);
        break;
      }
      else
      {
        AddGreenColor(ObjectName(j),clr);
        break;
      }
    }
  }
}

void MinusRedColor(double clr)
{
  for(int j=0;j<ObjectsTotal(OBJ_RECTANGLE);j++)
  {
    if(StringFind(ObjectName(j),"res",0)>=0)
    {
      AddRedColor(ObjectName(j),clr);
    }
  }
}

void MinusGreenColor(double clr)
{
  for(int j=0;j<ObjectsTotal(OBJ_RECTANGLE);j++)
  {
    if(StringFind(ObjectName(j),"sup",0)>=0)
    {
      AddGreenColor(ObjectName(j),clr);
    }
  }
}

void SetColorWhite(double clr)
{
  for(int j=0;j<ObjectsTotal(OBJ_RECTANGLE);j++)
  {
    if(StringFind(ObjectName(j),"sup",0)>=0)
    {
      SetGreenWhite(ObjectName(j),clr);
    }
    if(StringFind(ObjectName(j),"res",0)>=0)
    {
      SetRedWhite(ObjectName(j),clr);
    }
  }
}

void SetRedWhite(string name,double clr)
{
  double objclr;
  int r,g,b;
  
  objclr=ObjectGet(name,OBJPROP_COLOR);

  r =MathMod(objclr,0x100);
  objclr = MathFloor(objclr/0x100);
  g = MathMod(objclr,0x100);
  objclr = MathFloor(objclr/0x100);
  b = MathMod(objclr,0x100);

  if(g>clr && b>clr)
  {
    objclr=255+255*256+255*65536;
  }
  else
  {
    objclr=r+g*256+b*65536;
  }

  ObjectSet(name,OBJPROP_COLOR,objclr);
}

void SetGreenWhite(string name,double clr)
{
  double objclr;
  int r,g,b;
  
  objclr=ObjectGet(name,OBJPROP_COLOR);

  r =MathMod(objclr,0x100);
  objclr = MathFloor(objclr/0x100);
  g = MathMod(objclr,0x100);
  objclr = MathFloor(objclr/0x100);
  b = MathMod(objclr,0x100);

  if(r>clr && b>clr)
  {
    objclr=255+255*256+255*65536;
  }
  else
  {
    objclr=r+g*256+b*65536;
  }
  
  ObjectSet(name,OBJPROP_COLOR,objclr);
}

void DelColorWhite(double clr)
{
  double objclr,i;
  string name;
  datetime time2;
  int j;

  for(i=OpenDay-(Step/2)*Point;i>=OpenDay-SupportRange*Point;i=i-Step*Point)
  {
    name="sup"+DaysShift+"-"+j;
    objclr=ObjectGet(name,OBJPROP_COLOR);
    if(objclr==clr)
    {
      ObjectDelete(name);
    }
    j++;
  }
  
  j=0;
  for(i=OpenDay+(Step/2)*Point;i<=OpenDay+ResistanceRange*Point;i=i+Step*Point)
  {
    name="res"+DaysShift+"-"+j;
    objclr=ObjectGet(name,OBJPROP_COLOR);
    if(objclr==clr)
    {
      ObjectDelete(name);
    }
    j++;
  }
}



