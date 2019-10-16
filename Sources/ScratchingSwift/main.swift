//
//  main.swift
//  SwiftScratch
//
//  Created by psksvp on 18/9/19.
//  Copyright © 2019 com.psksvp. All rights reserved.
//

import Foundation
import Common
import PythonKit
#if os(Linux) && arch(arm)
import PiHardwareInterface
import LinuxInput
import Robot
#else
import AppKit
#endif


func testScaling() -> Void
{
  let s = Math.NumericScaler(fromRange: 0...180, toRange: 145.0 ... 650.0)
  for g in 0...180
  {
    print("\(g) -> \(s[Double(g)])")
  }
}

#if os(Linux) && arch(arm)

func testMotorHat() -> Void
{
	var speed = 0
  let motorHat = Adafruit.MotorHat()
  let m1 = motorHat.motor(atPort: .m1)
  let m2 = motorHat.motor(atPort: .m2)
  let m3 = motorHat.motor(atPort: .m3)
  let m4 = motorHat.motor(atPort: .m4)
  var keepGoing = true
  while(keepGoing)
  {
    if let key = SenseHat.stick.read()
    {
      switch key
      {
        case .up, .right   : speed = speed + 5
      
				case .down, .left  : speed = speed - 5
        
				case .push         : speed = 0;
				                     keepGoing = false                          
      }
			
			m1.speed = speed
			m2.speed = speed
			m3.speed = speed
			m4.speed = speed
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
    if let key = SenseHat.stick.read(msTimeout: 5000)
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
    else
    {
      print("timeout..")
    }
  }
}


func readGPS() -> Void
{
  let s = SerialPort(path: "/dev/ttyUSB0")
  var c = 0
  while(c < 200)
  {
    if let l = s.readLine()
    {
      print(l)
    }
    else
    {
      print("boom")
    }
    c = c + 1
  }
}

func cJoystick() -> Void
{
  let js = joystickOpen("/dev/input/js0")
  print("axis count : \(joystickAxisCount(js))")
  print("button count : \(joystickButtonCount(js))")
  while(true)
  {
    let d = joystickRead(js, 5000)
    print(d)
    if d.valid == 0
    {
      break;
    }
  }
  joystickClose(js)
}

func swiftJoystick() -> Void
{
  let scl = Math.NumericScaler<Double>(fromRange: -32676...32676, toRange: 0...180)
  let js = Joystick(devicePath: "/dev/input/js0")
  let sh = Adafruit.ServoHat()
  let servo = sh.servo(channel: .ch15)
  var keepGoing = true
  while(keepGoing)
  {
    if let e = js.poll()
    {
      print(e)
      switch e
      {
        case .Button(let id, _) : keepGoing =  2 != id
                                  
        case .Axis(0, let v)    : servo.angle = Int(scl[Double(v)])
                                     
        case .Axis(1, let v)    : print(v)                                
                                     
        default                 : print("m")
      }
    }
  }
  
}

func testMacanum() -> Void
{
  let maxL = 100.0
  let sR = Math.NumericScaler<Double>(fromRange: -32676...32676, toRange: 0...(2 * Double.pi))
  let sV = Math.NumericScaler<Double>(fromRange: -32676...32676, toRange: -100...100)
  let js = Joystick(devicePath: "/dev/input/js0") 
  var keepGoing = true
  var x = 0.0
  var y = 0.0
  var r = 0.0
	
  let motorHat = Adafruit.MotorHat()
  let m1 = motorHat.motor(atPort: .m1)
  let m2 = motorHat.motor(atPort: .m2)
  let m3 = motorHat.motor(atPort: .m3)
  let m4 = motorHat.motor(atPort: .m4)
	let mcw = MecanumWheelsDriver(frontLeft: m1, frontRight: m2, rearLeft: m3, rearRight: m4)
  
  func read() -> Void
  {
    if let e = js.poll()
    {
      //print(e)
      switch e
      {
        case .Button(2, _)   : keepGoing = false
        case .Axis(0, let v) : x = -sV[Double(v)]
        case .Axis(1, let v) : y = -sV[Double(v)]
        case .Axis(3, let v) : r = -sV[Double(v)]
        default              : break
      }
    }
  }

  while(keepGoing)
  {
    read()
    mcw.move(vx: x, vy: y, vr: r)
  }
}

#endif


print("Hello, World!")

print(Python.version)
let sys = try Python.import("sys")

print("Python \(sys.version_info.major).\(sys.version_info.minor)")
print("Python Version: \(sys.version)")
print("Python Encoding: \(sys.getdefaultencoding().upper())")

ANSI.test()
 
testMacanum()
//testSenseHat()
//swiftJoystick()
//reportMouse()
//readGPS()
//testScaling()
//testMotorHat()
//testServo()




