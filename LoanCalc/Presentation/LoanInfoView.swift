//
//  LoanInfoView.swift
//  LoanCalc
//
//  Created by Mukhtar Myrzakhanov on 25.01.2022.
//

import UIKit

class LoanInfoView: UIViewController{

    let grafCell = "GraffCell"
    @IBOutlet var vwResult: UIView!
    @IBOutlet weak var tblGraf: UITableView!
    @IBOutlet weak var lblSumma: UILabel!
    @IBOutlet weak var lblMonths: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblGraf.register(UINib.init(nibName: grafCell, bundle: nil), forCellReuseIdentifier: grafCell)
        //tblGraf.separatorColor
        lblSumma.text = "Loan summa \(String(loan?.summa ?? 0.0))"
        lblSumma.font = .sumFont()
        lblMonths.text = "Months \(String(loan?.months ?? 0))"
        lblMonths.font = .sumFont()
        
        tblGraf.reloadData()
        vwResult.backgroundColor = .Theme.MainColor
        // Do any additional setup after loading the view.

    }

}

extension LoanInfoView: UITableViewDelegate, UITableViewDataSource{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loan?.graf.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblGraf.dequeueReusableCell(withIdentifier: grafCell, for: indexPath) as! GraffCell
        cell.selectionStyle = .none
        let summa = loan?.graf[indexPath.row]
        
        cell.lblSumma.text = "\(String(summa?.month ?? 0)). \(String(summa?.monthlyPay.rounded(digits: 2) ?? 0.00))"
        cell.lblMonthNum.text = "Main debth \(String(summa?.summMainDebt.rounded(digits: 2) ?? 0.0)). Fee \(String(summa?.summaFee.rounded(digits: 2) ?? 0.0))"
        cell.lblSumma.font = .sumFont()
        cell.backgroundColor = .Theme.TableResultColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        summs = loan?.graf[indexPath.row]
        //print("summa fee = \(indexPath.row) - \(summs?.summaFee ?? 0)")
        self.performSegue(withIdentifier: "showGrafCell", sender: self) // переход на подробную информацию по суммам выплат за месяц
    }
    
}
