//
//  SecondViewController.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 22/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwimmerCellDelegate
{
  var timerManager : TimerManager = TimerManager ()
  var timer = NSTimer()
  
  @IBOutlet var tableView       : UITableView!
  @IBOutlet var editButton      : UIButton!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    var nib = UINib(nibName: "SwimmerCellNib", bundle: nil)
    self.tableView.registerNib (nib, forCellReuseIdentifier: "swimmer_cell_id")
    
    timerManager.addSwimmer("Viktor")
    timerManager.addSwimmer("Tomas")
    timerManager.addSwimmer("Johan")
    timerManager.addSwimmer("Emma")
    timerManager.addSwimmer("Bobby")
    timerManager.addSwimmer("Torbjörn")
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func updateTableView ()
  {
    timerManager.update ()
    tableView.reloadData ()
  }
  
  func tableView (tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return timerManager.nofSwimmers
  }
  
  @IBAction func StopAllButtonPressed (sender : AnyObject)
  {
    timerManager.stopAll ()
    timer.invalidate ()
    tableView.reloadData ()
  }
  
  @IBAction func StopNextButtonPressed (sender : AnyObject)
  {
    timerManager.stopNext ()
    tableView.reloadData ()
  }
  
  func StopIndividualSwimmer (cellName : String)
  {
    timerManager.stopSwimmer (cellName)
    tableView.reloadData ()
  }
  
  @IBAction func StartButtonPressed (sender : AnyObject)
  {
    timer = NSTimer.scheduledTimerWithTimeInterval (0.01, target: self, selector: "updateTableView", userInfo: nil, repeats: true)
    
    timerManager.start ()
  }
  
  @IBAction func EditButtonPressed (sender : AnyObject)
  {
    if tableView.editing
    {
      tableView.setEditing(false, animated: false);
      editButton.setTitle("Edit", forState: UIControlState.Normal)
    }
    else
    {
      tableView.setEditing(true, animated: true);
      editButton.setTitle("Done", forState: UIControlState.Normal)
    }
  }

  @IBAction func cancelToTimerView (segue:UIStoryboardSegue)
  {
  }
  
  @IBAction func addSwimmerDone (segue:UIStoryboardSegue)
  {
    var addSwimmerController = segue.sourceViewController as! AddSwimmerController
    
    timerManager.addSwimmer (addSwimmerController.name)
    
    tableView.reloadData ()
  }
  
  func tableView (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    var cell : SwimmerCellController =
      self.tableView.dequeueReusableCellWithIdentifier("swimmer_cell_id") as! SwimmerCellController
    
    cell.delegate = self
    
    timerManager.fillCell (&cell, index: indexPath.row)
    
    return cell
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 1
  }
  
  func tableView (tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    println("You selected cell #\(indexPath.row)!")
  }
  
  func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
  {
    return true // Yes, the table view can be reordered
  }
  
  func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath)
  {
    timerManager.moveSwimmer (fromIndexPath.row, toIndex: toIndexPath.row)
  }
}

