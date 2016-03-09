//
//  SecondViewController.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 22/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwimmerTimerDelegate, LaneHeaderDelegate
{
  var timerManager : TimerManager = TimerManager ()
  var timer = NSTimer()

  @IBOutlet var addSwimmerButton        : UIButton!
  @IBOutlet var addLaneButton           : UIButton!
  @IBOutlet var editButton              : UIBarButtonItem!
  
  @IBOutlet var startStopSessionButton  : UIBarButtonItem!
  
  @IBOutlet var startButton             : UIBarButtonItem!
  @IBOutlet var stopAllButton           : UIBarButtonItem!
  
  @IBOutlet var tableView               : UITableView!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    let headerNib = UINib(nibName: "LaneHeadingNib", bundle: nil)
    self.tableView.registerNib (headerNib, forCellReuseIdentifier: "header_cell")
    
    let cellNib = UINib(nibName: "SwimmerTimerNib", bundle: nil)
    self.tableView.registerNib (cellNib, forCellReuseIdentifier: "swimmer_timer_id")
    
    ResultsManager.singleton // Load results
    
    redraw ()
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func redraw ()
  {
    if (!timerManager.isRunning)
    {
      timer.invalidate ()
    }
    
    editButton.enabled              = !timerManager.isInSession
    addLaneButton.enabled           = !timerManager.isInSession && !tableView.editing
    addSwimmerButton.enabled        = !timerManager.isInSession && !tableView.editing
    
    startStopSessionButton.enabled  = !timerManager.isRunning   && !tableView.editing
    startButton.enabled             = timerManager.isInSession  && !timerManager.isRunning && !tableView.editing
    stopAllButton.enabled           = timerManager.isInSession  && timerManager.isRunning && !tableView.editing
    
    tableView.reloadData ()
  }
  
  func updateTimers ()
  {
    timerManager.update ()
    redraw ()
  }
  
  func LapNext (lane : Int)
  {
    timerManager.lapNext (lane)
    redraw ()
  }
  
  func StopNext (lane : Int)
  {
    timerManager.stopNext (lane)
    redraw ()
  }
  
  func StopIndividualSwimmer (cellName : String)
  {
    timerManager.stopSwimmer (cellName)
    redraw ()
  }
  
  func LapIndividualSwimmer (cellName : String)
  {
    timerManager.lapSwimmer (cellName)
    redraw ()
  }
  
  @IBAction func StartButtonPressed (sender : AnyObject)
  {
    timerManager.start ()
    
    timer = NSTimer.scheduledTimerWithTimeInterval (0.055, target: self, selector: "updateTimers", userInfo: nil, repeats: true)
    
    redraw ()
  }
  
  @IBAction func StopAllButtonPressed (sender : AnyObject)
  {
    timerManager.stopAll ()
    redraw ()
  }

  @IBAction func StartStopSessionPressed (sender : AnyObject)
  {
    if !timerManager.isInSession
    {
      timerManager.startSession ("Pass", dateTime: NSDateFormatter.localizedStringFromDate (NSDate (), dateStyle: .MediumStyle, timeStyle: .ShortStyle))
      
      startStopSessionButton.title = "End Session"
      
      redraw ()
    }
    else
    {
      let saveAlert = UIAlertController (title: "Save Session", message: "Do you want to save the session", preferredStyle: UIAlertControllerStyle.Alert)
      saveAlert.addAction (UIAlertAction (title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in self.timerManager.stopSession (true);  self.redraw (); ResultsManager.singleton.saveToJson ()}))
      saveAlert.addAction (UIAlertAction (title: "No",  style: .Default, handler: { (action: UIAlertAction!) in self.timerManager.stopSession (false); self.redraw () }))
      presentViewController (saveAlert, animated: true, completion: nil)
      
      startStopSessionButton.title = "Start Session"
    }
    
  }
  
  @IBAction func EditPressed(sender: AnyObject)
  {
    if tableView.editing
    {
      tableView.setEditing (false, animated: false);
      editButton.style      = UIBarButtonItemStyle.Plain;
      editButton.title      = "Edit";
      //startButton.enabled   = true
      //stopAllButton.enabled = true
      
      timerManager.saveToJson ()
    }
    else
    {
      tableView.setEditing (true, animated: true);
      editButton.title      = "Done";
      editButton.style      =  UIBarButtonItemStyle.Done;
      //startButton.enabled   = false
      //stopAllButton.enabled = false
    }
    redraw ()
  }
  

  @IBAction func addLane(sender: AnyObject)
  {
    timerManager.addLane ()
    
    redraw ()
    
    timerManager.saveToJson ()
  }

  @IBAction func chooseSwimmerCancel (segue:UIStoryboardSegue)
  {
  }
  
  @IBAction func chooseSwimmerDone (segue:UIStoryboardSegue)
  {
    let chooseSwimmerController = segue.sourceViewController as! ChooseSwimmerController
    
    // Add swimmer to the last lane
    if (chooseSwimmerController.selectedSwimmer != nil)
    {
      timerManager.addSwimmer (timerManager.nofLanes-1, swimmer: chooseSwimmerController.selectedSwimmer!)
    }
    
    redraw ()
  }
  
  func tableView (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    if (indexPath.row == 0)
    {
      let headerCell : LaneHeaderController = self.tableView.dequeueReusableCellWithIdentifier("header_cell") as! LaneHeaderController
      
      headerCell.lane     = indexPath.section
      headerCell.delegate = self
      
      headerCell.title.text = "Lane \(indexPath.section)"
      headerCell.lapNextButton.enabled  = timerManager.isRunning
      headerCell.stopNextButton.enabled = timerManager.isRunning
      
      return headerCell
    }
    
    var cell : SwimmerTimerController =
      self.tableView.dequeueReusableCellWithIdentifier("swimmer_timer_id") as! SwimmerTimerController
    
    cell.delegate = self
    
    timerManager.fillSwimmerCells (indexPath.section, index: indexPath.row - 1, cell: &cell)
    
    return cell
  }
  
  func tableView (tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return timerManager.getNofSwimmers (section) + 1
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return timerManager.nofLanes
  }
  
  func tableView (tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    print("You selected cell #\(indexPath.row)!")
  }
  
  func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
  {
    return indexPath.row != 0 // Yes, the table view can be reordered
  }
  
  func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
  {
    if (indexPath.section == 0 && indexPath.row == 0)
    {
      return UITableViewCellEditingStyle.None
    }
    
    return UITableViewCellEditingStyle.Delete
  }
  
  func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath)
  {
    // Cannot move to before heading
    let toIndex = toIndexPath.row == 0 ? 0 : toIndexPath.row - 1
    
    timerManager.moveSwimmer (fromIndexPath.section, fromIndex: fromIndexPath.row - 1, toLane: toIndexPath.section, toIndex: toIndex)

    redraw ()
  }
  
  func tableView (tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
  {
    if editingStyle == UITableViewCellEditingStyle.Delete
    {
      if (indexPath.row == 0)
      {
        timerManager.deleteLane (indexPath.section)
      }
      else
      {
        timerManager.deleteSwimmer (indexPath.section, index: indexPath.row - 1)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
      }
      
      redraw ()
    }
  }
}

