import Foundation
import LinuxInput

public class Joystick
{
  public enum State
  {
    case pressed
    case released
  }
  
  public enum Event
  {
    case Button(id: Int32, state: State)
    case Axis(id: Int32, value: Int32)
  }
  
  public var numberOfButton: UInt32
  {
    get { return joystickButtonCount(fd) }
  }
  
  public var numberOfAxis: UInt32
  {
    get { return joystickAxisCount(fd) }
  }
  
  
  private let fd: Int32
  
  public init(devicePath: String)
  {
    self.fd = joystickOpen(devicePath)
  }
  
  deinit
  {
    joystickClose(fd)
  }
  
  public func poll(msTimeout: Int = 3000) -> Event?
  {
    let evtButton = joystickControlButtonConst()
    let evtAxis = joystickConteolAxisConst()
    let e = joystickRead(fd, 3000)
    if 1 == e.valid
    {
      switch e.type
      {
        case evtButton : return .Button(id: e.controlID,
                                     state: 1 == e.value ? .pressed : .released)
        case evtAxis   : return .Axis(id: e.controlID, value: e.value)
        
        default        : return nil
      }
    }
    else
    {
      return nil
    }
  }
}

