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

#if os(Linux)

import Foundation
import LinuxInput

public class Joystick
{
  public enum State
  {
    case pressed
    case released
  }
  
  public enum Event
  {
    case Button(id: Int, state: State)
    case Axis(id: Int, value: Int)
  }
  
  public var numberOfButton: UInt32
  {
    get { return joystickButtonCount(fd) }
  }
  
  public var numberOfAxis: UInt32
  {
    get { return joystickAxisCount(fd) }
  }
  
  
  private let fd: Int32
  
  public init(devicePath: String)
  {
    self.fd = joystickOpen(devicePath)
  }
  
  deinit
  {
    joystickClose(fd)
  }
  
  public func poll(msTimeout: Int = 3000) -> Event?
  {
    let evtButton = joystickControlButtonConst()
    let evtAxis = joystickConteolAxisConst()
    let e = joystickRead(fd, 3000)
    if 1 == e.valid
    {
      switch e.type
      {
        case evtButton : return .Button(id: Int(e.controlID),
                                     state: 1 == e.value ? .pressed : .released)
                                     
        case evtAxis   : return .Axis(id: Int(e.controlID), value: Int(e.value))
        
        default        : return nil
      }
    }
    else
    {
      return nil
    }
  }
}

///////////////////////////////////////////////////////////////////
// class JoystickReader
// {
//   private let js: Joystick
//   private var keepRunning = true
//   private var axises = [Int]
//   private let looper = Thread
//                        {
//                          while keepRunning
//                          {
//
//                          }
//                        }
//
//
//
//   public init(joystick: Joystick)
//   {
//     self.js = joystick
//   }
//
//
// }




#endif

