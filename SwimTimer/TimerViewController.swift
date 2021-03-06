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
  @IBOutlet var abortRestButton         : UIBarButtonItem!
  
  @IBOutlet var tableView               : UITableView!
  
  // Size adjustments
  var adjustedFont = DeviceType.IS_IPAD ? UIFont.systemFontOfSize (20.0) : UIFont.systemFontOfSize (15.0)
  var headerRowHeight : CGFloat = DeviceType.IS_IPAD ? 70 : 50
  var timerRowHeight  : CGFloat = DeviceType.IS_IPAD ? 50 : 40
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    //let headerNib = UINib(nibName: "LaneHeadingNib", bundle: nil)
    //self.tableView.registerNib (headerNib, forCellReuseIdentifier: "header_cell")
    
    //let cellNib = UINib(nibName: "SwimmerTimerNib", bundle: nil)
    //self.tableView.registerNib (cellNib, forCellReuseIdentifier: "swimmer_timer_id")
    
    ResultsManager.singleton // Load results
    
    //tableView.rowHeight = UITableViewAutomaticDimension
    
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
    
    editButton.enabled              = !timerManager.isRunning
    addLaneButton.enabled           = !timerManager.isRunning
    addSwimmerButton.enabled        = !timerManager.isRunning
    
    startStopSessionButton.enabled  = !timerManager.isRunning
    startButton.enabled             = timerManager.isInSession  && !timerManager.isRunning && !tableView.editing
    abortRestButton.enabled         = timerManager.isInSession  && timerManager.isRunning  && !tableView.editing
    
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
    
    timer = NSTimer.scheduledTimerWithTimeInterval (0.055, target: self, selector: #selector(TimerViewController.updateTimers), userInfo: nil, repeats: true)
    
    redraw ()
  }
  
  @IBAction func AbortRestButtonPressed (sender : AnyObject)
  {
    timerManager.abortRest ()
    redraw ()
  }

  @IBAction func StartStopSessionPressed (sender : AnyObject)
  {
    if !timerManager.isInSession
    {
      if timerManager.nofSwimmers > 0
      {
        let sessionNameAlert = UIAlertController (title: "Workout name", message: "Enter the name of the workout", preferredStyle: .Alert)
        sessionNameAlert.addTextFieldWithConfigurationHandler({ (textField) -> Void in textField.text = "Pass" })
        sessionNameAlert.addAction (UIAlertAction(title: "OK", style: .Default, handler:
        { (action) -> Void in
          let textField = sessionNameAlert.textFields![0] as UITextField
          self.timerManager.startSession (textField.text!, dateTime: NSDateFormatter.localizedStringFromDate (NSDate (), dateStyle: .MediumStyle, timeStyle: .ShortStyle))
          self.startStopSessionButton.title = "End Workout"
          self.redraw ()
        }))
        presentViewController (sessionNameAlert, animated: true, completion: nil)
        
      }
      else
      {
        let saveAlert = UIAlertController (title: "No Swimmers", message: "Cannot start session without any swimmers!\nPress '+' to choose swimmers for the lanes.", preferredStyle: UIAlertControllerStyle.Alert)
        saveAlert.addAction (UIAlertAction (title: "OK", style: .Default, handler: nil))
        presentViewController (saveAlert, animated: true, completion: nil)
      }
    }
    else
    {
      let saveAlert = UIAlertController (title: "Save Session", message: "Do you want to save the session", preferredStyle: UIAlertControllerStyle.Alert)
      saveAlert.addAction (UIAlertAction (title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in self.timerManager.stopSession (true);  self.redraw (); ResultsManager.singleton.saveToJson ()}))
      saveAlert.addAction (UIAlertAction (title: "No",  style: .Default, handler: { (action: UIAlertAction!) in self.timerManager.stopSession (false); self.redraw () }))
      presentViewController (saveAlert, animated: true, completion: nil)
      
      startStopSessionButton.title = "Start Workout"
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
      //abortRestButton.enabled = true
      
      timerManager.saveToJson ()
    }
    else
    {
      tableView.setEditing (true, animated: true);
      editButton.title      = "Done";
      editButton.style      =  UIBarButtonItemStyle.Done;
      //startButton.enabled   = false
      //abortRestButton.enabled = false
    }
    redraw ()
  }
  

  @IBAction func addLane(sender: AnyObject)
  {
    timerManager.addLane ()
    
    redraw ()
    
    timerManager.saveToJson ()
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
  {
    if segue.identifier == "choose_swimmer_segue"
    {
      let chooseSwimmerController = segue.destinationViewController as! ChooseSwimmerController
      chooseSwimmerController.timerManager = timerManager
    }
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
      
      redraw ()
      timerManager.saveToJson ()
    }
  }
  
  func tableView (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    if (indexPath.row == 0)
    {
      let headerCell : LaneHeaderController = tableView.dequeueReusableCellWithIdentifier ("timer_lane_cell_id", forIndexPath: indexPath)  as! LaneHeaderController
      
      headerCell.lane     = indexPath.section
      headerCell.delegate = self
      
      headerCell.title.text = "Lane \(indexPath.section)"
      headerCell.lapNextButton.enabled  = timerManager.isRunning
      headerCell.stopNextButton.enabled = timerManager.isRunning
      
      return headerCell
    }
    
    var cell : SwimmerTimerController =
      tableView.dequeueReusableCellWithIdentifier ("timer_swimmer_cell_id", forIndexPath: indexPath)  as! SwimmerTimerController
    
    cell.delegate = self
    
    // Adjust depending on size 
    if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5
    {
      cell.lapLabel.hidden = true
    }
    cell.lapLabel.font    = adjustedFont
    cell.timeLabel.font   = adjustedFont
    cell.stateLabel.font  = adjustedFont
    cell.nameLabel.font   = adjustedFont
    
    
    timerManager.fillSwimmerCells (indexPath.section, index: indexPath.row - 1, cell: &cell)
    
    
    return cell
  }
  
  func tableView (tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return timerManager.getNofSwimmers (section) + 1
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
  {
    return indexPath.row == 0 ? headerRowHeight : timerRowHeight
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
  
  override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool
  {
    if identifier == "choose_swimmer_segue" && SwimmerManager.singleton.nofSwimmers == 0
    {
      let saveAlert = UIAlertController (title: "No Swimmers", message: "There are no swimmers to choose from.\nPlease add swimmers to the 'Swimmers' tab.", preferredStyle: UIAlertControllerStyle.Alert)
      saveAlert.addAction (UIAlertAction (title: "OK", style: .Default, handler: nil))
      presentViewController (saveAlert, animated: true, completion: nil)
      
      return false
    }
    
    // by default, transition
    return true
  }
}

