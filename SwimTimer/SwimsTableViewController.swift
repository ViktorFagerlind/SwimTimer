//
//  SwimsTableViewController.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 23/02/16.
//  Copyright © 2016 Viktor Fägerlind. All rights reserved.
//

import UIKit

class SwimsTableViewController: UITableViewController
{
  var currentSession : Session?

  override func viewDidLoad()
  {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func BackToSessions(sender: AnyObject)
  {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      if (currentSession == nil)
      {
        return 0
      }
      
      return currentSession!.swims.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
      let cell = tableView.dequeueReusableCellWithIdentifier ("swim_cell_id", forIndexPath: indexPath) as! SwimsCellController
      
      cell.nameLabel.text = String (currentSession!.swims[indexPath.row].length) + " meter"

      return cell
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
