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
  
  private init ()
  {

  }
  
  func addSession (session : Session) -> Void
  {
    sessions.append (session)
  }
  
  func nofSessions () -> Int
  {
    return sessions.count
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
  private(set) var length          : String!
  private(set) var individualSwims : [IndividualSwim]!
  
  init (length l : String)
  {
    length          = l
    individualSwims = [IndividualSwim]()
  }
  
  func appendIndividualSwim (individualSwim : IndividualSwim) -> Void
  {
    individualSwims.append (individualSwim)
  }
}

class IndividualSwim
{
  private(set) var swimmerName     : String!
  private(set) var time            : String!
  private(set) var lapTimes        : [NSTimeInterval]!
  
  init (swimmerName n : String, time t : String)
  {
    swimmerName = n
    time        = t
    lapTimes    = [NSTimeInterval]()
  }
  
  func appendSwim (lapTime : NSTimeInterval) -> Void
  {
    lapTimes.append (lapTime)
  }
}
