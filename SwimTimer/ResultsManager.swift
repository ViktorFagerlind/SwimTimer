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
  var name      : String!
  var dateTime  : String!
  var swims     : [Swim]!
}

class Swim
{
  var length          : String!
  var individualSwims : [IndividualSwim]!
}

class IndividualSwim
{
  var swimmerName     : String!
  var time            : String!
  var lapTimes        : [String]!
}
