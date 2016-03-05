//
//  TimerManager.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 27/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import Foundation
//import YamlSwift

class SettingsManager
{
  static let singleton = SettingsManager ()
  
  var poolLength          : Int!
  var timeBetweenSwimmers : Int!
  
  let filename = "settings.json"
  
  private init ()
  {
    if !loadFromJson ()
    {
      poolLength          = 50
      timeBetweenSwimmers = 3
    }
  }
  
  
  func saveToJson () -> Bool
  {
    let fileContents : String = "{\n" +
                                "  \"pool_length\": \(poolLength)," +
                                "  \"time_between_swimmers\": \(timeBetweenSwimmers)\n" +
                                "}\n"
    
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
      
      poolLength          = json["pool_length"] as! Int
      timeBetweenSwimmers = json["time_between_swimmers"] as! Int
    }
    catch
    {
      print("error deserializing JSON: \(error)")
      return false
    }
    
    return true
  }
  /*
  func saveToYaml () -> Bool
  {
    let fileContents : String = "pool_length: \(poolLength)\n" +
                                "time_between_swimmers: \(timeBetweenSwimmers)"
    
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
    
    poolLength          = yamlContents["pool_length"].int
    timeBetweenSwimmers = yamlContents["time_between_swimmers"].int
    
    return true
  }
*/
}
