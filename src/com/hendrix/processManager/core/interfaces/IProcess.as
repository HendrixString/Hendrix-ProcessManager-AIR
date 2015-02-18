package com.hendrix.processManager.core.interfaces
{
  /**
   * a common interface for processable elements
   * @author Tomer Shalev
   */
  public interface IProcess extends IId, IPriority, IProcessable, IDisposable
  {
  }
}