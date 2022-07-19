//
//  ViewGrafItem.swift
//  LoanCalc
//
//  Created by Mukhtar Myrzakhanov on 08.02.2022.
//

import UIKit

class ViewGrafItem: UIViewController {
    @IBOutlet var vwGrafItm: UIView!
    @IBOutlet weak var lblMonthlyPayment: UILabel!
    @IBOutlet weak var lblODSumm: UILabel!
    @IBOutlet weak var lblFeeSumm: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwGrafItm.backgroundColor = .Theme.MainColor
        lblMonthlyPayment.font = .cellFont()
        lblMonthlyPayment.text = "Monthly payment \(String(summs?.monthlyPay.rounded(digits: 2) ?? 0.0))"
        lblODSumm.font = .cellFont()
        lblODSumm.text = "Main debth \(String(summs?.summaOd.rounded(digits: 2) ?? 0.0))"
        lblFeeSumm.font = .cellFont()
        lblFeeSumm.text = "Fee amount \(String(summs?.summaFee.rounded(digits: 2) ?? 0.0))"
        // Do any additional setup after loading the view.
    }  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
