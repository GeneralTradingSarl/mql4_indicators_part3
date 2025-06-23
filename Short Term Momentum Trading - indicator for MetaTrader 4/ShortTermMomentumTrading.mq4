

    #property copyright "REMOVED BY ME TO PROTECT THE REPUTATION OF THE PROGRAMMER"

    extern bool UseArrow = true;
    extern bool UseAlert = true;
    extern bool UseEmail = true;

    extern bool LMWA_On = true;
    extern int LMWA_ShortLength = 3;
    extern int LMWA_LongLength = 13;
    extern int LMWA_Price = 0;

    extern bool LF_On = true;
    extern double LF_Gamma = 0.85;
    extern int LF_Price = 0;

    extern bool CCI_On = true;
    extern int CCI_Length = 14;
    extern int CCI_Price = 0;
    extern int CCI_Threshold = 100;

    extern bool ADX_On = true;
    extern int ADX_Length = 14;
    extern int ADX_Price = 0;
    extern int ADX_Threshold = 20;

    int lastAlert, lastTime;

    //+------------------------------------------------------------------+
    //| expert initialization function                                   |
    //+------------------------------------------------------------------+
    int init()
    {
    //----

    //----
    return(0);
    }
    //+------------------------------------------------------------------+
    //| expert deinitialization function                                 |
    //+------------------------------------------------------------------+
    int deinit()
    {
    //----

    //----
    return(0);
    }
    //+------------------------------------------------------------------+
    //| expert start function                                            |
    //+------------------------------------------------------------------+
    int start()
    {
    //----

    if(CheckADX(1)==true || ADX_On==false)
    {
    if(CheckCCI(1)==true || CCI_On==false)
    {
    if(CheckLF(1)==true || LF_On==false)
    {
    // All standard conditions valid - checking LMWA
    if(lastAlert!=1 && (CheckLMWA(1)==true || LMWA_On==false) && lastTime<iTime(NULL,0,0))
    {
    lastAlert=1;
    lastTime=iTime(NULL,0,0);

    if(UseArrow==true) PlotSignal(1);
    if(UseAlert==true) SendAlert(1);
    if(UseEmail==true) SendEmail(1);
    }
    }
    }
    }
    if(CheckADX(-1)==true || ADX_On==false)
    {
    if(CheckCCI(-1)==true || CCI_On==false)
    {
    if(CheckLF(-1)==true || LF_On==false)
    {
    // All standard conditions valid - checking LMWA
    if(lastAlert!=-1 && (CheckLMWA(-1)==true || LMWA_On==false) && lastTime<iTime(NULL,0,0))
    {
    lastAlert=-1;
    lastTime=iTime(NULL,0,0);

    if(UseArrow==true) PlotSignal(-1);
    if(UseAlert==true) SendAlert(-1);
    if(UseEmail==true) SendEmail(-1);
    }
    }
    }
    }

    if(lastAlert==1 && CheckReset(1)==false) lastAlert=0;
    if(lastAlert==-1 && CheckReset(-1)==false) lastAlert=0;


    //----
    return(0);
    }
    //+------------------------------------------------------------------+

    bool CheckLMWA(int mode)
    {
    double lmwaS=iMA(NULL,0,LMWA_ShortLength,0,3,LMWA_Price,1);
    double lmwaSp=iMA(NULL,0,LMWA_ShortLength,0,3,LMWA_Price,2);
    double lmwaL=iMA(NULL,0,LMWA_LongLength,0,3,LMWA_Price,1);
    double lmwaLp=iMA(NULL,0,LMWA_LongLength,0,3,LMWA_Price,2);

    if(mode==1)
    {
    if(lmwaS>lmwaL && lmwaSp<lmwaLp)
    {
    // Long conditions valid
    return(true);
    }
    }
    else if(mode==-1)
    {
    if(lmwaS<lmwaL && lmwaSp>lmwaLp)
    {
    // Long conditions valid
    return(true);
    }
    }
    return(false);
    }

    bool CheckReset(int mode)
    {
    double lmwaS=iMA(NULL,0,LMWA_ShortLength,0,3,LMWA_Price,1);
    double lmwaL=iMA(NULL,0,LMWA_LongLength,0,3,LMWA_Price,1);

    if(mode==1)
    {
    if(lmwaS>lmwaL)
    {
    // Long conditions valid
    return(true);
    }
    }
    else if(mode==-1)
    {
    if(lmwaS<lmwaL)
    {
    // Long conditions valid
    return(true);
    }
    }
    return(false);
    }

    bool CheckADX(int mode)
    {
    double di_plus=iADX(NULL,0,ADX_Length,ADX_Price,MODE_PLUSDI,0);
    double di_minus=iADX(NULL,0,ADX_Length,ADX_Price,MODE_MINUSDI,0);

    if(mode==1)
    {
    if(di_plus>di_minus && di_plus>ADX_Threshold)
    {
    // Conditions for long ADX valid
    return(true);
    }
    }
    else if(mode==-1)
    {
    if(di_plus<di_minus && di_minus>ADX_Threshold)
    {
    // Conditions for short ADX valid
    return(true);
    }
    }
    return(false);
    }

    bool CheckCCI(int mode)
    {
    double cci=iCCI(NULL,0,CCI_Length,CCI_Price,0);

    if(mode==1 && cci>CCI_Threshold)
    {
    // CCI long conditions valid
    return(true);
    }
    else if(mode==-1 && cci<-CCI_Threshold)
    {
    // CCI short conditions valid
    return(true);
    }
    return(false);
    }

    bool CheckLF(int mode)
    {
    double lf=iCustom(NULL,0,"LaguerreFilter",LF_Gamma,LF_Price,0,0);

    if(mode==1)
    {
    if(Open[0]>lf)
    {
    // Laguerre conditions valid
    return(true);
    }
    }
    else if(mode==-1)
    {
    if(Open[0]<lf)
    {
    // Laguerre conditions valid
    return(true);
    }
    }
    return(false);
    }

    void PlotSignal(int mode)
    {
    if(mode>0)
    {
    ObjectCreate("Signal_"+iTime(NULL,0,0),OBJ_ARROW,0,iTime(NULL,0,0),Low[iLowest(NULL,0,MODE_LOW,3,0)]);
    ObjectSet("Signal_"+iTime(NULL,0,0),OBJPROP_ARROWCODE,172);
    ObjectSet("Signal_"+iTime(NULL,0,0),OBJPROP_COLOR,Lime);
    }
    else if(mode<0)
    {
    ObjectCreate("Signal_"+iTime(NULL,0,0),OBJ_ARROW,0,iTime(NULL,0,0),High[iHighest(NULL,0,MODE_HIGH,3,0)]);
    ObjectSet("Signal_"+iTime(NULL,0,0),OBJPROP_ARROWCODE,172);
    ObjectSet("Signal_"+iTime(NULL,0,0),OBJPROP_COLOR,White);
    ObjectSet("Signal_"+iTime(NULL,0,0),OBJPROP_COLOR,Red);
    }
    return(0);
    }

    void SendAlert(int mode)
    {
    if(mode==1)
    {
    Alert("Buy triggered on "+Symbol()+"/"+Period()+" at Level "+DoubleToStr(Close[0],5)+" ("+TimeToStr(TimeCurrent(),TIME_MINUTES)+")");
    return(0);
    }
    else if(mode==11)
    {
    Alert("Sell triggered on "+Symbol()+"/"+Period()+" at Level "+DoubleToStr(Close[0],5)+" ("+TimeToStr(TimeCurrent(),TIME_MINUTES)+")");
    return(0);
    }
    return(0);
    }

    void SendEmail(int mode)
    {
    if(mode==1)
    {
    SendMail("Long Trigger","Buy triggered on "+Symbol()+"/"+Period()+" at Level "+DoubleToStr(Close[0],5)+" ("+TimeToStr(TimeCurrent(),TIME_MINUTES)+")");
    return(0);
    }
    else if(mode==11)
    {
    Alert("Short trigger","Sell triggered on "+Symbol()+"/"+Period()+" at Level "+DoubleToStr(Close[0],5)+" ("+TimeToStr(TimeCurrent(),TIME_MINUTES)+")");
    return(0);
    }
    return(0);
    }

