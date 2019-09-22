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
  let m2 = motorHat.motor(channel: 2)
  m2.power = 10
  var keepGoing = true
  while(keepGoing)
  {
    if let key = SenseHat.stick.read()
    {
      switch key
      {
        case .up    : m2.run(command: .forward)
        case .down  : m2.run(command: .reverse)
        case .right : m2.power = m2.power + 5
        case .left  : m2.power = m2.power - 5 
        case .push  : m2.run(command: .stop)
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


print("Hello, World!")
testScaling()




