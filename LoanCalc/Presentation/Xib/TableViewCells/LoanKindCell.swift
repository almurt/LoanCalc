//
//  LoanKindCell.swift
//  LoanCalc
//
//  Created by Mukhtar Myrzakhanov on 24.10.2022.
//

import UIKit

class LoanKindCell: UITableViewCell {

    @IBOutlet weak var labelLoanKind: UILabel!
    //@IBOutlet weak var labelBankName: UILabel!
    @IBOutlet weak var labelBankName: UILabel!
    @IBOutlet weak var labelPercentValue: UILabel!
    //@IBOutlet weak var labelBank: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
