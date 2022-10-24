//
//  GraffCell.swift
//  LoanCalc
//
//  Created by Mukhtar Myrzakhanov on 25.12.2021.
//

import UIKit

class GraffCell: UITableViewCell {

    @IBOutlet weak var lblSumma: UILabel!
    @IBOutlet weak var lblMonthNum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
