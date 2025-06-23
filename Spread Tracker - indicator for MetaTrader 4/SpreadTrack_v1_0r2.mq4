//+------------------------------------------------------------------------------------+
#define     _NAME_                  "SpreadTrack"
#define     _TITLE_                 "SpreadTrack (v1.0r2) - MetaTrader 4 Indicator"
#define     _ABSTRACT_              "OHLC History File Spread Tracker Indicator"
#property   copyright               "Copyright © 2013, Fernando M. I. Carreiro"
#property   link                    "mailto:fmi@carreiro.co.pt?subject=SpreadTrack"
#property   indicator_chart_window
#property   indicator_buffers       0
//+------------------------------------------------------------------------------------+
//                                  Please note that the TAB Size is based on 4, not 3
//+------------------------------------------------------------------------------------+


//+------------------------------------------------------------------------------------+
//  Indicator Includes and Library References
//+------------------------------------------------------------------------------------+

#include <WinUser32.mqh>

//--- Declare Function somestimes not present in the "WinUser32.mqh" header file
    #import "user32.dll"
    int RegisterWindowMessageA(string lpstring);


//--- Primary Indicator Settings
    extern string
        strPrimarySettings  = "--- Primary Indicator Settings ---"
    ;
    extern int
        intTimeframeHST     = 2
    ;


//---- Initialise OHLC History Chart File
    int
        intUnused[13]
    ,   intLastPosHST
    ,   intHandleHST    = EMPTY
    ;
    string
        strSymbol
    ,   strFileNameHST
    ,   strCopyright    = "(C)opyright 2003, MetaQuotes Software Corp."
    ;
    bool boolInitFileHST()
    {
        if ( intHandleHST > NULL )
        {
            FileFlush( intHandleHST );
            FileClose( intHandleHST );
        }

        strFileNameHST  = StringConcatenate( strSymbol, intTimeframeHST, ".hst" );
        intHandleHST    = FileOpenHistory( strFileNameHST, FILE_BIN|FILE_WRITE|FILE_SHARE_READ|FILE_SHARE_WRITE);

        if ( intHandleHST <= NULL ) return( false );

        FileWriteInteger(   intHandleHST, 400,              LONG_VALUE  );
        FileWriteString(    intHandleHST, strCopyright,     64          );
        FileWriteString(    intHandleHST, strSymbol,        12          );
        FileWriteInteger(   intHandleHST, intTimeframeHST,  LONG_VALUE  );
        FileWriteInteger(   intHandleHST, Digits,           LONG_VALUE  );
        FileWriteInteger(   intHandleHST, 0,                LONG_VALUE  );
        FileWriteInteger(   intHandleHST, 0,                LONG_VALUE  );
        FileWriteArray(     intHandleHST, intUnused,        0, 48       );
        FileFlush(          intHandleHST                                );

        intLastPosHST   = FileTell( intHandleHST );

        return( true );
    }


//---- Write/Save a OHLC Bar to History Chart File
    bool boolWriteFileHST(
            datetime dtTimeStamp,
            double dblOpen, double dblHigh,
            double dblLow,  double dblClose,
            double dblVolume )
    {
        if ( intHandleHST <= NULL ) return( false );

        FileSeek(           intHandleHST, intLastPosHST,    SEEK_SET        );
        FileWriteInteger(   intHandleHST, dtTimeStamp,      LONG_VALUE      );
        FileWriteDouble(    intHandleHST, dblOpen,          DOUBLE_VALUE    );
        FileWriteDouble(    intHandleHST, dblLow,           DOUBLE_VALUE    );
        FileWriteDouble(    intHandleHST, dblHigh,          DOUBLE_VALUE    );
        FileWriteDouble(    intHandleHST, dblClose,         DOUBLE_VALUE    );
        FileWriteDouble(    intHandleHST, dblVolume,        DOUBLE_VALUE    );
        FileFlush(          intHandleHST                                    );

        intLastPosHST   = FileTell( intHandleHST );

        return( true );
    }


//---- Process Tick Spread Data
    datetime
        dtTimeSpread    = NULL
    ;
    double
        dblOpenSpread   = EMPTY
    ,   dblHighSpread   = EMPTY
    ,   dblLowSpread    = EMPTY
    ,   dblCloseSpread  = EMPTY
    ,   dblVolumeSpread = NULL
    ;
    void voidProcessTickSpread(
            double dblSpread, bool boolBarNew, datetime dtTimeStamp )
    {
        if ( boolBarNew )
        {
            if ( dblVolumeSpread > NULL )
                boolWriteFileHST(
                    dtTimeSpread,   dblOpenSpread,  dblHighSpread,
                    dblLowSpread,   dblCloseSpread, dblVolumeSpread );

            dtTimeSpread    = dtTimeStamp;
            dblOpenSpread   = dblSpread;
            dblHighSpread   = dblSpread;
            dblLowSpread    = dblSpread;
            dblCloseSpread  = dblSpread;
            dblVolumeSpread = 1;
        }
        else
        {
            dblCloseSpread  = dblSpread;

            if ( dblSpread > dblHighSpread )    dblHighSpread   = dblSpread;
            if ( dblSpread < dblLowSpread )     dblLowSpread    = dblSpread;

            dblVolumeSpread++;
        }
    }


//---- Initialise Indicator Data other Properties
    int intMT4InternalMsg = NULL;
    int init()
    {
        // Set Number of Digits (Precision)
        IndicatorDigits( Digits );

        // Set Indicator Name
        IndicatorShortName( _NAME_ );

        // Get Current Symbol Name
        strSymbol = Symbol();

        // Define Internal Message Handle
        intMT4InternalMsg = RegisterWindowMessageA( "MetaTrader4_Internal_Message" );

        if ( boolInitFileHST() )
            Comment( StringConcatenate( _NAME_, ": ", strFileNameHST ) );
        else
            Comment( StringConcatenate( _NAME_, ": Disabled" ) );

        return( NULL );
    }


//---- Deinitialise Indicator Data other Properties
    int deinit()
    {
        if ( intHandleHST > 0 )
        {
            FileFlush( intHandleHST );
            FileClose( intHandleHST );
        }

        intHandleHST = EMPTY;

        Comment( "" );

        return( NULL );
    }


//---- Start Processing Data
    int intHandleWindow = NULL;
    int start()
    {
        // Check if File Handle is Valid
        if ( intHandleHST == EMPTY ) return( NULL );

        // Check current Spread Value
        double dblSpread = Ask - Bid;
        if ( dblSpread < 0 ) dblSpread = -dblSpread;    // Just in Case, Ask < Bid

        // Check for a New Bar open
        static  datetime    dtTimeStamp;    // TimeStamp for New Bar detection
                bool        boolBarNew;     // Consider if a New Bar Opening

        if ( dtTimeStamp    != Time[ 0 ] )  // Check Bar Time if New Bar
        {
            dtTimeStamp     = Time[ 0 ];    // Time Stamp of Bar Opening
            boolBarNew      = true;         // Tick is first on New Bar
        }
        else
            boolBarNew      = false;        // New Tick but not New Bar

        // Process the Data
        voidProcessTickSpread( dblSpread, boolBarNew, dtTimeStamp );

        Comment(
            StringConcatenate(
                _NAME_, ": ", DoubleToStr( dblSpread, Digits ),
                " ", strFileNameHST ) );

        if ( boolBarNew )
        {
            // Detect if Offline Chart is Open, Refresh in case chart is reopened
            intHandleWindow = WindowHandle( strSymbol, intTimeframeHST );

            // Refresh Offline Chart Window
            if ( intHandleWindow != NULL )
            {
                PostMessageA( intHandleWindow, WM_COMMAND, 33324, 0 );

                // Incoming tick for EAs on Offline Chart
                if ( intMT4InternalMsg != NULL )
                    PostMessageA( intHandleWindow, intMT4InternalMsg, 2, 1);
            }
        }

        return ( NULL );
    }


