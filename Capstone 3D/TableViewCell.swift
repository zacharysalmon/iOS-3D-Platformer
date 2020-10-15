//
//  TableViewCell1TableViewCell.swift
//  Capstone 3D
//
//  Created by Zack Salmon on 8/24/20.
//  Copyright © 2020 Zachary Salmon. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell
{

	
	@IBOutlet weak var place: UILabel!
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var score: UILabel!
	@IBOutlet weak var coins: UILabel!
	
	
    override func awakeFromNib()
	{
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
	{
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
