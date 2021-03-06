//
//  SecondViewController.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 22/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate
{
  @IBOutlet var poolLengthTextField           : UITextField!
  @IBOutlet var timeBetweenSwimmersTextField  : UITextField!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    poolLengthTextField.text          = String (SettingsManager.singleton.poolLength)
    timeBetweenSwimmersTextField.text = String (SettingsManager.singleton.timeBetweenSwimmers)
    
    poolLengthTextField.delegate          = self
    timeBetweenSwimmersTextField.delegate = self
  }
  
  override func viewWillDisappear(animated: Bool)
  {
    SettingsManager.singleton.saveToJson ()
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func aboutPressed (sender: AnyObject)
  {
    let aboutAlert = UIAlertController (
      title: "About",
      message: "App created by Viktor Fägerlind\n" +
               "All icons (except App icon) by icons8 (https://icons8.com)\n",
      preferredStyle: UIAlertControllerStyle.Alert)
    
    aboutAlert.addAction (UIAlertAction (title: "Ok", style: .Default, handler: nil))
    
    presentViewController (aboutAlert, animated: true, completion: nil)  }

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
  
  func textFieldShouldReturn(textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
  {
    textField.resignFirstResponder()
    
    SettingsManager.singleton.saveToJson ()
    return true;
  }
}

