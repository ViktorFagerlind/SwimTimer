//
//  AddSwimmerController.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 28/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import UIKit

class ChooseSwimmerController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate
{
  @IBOutlet var swimmerPicker: UIPickerView!
  
  var selectedSwimmer : Swimmer?
  var timerManager : TimerManager?
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    swimmerPicker.delegate = self
    swimmerPicker.dataSource = self
    
    selectedSwimmer = nil
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func donePressed(sender: AnyObject)
  {
    selectedSwimmer = SwimmerManager.singleton.getSwimmer (swimmerPicker.selectedRowInComponent (0))
    
    if timerManager!.isSwimmerPresent (selectedSwimmer!)
    {
      let duplicateAlert = UIAlertController (title: "Swimmer Duplicate", message: "You cannot add a swimmer that is already present on any lane", preferredStyle: UIAlertControllerStyle.Alert)
      duplicateAlert.addAction (UIAlertAction (title: "OK", style: .Default, handler: nil))
      presentViewController (duplicateAlert, animated: true, completion: nil)
    }
    else
    {
      performSegueWithIdentifier ("choose_swimmer_done_segue", sender: self)
    }
  }
  
  @IBAction func cancelPressed(sender: AnyObject)
  {
    performSegueWithIdentifier ("choose_swimmer_cancel_segue", sender: self)
  }
  
  func numberOfComponentsInPickerView (pickerView: UIPickerView) -> Int
  {
    return 1
  }
  
  func pickerView (pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
  {
    return SwimmerManager.singleton.nofSwimmers
  }
  
  func pickerView (pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
  {
    let swimmer = SwimmerManager.singleton.getSwimmer (row)
    return swimmer.name + "  -  " + swimmer.group
  }
  
/*  func pickerView (pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
  {
    selectedSwimmer = SwimmerManager.singleton.getSwimmer (row)
  }
*/
}

