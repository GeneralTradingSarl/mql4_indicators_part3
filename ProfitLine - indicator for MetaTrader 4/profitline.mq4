#property copyright "Copyright © Matus German 2015, www.mtexperts.net"
#property version   "1.1" 
#property strict
#property indicator_chart_window

#include <Controls\Dialog.mqh>
#include <Controls\Label.mqh>
#include <Controls\RadioButton.mqh>
#include <Controls\RadioGroup.mqh>
#include <Controls\CheckBox.mqh>
#include <Controls\Edit.mqh>
#include <Controls\Button.mqh>

extern int    Font = 12;
extern color  Color = Red;

#define INDENT_LEFT                         (1)      // indent from left (with allowance for border width)
#define INDENT_TOP                          (1)      // indent from top (with allowance for border width)
#define INDENT_RIGHT                        (1)      // indent from right (with allowance for border width)
#define INDENT_BOTTOM                       (1)      // indent from bottom (with allowance for border width)
//--- for buttons
#define BUTTON_WIDTH                        (52)     // size by X coordinate
#define BUTTON_HEIGHT                       (20)      // size by Y coordinate
#define RADIO_BUTTON_WIDTH                  (20)     // size by X coordinate
//--- for the edit area
#define EDIT_WIDTH      104
#define EDIT_HEIGHT     20
#define LABEL_WIDTH     28
#define LABEL_HEIGHT    20

//+------------------------------------------------------------------+
//| Class CPanelDialog                                               |
//| Usage: main dialog of the SimplePanel application                |
//+------------------------------------------------------------------+
class CPanelDialog : public CAppDialog
{
private:
   CRadioButton      m_Lot;
   CRadioButton      m_Profit;
   CCheckBox         m_Spread;
   CEdit             m_Value;
   CButton           m_InsertLine;
   CButton           m_EditLine;
   CLabel            m_Label_Lot; 
   CLabel            m_Label_Profit;
   CLabel            m_Label_Spread;
   
   int               lastID;
      
public:
                     CPanelDialog(void);
                    ~CPanelDialog(void);
   //--- create
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   //--- chart event handler
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);

protected:
   //--- create dependent controls
   bool              CreateLabel(void);
   bool              CreateValue(void);
   bool              CreateLot(void);
   bool              CreateProfit(void);
   bool              CreateSpread(void);
   bool              CreateLabelSpread(void);
   bool              CreateLabelLot(void);
   bool              CreateLabelProfit(void);
   bool              CreateInsertLine(void);
   bool              CreateEditLine(void);
   //--- internal event handlers
   //virtual bool      OnResize(void);
   //--- handlers of the dependent controls events
   void              OnClickLot(void);
   void              OnClickProfit(void);
   void              OnClickInsertLine(void);
   void              OnClickEditLine(void);
};
//+------------------------------------------------------------------+
//| Event Handling                                                   |
//+------------------------------------------------------------------+

EVENT_MAP_BEGIN(CPanelDialog)
   ON_EVENT(ON_CHANGE,m_Lot,OnClickLot)
   ON_EVENT(ON_CHANGE,m_Profit,OnClickProfit)
   ON_EVENT(ON_CLICK,m_InsertLine,OnClickInsertLine)
   ON_EVENT(ON_CLICK,m_EditLine,OnClickEditLine)
EVENT_MAP_END(CAppDialog)

CPanelDialog::CPanelDialog(void){}
CPanelDialog::~CPanelDialog(void){}
//+------------------------------------------------------------------+
//| Create the "Background Panel" element                            |
//+------------------------------------------------------------------+  
bool CPanelDialog::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
{
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
      return(false);
//--- create dependent controls
   if(!CreateValue())
      return(false);
   if(!CreateLot())
      return(false);
   if(!CreateLabelLot())
      return(false);
   if(!CreateProfit())
      return(false);
   if(!CreateLabelProfit())
      return(false);
   if(!CreateSpread())
      return(false);
   if(!CreateLabelSpread())
      return(false);
   if(!CreateInsertLine())
      return(false);
   if(!CreateEditLine())
      return(false);
//--- succeed
   lastID=-1;

   return(true);
}
//+------------------------------------------------------------------+
//| Create the "Lot Radio button" element                                  |
//+------------------------------------------------------------------+  
bool CPanelDialog::CreateLot(void)
{
   int x1 = INDENT_LEFT;
   int y1 = INDENT_TOP;
   int x2 = x1 + RADIO_BUTTON_WIDTH;
   int y2 = y1 + LABEL_HEIGHT;
   
   if(!m_Lot.Create(m_chart_id, m_name+"Lot", m_subwin, x1, y1, x2, y2))
      return(false);  
   
   m_Lot.State(true);
       
   if(!Add(m_Lot))   // attach m_Value to dialog
      return(false);
   
   return(true);
}
//+------------------------------------------------------------------+
//| Create the "label for radio button Lot" element                                  |
//+------------------------------------------------------------------+ 
bool CPanelDialog::CreateLabelLot(void)
{
   int x1 = INDENT_LEFT+RADIO_BUTTON_WIDTH;
   int y1 = INDENT_TOP;
   int x2 = x1 + LABEL_WIDTH;
   int y2 = y1 + LABEL_HEIGHT;
   
   if(!m_Label_Lot.Create(m_chart_id, m_name+"LabelLot", m_subwin, x1, y1, x2, y2))
      return(false);  
   
   if(!m_Label_Lot.Text("Lot"))
      return(false);
       
   if(!Add(m_Label_Lot))   
      return(false);
   
   return(true);
}
//+------------------------------------------------------------------+
//| Create the "Profit Radio button" element                                  |
//+------------------------------------------------------------------+ 
bool CPanelDialog::CreateProfit(void)
{
   int x1 = INDENT_LEFT+RADIO_BUTTON_WIDTH+LABEL_WIDTH;
   int y1 = INDENT_TOP;
   int x2 = x1 + RADIO_BUTTON_WIDTH;
   int y2 = y1 + LABEL_HEIGHT;
   
   if(!m_Profit.Create(m_chart_id, m_name+"Profit", m_subwin, x1, y1, x2, y2))
      return(false);  
       
   if(!Add(m_Profit))   
      return(false);
   
   return(true);
}
//+------------------------------------------------------------------+
//| Create the "Label for Radio button profit" element                                  |
//+------------------------------------------------------------------+ 
bool CPanelDialog::CreateLabelProfit(void)
{
   int x1 = INDENT_LEFT+RADIO_BUTTON_WIDTH+LABEL_WIDTH+RADIO_BUTTON_WIDTH;
   int y1 = INDENT_TOP;
   int x2 = x1 + LABEL_WIDTH;
   int y2 = y1 + LABEL_HEIGHT;
   
   if(!m_Label_Profit.Create(m_chart_id, m_name+"LabelProfit", m_subwin, x1, y1, x2, y2))
      return(false);  
      
   if(!m_Label_Profit.Text("Profit"))
      return(false);
             
   if(!Add(m_Label_Profit))
      return(false);
   
   return(true);
}
//+------------------------------------------------------------------+
//| Create the "Spread check box" element                                  |
//+------------------------------------------------------------------+ 
bool CPanelDialog::CreateSpread(void)
{
   int x1 = INDENT_LEFT;
   int y1 = INDENT_TOP+EDIT_HEIGHT;
   int x2 = x1 + RADIO_BUTTON_WIDTH;
   int y2 = y1 + EDIT_HEIGHT;
   
   if(!m_Spread.Create(m_chart_id, m_name+"Spread", m_subwin, x1, y1, x2, y2))
      return(false);  
       
   if(!Add(m_Spread))  
      return(false);
   
   return(true);
}
//+------------------------------------------------------------------+
//| Create the "Label for spread" element                                  |
//+------------------------------------------------------------------+ 
bool CPanelDialog::CreateLabelSpread(void)
{
   int x1 = INDENT_LEFT+RADIO_BUTTON_WIDTH;
   int y1 = INDENT_TOP+EDIT_HEIGHT;
   int x2 = x1 + LABEL_WIDTH;
   int y2 = y1 + LABEL_HEIGHT;
   
   if(!m_Label_Spread.Create(m_chart_id, m_name+"LabelSpread", m_subwin, x1, y1, x2, y2))
      return(false);  
      
   if(!m_Label_Spread.Text("Spread"))
      return(false);
             
   if(!Add(m_Label_Spread))  
      return(false);
   
   return(true);
}
//+------------------------------------------------------------------+
//| Create the "Edit Value" element                                  |
//+------------------------------------------------------------------+ 
bool CPanelDialog::CreateValue(void)
{
   int x1 = INDENT_LEFT;
   int y1 = INDENT_TOP+2*EDIT_HEIGHT;
   int x2 = x1 + EDIT_WIDTH;
   int y2 = y1 + EDIT_HEIGHT;
   
   if(!m_Value.Create(m_chart_id, m_name+"Value", m_subwin, x1, y1, x2, y2))
      return(false);  
   
   if(!m_Value.Text("0.01"))
      return(false);
   
   if(!m_Value.TextAlign(ALIGN_RIGHT))
      return(false);
       
   if(!Add(m_Value))   
      return(false);
   
   return(true);
}
//+------------------------------------------------------------------+
//| Create the "Insert new line button" element                                  |
//+------------------------------------------------------------------+ 
bool CPanelDialog::CreateInsertLine(void)
{
   int x1 = INDENT_LEFT;
   int y1 = INDENT_TOP+3*EDIT_HEIGHT;
   int x2 = x1 + BUTTON_WIDTH;
   int y2 = y1 + BUTTON_HEIGHT;
   
   if(!m_InsertLine.Create(m_chart_id, m_name+"InsertLine", m_subwin, x1, y1, x2, y2))
      return(false);  

   if(!m_InsertLine.Text("New"))
      return(false);
      
   if(!Add(m_InsertLine))   // attach m_Value to dialog
      return(false);
   
   return(true);
}
//+------------------------------------------------------------------+
//| Create the "Edit Last button" element                                  |
//+------------------------------------------------------------------+ 
bool CPanelDialog::CreateEditLine(void)
{
   int x1 = INDENT_LEFT+BUTTON_WIDTH;
   int y1 = INDENT_TOP+3*EDIT_HEIGHT;
   int x2 = x1 + BUTTON_WIDTH;
   int y2 = y1 + BUTTON_HEIGHT;
   
   if(!m_EditLine.Create(m_chart_id, m_name+"EditLine", m_subwin, x1, y1, x2, y2))
      return(false);  

   if(!m_EditLine.Text("Edit"))
      return(false);
       
   if(!Add(m_EditLine))   // attach m_Value to dialog
      return(false);
   
   return(true);
}
// 
//+------------------------------------------------------------------+
//|         ON CLIC FUNCTION                                         |
//+------------------------------------------------------------------+ 
void CPanelDialog::OnClickLot(void)
{
   if(m_Lot.State())
      m_Profit.State(false);
   else
      m_Profit.State(true);
}
void CPanelDialog::OnClickProfit(void)
{
   if(m_Profit.State())
      m_Lot.State(false);
   else
      m_Lot.State(true);
}  
//+------------------------------------------------------------------+
//|         ON CLIC FUNCTION   insert new profit line                |
//+------------------------------------------------------------------+ 
void CPanelDialog::OnClickInsertLine(void)
{
   string lineDescription;
   double price1, price2;
   datetime time1, time2;
   bool lineCreated;
      int lineID=FindFreeID();
      lineCreated=true;
      if(ObjectFind(StringConcatenate("Profit_Line_",lineID))<0)
      {
         time1=iTime(Symbol(), PERIOD_CURRENT, (int)NormalizeDouble(WindowBarsPerChart()/2,0));
         time2=iTime(Symbol(), PERIOD_CURRENT, 0);
         price1=High[iBarShift(Symbol(), PERIOD_CURRENT, time1)];
         price2=Low[iBarShift(Symbol(), PERIOD_CURRENT, time2)];
         if(!ObjectCreate(0,StringConcatenate("Profit_Line_",lineID),OBJ_TREND,0,time1,price1,time2,price2))
            lineCreated=false;
         ObjectSet(StringConcatenate("Profit_Line_",lineID),OBJPROP_RAY,false);
         ObjectSet(StringConcatenate("Profit_Line_",lineID),OBJPROP_COLOR,Color); 
         // set description if it is set lot or profit
         if(m_Lot.State()) 
            lineDescription="Lot"; 
         if(m_Profit.State())
            lineDescription="Profit";
         
         lineDescription=StringConcatenate(lineDescription," ", m_Value.Text());
         StringReplace(lineDescription,",",".");
         
         if(m_Spread.Checked())
            lineDescription=StringConcatenate(lineDescription," Spread");
         
         ObjectSetString(0,StringConcatenate("Profit_Line_",lineID),OBJPROP_TEXT,lineDescription);  
      }
      else
         lineCreated=false;
         
      if(ObjectFind(StringConcatenate("Profit_Value_",lineID))<0)
      {
         if(!ObjectCreate(0,StringConcatenate("Profit_Value_",lineID),OBJ_TEXT,0,time2,price2))
            lineCreated=false;
         ObjectSet(StringConcatenate("Profit_Value_",lineID),OBJPROP_FONTSIZE,Font);
         ObjectSet(StringConcatenate("Profit_Value_",lineID),OBJPROP_COLOR,Color); 
         ObjectSetText(StringConcatenate("Profit_Value_",lineID),"Drag to calculate");
      }
      else
         lineCreated=false;
         
      m_InsertLine.Pressed(false);
       
      if(lineCreated)  
      {  
         lines++; 
         lastID=lineID;
      } 
}
//+------------------------------------------------------------------+
//|         ON CLIC FUNCTION   edit last profit line                |
//+------------------------------------------------------------------+ 
void CPanelDialog::OnClickEditLine(void)
{
   string lineDescription;
   datetime time1, time2;
   double price1, price2, calculatedProfit, calculatedLot;
   
   int lineID;
      if(lastID>=0)
         lineID=FindLastID();
      else
         lineID=lastID;

      if(ObjectFind(StringConcatenate("Profit_Line_",lineID))>=0)
      {
         time1=(datetime)ObjectGetInteger(0,StringConcatenate("Profit_Line_",lineID), OBJPROP_TIME1);
         price1=ObjectGetDouble(0,StringConcatenate("Profit_Line_",lineID), OBJPROP_PRICE1);
         time2=(datetime)ObjectGetInteger(0,StringConcatenate("Profit_Line_",lineID), OBJPROP_TIME2);
         price2=ObjectGetDouble(0,StringConcatenate("Profit_Line_",lineID), OBJPROP_PRICE2);
         
         // edit description   
         if(m_Lot.State()) 
            lineDescription="Lot"; 
         if(m_Profit.State())
            lineDescription="Profit";
         
         lineDescription=StringConcatenate(lineDescription," ", m_Value.Text());
         StringReplace(lineDescription,",",".");
         
         if(m_Spread.Checked())
            lineDescription=StringConcatenate(lineDescription," Spread");
         ObjectSetString(0,StringConcatenate("Profit_Line_",lineID),OBJPROP_TEXT,lineDescription);
            
         if(MathAbs(price1-price2)==0)    // zero divide protectio
            price1+=Point;
            
         if(m_Lot.State())    // if radio button selected Lot
         {        
            if(m_Spread.Checked())
               calculatedProfit=(MathAbs(price1-price2)/Point + MarketInfo(Symbol(), MODE_SPREAD))*MarketInfo(Symbol(), MODE_TICKVALUE)*StringToDouble(m_Value.Text());
            else
               calculatedProfit=(MathAbs(price1-price2)/Point)*MarketInfo(Symbol(), MODE_TICKVALUE)*StringToDouble(m_Value.Text());   
                  
            ObjectSetText(StringConcatenate("Profit_Value_",lineID),StringConcatenate(DoubleToStr(calculatedProfit,2)," ",AccountCurrency()));
         }
         else if(m_Profit.State())    // if radio button selected Profit
         {
            if(m_Spread.Checked())
               calculatedLot=StringToDouble(m_Value.Text())/((MathAbs(price1-price2)/Point + MarketInfo(Symbol(), MODE_SPREAD))*MarketInfo(Symbol(), MODE_TICKVALUE));
            else
               calculatedLot=StringToDouble(m_Value.Text())/((MathAbs(price1-price2)/Point)*MarketInfo(Symbol(), MODE_TICKVALUE));
                     
            ObjectSetText(StringConcatenate("Profit_Value_",lineID),StringConcatenate(DoubleToStr(calculatedLot,2)," Lot"));
         }       
      }
  
      m_InsertLine.Pressed(false);
}

int lines=0;
CPanelDialog PLDialog;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   if(WindowOnDropped()!=0)
   {
      Print("ProfitLine must be applied to main chart window!");
      return(INIT_FAILED);
   }

   if(!PLDialog.Create(0,"Profit Line", 0, 5,5,119, 115)) return(INIT_FAILED);
   if(!PLDialog.Run()) return(INIT_FAILED);

   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   for(int i=0; i<lines; i++)
   {
      ObjectDelete(StringConcatenate("Profit_Line_",i));
      ObjectDelete(StringConcatenate("Profit_Value_",i));
   }
   PLDialog.Destroy(reason);
   return;
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
// on calculate only to remove error, logic of the indicator is handled by events
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime& time[],
                const double& open[],
                const double& high[],
                const double& low[],
                const double& close[],
                const long& tick_volume[],
                const long& volume[],
                const int& spread[])
{
   return(0);
}

//////////////////////////////////////////////////////////////////////////////////////////
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {   
  PLDialog.ChartEvent(id,lparam,dparam,sparam);
   double price1, price2, calculatedProfit, calculatedLot;
   datetime time1, time2;
   string objDes, objDesArr[3];
   
   // if moved line, calculate values
   if(id==CHARTEVENT_OBJECT_DRAG)
   {
      for(int i=0; i<lines; i++)
      {
         if(sparam==StringConcatenate("Profit_Line_",i))    // line moved
         {
            time1=(datetime)ObjectGetInteger(0,StringConcatenate("Profit_Line_",i), OBJPROP_TIME1);
            price1=ObjectGetDouble(0,StringConcatenate("Profit_Line_",i), OBJPROP_PRICE1);
            time2=(datetime)ObjectGetInteger(0,StringConcatenate("Profit_Line_",i), OBJPROP_TIME2);
            price2=ObjectGetDouble(0,StringConcatenate("Profit_Line_",i), OBJPROP_PRICE2);
         
            if(price1>price2)
               ObjectSetInteger(0,StringConcatenate("Profit_Value_",i), OBJPROP_ANCHOR, 0);
            else
               ObjectSetInteger(0,StringConcatenate("Profit_Value_",i), OBJPROP_ANCHOR, 2);
            
            ObjectSetInteger(0,StringConcatenate("Profit_Value_",i), OBJPROP_TIME, time2);
            ObjectSetDouble(0,StringConcatenate("Profit_Value_",i), OBJPROP_PRICE, price2);
            
            objDes=ObjectDescription(StringConcatenate("Profit_Line_",i));
            StringToLower(objDes);
            // split to find value
            string sep=" ";               
            ushort u_sep;                           
            u_sep=StringGetCharacter(sep,0);
            int k=StringSplit(objDes,u_sep,objDesArr);     // objDesArr[1] is set value ov Lot/profit
            
            if(MathAbs(price1-price2)==0)    // zero divide protectio
               price1+=Point;
            
            if(StringFind(objDes, "lot")>=0)    // if the description is lot calculate profit
            {        
               if(StringFind(objDes, "spread")>=0)
                  calculatedProfit=(MathAbs(price1-price2)/Point + MarketInfo(Symbol(), MODE_SPREAD))*MarketInfo(Symbol(), MODE_TICKVALUE)* StringToDouble(objDesArr[1]);
               else
                  calculatedProfit=(MathAbs(price1-price2)/Point)*MarketInfo(Symbol(), MODE_TICKVALUE)*StringToDouble(objDesArr[1]);   
                  
               ObjectSetText(StringConcatenate("Profit_Value_",i),StringConcatenate(DoubleToStr(calculatedProfit,2)," ",AccountCurrency()));
            }
            else if(StringFind(objDes, "profit")>=0)
            {
               if(StringFind(objDes, "spread")>=0)
                  calculatedLot=StringToDouble(objDesArr[1])/((MathAbs(price1-price2)/Point + MarketInfo(Symbol(), MODE_SPREAD))*MarketInfo(Symbol(), MODE_TICKVALUE));
               else
                  calculatedLot=StringToDouble(objDesArr[1])/((MathAbs(price1-price2)/Point)*MarketInfo(Symbol(), MODE_TICKVALUE));
                     
               ObjectSetText(StringConcatenate("Profit_Value_",i),StringConcatenate(DoubleToStr(calculatedLot,2)," Lot"));
            }
         }
      }
   } 
   
   // if deleted line delete value and vice versa
   if(id==CHARTEVENT_OBJECT_DELETE)
   {
      for(int i=0; i<lines; i++)
      {
         if(sparam==StringConcatenate("Profit_Line_",i))    // line deleted
            ObjectDelete(StringConcatenate("Profit_Value_",i));
         
         if(sparam==StringConcatenate("Profit_Value_",i))    // value deleted
            ObjectDelete(StringConcatenate("Profit_Line_",i));
      }
   } 
}

///////////////////////////////////////////////////////////
int FindFreeID()
{
   int i;
   for(i=0; i<lines; i++)
   {
      if(ObjectFind(StringConcatenate("Profit_Line_",i))<0)
         return(i);
   }
   return(i++);
}

///////////////////////////////////////////////////////////
int FindLastID()
{
   int i;
   for(i=lines-1; i>=0; i--)
   {
      if(ObjectFind(StringConcatenate("Profit_Line_",i))>=0)
         return(i);
   }
   return(-1);
}