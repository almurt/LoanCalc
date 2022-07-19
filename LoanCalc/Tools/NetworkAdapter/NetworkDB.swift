//
//  NetworkDB.swift
//  LoanCalc
//
//  Created by Mukhtar Myrzakhanov on 23.03.2022.
//

import Foundation

struct NetworkDB: Codable{
    let kind: String
    let bank: String
    let percent: Double
    let firstPayPercent: Double
}

func getDB(){
    let url = URL(string: "https://mukhtar.kz/test/")
    let session = URLSession(configuration: .default)
    
    let task = session.dataTask(with: url!) { data, response, error in
        guard let urlResponse = response as? HTTPURLResponse else { return }
        if urlResponse.statusCode == 200 {
            let stringResponse = String(data: data!, encoding: .utf8)
            
            let dbLoan = try! JSONDecoder().decode([NetworkDB].self, from: data!)
        } else {
            print("Status error : \(urlResponse.statusCode)")
        }
    }
    task.resume()
}
