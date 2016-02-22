//
//  TimerManager.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 27/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import UIKit

class SettingsManager
{
  static let singleton = SettingsManager ()
  
  var poolLength          : Int!
  var timeBetweenSwimmers : Int!
  
  private init ()
  {
    poolLength          = 50
    timeBetweenSwimmers = 5
  }
}
