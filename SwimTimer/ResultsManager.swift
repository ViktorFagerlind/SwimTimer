//
//  ResultsManager.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 23/02/16.
//  Copyright © 2016 Viktor Fägerlind. All rights reserved.
//

import Foundation
import YamlSwift

class ResultsManager
{
  static let singleton = ResultsManager ()
  
  private var sessions : [Session]!
  
  let filename = "results.yaml"
  
  var nofSessions : Int
  {
    get
    {
      return sessions.count
    }
  }
  
  private init ()
  {
    sessions = [Session] ()
    
    initRandomResults ()
    saveToFile ()
    loadFromFile ()
    
    //if !loadFromFile ()
    //{
    //  initRandomResults ()
    //}

  }
  
  func initRandomResults ()
  {
    for day in 0...0
    {
      let dateTime = NSCalendar.currentCalendar().dateByAddingUnit(
        .Day,
        value:    15 - day,
        toDate:   NSDate (),
        options:  NSCalendarOptions(rawValue: 0))
      
      let timestamp = NSDateFormatter.localizedStringFromDate (dateTime!, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
      
      let session = Session (name: "Pass", dateTime: timestamp)
      
      for i in 0...(SwimmerManager.singleton.nofSwimmers-1)
      {
        session.addMailAddress (SwimmerManager.singleton.getSwimmer(i).mail)
      }
      
      let rndTotalLenth = (Int (rand()) % (20) + 15)*100
      var totalLength : Int = 0
      
      while totalLength < rndTotalLenth
      {
        let interval = Interval ()
        
        let nofLengths : Int = Int (rand () % 8) + 1
        for i in 0...(SwimmerManager.singleton.nofSwimmers-1)
        {
          let individualInterval = IndividualInterval (swimmerName : SwimmerManager.singleton.getSwimmer(i).name, lapLength: SettingsManager.singleton.poolLength)
          
          for _ in 0...(nofLengths-1)
          {
            individualInterval.appendLapTime (NSTimeInterval ((Double (arc4random ()) /  Double (UINT32_MAX)) * 25.0 + 35.0))
          }
          
          interval.appendIndividualInterval (individualInterval)
        }
        totalLength += interval.length
        
        session.addInterval (interval)
      }
      addSession (session)
    }
  }
  
  func addSession (session : Session) -> Void
  {
    sessions.append (session)
  }

  func removeLastSession () -> Void
  {
    sessions.removeLast ()
  }
  
  func getSession (index : Int) -> Session
  {
    return sessions[index]
  }
  
  func saveToFile () -> Bool
  {
    var fileContents : String = ""
    
    for s in sessions
    {
      fileContents +=       "- session:\n" +
                            "  name:   \(s.name)\n" +
                            "  date:   \(s.dateTime)\n" +
                            "  length: \(s.length)\n" +
                            "  mailAddresses:\n"
      for m in s.mailAddresses
      {
        fileContents +=     "    - \(m)\n"
      }
      
      fileContents +=       "  intervals:\n"
      
      for i in s.intervals
      {
        fileContents +=     "    - interval:\n"
        
        for ii in i.individualIntervals
        {
          fileContents +=   "      - individualInterval:\n" +
                            "          swimmerName: \(ii.swimmerName)\n" +
                            "          time:        " + TimerManager.timeToString (ii.time) + "\n" +
                            "          lapLength:   \(ii.lapLength)\n" +
                            "          lapTimes:\n"
          
          for lt in ii.lapTimes
          {
            fileContents += "            - " + TimerManager.timeToString(lt) + "\n"
          }
          
        }
      }
    }
    
    return FileManager.singleton.writeFile (filename, contents: fileContents)
  }

  func loadFromFile () -> Bool
  {
    let fileContents = FileManager.singleton.readFileAsString (filename)
    
    if (fileContents == nil)
    {
      return false
    }
    
    let yamlContents = Yaml.load (fileContents!).value!
    
    if yamlContents.array == nil
    {
      return false
    }
    
    for sYaml in yamlContents.array!
    {
      let session = Session (name: sYaml["name"].string!, dateTime: sYaml["date"].string!)
      
      if (sYaml["mailAddresses"].array != nil)
      {
        for sMail in sYaml["mailAddresses"].array!
        {
          if sMail.string != nil
          {
            session.addMailAddress (sMail.string!)
          }
        }
      }
      
      addSession (session)
    }
    
    return true
  }

}

class Session
{
  private(set) var name           : String!
  private(set) var dateTime       : String!
  private(set) var length         : Int!
  private(set) var mailAddresses  : [String]!
  private(set) var intervals      : [Interval]!
  
  
  init (name n : String, dateTime d : String)
  {
    name          = n
    dateTime      = d
    intervals     = [Interval]()
    length        = 0
    mailAddresses = [String] ()
  }
  
  func addMailAddress (mailAddress : String) -> Void
  {
    mailAddresses.append (mailAddress)
  }
  
  func addInterval (interval : Interval) -> Void
  {
    intervals.append (interval)
    length = length + interval.length
  }
  
  func toHtml () -> String
  {
    var html : String =  "<h2>" + name + " (" + String (length) + "m)</h2>\n" +
                         "<h4>" + dateTime + "</h4>\n"
    
    html = html + "<hr>\n"
    
    for i in intervals
    {
      html += i.toHtml ()
    }
    
    return html
  }
}

class Interval
{
  private(set) var individualIntervals  : [IndividualInterval]!
  
  init ()
  {
    individualIntervals = [IndividualInterval]()
  }
  
  var length : Int
  {
    get
    {
      return individualIntervals.count == 0 ? 0 : individualIntervals[0].length
    }
  }
  
  var bestResult : NSTimeInterval
  {
    get
    {
      if individualIntervals.count == 0
      {
        return NSTimeInterval (0)
      }
      
      var bestTime = NSTimeInterval.infinity
      for ii in individualIntervals
      {
        let time = ii.time
        
        if bestTime > time
        {
          bestTime = time
        }
      }
      
      return bestTime
    }
  }
  
  func fixMissingLaps () -> Void
  {
    var nofMostCommonCount  : Int = 0
    var mostCommonCount     : Int = 0
    
    for ii1 in individualIntervals
    {
      let currentCount = ii1.lapTimes.count
      var nofSameCount : Int = 0
      
      for ii2 in individualIntervals
      {
        if ii2.lapTimes.count == currentCount
        {
          nofSameCount++
        }
      }
      if nofSameCount > nofMostCommonCount
      {
        nofMostCommonCount = nofSameCount
        mostCommonCount    = currentCount
      }
    }
    
    for ii in individualIntervals
    {
      ii.setNofLaps (mostCommonCount)
    }
    
  }
  
  func appendIndividualInterval (individualInterval : IndividualInterval) -> Void
  {
    individualIntervals.append (individualInterval)
  }
  
  func toHtml () -> String
  {
    var html : String = "<h4>" + String (length) + "m</h4>\n"
    
    for ii in individualIntervals
    {
      html = html + ii.toHtml ()
    }
    html = html + "<hr>\n"
    
    return html
  }
}

class IndividualInterval
{
  private(set) var swimmerName     : String!
  private(set) var time            : NSTimeInterval!
  private(set) var lapTimes        : [NSTimeInterval]!
  private(set) var lapLength       : Int!
  
  var length : Int
  {
    get
    {
      return lapTimes.count * lapLength
    }
  }
  
  init (swimmerName n : String, lapLength l : Int)
  {
    swimmerName = n
    time        = 0
    lapTimes    = [NSTimeInterval]()
    lapLength   = l
  }
  
  func appendLapTime (lapTime : NSTimeInterval) -> Void
  {
    lapTimes.append (lapTime)
    time    = time + lapTime
  }
  
  func setTotalTime (totalTime : NSTimeInterval) -> Void
  {
    time = totalTime
  }
  
  func setNofLaps (nofLaps : Int) -> Void
  {
    for var i = lapTimes.count; i < nofLaps; i++
    {
      appendLapTime (NSTimeInterval (-1.0))
    }
    
    while lapTimes.count > nofLaps
    {
      lapTimes.removeLast ()
    }
  }
  
  func toHtml () -> String
  {
    var html : String = "<b>" + swimmerName + " " + TimerManager.timeToString(time) + "</b><br>\n"
    
    for lt in lapTimes
    {
      html = html + TimerManager.timeToString(lt) + "<br>\n"
    }
    html = html + "<br>\n"
    
    return html
  }
}
