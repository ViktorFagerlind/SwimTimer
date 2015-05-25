//
//  SecondViewController.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 22/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.registerClass (UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        var nib = UINib(nibName: "SwimmerCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "swimmer_cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var tableView : UITableView!
    var items: [(String, String)] = [
        ("Viktor",      "01:34.192"),
        ("Tomas",       "01:37.819"),
        ("Johan",       "01:43.719"),
        ("Torbjörn",    "02:18.145"),
        ("Emma",        "02:21.231")
    ]
    
    func tableView (tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count;
    }
    
    func tableView (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        /*
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
        */
        
        var cell: SwimmerCell = self.tableView.dequeueReusableCellWithIdentifier("swimmer_cell") as! SwimmerCell
        
        var (name, time) = items[indexPath.row]
        
        cell.loadItem(name: name, time: time)
        
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
}

