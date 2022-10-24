//
//  NetworkError.swift
//  LoanCalc
//
//  Created by Mukhtar Myrzakhanov on 22.03.2022.
//

import Foundation

enum NetworkError: Error {
    case httpRequestError(String)
    case wrongResponseType
    case wrongResponseStatus(Int)
    case responseParsingError
    case wrongUrl(String)
    case dataIsAbsent
}
