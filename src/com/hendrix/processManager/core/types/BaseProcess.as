package com.hendrix.processManager.core.types
{
  import com.hendrix.processManager.core.interfaces.IProcess;
  
  /**
   * a base process that implements <code>IProcess</code>, helpful to make implementation of
   * an <code>IProcess</code> easy. programmer can implement <code>IProcess</code> directly without
   * this class
   * @see com.mreshet.mrProcessManager.core.interfaces.IProcess
   * @author Tomer Shalev
   */
  public class BaseProcess implements IProcess
  {
    protected var _onComplete:    Function = null;
    protected var _onError:       Function = null;
    protected var _priorityKey:   Object;
    protected var _id:            String;
    
    /**
     * a base process that implements <code>IProcess</code>, helpful to make implementation of
     * an <code>IProcess</code> easy. programmer can implement <code>IProcess</code> directly without
     * this class
     * @see com.mreshet.mrProcessManager.core.interfaces.IProcess
     * @author Tomer Shalev
     */
    public function BaseProcess($id:String = null, $priorityKey:Object = 10)
    {
      _id = $id;
      
      _priorityKey = $priorityKey;
    }
    
    /**
     * @inheritDoc 
     */
    public function process($onComplete:Function=null, $onError:Function=null):void
    {
      _onComplete = $onComplete;
      _onError    = $onError;
    }
    
    /**
     * @inheritDoc 
     */
    public function stop():void
    {
    }
    
    /**
     * @inheritDoc 
     */
    public function notifyComplete():void
    {
      if(_onComplete is Function)
        _onComplete(this);
    }
    
    /**
     * @inheritDoc 
     */
    public function notifyError():void
    {
      if(_onError is Function)
        _onError(this);
    }
    
    /**
     * @inheritDoc 
     */
    public function dispose():void
    {
      _onComplete = null;
    }
    
    /**
     * @inheritDoc 
     */
    public function get id():String
    {
      return _id;
    }
    
    /**
     * @inheritDoc 
     */
    public function set id(value:String):void
    {
      _id = value;
    }
    
    /**
     * @inheritDoc 
     */
    public function get priorityKey():Object
    {
      return _priorityKey;
    }
    
    /**
     * @inheritDoc 
     */
    public function set priorityKey(value:Object):void
    {
      _priorityKey = value;
    }
  }
}