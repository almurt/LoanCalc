//
//  ViewController.swift
//  LoanCalc
//
//  Created by Mukhtar Myrzakhanov on 21.12.2021.
// Main View Controller

import UIKit
import CoreData
import SwiftUI

class ViewController: UIViewController {

    @IBOutlet var vwFirst: UIView!
    @IBOutlet weak var summaTxt: UITextField!
    @IBOutlet weak var monthsTxt: UITextField!
    @IBOutlet weak var percentTxt: UITextField!
    @IBOutlet weak var tblCalcs: UITableView!
    @IBOutlet weak var calcMethodSegmentControl: UISegmentedControl!
    
    let fileManager = FileManager.default
    var fileUrl: URL?
    let historyCell = "HistoryCell"
    var history: [String]?
    
    // Структура JSON для сохранения в файл
    struct LoanSavParams: Encodable, Decodable{
        let summa: Double
        let months: Int
        let percent: Double
        
        init(summa: Double, months: Int, percent: Double){
            self.summa = summa
            self.months = months
            self.percent = percent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwFirst.backgroundColor = .Theme.MainColor
        tblCalcs.register(UINib.init(nibName: historyCell, bundle: nil), forCellReuseIdentifier: historyCell)
        // Do any additional setup after loading the view.
        
        // TODO: Возьмем входные параметры из файла
        if let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            fileUrl = url.appendingPathComponent("params").appendingPathExtension("json")
            if fileUrl != nil {
              do {
                  let jsonParams = try JSONDecoder().decode(LoanSavParams.self, from: Data(contentsOf: fileUrl!))
                  summaTxt.text = String(jsonParams.summa)
                  monthsTxt.text = String(jsonParams.months)
                  percentTxt.text = String(jsonParams.percent)
              } catch {
                  print("Error to read file \(fileUrl!)")
              }
            }
        }
        
        // MARK: Соберем историю из CoreData
        let request = NSFetchRequest<NSManagedObject>(entityName: "LoanHist")
        self.history = [String]()
        do {
            if let cDataContext = CoredataMngr.shared.context{
                if let cDataData = try? cDataContext.fetch(request){
                    for hist in cDataData{
                        let histSumma: Double = hist.value(forKey: "summa") as! Double
                        let histMonths: Int = hist.value(forKey: "months") as! Int
                        let histPercent: Double = hist.value(forKey: "percent") as! Double
                        let item: String = "Summa \(histSumma), months \(histMonths), percent \(histPercent)"
                        self.history?.append(item)
                    }
                }
            
                tblCalcs.reloadData()
            }
        }
        
        // MARK: подгрузим виды кредитов
        let reqKinds = NSFetchRequest<NSManagedObject>(entityName: "LoanKinds")
        self.history = [String]()
        do {
            if let cDataContext = CoredataMngr.shared.context{
                if let cDataData = try? cDataContext.fetch(reqKinds){
                    kindList.removeAll()
                    for hist in cDataData{
                        let kind = LoanKind(kind: hist.value(forKey: "kind") as! String, bank: hist.value(forKey: "bank") as! String, percent: hist.value(forKey: "percent") as! Double, firstPayPercent: hist.value(forKey: "firstPayPercent") as! Double)
                        
                        kindList.append(kind)
                    }
                }
                tblCalcs.reloadData()
            }
        }
        
        //getDB()
    }

    @IBAction func calculate(_ sender: Any) {
        let summa = atof(summaTxt.text)
        let months = atol(monthsTxt.text)
        let percent = atof(percentTxt.text)
        let calcMethod = CalcMethod(rawValue: calcMethodSegmentControl.selectedSegmentIndex) ?? .annuitet
        guard summa > 0 && months > 0 && percent > 0 else {return}
        
        loan = Loan(summa: summa, months: months, percent: percent, method: calcMethod)
        // TODO: Сохраним в файл введенные данные
        let savParams = LoanSavParams(summa: summa, months: months, percent: percent)
        let encoder = JSONEncoder()
        let dataToSavParams = try! encoder.encode(savParams)
        
            if fileUrl != nil {
            do {
                try dataToSavParams.write(to: fileUrl!)
            } catch {
                print("Error to save file \(fileUrl!)") // в случае не удачи выведем в консоль ошибку
            }
        }
        
        // TODO: Сохраним в CoreData историю
        if let cDataContext = CoredataMngr.shared.context{
            if let entity = NSEntityDescription.entity(forEntityName: "LoanHist", in: cDataContext){
                let histNote = NSManagedObject(entity: entity, insertInto: cDataContext)
                histNote.setValue(summa, forKey: "summa")
                histNote.setValue(months, forKey: "months")
                histNote.setValue(percent, forKey: "percent")
                histNote.setValue(calcMethod.rawValue, forKey: "calcMethod")
                //histNote.setValue(loan?.method.rawValue ?? "NONE", forKey: "method")
                do{
                    try? cDataContext.save()
                    self.history?.append("Summa \(summa)")
                    tblCalcs.reloadData()
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    
    @IBAction func logInUser(_ sender: Any) {
        let loginForm = UIHostingController(rootView: UserAuth())
        navigationController?.pushViewController(loginForm, animated: true)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.history?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellHist = tblCalcs.dequeueReusableCell(withIdentifier: historyCell, for: indexPath) as! HistoryCell
        cellHist.selectionStyle = .none
        let historyItem: String = self.history?[indexPath.row] ?? ""
        cellHist.lblDescription.text = historyItem
        cellHist.lblDescription.font = .descFont()
        cellHist.backgroundColor = .Theme.TableResultColor
        
        
        return cellHist
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
