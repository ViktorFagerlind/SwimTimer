//
//  TimerManager.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 27/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import UIKit

class TimerManager
{
  static var globalStartTime : NSTimeInterval = NSTimeInterval ()
  
  static var startTime  : NSTimeInterval?
  static let deltaTime  : NSTimeInterval = 5

  var swimmerTimers : [SwimmerTimer] = [SwimmerTimer]()
  
  var nofSwimmers: Int
  {
    get
    {
      return swimmerTimers.count
    }
  }
  
  func addSwimmer (name : String)
  {
    var swimmerTimer = SwimmerTimer (swimmerName: name)
    
    swimmerTimers.append(swimmerTimer)
  }
  
  func stopSwimmer (name : String)
  {
    var timer : SwimmerTimer? = findTimer (name)
    
    if (timer == nil)
    {
      return
    }
    
    timer!.stop ()
  }
  
  func fillCell (inout cell : SwimmerCellController, index : Int)
  {
    swimmerTimers[index].fillCell (&cell)
  }
  
  func start ()
  {
    TimerManager.startTime = NSDate.timeIntervalSinceReferenceDate ()
    
    for (i, timer) in enumerate (swimmerTimers)
    {
      timer.globalStart (NSTimeInterval (i) * TimerManager.deltaTime)
    }
  }
  
  func stopAll ()
  {
    for timer in swimmerTimers
    {
      timer.stop ()
    }
  }
  
  func stopNext ()
  {
    for timer in swimmerTimers
    {
      if (timer.state == .Running)
      {
        timer.stop ()
        return
      }
    }
  }
  
  func update ()
  {
    for timer in swimmerTimers
    {
      timer.update ()
    }
  }
  
  func findTimer (name : String) -> SwimmerTimer?
  {
    for timer in swimmerTimers
    {
      if (timer.name == name)
      {
        return timer
      }
    }
    return nil
  }
  
  func moveSwimmer (fromIndex: Int, toIndex: Int)
  {
    let timer = swimmerTimers[fromIndex]
    swimmerTimers.removeAtIndex (fromIndex)
    swimmerTimers.insert (timer, atIndex: toIndex)
  }
  
  static func timeToString (time: NSTimeInterval) -> String
  {
    //calculate the minutes in elapsed time.
    let minutes = UInt(time / 60.0)
    var elapsedTime = time - (NSTimeInterval(minutes) * 60)
    
    //calculate the seconds in elapsed time.
    let seconds = UInt(elapsedTime)
    elapsedTime -= NSTimeInterval(seconds)
    
    //find out the milliseconds to be displayed.
    let fraction = UInt(elapsedTime * 1000)
    
    //add the leading zero for minutes, seconds and millseconds and store them as string constants
    let strMinutes  = minutes  > 9 ? String(minutes): "0" + String(minutes)
    let strSeconds  = seconds  > 9 ? String(seconds): "0" + String(seconds)
    let strFraction =
      fraction > 9 ? (fraction > 99 ? String(fraction) :"0" + String(fraction)) :"00" + String(fraction)
    
    //concatenate minuets, seconds and milliseconds as assign it to the UILabel
    return "\(strMinutes):\(strSeconds):\(strFraction)"
  }
  
}

class SwimmerTimer
{
  enum State_E {case Idle, Waiting, Running}
  
  var name       : String
  var state     : State_E = .Idle
  var deltaTime  : NSTimeInterval!
  var resultTime : NSTimeInterval
  
  init (swimmerName : String)
  {
    name       = swimmerName
    resultTime = 0.0
  }
  
  func stateToString (state : State_E) -> String
  {
    switch (state)
    {
      case .Idle:
        return "Idle"
      
      case .Waiting:
        if (runningTime < -3.0)
        {
          return "Wait..."
        }
        if (runningTime < -2.0)
        {
          return "-3"
        }
        if (runningTime < -1.0)
        {
          return "-2"
        }
        if (runningTime < 0.0)
        {
          return "-1"
        }
        return "GO!"
      
      case .Running:
        if (runningTime < 1.0)
        {
          return "GO!"
        }
        return "Running"
    }
  }
  
  func fillCell (inout cell : SwimmerCellController)
  {
    // Don't show negatuve times
    var time : NSTimeInterval = runningTime
    time = time < 0.0 ? 0.0 : time
    cell.timeLabel.text   = TimerManager.timeToString (time)
    
    cell.nameLabel.text   = name
    cell.stateLabel.text = stateToString (state)
  }
  
  var runningTime: NSTimeInterval
  {
    get
    {
      if (state == .Idle)
      {
        return resultTime
      }
      
      return NSDate.timeIntervalSinceReferenceDate () - TimerManager.startTime! - deltaTime;
    }
  }
  
  func globalStart (swimmerDeltaTime : NSTimeInterval)
  {
    deltaTime = swimmerDeltaTime
    state = .Waiting
  }
  
  func update ()
  {
    if (state == .Idle)
    {
      return;
    }
    
    if (runningTime > 0.0)
    {
      state = .Running
    }
  }
  
  func stop ()
  {
    if (runningTime < 0.0)
    {
      resultTime = 0.0
    }
    else
    {
      resultTime = runningTime
    }
    
    state = .Idle
  }
  
}

