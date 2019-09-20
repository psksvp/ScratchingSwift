//
//  Bits.swift
//  SwiftScratch
//
//  Created by psksvp on 19/9/19.
//  Copyright © 2019 com.psksvp. All rights reserved.
//

import Foundation

public class Bits
{
  public class func twoUInt8ToUInt16(high: UInt8, low: UInt8) -> UInt16
  {
    return UInt16(((low & 0xFF) << 8) | (high & 0xFF))
  }
}
