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

//
//  SenseHAT.swift
//  SwiftScratch
//
//  Created by psksvp on 18/9/19.
//  Copyright © 2019 com.psksvp. All rights reserved.
//

#if os(Linux) && arch(arm)

import Foundation
import MPU9250
import Common

public class SenseHat
{
  public static let display = Display()
  public static let stick = Stick()
  public static let imu = IMU()
  
  //////////////////////////////////////////////
  public class IMU
  {
    public struct Values
    {
      public struct Vector
      {
        var roll: Double
        var pitch: Double
        var yaw: Double
        
        init(_ r: Double, _ p: Double, _ y: Double)
        {
          roll = r
          pitch = p
          yaw = y
        }
      }
      
      public var humidity: Double
      public var pressure: Double
      public var elevation: Double      // meter
      public var temperature: Double // c 
      // degree
      public var pose: Vector
      public var gyro: Vector
      public var accelerometer: Vector
      public var compass: Vector
      
      public var heading: (Degee: Double, Minute: Double)
      {
        get
        {
          let declinationDegree = 0.0
          let declinationMin = 6.0
          
          var headingRad = atan2(compass.pitch, compass.roll)
          let declination = (declinationDegree + declinationMin / 60.0) * (Double.pi / 180.0)
          headingRad += declination
          if(headingRad < 0)
          {
            headingRad += (2 * Double.pi)
          }

          if(headingRad >= 2 * Double.pi)
          {
            headingRad -= (2 * Double.pi)
          }
          
          let headingDeg = headingRad * 180.0 / Double.pi
          let degrees = floor(headingDeg)
          let minutes = round((headingDeg - degrees) * 60.0)
          return (degrees, minutes)
        }
      }
    }
    
    init()
    {
      MPU9250Start()
    }
    
    deinit
    {
      MPU9250Stop()
    }
    
    public func poll() -> Values?
    {
      let rawData = MPU9250Poll()
      if(1 == rawData.valid)
      {
        return Values(humidity: rawData.humidity,
                      pressure: rawData.pressure,
                      elevation: rawData.height,
                      temperature: rawData.temperature,
                      pose: Values.Vector(rawData.pose.roll, rawData.pose.pitch, rawData.pose.yaw),
                      gyro: Values.Vector(rawData.gyro.roll, rawData.gyro.pitch, rawData.gyro.yaw),
                      accelerometer: Values.Vector(rawData.accel.roll, rawData.accel.pitch, rawData.accel.yaw),
                      compass: Values.Vector(rawData.compass.roll, rawData.compass.pitch, rawData.compass.yaw))
      }
      else
      {
        return nil
      }
    }
  }
  
  //////////////////////////////////////////////
  public class Display
  {
    private let pixMap = [[[ 0,  1,  2,  3,  4,  5,  6,  7], // 0 degree
                           [ 8,  9, 10, 11, 12, 13, 14, 15],
                           [16, 17, 18, 19, 20, 21, 22, 23],
                           [24, 25, 26, 27, 28, 29, 30, 31],
                           [32, 33, 34, 35, 36, 37, 38, 39],
                           [40, 41, 42, 43, 44, 45, 46, 47],
                           [48, 49, 50, 51, 52, 53, 54, 55],
                           [56, 57, 58, 59, 60, 61, 62, 63]], // 90 degree
                          [[ 7, 15, 23, 31, 39, 47, 55, 63],
                           [ 6, 14, 22, 30, 38, 46, 54, 62],
                           [ 5, 13, 21, 29, 37, 45, 53, 61],
                           [ 4, 12, 20, 28, 36, 44, 52, 60],
                           [ 3, 11, 19, 27, 35, 43, 51, 59],
                           [ 2, 10, 18, 26, 34, 42, 50, 58],
                           [ 1,  9, 17, 25, 33, 41, 49, 57],
                           [ 0,  8, 16, 24, 32, 40, 48, 56]], 
                          [[63, 62, 61, 60, 59, 58, 57, 56], // 180 degree
                           [55, 54, 53, 52, 51, 50, 49, 48],
                           [47, 46, 45, 44, 43, 42, 41, 40],
                           [39, 38, 37, 36, 35, 34, 33, 32],
                           [31, 30, 29, 28, 27, 26, 25, 24],
                           [23, 22, 21, 20, 19, 18, 17, 16],
                           [15, 14, 13, 12, 11, 10,  9,  8],
                           [ 7,  6,  5,  4,  3,  2,  1,  0]],
                          [[56, 48, 40, 32, 24, 16,  8,  0], // 270 degree
                           [57, 49, 41, 33, 25, 17,  9,  1],
                           [58, 50, 42, 34, 26, 18, 10,  2],
                           [59, 51, 43, 35, 27, 19, 11,  3],
                           [60, 52, 44, 36, 28, 20, 12,  4],
                           [61, 53, 45, 37, 29, 21, 13,  5],
                           [62, 54, 46, 38, 30, 22, 14,  6],
                           [63, 55, 47, 39, 31, 23, 15,  7]]]
    
    
    //private let rotationMap = [0 : 0, 90 : 1, 180 : 2, 270 : 3]
    private var rotation = 0
    
    private let fbDir = "/sys/class/graphics"
    private var fbPath = ""
   
   // (2 * 8 * 8) 8x8 each is 2 bytes
    private var buffer = Array.init(repeating: UInt8(0), count: 128) 
    
    init()
    {
      switch FS.contentsOfDirectory(fbDir)
      {
        case .some(let contents) : for dir in contents
                                   {
                                     if(frameBuffer(dir))
                                     {
                                       fbPath = "/dev/" + dir
                                       Log.info("SenseHAT.Display.init found LED FB at path \(fbPath)")
                                       break
                                     }
                                   }
        
        case .none               : Log.error("SenseHAT.Display.init cannot find frame buffer RPi-Sense FB")
      }
    }
    
    private func frameBuffer(_ path:String) -> Bool
    {
      let nameFile = "\(fbDir)/\(path)/name"
      switch FS.readText(fromLocalPath: nameFile)
      {
        case .some(let text) : return "RPi-Sense FB" == text.trim()
        case .none           : return false
      }
      
    }
     
    public func update()
    {
      FS.writeBytes(inArray: buffer, toPath: fbPath)
    }
    
    public func clear()
    {
      for i in 0 ..< buffer.count
      {
        buffer[i] = 0
      }
      
      update()
    }
    
    public func setPixel(_ x:Int, _ y:Int, _ color:(Int, Int, Int), update redraw:Bool = false) -> Void
    {
      if (x >= 0 && x < 8 && y >= 0 && y < 8)
      {
        let offset = pixMap[rotation][y][x] * 2
        let (red, green, blue) = color
        let r = (red >> 3) & 0x1F
        let g = (green >> 2) & 0x3F
        let b = (blue >> 3) & 0x1F
        let pix16 = (r << 11) + (g << 5) + b
        buffer[offset] = UInt8(pix16 & 0xff)
        buffer[offset + 1] = UInt8((pix16 >> 8) & 0xff)
        if(redraw)
        {
          update()
        }
      }
      else
      {
        Log.error("SenseHAT.Display.setPixel \(x), \(y) are out of range (8x8)")
      }
      
    }
  } //class Display
  
  //////////////////////////////////////////////
  public class Stick
  {
    public enum Direction
    {
      case up
      case down
      case left
      case right
      case push
    }
    
    private let inputDevDir = "/sys/class/input"
    private var stickDevPath = ""
    
    init()
    {
      switch FS.contentsOfDirectory(inputDevDir)
      {
        case .some(let contents) : for dir in contents
                                   {
                                     if sitckDevice(atPath: dir)
                                     {
                                       stickDevPath = "/dev/input/\(dir)"
                                       Log.info("SenseHAT.Stick.init found stick at \(stickDevPath)")
                                       break
                                     }
                                   }
        case .none                : Log.error("SenseHAT.Stick.init could find stick device")
      }
    }
    
    private func sitckDevice(atPath dir: String) -> Bool
    {
      let fileName = "\(inputDevDir)/\(dir)/device/name"
      switch FS.readText(fromLocalPath: fileName)
      {
        case .some(let text) : return text.contains("Raspberry Pi Sense HAT Joystick")
        case .none           : return false
      }
    }
    
    public func read() -> Direction?
    {
      let codeMap:[UInt16 : Direction] = [103 : .up, 
                                          108 : .down,
                                          105 : .left, 
                                          106 : .right, 
                                          28  : .push]
      /*
       each input is 16 bytes.
       long,long,short,    short,  int
       time,time,inputType,keyCode,value
      */
      let evKey = UInt16(0x01)
      if let buffer = FS.readBytes(inFile: stickDevPath, length: 16)
      {
        let keyCode = Bits.twoUInt8ToUInt16(high: buffer[10], low: buffer[11])
        let inputType = Bits.twoUInt8ToUInt16(high: buffer[8], low: buffer[9])
        return evKey == inputType ? codeMap[keyCode] : nil
      } 
      else
      {
        return nil
      }
      
    }
  } // class Stick
} // class SenseHAT

#endif
