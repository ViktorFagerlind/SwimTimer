//
//  AddSwimmerController.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 28/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import UIKit

class AddSwimmerController: UIViewController
{
  @IBOutlet var nameField   : UITextField!
  @IBOutlet var groupField  : UITextField!
  @IBOutlet var mailField   : UITextField!
  
  var name  : String!
  var mail  : String!
  var group : String!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func done(sender: AnyObject)
  {
    if nameField.text == nil || nameField.text == ""
    {
      let duplicateAlert = UIAlertController (title: "No Name", message: "You cannot add a swimmer without name!", preferredStyle: UIAlertControllerStyle.Alert)
      duplicateAlert.addAction (UIAlertAction (title: "OK", style: .Default, handler: nil))
      presentViewController (duplicateAlert, animated: true, completion: nil)
    }
    else if SwimmerManager.singleton.isSwimmerPresent (nameField.text!)
    {
      let duplicateAlert = UIAlertController (title: "Duplicate Name", message: "You cannot add a swimmer with the same name as an existing swimmer!", preferredStyle: UIAlertControllerStyle.Alert)
      duplicateAlert.addAction (UIAlertAction (title: "OK", style: .Default, handler: nil))
      presentViewController (duplicateAlert, animated: true, completion: nil)
    }
    else
    {
      performSegueWithIdentifier ("add_swimmer_done_segue_id", sender: self)
    }
  }
  
  @IBAction func cancel(sender: AnyObject)
  {
    performSegueWithIdentifier ("add_swimmer_cancel_segue_id", sender: self)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
  {
    name  = nameField.text
    mail  = mailField.text
    group = groupField.text
    
    nameField.text  = ""
    mailField.text  = ""
    groupField.text = ""
  }

}

