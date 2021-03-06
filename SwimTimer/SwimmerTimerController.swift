//
//  SwimmerCell.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 24/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import UIKit

protocol SwimmerTimerDelegate
{
  func StopIndividualSwimmer (cellName : String)
  func LapIndividualSwimmer (cellName : String)
}

class SwimmerTimerController: UITableViewCell
{
  enum State_E {case Idle, Waiting, Running}
  
  @IBOutlet var stateLabel:   UILabel!
  @IBOutlet var nameLabel:    UILabel!
  @IBOutlet var timeLabel:    UILabel!
  @IBOutlet var lapLabel:     UILabel!

  @IBOutlet var stopButton:   UIButton!
  @IBOutlet var lapButton:    UIButton!
  
  var delegate : SwimmerTimerDelegate?

  
  @IBAction func StopButtonPressed (sender : AnyObject)
  {
    if (delegate != nil)
    {
      delegate!.StopIndividualSwimmer (nameLabel.text!)
    }
  }

  @IBAction func LapButtonPressed (sender : AnyObject)
  {
    if (delegate != nil)
    {
      delegate!.LapIndividualSwimmer (nameLabel.text!)
    }
  }
  
}

