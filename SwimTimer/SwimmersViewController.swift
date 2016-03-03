//
//  SecondViewController.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 22/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import UIKit

class SwimmersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
  @IBOutlet var addSwimmerButton  : UIButton!
  @IBOutlet var editButton        : UIBarButtonItem!
  @IBOutlet var tableView         : UITableView!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    let cellNib = UINib(nibName: "SwimmerNib", bundle: nil)
    self.tableView.registerNib (cellNib, forCellReuseIdentifier: "swimmer_id")
  }
  
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func redraw ()
  {
    tableView.reloadData ()
  }
  
  func setTextEnabling (enabled : Bool)
  {
    for swimmerCell in tableView.visibleCells
    {
      let swimmerController : SwimmerController = swimmerCell as! SwimmerController
      
      swimmerController.nameField.userInteractionEnabled    = enabled
      swimmerController.groupField.userInteractionEnabled   = enabled
    }
  }
  
  func updateSwimmersAccordingToGui () -> Void
  {
    for (i, swimmerCell) in tableView.visibleCells.enumerate()
    {
      let swimmerController : SwimmerController = swimmerCell as! SwimmerController
      
      let swimmer : Swimmer = SwimmerManager.singleton.getSwimmer (i)
      
      if (swimmerController.nameField.text != nil)
      {
        swimmer.name  = swimmerController.nameField.text!
      }
      
      if (swimmerController.groupField.text != nil)
      {
        swimmer.group = swimmerController.groupField.text
      }
      else
      {
        swimmer.group = ""
      }
    }
  }
  
  @IBAction func EditPressed(sender: AnyObject)
  {
    if tableView.editing
    {
      tableView.setEditing(false, animated: false)
      editButton.style      = UIBarButtonItemStyle.Plain
      editButton.title      = "Edit"
      
      updateSwimmersAccordingToGui ()
      SwimmerManager.singleton.saveToJson ()
    }
    else
    {
      tableView.setEditing(true, animated: true)
      editButton.title = "Done"
      editButton.style =  UIBarButtonItemStyle.Done
    }
    
    setTextEnabling (tableView.editing)

    redraw ()
  }
  
  @IBAction func addSwimmerCancel (segue:UIStoryboardSegue)
  {
  }
  
  
  @IBAction func addSwimmerDone (segue:UIStoryboardSegue)
  {
    let addSwimmerController = segue.sourceViewController as! AddSwimmerController
    
    // Add swimmer to the last lane
    SwimmerManager.singleton.addSwimmer (addSwimmerController.name, mail: addSwimmerController.mail, group: addSwimmerController.group)
    
    redraw ()
    SwimmerManager.singleton.saveToJson ()
  }
  
  func tableView (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell : SwimmerController =
      self.tableView.dequeueReusableCellWithIdentifier("swimmer_id") as! SwimmerController
    
    let swimmer : Swimmer = SwimmerManager.singleton.getSwimmer (indexPath.row)
    cell.nameField.text   = swimmer.name
    cell.mailField.text   = swimmer.mail
    cell.groupField.text  = swimmer.group
    
    return cell
  }
  
  func tableView (tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return SwimmerManager.singleton.nofSwimmers
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 1
  }
  
  func tableView (tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    print("You selected cell #\(indexPath.row)!")
  }
  
  func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
  {
    return true // Yes, the table view can be reordered
  }
  
  func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
  {
    return UITableViewCellEditingStyle.Delete
  }
  
  func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath)
  {
    SwimmerManager.singleton.moveSwimmer (fromIndexPath.row, toIndex: toIndexPath.row)

    redraw ()
  }
  
  func tableView (tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
  {
    if editingStyle == UITableViewCellEditingStyle.Delete
    {
      SwimmerManager.singleton.deleteSwimmer (indexPath.row)
      tableView.deleteRowsAtIndexPaths ([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
      
      redraw ()
    }
  }
}

