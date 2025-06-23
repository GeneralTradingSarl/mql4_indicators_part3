//+------------------------------------------------------------------+
//|                                                  TesterSpeed.mq4 |
//|                                Copyright © 2015, Zoltan Meszaros |
//+------------------------------------------------------------------+
#ifndef __VERSION
#define __VERSION   "1.00"
#endif

#property copyright "Copyright © 2015, Zoltan Meszaros"
#property version   __VERSION
#property strict
#property indicator_chart_window
#property description "Tester Speed Equalizer"
#property description "Metatrader Strategy Tester speed controler."
#property description " "
#property description "Requirement:"
#property description " - Checked \'Allow DLL imports\' before running the indicator."
#property indicator_plots 0
#property indicator_buffers 0
#property indicator_minimum 0.0
#property indicator_maximum 0.0

#import "kernel32.dll"
   int SleepEx(int dwMilliseconds, bool alert);
#import 

#define INDENT_LEFT     5
#define INDENT_TOP      5
#define INDENT_RIGHT    5
#define INDENT_BOTTOM   5
#define CONTROLS_GAP_X  10
#define CONTROLS_GAP_Y  10
#define EDIT_WIDTH      50
#define EDIT_HEIGHT     20
#define LABEL_WIDTH     90
#define LABEL_HEIGHT    20
#define BUTTON_WIDTH    80
#define BUTTON_HEIGHT   26
#define NUMBERS         "0123456789"
#define SHORTNAME       "Tester Speed Equalizer"

#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Edit.mqh>
#include <Controls\Label.mqh>
 
extern int Speed    = -1;  //Speed
extern int SkipTick = 0;   //Skip Tick
extern int Step     = 5;   //Step

//+------------------------------------------------------------------+
//| CPanelDialog                                                     |
//+------------------------------------------------------------------+
#ifndef __CPANELDIALOG
#define __CPANELDIALOG

class CPanelDialog : public CAppDialog
{
   private:
      int      m_step;
      int      m_skip;
      int      m_speed;
      bool     m_close;
      CEdit    m_edit1;
      CEdit    m_edit2;
      CLabel   m_label1;
      CLabel   m_label2;
      CButton  m_button1;
      CButton  m_button2UP;
      CButton  m_button2DOWN;
      CButton  m_button3UP;
      CButton  m_button3DOWN;
      bool CreateEdit(CEdit &_edit, const string _name, const int _x1, const int _y1, const int _x2, const int _y2, const bool _readOnly=false);
      bool CreateLabel(CLabel &_lbl, const string _name, const int _x1, const int _y1, const int _x2, const int _y2, const string _str, const int _fontSize, const int _clr);
      bool CreateButton(CButton &_button, const string _name, const int _x1, const int _y1, const int _x2, const int _y2, const string _str, const int _fontSize, const int _clr);
   public:
      CPanelDialog(void);
      ~CPanelDialog(void);
      void setup(int, int, int);
      int getSkip() const { return m_skip; }
      int getSpeed() const { return m_speed; }
      bool isClosed() const { return m_close; }
      virtual bool OnEvent(const int _id, const long &_lparam, const double &_dparam, const string &_sparam);
      virtual bool Create(const long _chart, const string _name, const int _subwin, const int _x1, const int _y1, const int _x2, const int _y2);
   protected:
      void setSkip(int);
      void setSpeed(int);
      bool CreateEdit1(void);
      bool CreateEdit2(void);
      bool CreateLabel1(void);
      bool CreateLabel2(void);
      bool CreateButton1(void);
      bool CreateButton2UP(void);
      bool CreateButton2DOWN(void);
      bool CreateButton3UP(void);
      bool CreateButton3DOWN(void);
      void OnClickButton1(void);
      void OnClickButton2UP(void);
      void OnClickButton2DOWN(void);
      void OnClickButton3UP(void);
      void OnClickButton3DOWN(void);
      virtual void OnClickButtonClose(void);
};

EVENT_MAP_BEGIN(CPanelDialog)
   ON_EVENT(ON_CLICK, m_button1, OnClickButton1)
   ON_EVENT(ON_CLICK, m_button2UP, OnClickButton2UP)
   ON_EVENT(ON_CLICK, m_button2DOWN, OnClickButton2DOWN)
   ON_EVENT(ON_CLICK, m_button3UP, OnClickButton3UP)
   ON_EVENT(ON_CLICK, m_button3DOWN, OnClickButton3DOWN)
EVENT_MAP_END(CAppDialog)

CPanelDialog::CPanelDialog(void)
{
   m_step = 0;
   m_skip = 0;
   m_speed = 0;
   m_close = false;
}

CPanelDialog::~CPanelDialog(void) { }

void CPanelDialog::setup(int _speed, int _skip, int _step)
{
   setSkip(_skip);
   setSpeed(_speed);
   m_step = (_step < 1 ? 1 : _step);
}

void CPanelDialog::setSpeed(int _speed)
{
   m_speed = _speed;
   m_edit1.Text(IntegerToString(_speed));
}

void CPanelDialog::setSkip(int _skip)
{
   m_skip = _skip;
   m_edit2.Text(IntegerToString(_skip));
}

bool CPanelDialog::Create(const long _chart, const string _name, const int _subwin, const int _x1, const int _y1, const int _x2, const int _y2)
{
   if(!CAppDialog::Create(_chart, _name, _subwin, _x1, _y1, _x2, _y2)) return(false);
   if(!CreateEdit1()) return(false);
   if(!CreateEdit2()) return(false);
   if(!CreateLabel1()) return(false);
   if(!CreateLabel2()) return(false);
   if(!CreateButton1()) return(false);
   if(!CreateButton2UP()) return(false);
   if(!CreateButton2DOWN()) return(false);
   if(!CreateButton3UP()) return(false);
   if(!CreateButton3DOWN()) return(false);
   return(true);
}

bool CPanelDialog::CreateEdit1(void)
{
   int x1 = INDENT_LEFT + LABEL_WIDTH + 22;
   int y1 = INDENT_TOP + 1;
   int x2 = x1 + EDIT_WIDTH;
   int y2 = y1 + EDIT_HEIGHT;

   return(CreateEdit(m_edit1, m_name+"Edit1", x1, y1, x2, y2));
}

bool CPanelDialog::CreateEdit2(void)
{
   int x1 = INDENT_LEFT + LABEL_WIDTH + 22;
   int y1 = INDENT_TOP + 25;
   int x2 = x1 + EDIT_WIDTH;
   int y2 = y1 + EDIT_HEIGHT;

   return(CreateEdit(m_edit2, m_name+"Edit2", x1, y1, x2, y2));
}

bool CPanelDialog::CreateLabel1(void)
{
   int x1 = INDENT_LEFT;
   int y1 = INDENT_TOP;
   int x2 = x1 + LABEL_WIDTH;
   int y2 = y1 + LABEL_HEIGHT;

   return(CreateLabel(m_label1, m_name+"Label1", x1, y1, x2, y2, "Speed:", 11, clrBlack));
}

bool CPanelDialog::CreateLabel2(void)
{
   int x1 = INDENT_LEFT;
   int y1 = INDENT_TOP + 23;
   int x2 = x1 + LABEL_WIDTH;
   int y2 = y1 + LABEL_HEIGHT;

   return(CreateLabel(m_label2, m_name+"Label2", x1, y1, x2, y2, "Skip Tick:", 11, clrBlack));
}

bool CPanelDialog::CreateButton1(void)
{
   int x1 = ((ClientAreaWidth() - BUTTON_WIDTH) / 2);
   int y1 = INDENT_TOP + 50;
   int x2 = x1 + BUTTON_WIDTH;
   int y2 = y1 + EDIT_HEIGHT;
   
   return(CreateButton(m_button1, m_name+"Button1", x1, y1, x2, y2, "Accept", 12, clrBlack));
}

bool CPanelDialog::CreateButton2UP(void)
{
   int x1 = INDENT_LEFT + LABEL_WIDTH + EDIT_WIDTH + 24;
   int y1 = INDENT_TOP + 2;
   int x2 = x1 + 20;
   int y2 = y1 + EDIT_HEIGHT - 2;
   
   return(CreateButton(m_button2UP, m_name+"Button2UP", x1, y1, x2, y2, ">", 14, clrBlack));
}

bool CPanelDialog::CreateButton2DOWN(void)
{
   int x1 = INDENT_LEFT + LABEL_WIDTH;
   int y1 = INDENT_TOP + 2;
   int x2 = x1 + 20;
   int y2 = y1 + EDIT_HEIGHT - 2;
   
   return(CreateButton(m_button2DOWN, m_name+"Button2DOWN", x1, y1, x2, y2, "<", 14, clrBlack));
}

bool CPanelDialog::CreateButton3UP(void)
{
   int x1 = INDENT_LEFT + LABEL_WIDTH + EDIT_WIDTH + 24;
   int y1 = INDENT_TOP + 26;
   int x2 = x1 + 20;
   int y2 = y1 + EDIT_HEIGHT - 2;
   
   return(CreateButton(m_button3UP, m_name+"Button3UP", x1, y1, x2, y2, ">", 14, clrBlack));
}

bool CPanelDialog::CreateButton3DOWN(void)
{
   int x1 = INDENT_LEFT + LABEL_WIDTH;
   int y1 = INDENT_TOP + 26;
   int x2 = x1 + 20;
   int y2 = y1 + EDIT_HEIGHT - 2;
   
   return(CreateButton(m_button3DOWN, m_name+"Button3DOWN", x1, y1, x2, y2, "<", 14, clrBlack));
}

bool CPanelDialog::CreateEdit(CEdit &_edit, const string _name, const int _x1, const int _y1, const int _x2, const int _y2, const bool _readOnly=false)
{
   if(!_edit.Create(m_chart_id, _name, m_subwin, _x1, _y1, _x2, _y2)) return(false);
   if(!_edit.ReadOnly(_readOnly)) return(false);
   if(!Add(_edit)) return(false);
   return(true);
}

bool CPanelDialog::CreateLabel(CLabel &_lbl, const string _name, const int _x1, const int _y1, const int _x2, const int _y2, const string _str, const int _fontSize, const int _clr)
{
   if(!_lbl.Create(m_chart_id, _name, m_subwin, _x1, _y1, _x2, _y2)) return(false);
   if(!_lbl.Text(_str)) return(false);
   if(!_lbl.FontSize(_fontSize)) return(false);
   if(!_lbl.Color(_clr)) return(false);
   if(!Add(_lbl)) return(false);
   return(true);
}

bool CPanelDialog::CreateButton(CButton &_button, const string _name, const int _x1, const int _y1, const int _x2, const int _y2, const string _str, const int _fontSize, const int _clr)
{
   if(!_button.Create(m_chart_id, _name, m_subwin, _x1, _y1, _x2, _y2)) return(false);
   if(!_button.Text(_str)) return(false);
   if(!_button.FontSize(_fontSize)) return(false);
   if(!_button.Color(_clr)) return(false);
   if(!Add(_button)) return(false);
   return(true);
}

void CPanelDialog::OnClickButtonClose(void)
{
   m_close = true;
   CAppDialog::OnClickButtonClose();
}

void CPanelDialog::OnClickButton1(void)
{
   if(stringIsDigit(m_edit1.Text()))
   {
      int speed = (int)StringToInteger(m_edit1.Text());
      if(speed < 0) setSpeed(speed);
      else setSpeed((-1)*speed);
   }
   else setSpeed(m_speed);
   if(stringIsDigit(m_edit2.Text()))
   {
      int skip = (int)StringToInteger(m_edit2.Text());
      if(skip > 0) setSkip(skip);
      else setSkip(0);
   }
   else setSkip(m_skip);
}

void CPanelDialog::OnClickButton2UP(void)
{
   if(stringIsDigit(m_edit1.Text()))
   {
      int speed = (int)StringToInteger(m_edit1.Text());
      speed += m_step;
      if(speed < 0) setSpeed(speed);
      else setSpeed(0);
   }
}

void CPanelDialog::OnClickButton2DOWN(void)
{
   if(stringIsDigit(m_edit1.Text()))
   {
      int speed = (int)StringToInteger(m_edit1.Text());
      speed -= m_step;
      setSpeed(speed);
   }
}

void CPanelDialog::OnClickButton3UP(void)
{
   if(stringIsDigit(m_edit2.Text()))
   {
      int skip = (int)StringToInteger(m_edit2.Text());
      skip += m_step;
      setSkip(skip);
   }
}

void CPanelDialog::OnClickButton3DOWN(void)
{
   if(stringIsDigit(m_edit2.Text()))
   {
      int skip = (int)StringToInteger(m_edit2.Text());
      skip -= m_step;
      if(skip > 0) setSkip(skip);
      else setSkip(0);
   }
}
#endif

CPanelDialog* ExtDialog = NULL;

int OnInit()
{
   IndicatorBuffers(0);
   IndicatorSetString(INDICATOR_SHORTNAME, SHORTNAME);
   
   if(!IsDllsAllowed())
   {
      Print("DLL call is not allowed! Indicator cannot run.");
      return(INIT_FAILED);
   }

   Speed = (-1) * MathAbs(Speed);
   ExtDialog = new CPanelDialog();
   if(CheckPointer(ExtDialog) == POINTER_INVALID) return(INIT_FAILED);
   if(!ExtDialog.Create(0, SHORTNAME, 0, 20, 20, 225, 130)) return(INIT_FAILED);
   if(!ExtDialog.Run()) return(INIT_FAILED);
   ExtDialog.setup(Speed, SkipTick, Step);

   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   if(CheckPointer(ExtDialog) == POINTER_DYNAMIC)
   {
      ExtDialog.Destroy(reason);
      delete ExtDialog;
      ExtDialog = NULL;
   }
   if(!IsTesting()) ChartIndicatorDelete(0, ChartWindowFind(), SHORTNAME);
}

int OnCalculate(const int rates_total,
                const int _prev_calculated,
                const datetime& _time[],
                const double& _open[],
                const double& _high[],
                const double& _low[],
                const double& _close[],
                const long& _tick_volume[],
                const long& _volume[],
                const int& _spread[])
{
   int skip = 0;
   int speed = 0;
   static int skipTick = 0;
   
   if(CheckPointer(ExtDialog) == POINTER_DYNAMIC)
   {
      skip = ExtDialog.getSkip();
      speed = MathAbs(ExtDialog.getSpeed());
      if(ExtDialog.isClosed()) OnDeinit(REASON_REMOVE);
   }
   
   if(skipTick < skip)
   {
      skipTick++;
      return(0);
   }
   skipTick = 0;
   if(speed > 0) SleepEx(speed, false);   
   return(rates_total);
}

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   if(CheckPointer(ExtDialog) == POINTER_DYNAMIC) ExtDialog.ChartEvent(id, lparam, dparam, sparam);
}

bool isDigit(string _number, bool _double=false)
{
   string numbers = (_double ? StringConcatenate(NUMBERS, ".") : NUMBERS);
   if(StringFind(numbers, StringSubstr(_number+" ", 0, 1)) < 0) return(false);
   return(true);
}

bool stringIsDigit(string _str, bool _double=false)
{
   bool result = true;
   StringReplace(_str, "-", "");
   string str = StringTrimLeft(StringTrimRight(_str));
   int lenght = StringLen(str);
   if(lenght < 1) return(false);
   for(int i = 0; i < lenght; i++)
   {
      if(!isDigit(StringSubstr(str, i, 1), _double))
      {
         result = false;
         break;
      }
   }
   return(result);
}