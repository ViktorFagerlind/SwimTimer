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
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
  {
    selectedSwimmer = SwimmerManager.singleton.getSwimmer (swimmerPicker.selectedRowInComponent (0))
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

