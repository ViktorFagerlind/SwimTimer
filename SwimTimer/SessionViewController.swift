//
//  SwimsTableViewController.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 23/02/16.
//  Copyright © 2016 Viktor Fägerlind. All rights reserved.
//

import UIKit

class SessionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
  @IBOutlet var tableView : UITableView!
  
  @IBOutlet var navigationBar: UINavigationBar!
  var currentSession : Session?

  override func viewDidLoad()
  {
    super.viewDidLoad()

    //tableView.clearsSelectionOnViewWillAppear = false
  }

  override func viewDidAppear(animated: Bool)
  {
    super.viewDidAppear(animated)
    
    navigationBar.topItem!.title = currentSession!.name + " - " + currentSession!.dateTime
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  /*
  @IBAction func BackToSessions(sender: AnyObject)
  {
    dismissViewControllerAnimated(true, completion: nil)
  }
*/
  
    @IBAction func backFromIntervalSegue (segue:UIStoryboardSegue)
    {
    }
  
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      if (currentSession == nil)
      {
        return 0
      }
      
      return currentSession!.intervals.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
      let cell = tableView.dequeueReusableCellWithIdentifier ("interval_cell_id", forIndexPath: indexPath) as! IntervalCellController
      
      let interval = currentSession!.intervals[indexPath.row]
      cell.nameLabel.text = String (interval.length) + " meter (" + TimerManager.timeToString (interval.bestResult) + ")"

      return cell
    }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
  {
    if segue.identifier == "show_interval_seque_id"
    {
      let intervalViewController = segue.destinationViewController as! IntervalViewController
      
      // Get the cell that generated this segue.
      if let selectedInterval = sender as? IntervalCellController
      {
        let indexPath = tableView.indexPathForCell (selectedInterval)!
        intervalViewController.currentInterval = currentSession!.intervals[indexPath.row]
      }
    }
  }

}
