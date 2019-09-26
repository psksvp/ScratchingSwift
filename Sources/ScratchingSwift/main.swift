//
//  main.swift
//  SwiftScratch
//
//  Created by psksvp on 18/9/19.
//  Copyright © 2019 com.psksvp. All rights reserved.
//

import Foundation
import Common
import PiHardwareInterface



func testScaling() -> Void
{
  let s = Math.NumericScaler(fromRange: 0...180, toRange: 145.0 ... 650.0)
  for g in 0...180
  {
    print("\(g) -> \(s[Double(g)])")
  }
}


func testMotorHat() -> Void
{
  let motorHat = Adafruit.MotorHat()
  let m1 = motorHat.motor(atPort: .m1)
  let m2 = motorHat.motor(atPort: .m2)
  let m3 = motorHat.motor(atPort: .m3)
  let m4 = motorHat.motor(atPort: .m4)
  m1.power = 30
  m2.power = 30
  m3.power = 30
  m4.power = 30
  var keepGoing = true
  while(keepGoing)
  {
    if let key = SenseHat.stick.read()
    {
      switch key
      {
        case .up    : 
          m1.run(command: .forward)
          m2.run(command: .forward)
          m3.run(command: .forward)
          m4.run(command: .forward)
        case .down  : 
          m1.run(command: .reverse)
          m2.run(command: .reverse)
          m3.run(command: .reverse)
          m4.run(command: .reverse)
        case .right :
          m1.power = m1.power + 5
          m2.power = m2.power + 5
          m3.power = m3.power + 5
          m4.power = m4.power + 5
        case .left  : 
          m1.power = m1.power - 5 
          m2.power = m2.power - 5 
          m3.power = m3.power - 5 
          m4.power = m4.power - 5 
        case .push  : 
          m1.run(command: .stop)
          m2.run(command: .stop)
          m3.run(command: .stop)
          m4.run(command: .stop)
          keepGoing = false                          
      }
    }
  }
}

func testSenseHat() -> Void
{
  var keepGoing = true
  var k = 0

  while(keepGoing)
  {
    let x = Int.random(in: 0 ..< 8)
    let y = Int.random(in: 0 ..< 8)
    let r = Int.random(in: 0 ..< 256)
    let g = Int.random(in: 0 ..< 256)
    let b = Int.random(in: 0 ..< 256)
    SenseHat.display.setPixel(x, y, (r, g, b), update:true)
  
    if let sensors = SenseHat.imu.poll()
    {
      print(sensors.heading)
    }
  
    print(RaspberryPi.cpuTemperature)
    print(RaspberryPi.model)
  
    if(k > 100)
    {
      SenseHat.display.clear()
      keepGoing = false
    }
    else
    {
      k = k + 1
    }
  }
}

func testServo() -> Void
{
  let sh = Adafruit.ServoHat()
  let servo = sh.servo(channel: .ch15)
  var keepGoing = true
  while(keepGoing)
  {
    if let key = SenseHat.stick.read()
    {
      switch key
      {
        case .up    : servo.angle = servo.angle + 5
        case .down  : servo.angle = servo.angle - 5
        case .right : servo.angle = servo.angle + 5
        case .left  : servo.angle = servo.angle - 5 
        case .push  : servo.angle = 90
                      keepGoing = false                          
      }
    }
  }
}


print("Hello, World!")
//testScaling()
testSenseHat()
testMotorHat()
//testServo()




