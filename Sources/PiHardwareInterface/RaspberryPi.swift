import Common

public class RaspberryPi
{
  public static var cpuTemperature: Double 
  {
    get 
    {
      if let c = FS.readText(fromLocalPath: "/sys/class/thermal/thermal_zone0/temp")
      {
        let temp = Int(c.trim()) ?? -1
        return Double(temp) / 1000.0
      }
      else
      {
        return -1
      }
    }
  }
  
  public static var model: String
  {
    get
    {
      if let model = FS.readText(fromLocalPath: "/sys/firmware/devicetree/base/model")
      {
        return model
      }
      else
      {
        return ""
      }
    }
  }
}