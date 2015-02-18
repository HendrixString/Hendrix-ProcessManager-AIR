package com.hendrix.processManager
{
  import com.hendrix.collection.binaryHeap.BinaryHeap;
  import com.hendrix.collection.idCollection.IdCollection;
  import com.hendrix.collection.queue.IQueue;
  import com.hendrix.collection.queue.PriorityQueue;
  import com.hendrix.collection.queue.Queue;
  import com.hendrix.processManager.core.interfaces.IProcess;
  import com.hendrix.processManager.core.interfaces.IProcessManager;
  import com.hendrix.processManager.core.types.ProcessManagerError;
  import com.hendrix.processManager.core.types.ProcessManagerStatus;
  
  public class ProcessManager implements IProcessManager
  {
    public var onComplete:              Function                = null;
    public var onProgress:              Function                = null;
    public var onError:                 Function                = null;
    
    private var _sourceList:            Vector.<Object>         = null;
    private var _processesQueue:        IQueue                  = null;
    private var _finishedProcesses:     IdCollection            = null;
    private var _runningProcesses:      IdCollection            = null;
    private var _failedProcesses:       IdCollection            = null;
    
    private var _storeFinishedProcesses:Boolean                 = true;
    private var _numProcessesAtOnce:    Number                  = Number.POSITIVE_INFINITY;
    private var _status:                ProcessManagerStatus  = null;
    
    /**
     * <p>implements a process manager thru a common <code>IProcessManager</code> interface</p>
     * <p>Supports a <code>Priority Queue</code>, to make the best out of it set <code>numProcessesAtOnce=1</code> 
     * and <code>onProgress</code> to get processing done with ordering when this type of processing
     * is required.</p>
     * <p>When using a priority queue, finished processes are ofcourse stored at getFinishedProcesses() and sorted</p>
     * @param $withPriority instructs the process manager to use a <b>Priority Queue</b> or a <b>regular Queue</b>
     * @param $storeFinishedProcesses instructs the process manager to store references of finished processes in <code>this.finishedProcesses</code> list,
     *        set it <code>True</code> if you want to save memory
     * @see com.mreshet.mrProcessManager.core.interfaces.IProcessManager
     * @author Tomer Shalev
     */
    public function ProcessManager($withPriority:Boolean = false, $storeFinishedProcesses:Boolean = true)
    {
      _storeFinishedProcesses = $storeFinishedProcesses;
      
      if($withPriority) {
        _processesQueue       = new PriorityQueue("priorityKey", BinaryHeap.MAX_HEAP);
        _numProcessesAtOnce   = 1;
      }
      else
        _processesQueue       = new Queue();
      
      if(_storeFinishedProcesses)
        _finishedProcesses    = new IdCollection("id");
      
      _runningProcesses       = new IdCollection("id");
      _failedProcesses        = new IdCollection("id");
      
      _status                 = new ProcessManagerStatus();
      _status.status          = ProcessManagerStatus.STATUS_READY;
    }
    
    /**
     * @inheritDoc 
     */
    public function dispose():void
    {
      onComplete            = null;
      onProgress            = null;
      onError               = null;
      _sourceList           = null;
      
      _processesQueue.dispose();
      _processesQueue       = null;
      
      if(_storeFinishedProcesses) {
        _finishedProcesses.removeAll();
        _finishedProcesses  = null;
      }
      
      _runningProcesses.removeAll();
      _runningProcesses     = null;
      
      _status.dispose();
      _status               = null;
    }
    
    /**
     * @inheritDoc 
     */
    public function pause():void
    {
      if(isRunning())
        _status.status = ProcessManagerStatus.STATUS_PAUSE;
    }
    
    /**
     * @inheritDoc 
     */
    public function resume():void
    {
      if(isPaused()) {
        _status.status = ProcessManagerStatus.STATUS_IDLE;
        runNextProcess();
      }
    }
    
    /**
     * @inheritDoc 
     */
    public function start():void
    {
      if(isRunning()) {
        trace("ProcessManager.start():: is already working: WORKING or IDLE");
        return;
      }
      
      _status.status      = ProcessManagerStatus.STATUS_IDLE;
      
      runNextProcess();
    }
    
    /**
     * @inheritDoc 
     */
    public function retry():void
    {
      var numFailed:  uint      = _failedProcesses.count;
      
      var p:          IProcess  = null;
      
      while(_failedProcesses.count) {
        p                       = _failedProcesses.removeByIndex(0) as IProcess;
        
        enqueue(p);
      }
      
      resume();
    }
    
    /**
     * @inheritDoc 
     */
    public function stop():void
    {
      if(isReady())
        return;
      
      _status.status  = ProcessManagerStatus.STATUS_STOP;
      
      // here remove all processes
      
      var countRunningProcesses:uint = _runningProcesses.count;
      
      for (var ix:int = 0; ix < countRunningProcesses; ix++) 
      {
        (_runningProcesses.vec[ix] as IProcess).stop();
      }
      
      _runningProcesses.removeAll();
      _processesQueue.clear();
    }
    
    /**
     * @inheritDoc 
     */
    public function enqueue($element:IProcess):void
    {
      _processesQueue.enqueue($element);
      
      _status.numTotal += 1;
      
      if(isRunning())
        runNextProcess();
    }
    
    public function extractal2l():void
    {
      var qs:uint = _processesQueue.queueSize;
      
      for(var ix:uint = 0; ix < qs; ix++)
        _processesQueue.extractHighestElement();  
    }
    
    private function runNextProcess():void
    {
      var pp: IProcess  = null;
      
      if(canSpawnAnotherProcess() == false)
        return;
      
      pp                = _processesQueue.extractHighestElement() as IProcess;
      
      if(pp == null)
        return;
      
      _runningProcesses.add(pp); //
      
      // could be the case that all processes finished already by the time
      // the first process above finished.
      _status.status      = ProcessManagerStatus.STATUS_WORKING;
      
      pp.process(onProcessFinished, onProcessFailed);
      
      if(canSpawnAnotherProcess() == true)
        runNextProcess();
      
    }
    
    public function numProcesses():uint
    {
      return _processesQueue.queueSize;
    }
    
    private function canSpawnAnotherProcess():Boolean
    {
      if(isRunning() == false)
        return false;
      
      var countCurrentRunningProcesses: uint  = _runningProcesses.count;
      
      var count:                        uint  = Math.min(_numProcessesAtOnce - countCurrentRunningProcesses, _processesQueue.queueSize);
      
      return count;
    }
    
    public function set numProcessesAtOnce(value:int):  void  { _numProcessesAtOnce = value;  }
    public function get numProcessesAtOnce():           int   { return _numProcessesAtOnce;   }
    
    /**
     * @inheritDoc 
     */
    public function get status():                       ProcessManagerStatus  { return _status; }
    
    /**
     * @inheritDoc 
     */
    public function getFinishedProcesses():Vector.<Object>
    {
      return _finishedProcesses.vec as Vector.<Object>;
    }
    /**
     * @inheritDoc 
     */
    public function getFinishedProcess(id:String):IProcess
    {
      if(_finishedProcesses == null)
        return null;
      
      var process:  IProcess  = null;
      
      if(_finishedProcesses.hasById(id))
        process               = _finishedProcesses.getById(id) as IProcess;
      
      return process;
    }
    
    /**
     * @inheritDoc 
     */
    public function notifyComplete():void
    {
      if(onComplete is Function)
        onComplete(this);
    }
    
    /**
     * @inheritDoc 
     */
    public function notifyProgress(prcs: IProcess):void
    {
      if(onProgress is Function)
        onProgress(prcs.id);      
    }
    
    /**
     * @inheritDoc 
     */
    public function notifyError(res: ProcessManagerError):void
    {
      if(onError is Function)
        onError(res);
    }
    
    /**
     * indicates a process has failed 
     * @param $element The process that has failed
     */
    protected function onProcessFailed($element:IProcess):void
    {
      pause();
      
      _runningProcesses.removeById($element.id);
      _failedProcesses.add($element, false);
      
      var pme: ProcessManagerError = new ProcessManagerError("Process with ID: " + $element.id + " FAILED!!", ProcessManagerError.ERROR_FAILED_PROCESS, $element.id);
      
      _status.addError(pme);
      
      notifyError(pme);
    }
    
    /**
     * indicates a process has finished 
     * @param $element The process that has finished
     */
    protected function onProcessFinished($element:IProcess):void
    {
      //trace("finished processing process with id: " + $element.id + " and priority: " + $element.priorityKey);
      //returns sorted and tracks id if needed
      if(_storeFinishedProcesses)
        _finishedProcesses.add($element);
      
      _runningProcesses.remove($element);
      
      _status.numComplete += 1;
      
      // checks if pause or stop were pending
      if(isRunning() == false)
        return;
      
      // check completion
      if(_processesQueue.queueSize==0 && _runningProcesses.count==0) {
        _status.status = ProcessManagerStatus.STATUS_IDLE
        notifyComplete();
        return;
      }
      
      notifyProgress($element);   
      
      runNextProcess();
    }
    
    public function getFailedProcesses():Vector.<Object>
    {
      return _failedProcesses.vec;
    }
    
    
    /**
     * useful for making derivations of this class and making the enqueing in-House. 
     * @return 
     * 
     */   
    public function get sourceList():Vector.<Object>  { return _sourceList; }
    public function set sourceList(value:Vector.<Object>):void  { _sourceList = value;  }
    
    /**
     * @inheritDoc 
     */
    public function isIdle():Boolean
    {
      return (_status.status == ProcessManagerStatus.STATUS_IDLE);
    }
    
    /**
     * @inheritDoc 
     */
    public function isPaused():Boolean
    {
      return (_status.status == ProcessManagerStatus.STATUS_PAUSE);
    }
    
    /**
     * @inheritDoc 
     */
    public function isStopped():Boolean
    {
      return (_status.status == ProcessManagerStatus.STATUS_STOP);
    }
    
    /**
     * @inheritDoc 
     */
    public function isWorking():Boolean
    {
      return (_status.status == ProcessManagerStatus.STATUS_WORKING);
    }
    
    /**
     * @inheritDoc 
     */
    public function isRunning():Boolean
    {
      return (isWorking() || isIdle());
    }
    
    /**
     * @inheritDoc 
     */
    public function isReady():Boolean
    {
      return (_status.status == ProcessManagerStatus.STATUS_READY);
    }
    
  }
  
}