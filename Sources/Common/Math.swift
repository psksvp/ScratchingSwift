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

public class Math
{
  // fancy word type constrain.
  public class Scaler<T: FloatingPoint & Comparable> //where T : Numeric & Comparable
  {
    private var inRange:T
    private var outRange:T
    private var inMin:T
    private var inMax:T
    private var outMin:T
    private var outMax:T
    
    public init(fromRange: (min: T, max: T), toRange: (min: T, max: T))
    {
      inRange = fromRange.max - fromRange.min
      outRange = toRange.max - toRange.min
      inMin = fromRange.min
      inMax = fromRange.max
      outMin = toRange.min
      outMax = toRange.max
    }
    
    public subscript(value: T) -> T
    {
      if(value < inMin)
      {
        return outMin
      }
      else if(value > inMax)
      {
        return outMax
      }
      else
      {
        return (((value - inMin) * outRange) / inRange) + outMin
      }
    }
    
  }
  
  public class NumericScaler<T: FloatingPoint & Comparable>
  {
    private var fromRange: ClosedRange<T>
    private var toRange: ClosedRange<T> 
    private var fromRangeLength: T
    private var toRangeLength: T
    
    public init(fromRange: ClosedRange<T>, toRange: ClosedRange<T>)
    {
      self.fromRange = fromRange
      self.toRange = toRange
      fromRangeLength = fromRange.upperBound - fromRange.lowerBound
      toRangeLength = toRange.upperBound - toRange.lowerBound
    }
    
    public subscript(value: T) -> T
    {
      if(value < fromRange.lowerBound)
      {
        return toRange.lowerBound
      }
      else if(value > fromRange.upperBound)
      {
        return toRange.upperBound
      }
      else
      {
        return (value - fromRange.lowerBound) * toRangeLength / fromRangeLength + toRange.lowerBound
      }
    }
  }
}