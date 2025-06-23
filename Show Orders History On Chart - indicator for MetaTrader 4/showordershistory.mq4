//+------------------------------------------------------------------+
//|                                            ShowOrdersHistory.mq4 |
//|                                              Copyright 2021, xk5 |
//|                                https://www.mql5.com/en/users/xk5 |
//+------------------------------------------------------------------+
#property copyright        "Copyright 2021, xk5"
#property version          "1.10"
#property link             "https://www.mql5.com/en/users/xk5"
#property indicator_chart_window
#property strict

#define NAMES              "OrdersHistory_"
#define EXIT_SUCCESSED     0
#define EXIT_FAILED        1

extern bool ShowHistoryOrders          = true;
extern bool ShowOpenOrders             = true;
extern bool ShowStopLosses             = true;
extern bool ShowTakeProfits            = true;
extern color BuyArrowColor             = clrBlue;
extern color SellArrowColor            = clrRed;
extern color CloseArrowColor           = clrGoldenrod;
extern color TakeProfitColor           = clrBlue;
extern color StopLossColor             = clrRed;
extern ENUM_LINE_STYLE ProfitLineStyle = STYLE_DASH;
extern ENUM_LINE_STYLE LossLineStyle   = STYLE_DOT;
extern int  MagicNumber                = 0;

static int orders_history[], orders_open[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
    return(INIT_SUCCEEDED);
}


//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    // Delete objects and array
    DeleteObjects(orders_history);
    DeleteObjects(orders_open);
}

//+------------------------------------------------------------------+
//| Custom indicator start function                                  |
//+------------------------------------------------------------------+
int start()
{
    // Delete objects and array
    DeleteObjects(orders_history);
    DeleteObjects(orders_open);

    // Show history orders
    if (ShowHistoryOrders)
    {
        FillingOrdersArray(orders_history, MODE_HISTORY, MagicNumber);
        ShowOrders(orders_history, MODE_HISTORY);
    }

    // Show open orders
    if (ShowOpenOrders)
    {
        FillingOrdersArray(orders_open, MODE_TRADES, MagicNumber);
        ShowOrders(orders_open, MODE_TRADES);
    }

    WindowRedraw();

    return(EXIT_SUCCESSED);
}


//+------------------------------------------------------------------+
//| Filling Orders Array function                                    |
//+------------------------------------------------------------------+
int FillingOrdersArray(int& orders[], int mode, int magic)
{
    int total = OrdersHistoryTotal();

    if (mode == MODE_TRADES)
        total = OrdersTotal();

    int i;
    for (i = 0; i < total; i++)
    {
        if (!OrderSelect(i, SELECT_BY_POS, mode))
        {
            Print("FillingOrdersArray(): failed. position: " + IntegerToString(i) + "; mode: " + IntegerToString(mode) + "; error #" + IntegerToString(GetLastError()));
            return (EXIT_FAILED);
        }
        if (OrderSymbol() != Symbol())
            continue;
        if (OrderType() >= 2)
            continue;
        switch (magic)
        {
        case  0:
            break;
        case -1:
            if (OrderMagicNumber() <= 0)
                continue;
            break;
        case -2:
            if (OrderMagicNumber() > 0)
                continue;
            break;
        default:
            if (OrderMagicNumber() != magic)
                continue;
            break;
        }
        ArrayResize(orders, ArraySize(orders) + 1);
        orders[ArraySize(orders) - 1] = OrderTicket();
    }

    return (EXIT_SUCCESSED);
}


//+------------------------------------------------------------------+
//| Show Orders function                                             |
//+------------------------------------------------------------------+
int ShowOrders(int& orders[], int mode)
{
    int i;
    for (i = 0; i < ArraySize(orders); i++)
    {
        if (!OrderSelect(orders[i], SELECT_BY_TICKET, mode))
        {
            Print("ShowOrders(): failed. orders: " + IntegerToString(orders[i]) + "; mode: " + IntegerToString(mode) + "; error #" + IntegerToString(GetLastError()));
            return (EXIT_FAILED);
        }
        color color1 = clrNONE;
        if (OrderType() == OP_BUY)
            color1 = BuyArrowColor;
        if (OrderType() == OP_SELL)
            color1 = SellArrowColor;
        DrawArrow(NAMES + IntegerToString(orders[i]) + "_Open", 1, OrderOpenTime(), OrderOpenPrice(), color1);
        if (OrderCloseTime() > 0)
        {
            DrawArrow(NAMES + IntegerToString(orders[i]) + "_Close", 3, OrderCloseTime(), OrderClosePrice(), CloseArrowColor);
            if (ShowStopLosses)
                DrawArrow(NAMES + IntegerToString(orders[i]) + "_StopLoss", 4, OrderOpenTime(), OrderStopLoss(), StopLossColor);
            if (ShowTakeProfits)
                DrawArrow(NAMES + IntegerToString(orders[i]) + "_TakeProfit", 4, OrderOpenTime(), OrderTakeProfit(), TakeProfitColor);
            if (OrderProfit() > 0.0)
                DrawTrend(NAMES + IntegerToString(orders[i]) + "_Line", OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderClosePrice(), ProfitLineStyle, 1, color1);
            else
                DrawTrend(NAMES + IntegerToString(orders[i]) + "_Line", OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderClosePrice(), LossLineStyle, 1, color1);
        }
        else
        {
            if (OrderProfit() > 0.0)
                DrawTrend(NAMES + IntegerToString(orders[i]) + "_Line", OrderOpenTime(), OrderOpenPrice(), TimeCurrent(), OrderClosePrice(), ProfitLineStyle, 1, color1);
            else
                DrawTrend(NAMES + IntegerToString(orders[i]) + "_Line", OrderOpenTime(), OrderOpenPrice(), TimeCurrent(), OrderClosePrice(), LossLineStyle, 1, color1);
        }
    }

    return (EXIT_SUCCESSED);
}


//+------------------------------------------------------------------+
//| Draw Arrow function                                              |
//+------------------------------------------------------------------+
void DrawArrow(string name, int arrowcode, datetime time1, double price1, color color1)
{
    ObjectCreate(name, OBJ_ARROW, 0, 0, 0);
    ObjectSet(name, OBJPROP_ARROWCODE, arrowcode);
    ObjectSet(name, OBJPROP_TIME1, time1);
    ObjectSet(name, OBJPROP_PRICE1, price1);
    ObjectSet(name, OBJPROP_COLOR, color1);
}


//+------------------------------------------------------------------+
//| Draw Trend function                                              |
//+------------------------------------------------------------------+
void DrawTrend(string name, datetime time1, double price1, datetime time2, double price2, double style, double width, color color1)
{
    ObjectCreate(name, OBJ_TREND, 0, 0, 0);
    ObjectSet(name, OBJPROP_STYLE, style);
    ObjectSet(name, OBJPROP_WIDTH, width);
    ObjectSet(name, OBJPROP_TIME1, time1);
    ObjectSet(name, OBJPROP_PRICE1, price1);
    ObjectSet(name, OBJPROP_TIME2, time2);
    ObjectSet(name, OBJPROP_PRICE2, price2);
    ObjectSet(name, OBJPROP_COLOR, color1);
    ObjectSet(name, OBJPROP_RAY, 0);
}


//+------------------------------------------------------------------+
//| Delete Objects function                                          |
//+------------------------------------------------------------------+
void DeleteObjects(int& orders[])
{
    int i;
    for (i = 0; i < ArraySize(orders); i++)
    {
        ObjectDelete(NAMES + IntegerToString(orders[i]) + "_Line");
        ObjectDelete(NAMES + IntegerToString(orders[i]) + "_StopLoss");
        ObjectDelete(NAMES + IntegerToString(orders[i]) + "_TakeProfit");
        ObjectDelete(NAMES + IntegerToString(orders[i]) + "_Open");
        ObjectDelete(NAMES + IntegerToString(orders[i]) + "_Close");
    }
    ArrayResize(orders, 0);
}


//+------------------------------------------------------------------+
