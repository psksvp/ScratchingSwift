
public class ANSI
{
  static let esc = "\u{001B}["
  static let black = 30
  static let red = 31
  static let green = 32
  static let yellow = 33
  static let blue = 34
  static let magenta = 35
  static let cyan = 36
  static let white = 37
  static let normal = 0
  static let bold = 1
  static let underline = 4
  static let blink = 5
  static let reverse = 7
  static let concealed = 8


  public class func setCursor(row:Int, col:Int) -> Void { print("\(esc)\(row);\(col)H")}
  public class func cursorUp(n:Int) -> Void { print("\(esc)\(n)A")}
  public class func cursorDown(n:Int) -> Void {print("\(esc)\(n)B")}
  public class func cursorForward(n:Int) -> Void {print("\(esc)\(n)C")}
  public class func cursorBackward(n:Int) -> Void {print("\(esc)\(n)D")}
  public class func clearScreen() -> Void {print("\(esc)2J")}
  public class func clearLine() -> Void {print("\(esc)K")}
  public class func setForegroundColor(c:Int) -> Void {print("\(esc)\(c)m")}
  public class func setBackgroundColor(c:Int) -> Void {print("\(esc)\(c + 10)m")}
  public class func setTextAttribute(a:Int) -> Void {print("\(esc)\(a)m")}
    
  public class func test() -> Void
  {
    clearScreen()
    setCursor(row: 10, col: 10)
    setForegroundColor(c: blue)
    print("HelloWorld")
  }
}
