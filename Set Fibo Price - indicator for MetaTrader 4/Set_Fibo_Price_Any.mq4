//+------------------------------------------------------------------+
//|                                           Set_Fibo_Price_Any.mq4 |
//|                              Copyright © 2007, Eng. Waddah Attar |
//|                                          waddahattar@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright Waddah Attar"
#property link      "waddahattar@hotmail.com"
//----
#property indicator_chart_window
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   Comment("Set_Fibo_Price_Any");
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   int obj_total = ObjectsTotal();
   string name;
   for(int i = 0; i < obj_total; i++)
     {
       name = ObjectName(i);
       if(ObjectType(name) == OBJ_FIBO)
         {
          for(int j=0;j<32;j++)
            {
              if(GetLastError() != 0) 
                break;
              ObjectSetFiboDescription(name, j, DoubleToStr(ObjectGet(name, 
                                       OBJPROP_FIRSTLEVEL + j)*100, 1));
            }
         }
     }
   Comment("");
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int    obj_total = ObjectsTotal();
   string name,text;
   for(int i = 0; i < obj_total; i++)
     {
       name = ObjectName(i);
       if(ObjectType(name) == OBJ_FIBO)
         {
           for(int j = 0; j < 32; j++)
             {
               if(GetLastError() != 0) 
                 break;
               ObjectSetFiboDescription(name, j, "(" + DoubleToStr(ObjectGet(name,
                                        OBJPROP_FIRSTLEVEL+j)*100,1) + ")" + " - %$");
             }
         }
     }
//----   
   return(0);
  }
//+------------------------------------------------------------------+


