package com.hendrix.processManager.core.interfaces
{
  public interface IProcessable
  {
    /**
     * stop proceesing the item
     */
    function stop():void;
    
    /**
     * process the item
     */
    function process($onComplete:Function = null, $onError:Function = null):void;
    
    /**
     * notify completion
     */
    function notifyComplete():void;
    
    /**
     * notify error
     */
    function notifyError():void;
  }
}