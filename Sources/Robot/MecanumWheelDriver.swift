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
 
public class MecanumWheelsDriver
{
  private var frontLeft: Motor
  private var frontRight: Motor
  private var rearLeft: Motor
  private var rearRight: Motor
  
  
  public init(frontLeft: Motor,
              frontRight: Motor,
              rearLeft:Motor,
              rearRight:Motor)
  {
    self.frontLeft  = frontLeft
    self.frontRight = frontRight
    self.rearLeft   = rearLeft
    self.rearRight  = rearRight
  }
    
  public func move(vx: Double, vy: Double, vr: Double) -> Void
  {
    let m1 = vy - vx + vr
    let m2 = vy + vx - vr
    let m3 = vy - vx - vr
    let m4 = vy + vx + vr
    let limit = Double(self.frontLeft.limit)
		print("limit = \(limit) \(m1) \(m2) \(m3) \(m4)")
		
  	frontLeft.speed = Int(m1)
  	frontRight.speed = Int(m2)
  	rearLeft.speed = Int(m3)
  	rearRight.speed = Int(m4)
      
			//     if let max = [m1, m2, m3, m4].max()
			//     {
			// if max != 0.0
			// {
			//       	let s1 = Int(m1 / (max * limit))
			//       	let s2 = Int(m2 / (max * limit))
			//       	let s3 = Int(m3 / (max * limit))
			//       	let s4 = Int(m4 / (max * limit))
			// 	print(s1, s2, s3, s4)
			//
			//       	frontLeft.speed = s1
			//       	frontRight.speed = s2
			//       	rearLeft.speed = s3
			//       	rearRight.speed = s4
			// }
			//     }
  }
  
  
}
