//
//  NetworkService.swift
//  LoanCalc
//
//  Created by Mukhtar Myrzakhanov on 23.03.2022.
//

import Foundation

protocol NetworkService{
    func getKindList(completion: KindListCallback?)
}

final class NetworkServiceImpl: NetworkService{
    private let host = "https://mukhtar.kz/test/"
    private let decoder = JSONDecoder()
    
    private lazy var sessionConfig: URLSessionConfiguration = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.allowsCellularAccess = true
        return sessionConfig
    }()
    
    private lazy var session = URLSession(configuration: sessionConfig)
    
    func getKindList(completion: KindListCallback?) {
        guard let url = URL(string: host) else {
            completion?(.failure(.wrongUrl(host)))
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { [weak self] data, response, error  in
            guard let self = self else {
                return
            }
            if let error = error {
                completion?(.failure(.httpRequestError(error.localizedDescription)))
            }
            
            print("Its work")

            let handledResult = self.handleDefaultResponse(response)
            switch handledResult {
            case .success:
                if let data = data {
                    self.handleKindResult(fromData: data, completion: completion)
                } else {
                    completion?(.failure(.dataIsAbsent))
                }
            case let .failure(error):
                completion?(.failure(error))
            }
        }
        task.resume()
    }
    
    private func handleKindResult(fromData data: Data, completion: KindListCallback?) {
        do {
            let parsedResponse = try JSONDecoder().decode([LoanKindElement].self, from: data)
            completion?(.success(parsedResponse))
        } catch {
            print(error)
            completion?(.failure(.responseParsingError))
        }
    }
    
    private func handleDefaultResponse(_ response: URLResponse?) -> BaseNetworkResult {
        guard let response = response as? HTTPURLResponse else {
            return .failure(.wrongResponseType)
        }

        if  response.statusCode == 200 {
            return .success(())
        } else {
            return .failure(.wrongResponseStatus(response.statusCode))
        }
    }
}
