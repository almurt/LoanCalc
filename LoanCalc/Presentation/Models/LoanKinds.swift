//
//  LoanKinds.swift
//  LoanCalc
//
//  Created by Mukhtar Myrzakhanov on 24.10.2022.
//

import Foundation

class LoanKind {
    var kind: String
    var bank: String
    var percent: Double
    var firstPayPercent: Double
    
    init(kind: String = "", bank: String = "", percent: Double = 0.0, firstPayPercent: Double = 0.0) {
        self.kind = kind
        self.bank = bank
        self.percent = percent
        self.firstPayPercent = firstPayPercent
    }
}


extension LoanKind: Equatable {
    static func == (_ lhs: LoanKind, _ rhs: LoanKind) -> Bool {
        lhs.kind == rhs.kind &&
        lhs.bank == rhs.bank &&
        lhs.percent == rhs.percent &&
        lhs.firstPayPercent == rhs.firstPayPercent
    }
}


var kindList: [LoanKind] = []
