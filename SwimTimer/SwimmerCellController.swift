//
//  SwimmerCell.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 24/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import UIKit

protocol SwimmerCellDelegate
{
  func StopIndividualSwimmer (cellName : String)
}

class SwimmerCellController: UITableViewCell
{
  enum State_E {case Idle, Waiting, Running}
  
  @IBOutlet var stateLabel:   UILabel!
  @IBOutlet var nameLabel:    UILabel!
  @IBOutlet var timeLabel:    UILabel!
  
  var delegate : SwimmerCellDelegate?

  
  @IBAction func StopButtonPressed (sender : AnyObject)
  {
    if (delegate != nil)
    {
      delegate!.StopIndividualSwimmer (nameLabel.text!)
    }
  }

}

