package com.hendrix.processManager.core.interfaces
{
  import com.hendrix.processManager.core.types.ProcessManagerError;
  import com.hendrix.processManager.core.types.ProcessManagerStatus;
  
  /**
   * Process manager interface
   * @author Tomer Shalev
   */ 
  public interface IProcessManager
  {
    /**
     *  pause the process manager 
     */
    function pause():void;
    
    /**
     * resume the process manager 
     */
    function resume():void;
    
    /**
     * start the process manager
     */
    function start():void;
    
    /**
     * Stop the process manager   
     */
    function stop():void;
    
    /**
     * retry failed processes   
     */
    function retry():void;
    
    /**
     * signals completion, or more specifically
     * when status went from <code>WORKING</code> into <code>IDLE</code>. 
     * 
     */
    function notifyComplete():void
    
    /**
     * signals progress 
     * 
     */
    function notifyProgress(prcs: IProcess):void
    
    /**
     * signals Error 
     */
    function notifyError(res: ProcessManagerError):void
    
    /**
     * enqueue a process into the priority queue 
     * @param $element A processable element
     * 
     */   
    function enqueue($element:IProcess):void;
    
    /**
     * get a finished process by it's id 
     * @param id <code>id</code> of the process.
     * @return the process
     * 
     */
    function getFinishedProcess(id:String):IProcess;
    
    /**
     * Set the number of processes that are processed at once.
     * defaults to 1 
     */
    function set numProcessesAtOnce(value:int):void;
    function get numProcessesAtOnce():int;
    
    /**
     * Get the processes that finished. if <code>numProcessesAtOnce</code> is set to 1, 
     * then vector is sorted for free if we use a priority queue. 
     * @return A vector of processable elements
     */
    function getFinishedProcesses():Vector.<Object>;
    
    /**
     * Get the processes that finished. if <code>numProcessesAtOnce</code> is set to 1, 
     * then vector is sorted for free if we use a priority queue. 
     * @return A vector of processable elements
     */
    function getFailedProcesses():Vector.<Object>;
    
    /**
     * @return The status object
     */
    function get status():ProcessManagerStatus;
    
    /**
     * dispose 
     */
    function dispose():void;
    
    /**
     * @return the number of processes 
     */
    function numProcesses():uint;
    
    /**
     * @return flag if process manager status is STATUS_STOP 
     */
    function isStopped():Boolean;
    
    /**
     * @return flag if process manager status is STATUS_PAUSE 
     */
    function isPaused():Boolean;
    
    /**
     * @return flag if process manager status is (STATUS_WORKING || STATUS_IDLE) 
     */
    function isRunning():Boolean;
    
    /**
     * @return flag if process manager status is STATUS_WORKING
     */
    function isWorking():Boolean;
    
    /**
     * @return flag if process manager status is STATUS_IDLE
     */
    function isIdle():Boolean;
    
    /**
     * @return flag if process manager status is STATUS_READY
     */
    function isReady():Boolean;
    
  }
  
}