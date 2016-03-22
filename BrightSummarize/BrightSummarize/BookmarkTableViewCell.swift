//
//  BookmarkTableViewCell.swift
//  BrightSummarize
//
//  Created by 查明轩 on 3/21/16.
//  Copyright © 2016 Mingxuan Zha. All rights reserved.
//

import UIKit

class BookmarkTableViewCell: UITableViewCell {

	@IBOutlet weak var sumText: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
