package com.hendrix.processManager.core.types
{ 
  public class SimpleProcess extends BaseProcess
  {
    
    /**
     * a simple process that implements <code>BaseProcess</code>, mimics a syncronous process
     * @see com.mreshet.mrProcessManager.core.types.BaseProcess
     * @see com.mreshet.mrProcessManager.core.interfaces.IProcess
     * @author Tomer Shalev
     */
    public function SimpleProcess($id:String = null, $priorityKey:Object = 10)
    {
      super($id, $priorityKey);
    }
    
    /**
     * @inheritDoc 
     */
    override public function process($onComplete:Function=null, $onError:Function=null):void
    {
      super.process($onComplete);
      
      trace("finished process ID: " + id + " , priority: " + priorityKey);
      
      notifyComplete();
    }
  }
}