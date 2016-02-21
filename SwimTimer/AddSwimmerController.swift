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
  
  var name  : String!
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
    group = groupField.text
    
    nameField.text = ""
    groupField.text = ""
  }
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
}

