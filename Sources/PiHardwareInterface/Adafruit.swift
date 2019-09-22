/*
 *  The BSD 3-Clause License
 *  Copyright (c) 2018. by Pongsak Suvanpong (psksvp@gmail.com)
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without modification,
 *  are permitted provided that the following conditions are met:
 *
 *  1. Redistributions of source code must retain the above copyright notice,
 *  this list of conditions and the following disclaimer.
 *
 *  2. Redistributions in binary form must reproduce the above copyright notice,
 *  this list of conditions and the following disclaimer in the documentation
 *  and/or other materials provided with the distribution.
 *
 *  3. Neither the name of the copyright holder nor the names of its contributors may
 *  be used to endorse or promote products derived from this software without
 *  specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 *  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 *  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 *  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * This information is provided for personal educational purposes only.
 *
 * The author does not guarantee the accuracy of this information.
 *
 * By using the provided information, libraries or software, you solely take the risks of damaging your hardwares.
 */

import Foundation 
import Common

public class Adafruit
{
  ////////////////////////////////////////////////////
  public class PWMI2CBus : I2CBus
  {
    /////////////////////////////////////////////////////
    private let kMode1       = Int32(0x00)
    private let kMode2       = Int32(0x01)
    private let kSubAddr1    = Int32(0x02)
    private let kSubAddr2    = Int32(0x04)
    private let kSumAddr3    = Int32(0x04)
    private let kPreScale    = Int32(0xFE)
    private let kOnLow       = Int32(0x06)
    private let kOnHigh      = Int32(0x07)
    private let kOffLow      = Int32(0x08)
    private let kOffHigh     = Int32(0x09)
    private let kAllOnLow    = Int32(0xFA)
    private let kAllOnHigh   = Int32(0xFB)
    private let kAllOffLow   = Int32(0xFC)
    private let kAllOffHigh  = Int32(0xFD)

    //Bits
    private let kSleep   = UInt8(0x10)
    private let kAllCall = UInt8(0x01)
    private let kInvert  = UInt8(0x10)
    private let kOutDrv  = UInt8(0x04)

    
    public init(frequency: Double, i2cAddress: Int)
    {
      super.init(deviceAddress: Int32(i2cAddress))
      sendToAllChannel(0, 0)
      writeByte(register: kMode2, data: kOutDrv)
      writeByte(register: kMode1, data: kAllCall)
      Thread.sleep(forTimeInterval: 5.0)
      let mode1 = readByte(register: kMode1) & ~kSleep
      writeByte(register: kMode1, data: mode1)
      Thread.sleep(forTimeInterval: 5.0)
      setFrequency(frequency)
    }
    
    
    public func setFrequency(_ freq: Double) -> Void
    {
      let prescale = floor((((25000000.0 / 4096.0) / freq ) - 1.0) + 0.5)
      let oldmode = readByte(register: kMode1)
      let newmode = (oldmode & 0x7F) | 0x10
      writeByte(register: kMode1, data: UInt8(newmode))
      writeByte(register: kPreScale, data: UInt8(prescale))
      writeByte(register: kMode1, data: oldmode)
      Thread.sleep(forTimeInterval: 5.0)
      writeByte(register: kMode1, data: UInt8(oldmode | 0x80))
    }
    
    public func send(_ channel: Int, _ on: Int, _ off: Int) -> Void
    {
      let f = Int32(4 * channel)
      writeByte(register: kOnLow +   f, data: UInt8(on & 0xff))
      writeByte(register: kOnHigh +  f, data: UInt8(on >> 8))
                                     
      writeByte(register: kOffLow +  f, data: UInt8(off & 0xff))
      writeByte(register: kOffHigh + f, data: UInt8(off >> 8))
    }
    
    public func sendToAllChannel(_ on:Int, _ off:Int) -> Void
    {
      writeByte(register: kAllOnLow,  data: UInt8(on & 0xFF))
      writeByte(register: kAllOnHigh, data: UInt8(on >> 8))
                                      
      writeByte(register: kAllOffLow, data: UInt8(off & 0xFF))
      writeByte(register: kAllOffHigh, data: UInt8(off >> 8))
    }
    
    public func setPin(_ pin: Int, _ value: Int) -> Void
    {
      switch value
      {
        case 0 : send(pin, 0, 4096)
        case 1 : send(pin, 4096, 0)
        default : Log.error("PWMI2C.setPin param value must be either 0 or 1")
      }
    }
  }
  
  ////////////////////////////////////////////////////
  public class MotorHat
  { 
    public enum Command
    {
      case forward
      case reverse
      case stop
    }
    
    public class DCMotor
    {
      private let channelConfig = [0 : (8, 9, 10),
                                   1 : (13, 12, 11),
                                   2 : (2, 3, 4),
                                   3 : (7, 6, 5)]
      private var pwmPin = 0
      private var in1Pin = 0
      private var in2Pin = 0
      private var powerState = 10
      private var motorHat:MotorHat 
      
      init(channel: Int, motorHat: MotorHat)
      {
        self.motorHat = motorHat
        if let (a, b, c) = channelConfig[channel]
        {
          pwmPin = a
          in2Pin = b
          in1Pin = c
        }
        else
        {
          Log.error("DCMotor.init channel must be between [0, 3]")
        }
      }
      
      public func run(command: Command) -> Void
      {
        switch command
        {
          case .forward : motorHat.pwmI2C.setPin(in2Pin, 0)
                          motorHat.pwmI2C.setPin(in1Pin, 1)
                          
          case .reverse : motorHat.pwmI2C.setPin(in1Pin, 0)
                          motorHat.pwmI2C.setPin(in2Pin, 1)
                          
          case .stop    : motorHat.pwmI2C.setPin(in2Pin, 0)
                          motorHat.pwmI2C.setPin(in1Pin, 0)                                   
        }
      }
      
      public func setPower(_ p: Int) -> Void
      { 
        motorHat.pwmI2C.send(pwmPin, 0, p.clamped(to: 0 ... 255) * 16)
      }
      
      public var power: Int 
      {
        get
        {
          return powerState
        }
        
        set(newPowerState)
        {
          if(newPowerState != powerState)
          {
            powerState = newPowerState.clamped(to: 0 ... 255)
            motorHat.pwmI2C.send(pwmPin, 0, powerState * 16)
          }
        }
      }
      
    } // class DCMotor
    
    private var pwmI2C: PWMI2CBus
    private var motors = [Int : DCMotor]()
    
    public init(address: Int = 0x60)
    {
      pwmI2C = PWMI2CBus(frequency: 1600.0, i2cAddress: address)
    }
    
    public func motor(channel: Int) -> DCMotor
    {
      if let m = motors[channel]
      {
        return m
      }
      else
      {
        let m = DCMotor(channel: channel, motorHat: self)
        motors[channel] = m
        return m
      }
    }
  }
  
  ///////////////////////
  public class ServoHat
  {
    public class RangedDevice
    {
      private var scaler: Math.NumericScaler<Double>
      private var channel: Int
      private var servoHat: ServoHat
      
       // unsure why raw range is 150 to 600, just copy from adafruit code
      init(channel:Int, servoHat: ServoHat, logicalRange: ClosedRange<Double>, rawRange: ClosedRange<Double> = 145.0 ... 650.0)
      {
        self.scaler = Math.NumericScaler<Double>(fromRange: logicalRange, toRange: rawRange)
        self.channel = channel
        self.servoHat = servoHat
      }
      
      public func set(value: Int) -> Void
      {
        let sc = scaler[Double(value)]
        servoHat.pwmI2C.send(channel, 0, Int(sc))
      }
      
    } // class RangedDevice
    
    public class Servo : RangedDevice
    {
      private var currentAngle = 0
      
      init(channel: Int, servoHat: ServoHat)
      {
        super.init(channel: channel, servoHat: servoHat, logicalRange: 0...180)
      }
      
      public var angle: Int
      {
        get
        {
          return currentAngle
        }
        
        set(newAngle)
        {
          if(currentAngle != newAngle)
          {
            currentAngle = newAngle
            super.set(value: newAngle)
          }
        }
      }
    } // class Servo
    
    private var pwmI2C: PWMI2CBus
    private var servos = [Int : Servo]()
    
    public init(address: Int = 0x40)
    {
      pwmI2C = PWMI2CBus(frequency: 60, i2cAddress: address)
    }
    
    public func servo(channel: Int) -> Servo
    {
      if let s = servos[channel]
      {
        return s
      }
      else
      {
        let s = Servo(channel: channel, servoHat: self)
        servos[channel] = s
        return s
      }
    }
  }
}