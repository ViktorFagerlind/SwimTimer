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

  
  func getSession (index : Int) -> Session
  {
    return sessions[index]
  }
}

class Session
{
  private(set) var name      : String!
  private(set) var dateTime  : String!
  private(set) var swims     : [Swim]!
  
  init (name n : String, dateTime d : String)
  {
    name      = n
    dateTime  = d
    swims     = [Swim]()
  }
  
  func appendSwim (swim : Swim) -> Void
  {
    swims.append (swim)
  }
}

class Swim
{
  private(set) var length          : Int!
  private(set) var individualSwims : [IndividualSwim]!
  
  init ()
  {
    length          = 0
    individualSwims = [IndividualSwim]()
  }
  
  func setLength (length l : Int) -> Void
  {
    length = l
  }
  
  func appendIndividualSwim (individualSwim : IndividualSwim) -> Void
  {
    individualSwims.append (individualSwim)
  }
}

class IndividualSwim
{
  private(set) var swimmerName     : String!
  private(set) var time            : NSTimeInterval!
  private(set) var lapTimes        : [NSTimeInterval]!
  private(set) var length          : Int!
  
  init (swimmerName n : String)
  {
    swimmerName = n
    time        = 0
    lapTimes    = [NSTimeInterval]()
    length      = 0
  }
  
  func appendLapTime (lapTime : NSTimeInterval) -> Void
  {
    lapTimes.append (lapTime)
    
    time    = time + lapTime
    length  = length + SettingsManager.singleton.poolLength
  }
}
