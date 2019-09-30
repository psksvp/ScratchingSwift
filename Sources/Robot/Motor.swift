//
//  File.swift
//  
//
//  Created by psksvp on 27/9/19.
//

import Foundation

public protocol Motor
{
  public enum Command
  {
    case forward
    case reverse
    case stop
  }
  
  public var power: Int { get set }
  public var command: Command { get set }
}
