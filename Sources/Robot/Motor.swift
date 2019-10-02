//
//  Motor.swift
//  
//
//  Created by psksvp on 27/9/19.
//

import Foundation


public enum MotorCommand
{
  case forward
  case reverse
  case stop
}

public protocol Motor
{
  var power: Int { get set }
  var command: MotorCommand { get set }
}


