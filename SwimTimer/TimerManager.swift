//
//  TimerManager.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 27/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import Foundation

class TimerManager
{
  static var globalStartTime : NSTimeInterval = NSTimeInterval ()
  
  static var startTime  : NSTimeInterval?
  static let countTime  : NSTimeInterval = 0.7

  var swimmerTimers : [[SwimmerTimer]] = [[SwimmerTimer]]()
  
  init ()
  {
    // Create an initial lane
    addLane ()
  }
  
  var nofSwimmers: Int
  {
    get
    {
      var total = 0
      for lane in swimmerTimers.enumerate ()
      {
        total += lane.element.count
      }
      
      return total
    }
  }
  
  var allStopped: Bool
    {
    get
    {
      for lane in swimmerTimers.enumerate ()
      {
        for timer in lane.element
        {
          if (timer.state != SwimmerTimer.State_E.Idle)
          {
            return false
          }
        }
      }
      return true
    }
  }
  
  var nofLanes: Int
  {
    get
    {
      return swimmerTimers.count
    }
  }
  
  func getNofSwimmers (lane : Int) -> Int
  {
    return swimmerTimers[lane].count
  }
  
  func addSwimmer (lane : Int, name : String)
  {
    let swimmerTimer = SwimmerTimer (swimmerName: name)
    
    swimmerTimers[lane].append(swimmerTimer)
  }
  
  func addLane ()
  {
    let lane : [SwimmerTimer] = [SwimmerTimer]()
    swimmerTimers.append (lane)
  }
  
  func deleteSwimmer (lane : Int, index : Int)
  {
    swimmerTimers[lane].removeAtIndex (index)
  }
  
  // Lane 0 cannot be deleted
  func deleteLane (lane : Int)
  {
    swimmerTimers[lane-1].appendContentsOf (swimmerTimers[lane])
    swimmerTimers.removeAtIndex(lane)
  }
  
  func stopSwimmer (name : String)
  {
    let timer : SwimmerTimer? = findTimer (name)
    
    if (timer == nil)
    {
      return
    }
    
    timer!.stop ()
  }
  
  func lapSwimmer (name : String)
  {
    let timer : SwimmerTimer? = findTimer (name)
    
    if (timer == nil)
    {
      return
    }
    
    timer!.lap ()
  }
  
  func fillSwimmerCells (lane : Int, index : Int, inout cell : SwimmerTimerController)
  {
    swimmerTimers[lane][index].fillCells (&cell)
  }
  
  func start ()
  {
    TimerManager.startTime = NSDate.timeIntervalSinceReferenceDate ()
    
    for lane in swimmerTimers
    {
      for (i, timer) in lane.enumerate ()
      {
        timer.globalStart (NSTimeInterval (i) * Double (SettingsManager.singleton.timeBetweenSwimmers))
      }
    }
  }
  
  func stopAll ()
  {
    for lane in swimmerTimers.enumerate ()
    {
      for timer in lane.element
      {
        timer.stop ()
      }
    }
  }
  
  func stopNext (lane : Int)
  {
    for timer in swimmerTimers[lane]
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
    for lane in swimmerTimers.enumerate ()
    {
      for timer in lane.element
      {
        timer.update ()
      }
    }
  }
  
  func findTimer (name : String) -> SwimmerTimer?
  {
    for lane in swimmerTimers.enumerate ()
    {
      for timer in lane.element
      {
        if (timer.name == name)
        {
          return timer
        }
      }
    }
    return nil
  }
  
  func moveSwimmer (fromLane: Int, fromIndex: Int, toLane: Int, toIndex: Int)
  {
    let timer = swimmerTimers[fromLane][fromIndex]
    swimmerTimers[fromLane].removeAtIndex (fromIndex)
    swimmerTimers[toLane].insert (timer, atIndex: toIndex)
  }
  
  static func timeToString (time: NSTimeInterval) -> String
  {
    //calculate the minutes in elapsed time.
    let minutes = UInt(time / 60.0)
    var elapsedTime = time - (NSTimeInterval(minutes) * 60)
    
    //calculate the seconds in elapsed time.
    let seconds = UInt(elapsedTime)
    elapsedTime -= NSTimeInterval(seconds)
    
    //find out the 1/100 seconds to be displayed.
    let fraction = UInt(elapsedTime * 100)
    
    //add the leading zero for minutes, seconds and millseconds and store them as string constants
    let strMinutes  = minutes  > 9 ? String(minutes): "0" + String(minutes)
    let strSeconds  = seconds  > 9 ? String(seconds): "0" + String(seconds)
    let strFraction =
    fraction <= 9 ? "0" + String(fraction) : String(fraction)
    
    //concatenate minuets, seconds and milliseconds as assign it to the UILabel
    return "\(strMinutes):\(strSeconds):\(strFraction)"
  }
  
}

class SwimmerTimer
{
  enum State_E {case Idle, Waiting, Running}
  
  var name              : String
  var state             : State_E = .Idle
  var deltaTime         : NSTimeInterval!
  var resultTime        : NSTimeInterval
  var lapTime           : NSTimeInterval
  var lastLapOccurance  : NSTimeInterval
  
  init (swimmerName : String)
  {
    name              = swimmerName
    resultTime        = 0.0
    lapTime           = 0.0
    lastLapOccurance  = 0.0
  }
  
  func stateToString (state : State_E) -> String
  {
    switch (state)
    {
      case .Idle:
        return "Idle"
      
      case .Waiting:
        if (runningTime < -3.0 * TimerManager.countTime)
        {
          return "Wait..."
        }
        if (runningTime < 0.0)
        {
          return "\(Int((-runningTime)/TimerManager.countTime + 1.0))"
        }
        return "GO!"
      
      case .Running:
        if (runningTime < TimerManager.countTime)
        {
          return "GO!"
        }
        return "Going"
    }
  }
  
  func fillCells (inout cell : SwimmerTimerController)
  {
    // Don't show negative times
    let time = state == .Idle ? resultTime : (state == .Waiting ? 0.0 : runningTime)
    
    cell.timeLabel.text   = TimerManager.timeToString (time)
    cell.lapLabel.text    = TimerManager.timeToString (lapTime)
    
    cell.nameLabel.text   = name
    cell.stateLabel.text  = stateToString (state)
    
    cell.stopButton.enabled = state == .Running
    cell.lapButton.enabled  = state == .Running
  }
  
  var runningTime: NSTimeInterval
  {
    get
    {
      return NSDate.timeIntervalSinceReferenceDate () - TimerManager.startTime! - deltaTime;
    }
  }
  
  func globalStart (swimmerDeltaTime : NSTimeInterval)
  {
    deltaTime = swimmerDeltaTime
    state = .Waiting
    
    lapTime           = 0.0
    lastLapOccurance  = 0.0
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
    if (state == .Idle)
    {
      return
    }
    
    state = .Idle
    
    resultTime  = max (0.0, runningTime)
  }
  
  func lap ()
  {
    if (state != .Running)
    {
      return
    }
    
    let tmpLap : NSTimeInterval = runningTime - lastLapOccurance
    
    lastLapOccurance = runningTime
    
    if ( tmpLap < 0.0)
    {
      lapTime = 0.0
    }
    else
    {
      lapTime = tmpLap
    }
  }
  
}

