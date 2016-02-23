//
//  TimerManager.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 27/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import Foundation

class SwimmerManager
{
  static let singleton = SwimmerManager ()
  
  var swimmers : [Swimmer] = [Swimmer]()
  
  private init ()
  {
    addSwimmer ("Tomas",    group: "Race")
    addSwimmer ("Emma",     group: "Race")
    addSwimmer ("Julia",    group: "Race")
    addSwimmer ("Johan",    group: "Race")
    addSwimmer ("Viktor",   group: "Race")
    addSwimmer ("Anna",     group: "Race")
    addSwimmer ("John D", group: "Beginner")
    addSwimmer ("Jane D", group: "Beginner")
  }
  
  var nofSwimmers: Int
  {
    get
    {
      return swimmers.count
    }
  }
  
  func getSwimmer (index : Int) -> Swimmer
  {
    return swimmers[index]
  }
  
  func addSwimmer (name : String, group : String)
  {
    swimmers.append (Swimmer (name: name, group: group))
  }
  
  func deleteSwimmer (index : Int)
  {
    swimmers.removeAtIndex (index)
  }
  
  func moveSwimmer (fromIndex: Int, toIndex: Int)
  {
    let swimmer = swimmers.removeAtIndex (fromIndex)
    swimmers.insert (swimmer, atIndex: toIndex)
  }
  
}

class Swimmer
{
  init (name n : String, group g : String)
  {
    name   = n
    group  = g
  }
  
  var name  : String!
  var group : String!
}

