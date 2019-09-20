//
//  FS.swift
//  SwiftScratch
//
//  Created by psksvp on 18/9/19.
//  Copyright © 2019 com.psksvp. All rights reserved.
//

import Foundation

public class FS
{
  public class func readText(fromLocalPath path:String) -> String?
  {
    do
    {
      let text = try String(contentsOf:URL(fileURLWithPath:path))
      return text
    }
    catch
    {
      return nil
    }
  }
  
  public class func writeText(inString text:String, toPath path:String) -> Void
  {
    do
    {
      try text.write(to: URL(fileURLWithPath: path),
             atomically: true,
               encoding: String.Encoding.utf8)
    }
    catch
    {
      Log.error("FS.writeText Fail -> \(path)")
    }
  }
  
  public class func contentsOfDirectory(_ path:String) -> [String]?
  {
    let fm = FileManager.default
    do
    {
      let contents = try fm.contentsOfDirectory(atPath: path)
      return contents
    }
    catch
    {
      Log.error("FS.contentsOfDirectory fail to get contents of path -> \(path)")
      return nil
    }
  }
  
  
  public class func writeBytes(inArray a:[UInt8], toPath path:String) -> Void
  {
    do
    {
      let data = Data(a)
      try data.write(to: URL(fileURLWithPath:path))
    }
    catch
    {
      Log.error("FS.writeBytes fail to write to file -> \(path)")
    }
  }
  
  public class func readBytes(inFile path: String) -> [UInt8]?
  {
    do
    {
       let data = try Data(contentsOf: URL(fileURLWithPath: path))
       return [UInt8](data)
    }
    catch
    {
      Log.error("FS.readBytes fail to read from file -> \(path)")
      return nil
    }
  }
  
  public class func readBytes(inFile path: String, length:Int) -> [UInt8]?
  {
    if let stream:InputStream = InputStream(fileAtPath: path)
    {
      var buffer = [UInt8](repeating: 0, count: length)
      stream.open()
      let l = stream.read(&buffer, maxLength: buffer.count) 
      stream.close()
      if -1 == l
      {
        Log.error("FS.readBytes fail to open file -> \(path)")
        return nil
      }
      else
      {
        return buffer
      }    
    }
    else
    {
      Log.error("FS.readBytes fail to open file -> \(path)")
      return nil
    }
  }

}
