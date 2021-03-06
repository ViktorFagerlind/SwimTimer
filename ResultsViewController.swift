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
      
      // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
      // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
  
    // Redraw table if sessions have been added
    override func viewDidAppear (animated: Bool)
    {
      super.viewDidAppear(animated)
    
      tableView.reloadData ()
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
