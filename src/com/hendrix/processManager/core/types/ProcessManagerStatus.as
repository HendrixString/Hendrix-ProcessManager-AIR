package com.hendrix.processManager.core.types
{
  import com.hendrix.processManager.core.interfaces.IDisposable;
  
  //import net.atoran.as3.utils.Stdio;
  
  public class ProcessManagerStatus implements IDisposable
  {
    /**
     * <code>STATUS_READY</code> - represents a process manager that is not working, but is ready to start for first time.
     */
    public static var STATUS_READY:     String                        = "STATUS_READY";
    
    /**
     * <code>STATUS_WORKING</code> - represents a process manager that is currently working one process or more.
     */
    public static var STATUS_WORKING:   String                        = "STATUS_WORKING";
    
    /**
     * <code>STATUS_IDLE</code> - represents a process manager that is active but currently is not working any process.
     */
    public static var STATUS_IDLE:      String                        = "STATUS_IDLE";
    
    /**
     * <code>STATUS_PAUSE</code> - represents a process manager that is currently pausing or has paused.
     */
    public static var STATUS_PAUSE:     String                        = "STATUS_PAUSE";
    
    /**
     * <code>STATUS_STOP</code> - represents a process manager that has stopped and removed all of it's processes.
     */
    public static var STATUS_STOP:      String                        = "STATUS_STOP";
    
    public var flagTraceLog:            Boolean                       = true;
    
    public var numComplete:             uint                          = 0;
    public var numTotal:                uint                          = 0;
    
    private var _status:                String                        = null;
    
    private var _errors:                Vector.<ProcessManagerError>  = null;
    
    public function ProcessManagerStatus()
    {
      _errors = new Vector.<ProcessManagerError>();
      
      status  = STATUS_READY;
    }
    
    /**
     * @param error an error
     */
    public function addError(error:ProcessManagerError):void
    {
      _errors.push(error);
      
      //if(flagTraceLog)
      //trace(Stdio.sprintf("ProcessManager Error: code=%s, msg=%s, dataAux=%s", error.codeError, error.msgError, error.dataAux));
    }
    
    /**
     * errors description 
     */
    public function get errors():Vector.<ProcessManagerError>
    {
      return _errors;
    }
    
    /**
     * clean errors 
     */
    public function cleanErrors():void
    {
      _errors.length  = 0;
    }
    
    /**
     * @inheritDoc 
     */
    public function dispose():void
    {
      //if(flagTraceLog)
      //  trace(Stdio.sprintf("ProcessManager Dispose()"));
      
      cleanErrors();
      
      _errors = null;
    }
    
    public function get status():String { return _status; }
    public function set status(value:String):void
    {
      _status = value;
      
      //if(flagTraceLog)
      //  trace(Stdio.sprintf("ProcessManager new status: %s", _status));
    }
    
  }
  
}