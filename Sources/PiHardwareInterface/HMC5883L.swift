/**
  * Created by psksvp@gmail.com on 3/12/17.
  * Based on https://bitbucket.org/thinkbowl/i2clibraries/src/037e6107a866eb6406fced4d0fbef197f2f131a0/i2c_hmc5883l.py?at=master&fileviewer=file-view-default
  */

#if os(Linux) && arch(arm)

import Glibc


class HMC5883L
{
  private let address:Int
  private let declinationDegree:Float
  private let declinationMin:Float
  private let gauss:Float
  private let declination:Float
  
  private let ConfigurationRegisterA :Int32 = 0x00
  private let ConfigurationRegisterB :Int32 = 0x01
  private let ModeRegister: Int32 = 0x02
  private let AxisXDataRegisterMSB :Int32 = 0x03
  private let AxisXDataRegisterLSB :Int32 = 0x04
  private let AxisZDataRegisterMSB :Int32 = 0x05
  private let AxisZDataRegisterLSB :Int32 = 0x06
  private let AxisYDataRegisterMSB :Int32 = 0x07
  private let AxisYDataRegisterLSB :Int32 = 0x08
  private let StatusRegister:UInt8 = 0x09
  private let IdentificationRegisterA:UInt8 = 0x10
  private let IdentificationRegisterB:UInt8 = 0x11
  private let IdentificationRegisterC:UInt8 = 0x12
  private let MeasurementContinuous:UInt8 = 0x00
  private let MeasurementSingleShot:UInt8 = 0x01
  private let MeasurementIdle:UInt8 = 0x03
  
  private let scaleMap = [0.88: (0x00, 0.73),
                          1.3 : (0x01, 0.92),
                          1.9 : (0x02, 1.22),
                          2.5 : (0x03, 1.52),
                          4.0 : (0x04, 2.27),
                          4.7 : (0x05, 2.56),
                          5.6 : (0x06, 3.03),
                          8.1 : (0x07, 4.35)]
                          
 
  private let i2c: I2CBus
  private let scaleReg: UInt8
  private let scale: Float
  
  init(address:Int=0x1e, declinationDegree:Float=0, declinationMin:Float=6, gauss:Float=1.3)
  {
    //guard i2c.isReachable(address) else { }
    self.address = address
    self.declinationDegree = declinationDegree
    self.declinationMin = declinationMin
    self.gauss = gauss
    self.declination = (declinationDegree + declinationMin / 60.0) * (Float.pi / 180.0)
    self.scaleReg = UInt8(0x01 << 5)
    self.scale = 0.92
    
    self.i2c = I2CBus(deviceAddress: Int32(address))
    i2c.writeByte(register: ConfigurationRegisterB, data: scaleReg);
    i2c.writeByte(register: ModeRegister, data: MeasurementContinuous)
  }
  
  func read() -> (x: Float, y: Float, z: Float)
  {
    let msbx = i2c.readByte(register: AxisXDataRegisterMSB)
    let lsbx = i2c.readByte(register: AxisXDataRegisterLSB)
    let msbz = i2c.readByte(register: AxisZDataRegisterMSB)
    let lsbz = i2c.readByte(register: AxisZDataRegisterLSB)
    let msby = i2c.readByte(register: AxisYDataRegisterMSB)
    let lsby = i2c.readByte(register: AxisYDataRegisterLSB)
    
    let magx:UInt16 = UInt16(msbx << 8 | lsbx & 0xff)
    let magz:UInt16 = UInt16(msbz << 8 | lsbz & 0xff)
    let magy:UInt16 = UInt16(msby << 8 | lsby & 0xff)
    return (Float(magx) * scale, Float(magy) * scale, Float(magz) * scale)
  }
  
  var  heading: (degree: Float, minute: Float)
  {
    get
    {
      let (x, y, _) = read()
      var headingRad = atan2(y, x)
      headingRad += declination
      if(headingRad < 0)
      {
        headingRad += (2 * Float.pi)
      }

      if(headingRad >= 2 * Float.pi)
      {
        headingRad -= (2 * Float.pi)
      }

      let headingDeg = headingRad * 180.0 / Float.pi
      let degrees = floor(headingDeg)
      let minutes = round((headingDeg - degrees) * 60.0)
      return (Float(degrees), Float(minutes))
    }
  } 
}

#endif
