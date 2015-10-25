package com.hendrix.processManager.core.types
{
  public class ProcessManagerError
  {
    /**
     * <code>ERROR_FAILED_PROCESS</code> - represents a process that has failed.
     */
    public static var ERROR_FAILED_PROCESS:   String  = "ERROR_FAILED_PROCESS";
    
    /**
     * <code>NO_ERROR</code> - NO ERROR.
     */
    public static var NO_ERROR:               String  = "NO_ERROR";
    
    private var _msgError:                    String  = NO_ERROR;
    private var _codeError:                   String  = NO_ERROR;
    
    private var _dataAux:                     Object  = null;
    
    public function ProcessManagerError(codeError:String, msg:String, dataAux:Object = null)
    {
      _msgError   = msg;
      _codeError  = codeError;
      _dataAux    = dataAux;
    }
    
    public function setError(codeError:String, msg:String, dataAux:Object = null):void
    {
      _msgError   = msg;
      _codeError  = codeError;
      _dataAux    = dataAux;
    }
    
    /**
     * error description. 
     */
    public function get msgError():               String  { return _msgError;   }
    public function set msgError(value:String):   void    { _msgError = value;  }
    
    /**
     * error code. 
     */
    public function get codeError():              String  { return _codeError;  }
    public function set codeError(value:String):  void    { _codeError = value; }
    
    /**
     * auxilary data to pass along with the error, can be id or a process or whatever. 
     */
    public function get dataAux():                Object  { return _dataAux;    }
    public function set dataAux(value:Object):    void    { _dataAux = value;   }
    
    public function toString():String {
      return msgError + "::" + codeError + "::" + dataAux;
    }
    
  }
  
}