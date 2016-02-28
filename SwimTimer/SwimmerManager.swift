//
//  TimerManager.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 27/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import Foundation
import YamlSwift

class SwimmerManager
{
  static let singleton = SwimmerManager ()
  
  var swimmers : [Swimmer] = [Swimmer]()
  
  let filename = "Swimmers.yaml"
  
  private init ()
  {
    if (!loadFromFile())
    {
      addSwimmer ("John D",   mail: "", group: "Beginner")
      addSwimmer ("Jane D",   mail: "", group: "Beginner")
    }
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
  
  func addSwimmer (name : String, mail m : String?, group : String)
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

  func saveToFile () -> Bool
  {
    var fileContents : String = ""
    
    for s in swimmers
    {
      fileContents += "- name: \(s.name)\n" +
                      "  mail: \(s.mail)\n" +
                      "  group: \(s.group)\n\n"
    }
    
    return FileManager.singleton.writeFile (filename, contents: fileContents)
  }

  func loadFromFile () -> Bool
  {
    let fileContents = FileManager.singleton.readFile (filename)
    
    if (fileContents == nil)
    {
      return false
    }
    
    let yamlContents = Yaml.load (fileContents!).value!
    
    for swimmerYaml in yamlContents.array!
    {
      addSwimmer (swimmerYaml["name"].string!, mail: swimmerYaml["mail"].string, group: swimmerYaml["group"].string!)
    }
    
    return true
  }
}

class Swimmer
{
  init (name n : String, mail m : String?, group g : String)
  {
    name   = n
    mail   = m == nil ? "" : m
    group  = g
  }
  
  var name  : String!
  var mail  : String!
  var group : String!
}

