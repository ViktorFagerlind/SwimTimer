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

