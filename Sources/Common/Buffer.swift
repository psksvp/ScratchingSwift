
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

public class Buffer<T>
{
  private var buffer = [T]()
  private var maxSize:Int
  
  public var size: Int
  {
    get
    {
      return buffer.count
    }
  }
  
  public var empty: Bool
  {
    get
    {
      return buffer.isEmpty
    }
  }
  
  public var capacity: Int
  {
    get
    {
      return maxSize
    }
    
    set(newCap)
    {
      maxSize = newCap
    }
  }
  
  public init(capacity: Int = 100)
  {
    self.maxSize = capacity
  }
  
  
  public func consume() -> T?
  {
    if self.empty
    {
      Log.warn("\(self) consume() fail: buffer is empty")
      return nil
    }
    else
    {
      return buffer.removeFirst()
    }
  }
  
  public func consume(amount: Int) -> [T]?
  {
    if buffer.isEmpty
    {
      Log.warn("\(self) consume(\(amount)) fail: buffer is empty")
      return nil
    }
    else if amount >= buffer.count
    {
      Log.info("\(self) consume(\(amount)) buffer has \(buffer.count)")
      let r = [T](buffer)
      buffer.removeAll(keepingCapacity: true)
      return r
    }
    else
    {
      return [T](buffer[0 ..< amount])
    }
    
  }
  
  public func add(_ e: T) -> Void
  {
    if(buffer.count <= maxSize)
    {
      buffer.append(e)
    }
    else
    {
      Log.warn("\(self) add() fail: buffer is full. maxSize is \(maxSize)")
    }
  }
  
  public func add(_ e: [T]) -> Void
  {
    if(buffer.count + e.count <= maxSize)
    {
      buffer.append(contentsOf: e)
    }
    else
    {
      Log.warn("\(self) add() fail: buffer is full. maxSize is \(maxSize)")
    }
  }
  
}
