//
//  Log.swift
//  SwiftScratch
//
//  Created by psksvp on 18/9/19.
//  Copyright © 2019 com.psksvp. All rights reserved.
//

import Foundation

public class Log
{
  public class func error(_ msg:String) -> Void
  {
    print("Error: \(msg)")
  }
  
  public class func warn(_ msg:String) -> Void
  {
    print("warn: \(msg)")
  }
  
  public class func info(_ msg:String) -> Void
  {
   print("info: \(msg)")
  }
}
