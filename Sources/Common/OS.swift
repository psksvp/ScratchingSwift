//
//  OS.swift
//  SwiftScratch
//
//  Created by psksvp on 18/9/19.
//  Copyright © 2019 com.psksvp. All rights reserved.
//

import Foundation

public class OS
{
  public class func spawn(_ args:[String]) -> [String]?
  {
    if args.isEmpty
    {
      return nil
    }
    else
    {
      let outputPipe = Pipe()
      let errorPipe = Pipe()
      let task = Process()
      task.executableURL = URL(fileURLWithPath: args[0])
      task.standardOutput = outputPipe
      task.standardError = errorPipe
      if(args.count > 1)
      {
        task.arguments = Array(args.dropFirst())
      }
      
      do 
      {
        try task.run()
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

        return [String(decoding: outputData, as: UTF8.self), 
                String(decoding: errorData, as: UTF8.self)]
      }
      catch
      {
        return nil
      }
    }
  }
}
