import CSFML


public class View
{
  private let window: OpaquePointer
  
  public var visible: Bool
  {
    get
    {
      return sfWindow_isOpen(window) == 1
    }
    
    set(isVisible)
    {
      if(isVisible)
      {
        sfWindow_display(window)
      }
      else
      {
        sfWindow_close(window)
      }
    }
  }
  
  
  public init(width w: UInt32, height h: UInt32, name: String)
  {
    let m = sfVideoMode(width: w, height: h, bitsPerPixel: 32)
    
    self.window = sfRenderWindow_create(m, name, sfResize.rawValue|sfClose.rawValue, nil)
  }
  
  deinit
  {
    sfWindow_destroy(window)
  }
  
  public func render() -> Void
  {
    sfWindow_display(window)
  }
  
  
  
}
