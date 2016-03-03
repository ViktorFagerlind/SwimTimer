//
//  SwimmerCell.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 24/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import UIKit

protocol LaneHeaderDelegate
{
  func LapNext (lane : Int)
  func StopNext (lane : Int)
}

class LaneHeaderController: UITableViewCell
{
  enum State_E {case Idle, Waiting, Running}
  
  @IBOutlet var title:          UILabel!
  @IBOutlet var lapNextButton:  UIButton!
  @IBOutlet var stopNextButton: UIButton!
  
  var lane      : Int?
  var delegate  : LaneHeaderDelegate?

  @IBAction func LapNextButtonPressed (sender : AnyObject)
  {
    if (delegate != nil && lane != nil)
    {
      delegate!.LapNext (lane!)
    }
  }
  
  @IBAction func StopNextButtonPressed (sender : AnyObject)
  {
    if (delegate != nil && lane != nil)
    {
      delegate!.StopNext (lane!)
    }
  }

}

