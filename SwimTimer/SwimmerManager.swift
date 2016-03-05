//
//  TimerManager.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 27/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import Foundation
//import YamlSwift

class SwimmerManager
{
  static let singleton = SwimmerManager ()
  
  var swimmers : [Swimmer] = [Swimmer]()
  
  let filename = "swimmers.json"
  
  private init ()
  {
    if !loadFromJson()
    {
      addSwimmer ("Peter A",      mail: "", group: "Coach")
      addSwimmer ("Sandra H",     mail: "", group: "Coach")
      addSwimmer ("Tomas R",      mail: "", group: "Race")
      addSwimmer ("Viktor F",     mail: "", group: "Race")
      addSwimmer ("Emma Å",       mail: "", group: "Race")
      addSwimmer ("Julia P",      mail: "", group: "Race")
      addSwimmer ("Johan J",      mail: "", group: "Race")
      addSwimmer ("Anna S",       mail: "", group: "Race")
      addSwimmer ("Thord L",      mail: "", group: "Race")
      addSwimmer ("Gabriella N",  mail: "", group: "Race")
      addSwimmer ("Mirella C",    mail: "", group: "Race")
      addSwimmer ("Magnus E",     mail: "", group: "Race")
      addSwimmer ("Birgitta L",   mail: "", group: "Race")
      addSwimmer ("Mats G",       mail: "", group: "Race")
      addSwimmer ("Helena N",     mail: "", group: "Race")
      addSwimmer ("Michael Z",    mail: "", group: "Race")
      addSwimmer ("John D",       mail: "", group: "Beginner")
      addSwimmer ("Jane D",       mail: "", group: "Beginner")
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
  
  func findSwimmer (name : String) -> Swimmer?
  {
    for s in swimmers
    {
      if s.name == name
      {
        return s
      }
    }
    
    return nil
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

  
  func saveToJson () -> Bool
  {
    var fileContents : String = "{\n  \"swimmers\" :\n  ["
    
    for (i,s) in swimmers.enumerate ()
    {
      fileContents += "\n   {\"name\": \"\(s.name)\", \"mail\": \"\(s.mail)\", \"group\": \"\(s.group)\"}"
      
      if i != (swimmers.count - 1)
      {
        fileContents += ","
      }
    }
    
    fileContents += "\n  ]\n}\n"
    
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
      let json = try NSJSONSerialization.JSONObjectWithData (fileContents!, options: .AllowFragments)
      
      if let swimmersJson = json["swimmers"] as? [[String: String]]
      {
        for swimmerJson in swimmersJson
        {
          addSwimmer (swimmerJson["name"]!, mail: swimmerJson["mail"], group: swimmerJson["group"]!)
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
  func saveToYaml() -> Bool
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

  func loadFromYaml () -> Bool
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
    
    for swimmerYaml in yamlContents.array!
    {
      addSwimmer (swimmerYaml["name"].string!, mail: swimmerYaml["mail"].string, group: swimmerYaml["group"].string!)
    }
    
    return true
  }
*/
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

