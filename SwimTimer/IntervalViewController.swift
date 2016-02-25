//
//  SwimsTableViewController.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 23/02/16.
//  Copyright © 2016 Viktor Fägerlind. All rights reserved.
//

import UIKit

class IntervalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
  @IBOutlet var tableView : UITableView!
  
  @IBOutlet var navigationBar: UINavigationBar!
  var currentInterval : Interval?

  override func viewDidLoad()
  {
    super.viewDidLoad()

    //tableView.clearsSelectionOnViewWillAppear = false
  }

  override func viewDidAppear(animated: Bool)
  {
    super.viewDidAppear(animated)
    
    navigationBar.topItem!.title = String (currentInterval!.length) + " meters"
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Table view data source

  func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    if (currentInterval == nil)
    {
      return 0
    }
    
    return currentInterval!.individualIntervals.count
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    if (currentInterval == nil)
    {
      return 0
    }
    
    return currentInterval!.individualIntervals[section].lapTimes.count + 1 // Add one for the section header
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    if (indexPath.row == 0)
    {
      let cell = tableView.dequeueReusableCellWithIdentifier ("swimmer_name_cell_id", forIndexPath: indexPath) as! SwimmerResultCellController
      
      cell.nameLabel.text = String (currentInterval!.individualIntervals[indexPath.section].swimmerName)
      cell.timeLabel.text = TimerManager.timeToString (currentInterval!.individualIntervals[indexPath.section].time)
      
      return cell
    }
    
    let cell = tableView.dequeueReusableCellWithIdentifier ("lap_cell_id", forIndexPath: indexPath) as! LapCellController
    
    cell.lengthLabel.text = String (currentInterval!.individualIntervals[indexPath.section].lapLength) + "m"
    cell.timeLabel.text   = TimerManager.timeToString (currentInterval!.individualIntervals[indexPath.section].lapTimes[indexPath.row-1])

    return cell
  }
}
