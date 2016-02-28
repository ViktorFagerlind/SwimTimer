//
//  TimerManager.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 27/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import Foundation
import YamlSwift

class SettingsManager
{
  static let singleton = SettingsManager ()
  
  var poolLength          : Int!
  var timeBetweenSwimmers : Int!
  
  let filename = "Settings.yaml"
  
  private init ()
  {
    if !loadFromFile ()
    {
      poolLength          = 50
      timeBetweenSwimmers = 3
    }
  }
  
  func saveToFile () -> Bool
  {
    let fileContents : String = "pool_length: \(poolLength)\n" +
                                "time_between_swimmers: \(timeBetweenSwimmers)"
    
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
    
    poolLength          = yamlContents["pool_length"].int
    timeBetweenSwimmers = yamlContents["time_between_swimmers"].int
    
    return true
  }
}
