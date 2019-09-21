import wiringPi
import Common

public class I2CBus
{
  private var fd  = Int32(-1)
  
  public init(deviceAddress: Int32)
  {
    fd = wiringPiI2CSetup(deviceAddress)
    if(-1 == fd)
    {
      Log.error("I2CBus.init fail to connect to device at address \(deviceAddress)")
    }
  }
  
  // r/w from/to byte
  public func read() -> UInt8
  {
    return UInt8(wiringPiI2CRead(fd))
  }
  
  public func write(data: UInt8) -> Void
  {
    wiringPiI2CWrite(fd, Int32(data))
  } 
  
  // r/w from/to byte at Reg
  public func readByte(register: Int32) -> UInt8
  {
    return UInt8(wiringPiI2CReadReg8(fd, register))
  }
  
  public func writeByte(register: Int32, data: UInt8) -> Void
  {
    wiringPiI2CWriteReg8(fd, register, Int32(data))
  }
  
  // r/w from/to word at Reg
  public func readWord(register: Int32) -> UInt16
  {
    return UInt16(wiringPiI2CReadReg16(fd, register))
  }

  public func writeWord(register: Int32, data: UInt16) -> Void
  {
    wiringPiI2CWriteReg16(fd, register, Int32(data))
  }
  
}