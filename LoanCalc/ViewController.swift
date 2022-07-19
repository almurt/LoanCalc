//
//  ViewController.swift
//  LoanCalc
//
//  Created by Mukhtar Myrzakhanov on 21.12.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet var vwFirst: UIView!
    @IBOutlet weak var summaTxt: UITextField!
    @IBOutlet weak var monthsTxt: UITextField!
    @IBOutlet weak var percentTxt: UITextField!
    @IBOutlet weak var tblCalcs: UITableView!
    
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
        
        // TODO: Возьмем входные параметры из файла. По требованиям ДЗ №4
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
        
        // TODO: Соберем историю из CoreData. По требованиям ДЗ №4
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
        } catch {
            print("Erorr to load hidtory from CoreData")
        }
        
        getDB()
    }

    @IBAction func calculate(_ sender: Any) {
        let summa = atof(summaTxt.text)
        let months = atol(monthsTxt.text)
        let percent = atof(percentTxt.text)
        guard summa > 0 && months > 0 && percent > 0 else {return}
        
        loan = Loan(summa: summa, months: months, percent: percent, method: .annuitet)
        
        // TODO: Сохраним в файл введенные данные. По требоанию ДЗ №4
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
        
        // TODO: Сохраним в CoreData историю. По требованию ДЗ №4
        if let cDataContext = CoredataMngr.shared.context{
            if let entity = NSEntityDescription.entity(forEntityName: "LoanHist", in: cDataContext){
                let histNote = NSManagedObject(entity: entity, insertInto: cDataContext)
                histNote.setValue(summa, forKey: "summa")
                histNote.setValue(months, forKey: "months")
                histNote.setValue(percent, forKey: "percent")
                //histNote.setValue(loan?.method.rawValue ?? "NONE", forKey: "method")
                do{
                    try? cDataContext.save()
                    self.history?.append("Summa \(summa)")
                    tblCalcs.reloadData()
                } catch {
                    print("Error to save into CoreData")
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
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
