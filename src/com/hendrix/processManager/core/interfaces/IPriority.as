package com.hendrix.processManager.core.interfaces
{
  public interface IPriority
  {
    /**
     * Process priority
     */
    function get priorityKey():             Object;
    function set priorityKey(value:Object): void;
  }
}