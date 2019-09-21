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
print("Hello, World!")

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

  // switch SenseHat.stick.read()
  // {
  //   case .some(let key) : print(key)
  //                         if(key == .push)
  //                         {
  //                           print("exit")
  //                           SenseHat.display.clear()
  //                           keepGoing = false
  //                         }
  //   case .none          : print("no key")
  // }
}


// switch FS.readBytes(inFile: "/home/pi/workspace/test/Simple.swift", length: 16)
// {
//   case .some(let buffer) : print(buffer.count)
//                            print(buffer)
//   case .none             : print("boom")
// }



