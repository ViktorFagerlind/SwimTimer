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
    sessions = [Session]()
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
  
  init (name n : String, dateTime d : String)
  {
    name      = n
    dateTime  = d
    intervals = [Interval]()
    length    = 0
  }
  
  func appendSwim (interval : Interval) -> Void
  {
    intervals.append (interval)
    length = length + interval.length
  }
}

class Interval
{
  private(set) var length               : Int!
  private(set) var individualIntervals  : [IndividualInterval]!
  
  init ()
  {
    length              = 0
    individualIntervals = [IndividualInterval]()
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
  
  func appendIndividualInterval (individualInterval : IndividualInterval) -> Void
  {
    if (individualIntervals.count == 0)
    {
      length = individualInterval.length
    }
    
    individualIntervals.append (individualInterval)
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
}
