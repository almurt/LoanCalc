//
//  HttpResponseStatus.swift
//  LoanCalc
//
//  Created by Mukhtar Myrzakhanov on 24.10.2022.
//

import Foundation


enum HttpResponseStatus: Int {
    case success = 200
    case pageNotFound = 404
    case serverError = 500
    case redirect = 301
    case unauthorised = 403
    case badGateway = 502
}
