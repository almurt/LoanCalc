//
//  Loan.swift
//  LoanCalc
//
//  Created by Mukhtar Myrzakhanov on 04.01.2022.
//

import Foundation

private struct Constants {
    let fracts = 100.0
    let year = 12
}

enum CalcMethod: String {
    case annuitet = "Аннуитет"
    case differentiated = "Дифференцированный"
}


protocol CalcParameters {
    var summa: Double { get set }
    var months: Int { get set }
    var percent: Double { get set }
}

//let method = CalcMethod.annuitet
struct MounthlyPayment {
    let month: Int
    let summMainDebt: Double
    let summaFee: Double
    let monthlyPay: Double
}

extension Double {
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
}

class Loan {
    var summa: Double
    var months: Int
    var percent: Double
    var method: CalcMethod
    var totalSumm: Double = 0.0
    var monthlyPay: Double = 0.0
    var graf: [MounthlyPayment] = []

    init(summa: Double, months: Int, percent: Double, method: CalcMethod) {
        self.summa = summa
        self.months = months
        self.percent = percent
        self.method = method
        calcLoan()
    }
    
    // Расчет кредита 
    func calcLoan() {
        let constants = Constants()
        switch method{
        case .annuitet: // Расчет аннуитетом
            //print("Calc method annuitet")
            totalSumm = summa * ((percent / constants.fracts) * Double(months)) / Double(constants.year) * (1+(1/(pow(1+((percent / constants.fracts)/Double(constants.year)), Double(months))-1)))
            monthlyPay = totalSumm / Double(months)
            let multiplier: Double = 1 + (percent / constants.fracts) * 1 / Double(constants.year) // Множитель
            var mainDebt = monthlyPay * pow(1 + (percent / constants.fracts) * 1 / Double(constants.year), Double(months) * ( -1 ))
            graf.insert(MounthlyPayment(month: 1, summMainDebt: mainDebt, summaFee: monthlyPay - mainDebt, monthlyPay: monthlyPay), at: 0) // Определим первую запись
            // Рассчитаем остальной массив
            for idx in 1..<months{
                mainDebt = multiplier * graf[idx-1].summMainDebt
                graf.insert(MounthlyPayment(month: idx + 1, summMainDebt: mainDebt, summaFee: monthlyPay - mainDebt, monthlyPay: monthlyPay), at: idx)
            }
        case .differentiated: // Рассчет дифференцированный(ровнодолевой)
            //print("Differented method")
            let summMainDebt: Double = summa / Double(months)
            for idx in 1...months{
                monthlyPay = summMainDebt * (1.0 + (percent / constants.fracts) / Double(constants.year) * (Double(months) + 1.0 - Double(idx)))
                totalSumm += monthlyPay
                graf.insert(MounthlyPayment(month: idx, summMainDebt: summMainDebt, summaFee: monthlyPay - summMainDebt, monthlyPay: monthlyPay), at: idx - 1)
            }
        }
    }
    
    

}

extension Loan: Equatable {
    static func == (_ lhs: Loan, _ rhs: Loan) -> Bool {
        lhs.summa == rhs.summa &&
        lhs.months == rhs.months &&
        lhs.percent == rhs.percent &&
        lhs.method == rhs.method &&
        lhs.totalSumm == rhs.totalSumm &&
        lhs.monthlyPay == rhs.monthlyPay &&
        lhs.graf == rhs.graf
    }
    
}

extension MounthlyPayment: Equatable {
    static func == (_ lhs: MounthlyPayment, _ rhs: MounthlyPayment) -> Bool {
        lhs.month == rhs.month &&
        lhs.summMainDebt == rhs.summMainDebt &&
        lhs.summaFee == rhs.summaFee &&
        lhs.monthlyPay == rhs.monthlyPay
    }
    
}

var loan: Loan?
var summs: MounthlyPayment?
