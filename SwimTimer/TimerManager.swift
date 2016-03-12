//
//  TimerManager.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 27/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import UIKit
//import YamlSwift

extension NSTimeInterval
{
  func toString () -> String
  {
    // Erroneous time?
    if self.isInvalid ()
    {
      return "--:--:--"
    }
    
    //calculate the minutes in elapsed time.
    let minutes = UInt(self / 60.0)
    var elapsedTime = self - (NSTimeInterval(minutes) * 60)
    
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
  
  static func fromString (timeString: String) -> NSTimeInterval
  {
    let minutes  : String = (timeString.substringWithRange(Range (start: timeString.startIndex,               end: timeString.startIndex.advancedBy(2))))
    let seconds  : String = (timeString.substringWithRange(Range (start: timeString.startIndex.advancedBy(3), end: timeString.startIndex.advancedBy(5))))
    let hundreds : String = (timeString.substringWithRange(Range (start: timeString.startIndex.advancedBy(6), end: timeString.startIndex.advancedBy(8))))

    return 60.0 * NSTimeInterval (minutes)! + NSTimeInterval (seconds)! + NSTimeInterval (hundreds)!/100.0
  }
  
  func isInvalid () -> Bool
  {
    return self < 0.0
  }
  
  static func invalidTime () -> NSTimeInterval
  {
    return -1.0
  }
}

class TimerManager
{
  static var globalStartTime : NSTimeInterval = NSTimeInterval ()
  
  static var startTime  : NSTimeInterval?
  static let countTime  : NSTimeInterval = 0.7

  var swimmerTimers : [[SwimmerTimer]] = [[SwimmerTimer]]()
  
  var ongoingInterval : Interval?
  var ongoingSession  : Session?
  
  let filename = "timer.json"
  
  init ()
  {
    ongoingInterval = nil
    ongoingSession  = nil
    
    if !loadFromJson ()
    {
      addLane ()
      addLane ()
      
      for i in 0...7
      {
        addSwimmer (i%2, swimmer: SwimmerManager.singleton.getSwimmer (i))
      }
    }
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
  
  var isRunning: Bool
    {
    get
    {
      for lane in swimmerTimers.enumerate ()
      {
        for timer in lane.element
        {
          if (timer.state != SwimmerTimer.State_E.Idle)
          {
            return true
          }
        }
      }
      return false
    }
  }
  
  func startSession (name : String, dateTime : String) -> Void
  {
    ongoingSession = Session (name: name, dateTime: dateTime)
    
    for lane in swimmerTimers
    {
      for st in lane
      {
        ongoingSession!.addMailAddress (st.swimmer.mail)
      }
    }
    
    ResultsManager.singleton.addSession (ongoingSession!)
  }
  
  func stopSession (save : Bool) -> Void
  {
    if !save && ongoingSession != nil
    {
      ResultsManager.singleton.removeLastSession ()
    }
    
    ongoingSession = nil
  }
  
  var isInSession: Bool
  {
    get
    {
      return ongoingSession != nil
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
  
  func addSwimmer (lane : Int, swimmer : Swimmer)
  {
    let swimmerTimer = SwimmerTimer (swimmer: swimmer)
    
    swimmerTimers[lane].append (swimmerTimer)
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
    
    ongoingInterval = Interval ()
    
    for lane in swimmerTimers
    {
      for (i, timer) in lane.enumerate ()
      {
        timer.globalStart (NSTimeInterval (i) * Double (SettingsManager.singleton.timeBetweenSwimmers), ongoingInterval: ongoingInterval)
      }
    }
  }
  
  func stopSwimmer (name : String)
  {
    let timer : SwimmerTimer? = findTimer (name)
    
    if (timer == nil)
    {
      return
    }
    
    timer!.stop ()
    
    if !isRunning
    {
      onAllStopped ()
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
    onAllStopped ()
  }
  
  func onAllStopped ()
  {
    if (ongoingInterval != nil)
    {
      ongoingInterval?.fixMissingLaps ()
      ongoingSession?.addInterval (ongoingInterval!)
    }
    
    ongoingInterval = nil
  }
  
  
  func findNextInTurn (lane : Int) -> SwimmerTimer?
  {
    let timerLane = swimmerTimers[lane]
    
    if swimmerTimers.count == 0
    {
      return nil
    }
    
    var indexOfSmallestLastLap : Int = 0
    var smallestLastLap : NSTimeInterval = timerLane[0].lastLapOccurance + timerLane[0].deltaTime
    
    for i in 1...(timerLane.count-1)
    {
      let timer = timerLane[i]
      
      if (timer.state == .Running && (timer.lastLapOccurance + timer.deltaTime) < smallestLastLap)
      {
        indexOfSmallestLastLap = i
        smallestLastLap = timer.lastLapOccurance + timer.deltaTime
      }
    }
    return timerLane[indexOfSmallestLastLap]
  }
  
  func lapNext (lane : Int)
  {
    let nextInTurn = findNextInTurn (lane)
    
    if nextInTurn != nil
    {
      nextInTurn!.lap ()
    }
  }
  
  func stopNext (lane : Int)
  {
    let timer : SwimmerTimer? = findNextInTurn (lane)
    
    if (timer == nil)
    {
      return
    }
    
    timer!.stop ()
    
    if !isRunning
    {
      onAllStopped ()
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
        if (timer.swimmer.name == name)
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
  /*
  static func timeToString (time: NSTimeInterval) -> String
  {
    // Erroneous time?
    if time < 0.0
    {
      return "--:--:--"
    }
    
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
  
  static func stringToTime (timeString: String) -> NSTimeInterval
  {
    let minutes  : String = (timeString.substringWithRange(Range (start: timeString.startIndex,               end: timeString.startIndex.advancedBy(2))))
    let seconds  : String = (timeString.substringWithRange(Range (start: timeString.startIndex.advancedBy(3), end: timeString.startIndex.advancedBy(5))))
    let hundreds : String = (timeString.substringWithRange(Range (start: timeString.startIndex.advancedBy(6), end: timeString.startIndex.advancedBy(8))))
    
    return 60.0 * NSTimeInterval (minutes)! + NSTimeInterval (seconds)! + NSTimeInterval (hundreds)!/100.0
  }
  */
  func saveToJson () -> Bool
  {
    var fileContents : String = "{\n  \"lanes\":\n  [\n"
    
    for (i,lane) in swimmerTimers.enumerate ()
    {
      fileContents   += "    {\"lane\":["
      for (j,timer) in lane.enumerate ()
      {
        fileContents += "{\"name\": \"\(timer.swimmer.name)\"}"
        
        if j != (lane.count - 1)
        {
          fileContents += ", "
        }
      }
      fileContents   += "]}"
      
      if i != (lane.count - 1)
      {
        fileContents += ","
      }
      fileContents   += "\n"
    }
    
    fileContents += "  ]\n}\n"
    
    return FileManager.singleton.writeFile (filename, contents: fileContents)
  }
  
  func loadFromJson () -> Bool
  {
    let fileContents = FileManager.singleton.readFile (filename)
    
    if (fileContents == nil)
    {
      return false
    }
    
    do
    {
      let json = try NSJSONSerialization.JSONObjectWithData (fileContents!, options: .AllowFragments) as? [String: AnyObject]
      
      if let lanesJson = json!["lanes"] as? [[String: AnyObject]]
      {
        for (lane, laneJson) in lanesJson.enumerate ()
        {
          if let swimmersJson = laneJson["lane"] as? [[String: String]]
          {
            addLane ()
            
            for swimmerJson in swimmersJson
            {
              let swimmer = SwimmerManager.singleton.findSwimmer (swimmerJson["name"]!)
              
              if swimmer != nil
              {
                addSwimmer (lane, swimmer: swimmer!)
              }
            }
          }
        }
      }
    }
    catch
    {
      print("error deserializing JSON: \(error)")
      return false
    }
    
    return true
  }
  /*
  func saveToYaml () -> Bool
  {
    var fileContents : String = ""
    
    for lane in swimmerTimers.enumerate ()
    {
      fileContents   += "- lap:\n"
      for timer in lane.element
      {
        fileContents += "  - name: \(timer.swimmer.name)\n"
      }
    }
    
    return FileManager.singleton.writeFile (filename, contents: fileContents)
  }
  
  func loadFromYaml () -> Bool
  {
    let fileContents = FileManager.singleton.readFileAsString (filename)
    
    if (fileContents == nil)
    {
      return false
    }
    
    let yamlContents = Yaml.load (fileContents!).value!
    
    //
    for (lane,lapYaml) in yamlContents.array!.enumerate ()
    {
      print (lapYaml)
      
      if lapYaml["lap"].array == nil
      {
        continue
      }
      
      addLane ()
      
      for swimmerYaml in lapYaml["lap"].array!
      {
        let swimmer = SwimmerManager.singleton.findSwimmer (swimmerYaml["name"].string!)
        
        if swimmer != nil
        {
          addSwimmer (lane, swimmer: swimmer!)
        }
      }
    }
    
    return swimmerTimers.count != 0
  }
*/
}

class SwimmerTimer
{
  enum State_E {case Idle, Waiting, Running}
  
  var swimmer           : Swimmer
  var state             : State_E = .Idle
  var deltaTime         : NSTimeInterval!
  var resultTime        : NSTimeInterval
  var lapTime           : NSTimeInterval
  var lastLapOccurance  : NSTimeInterval
  
  var ongoingInterval             : Interval?
  var ongoingIndividualInterval   : IndividualInterval?
  
  init (swimmer s : Swimmer)
  {
    swimmer                   = s
    resultTime                = 0.0
    lapTime                   = 0.0
    lastLapOccurance          = 0.0
    ongoingInterval           = nil
    ongoingIndividualInterval = nil
    deltaTime                 = 0.0
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
    
    cell.timeLabel.text   = time.toString ()
    cell.lapLabel.text    = lastLapOccurance.toString ()
    
    if state == .Running
    {
      let timeSinceLap = runningTime - lastLapOccurance
      if lastLapOccurance > 0.0 && timeSinceLap < 1.0
      {
        cell.lapLabel.font = UIFont.boldSystemFontOfSize (15.0)
      }
      else
      {
        cell.lapLabel.font = UIFont.systemFontOfSize (15.0)
      }
    }
    
    cell.nameLabel.text   = swimmer.name
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
  
  func globalStart (swimmerDeltaTime : NSTimeInterval, ongoingInterval oi : Interval?)
  {
    deltaTime = swimmerDeltaTime
    state = .Waiting
    
    lapTime           = 0.0
    lastLapOccurance  = 0.0
    
    ongoingInterval           = oi
    ongoingIndividualInterval = IndividualInterval (swimmerName: swimmer.name, lapLength: SettingsManager.singleton.poolLength)
  }
  
  func update ()
  {
    if (state == .Idle)
    {
      return;
    }
    
    if (runningTime > 0.0 && state != .Running)
    {
      state = .Running
      onStarted ()
    }
  }
  
  func onStarted () -> Void
  {
  }
  
  func stop ()
  {
    if (state == .Idle)
    {
      return
    }
    
    lap () // Add the last "lap"
    
    state = .Idle
    onStopped ()
    
    resultTime  = max (0.0, runningTime)
    
    ongoingIndividualInterval?.setTotalTime (resultTime)
  }
  
  func onStopped () ->Void
  {
    if ongoingIndividualInterval != nil
    {
      ongoingInterval?.appendIndividualInterval (ongoingIndividualInterval!)
    }
    
    ongoingIndividualInterval   = nil
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
    
    ongoingIndividualInterval?.appendLapTime (lapTime)
  }
  
}

