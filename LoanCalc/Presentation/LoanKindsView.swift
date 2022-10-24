//
//  LoanKindsView.swift
//  LoanCalc
//
//  Created by Mukhtar Myrzakhanov on 24.10.2022.
//

import UIKit
import CoreData
class LoanKindsView: UIViewController {
    
    let cellId = "LoanKindCell"
    private let networkService = NetworkServiceImpl()
    //@IBOutlet weak var tableViewKinds: UITableView!
    @IBOutlet weak var tableViewKIndsList: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewKIndsList.register(UINib.init(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)

        if kindList.count == 0 {
            fetchKinds()
        } else {
            tableViewKIndsList.reloadData()
        }
    }
    
    private func fetchKinds() {
        networkService.getKindList(){ [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case let .success(data):
                print(data[0].kind)
                let kind = data.map {
                    self.convertToKind(networkList: $0)
                }
                kindList.append(contentsOf: kind)
                DispatchQueue.main.async {
                    self.tableViewKIndsList.reloadData()
                }
            case let .failure(error):
                self.handleNetworkError(error)
            }
        }
    }
    
    private func handleNetworkError(_ error: NetworkError) {
        switch(error) {
        case NetworkError.wrongUrl(let url):
            print("We have wrong url : \(url)")
        case NetworkError.wrongResponseType:
            print("Error converting response to HTTPURLResponse")
        default:
            print("Something else")
        }
    }

    func convertToKind(networkList: LoanKindElement) -> LoanKind {
        let kind = LoanKind(kind: networkList.kind, bank: networkList.bank, percent: networkList.percent, firstPayPercent: networkList.firstPayPercent)
        saveToCD(kind: kind)
        return kind
    }
    
    func saveToCD(kind: LoanKind) {
        if let context = CoredataMngr.shared.context {
            if  let entity = NSEntityDescription.entity(forEntityName: "LoanKinds", in: context){
                let kindObject = NSManagedObject(entity: entity, insertInto: context)
                kindObject.setValue(kind.kind, forKey: "kind")
                kindObject.setValue(kind.bank, forKey: "bank")
                kindObject.setValue(kind.percent, forKey: "percent")
                kindObject.setValue(kind.firstPayPercent, forKey: "firstPayPercent")
                do {
                    try? context.save()
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension LoanKindsView: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kindList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! LoanKindCell
        cell.selectionStyle = .none
        let kind = kindList[indexPath.row]
        cell.labelLoanKind.text = kind.kind
        cell.labelBankName.text = kind.bank
        cell.labelPercentValue.text = String(kind.percent)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let kind = kindList[indexPath.row]
        //print(kind.bank)
    }
}

