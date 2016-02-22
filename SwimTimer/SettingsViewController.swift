//
//  SecondViewController.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 22/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController
{
  @IBOutlet var poolLengthTextField           : UITextField!
  @IBOutlet var timeBetweenSwimmersTextField  : UITextField!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    poolLengthTextField.text          = String (SettingsManager.singleton.poolLength)
    timeBetweenSwimmersTextField.text = String (SettingsManager.singleton.timeBetweenSwimmers)
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func textFieldChanged (sender: AnyObject)
  {
    var tmp : Int?
    
    tmp = Int (poolLengthTextField.text!)
    if tmp != nil && tmp > 0
    {
      SettingsManager.singleton.poolLength = tmp
    }
    else
    {
      poolLengthTextField.text = String (SettingsManager.singleton.poolLength)
    }
    
    tmp = Int (timeBetweenSwimmersTextField.text!)
    if tmp != nil && tmp > 0
    {
      SettingsManager.singleton.timeBetweenSwimmers = tmp
    }
    else
    {
      timeBetweenSwimmersTextField.text = String (SettingsManager.singleton.timeBetweenSwimmers)
    }
  }
}

