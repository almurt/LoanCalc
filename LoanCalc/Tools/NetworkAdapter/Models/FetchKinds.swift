//
//  FetchKinds.swift
//  LoanCalc
//
//  Created by Mukhtar Myrzakhanov on 24.10.2022.
//

import Foundation

struct LoanKindElement: Codable {
    let kind, bank: String
    let percent, firstPayPercent: Double
}
