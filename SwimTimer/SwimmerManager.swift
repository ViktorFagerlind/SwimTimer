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
    addSwimmer ("Tomas",    mail: "", group: "Race")
    addSwimmer ("Emma",     mail: "", group: "Race")
    addSwimmer ("Julia",    mail: "", group: "Race")
    addSwimmer ("Johan",    mail: "", group: "Race")
    addSwimmer ("Viktor",   mail: "viktor_fagerlind@hotmail.com", group: "Race")
    addSwimmer ("Anna",     mail: "", group: "Race")
    addSwimmer ("John D",   mail: "", group: "Beginner")
    addSwimmer ("Jane D",   mail: "", group: "Beginner")
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
  
  func addSwimmer (name : String, mail m : String, group : String)
  {
    swimmers.append (Swimmer (name: name, mail: m, group: group))
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
  init (name n : String, mail m : String, group g : String)
  {
    name   = n
    mail   = m
    group  = g
  }
  
  var name  : String!
  var mail  : String!
  var group : String!
}

