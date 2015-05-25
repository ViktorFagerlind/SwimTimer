//
//  SwimmerCell.swift
//  SwimTimer
//
//  Created by Viktor Fägerlind on 24/05/15.
//  Copyright (c) 2015 Viktor Fägerlind. All rights reserved.
//

import UIKit

class SwimmerCell: UITableViewCell
{
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
 /*
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
  
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
  */
  func loadItem (#name: String, time: String)
  {
    nameLabel.text = name
    timeLabel.text = time
  }
  
}

