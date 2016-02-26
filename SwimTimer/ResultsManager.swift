//
//  ResultsManager.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 23/02/16.
//  Copyright © 2016 Viktor Fägerlind. All rights reserved.
//

import Foundation


class ResultsManager
{
  static let singleton = ResultsManager ()
  
  private var sessions : [Session]!
  
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
}

class Session
{
  private(set) var name      : String!
  private(set) var dateTime  : String!
  private(set) var intervals : [Interval]!
  private(set) var length    : Int!
  
  private(set) var swimmers : [Swimmer]!
  
  
  init (name n : String, dateTime d : String)
  {
    name      = n
    dateTime  = d
    intervals = [Interval]()
    length    = 0
    swimmers = [Swimmer] ()
  }
  
  func addSwimmer (swimmer: Swimmer)
  {
    swimmers.append (swimmer)
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
