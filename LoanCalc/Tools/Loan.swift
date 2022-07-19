//
//  Loan.swift
//  LoanCalc
//
//  Created by Mukhtar Myrzakhanov on 04.01.2022.
//

import Foundation


enum CalcMethod: String{
    case annuitet = "Аннуитет"
    case diferrentiated = "Дифференцированный"
}


protocol CalcParameters{
    var summa: Double { get set }
    var months: Int { get set }
    var percent: Double { get set }
}

let method = CalcMethod.annuitet
struct MounthlyPayment{
    let month: Int
    let summaOd: Double
    let summaFee: Double
    let monthlyPay: Double
}

extension Double {
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
}

class Loan{
    var summa: Double
    var months: Int
    var percent: Double
    var method: CalcMethod
    var totalSumm: Double = 0.0
    var monthlyPay: Double = 0.0
    var graf: [MounthlyPayment] = []

    // Расчет кредита 
    func calcLoan(){
        switch method{
        case .annuitet: // Расчет аннуитетом
            //print("Calc method annuitet")
            totalSumm = summa * ((percent / 100) * Double(months)) / 12 * (1+(1/(pow(1+((percent / 100)/12), Double(months))-1)))
            monthlyPay = totalSumm / Double(months)
            let multiplier: Double = 1 + (percent / 100) * 1 / 12 // Множитель
            var od = monthlyPay * pow(1 + (percent / 100) * 1 / 12, Double(months) * ( -1 ))
            graf.insert(MounthlyPayment(month: 1, summaOd: od, summaFee: monthlyPay - od, monthlyPay: monthlyPay), at: 0) // Определим первую запись
            // Рассчитаем остальной массив
            for idx in 1..<months{
                od = multiplier * graf[idx-1].summaOd
                graf.insert(MounthlyPayment(month: idx + 1, summaOd: od, summaFee: monthlyPay - od, monthlyPay: monthlyPay), at: idx)
            }
        case .diferrentiated: // Рассчет дифференцированный(ровнодолевой)
            //print("Differented method")
            let summaOd: Double = summa / Double(months)
            for idx in 1...months{
                monthlyPay = summaOd * (1.0 + (percent / 100) / 12.0 * (Double(months) + 1.0 - Double(idx)))
                totalSumm += monthlyPay
                graf.insert(MounthlyPayment(month: idx, summaOd: summaOd, summaFee: monthlyPay - summaOd, monthlyPay: monthlyPay), at: idx - 1)
            }
        }
    }
    
    init(summa: Double, months: Int, percent: Double, method: CalcMethod){
        self.summa = summa
        self.months = months
        self.percent = percent
        self.method = method
        calcLoan()
    }
}

var loan: Loan?
var summs: MounthlyPayment?
