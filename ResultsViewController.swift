//
//  ResultsViewController.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 23/02/16.
//  Copyright © 2016 Viktor Fägerlind. All rights reserved.
//

import UIKit

class ResultsViewController: UITableViewController
{
  
    override func viewDidLoad()
    {
      super.viewDidLoad()

      clearsSelectionOnViewWillAppear = false

      tableView.contentInset = UIEdgeInsetsMake (50, 0, 0, 0);
      
      initRandomResults ()
      
      // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
      // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
  
    func initRandomResults ()
    {
      for day in 0...14
      {
        let dateTime = NSCalendar.currentCalendar().dateByAddingUnit(
          .Day,
          value:    15 - day,
          toDate:   NSDate (),
          options:  NSCalendarOptions(rawValue: 0))
        
        let timestamp = NSDateFormatter.localizedStringFromDate (dateTime!, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        
        let session = Session (name: "Pass", dateTime: timestamp)
        
        let rndTotalLenth = (Int (rand()) % (40) + 30)*50
        var totalLength : Int = 0
        
        while totalLength < rndTotalLenth
        {
          let interval = Interval ()
          
          let nofLengths : Int = Int (rand () % 8) + 1
          for i in 0...(SwimmerManager.singleton.nofSwimmers-1)
          {
            let individualInterval = IndividualInterval (swimmerName : SwimmerManager.singleton.getSwimmer(i).name, lapLength: SettingsManager.singleton.poolLength)
            
            for _ in 0...(nofLengths-1)
            {
              individualInterval.appendLapTime (NSTimeInterval ((Double (arc4random ()) /  Double (UINT32_MAX)) * 25.0 + 35.0))
            }
            
            interval.appendIndividualInterval (individualInterval)
          }
          totalLength += interval.length
          
          session.appendSwim (interval)
        }
        ResultsManager.singleton.addSession (session)
      }
    }
  
  @IBAction func backFromSessionSegue (segue:UIStoryboardSegue)
  {
  }

    override func didReceiveMemoryWarning()
    {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
      return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      return ResultsManager.singleton.nofSessions
    }

    func getSessionFromIndexPath (indexPath : NSIndexPath) -> Session
    {
      return ResultsManager.singleton.getSession (ResultsManager.singleton.nofSessions - indexPath.row - 1)
    }
  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
      let cell = tableView.dequeueReusableCellWithIdentifier ("session_cell_id", forIndexPath: indexPath)  as! SessionCellController

      let session = getSessionFromIndexPath (indexPath)
      
      cell.nameLabel.text = session.name + " (" + String (session.length) + "m)"
      cell.timeLabel.text = session.dateTime
      
      return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
      if segue.identifier == "show_session_seque_id"
      {
        let swimsViewController = segue.destinationViewController as! SessionViewController
        
        // Get the cell that generated this segue.
        if let selectedSessionCell = sender as? SessionCellController
        {
          let indexPath = tableView.indexPathForCell (selectedSessionCell)!
          let session = getSessionFromIndexPath (indexPath)
          
          swimsViewController.currentSession = session
        }
      }
    }
  

}
