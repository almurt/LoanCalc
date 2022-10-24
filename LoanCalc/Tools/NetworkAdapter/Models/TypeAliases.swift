//
//  TypeAliases.swift
//  LoanCalc
//
//  Created by Mukhtar Myrzakhanov on 24.10.2022.
//

import Foundation

typealias KindListCallback = (Result<[LoanKindElement], NetworkError>) -> Void
typealias BaseNetworkResult = Result<Void, NetworkError>
