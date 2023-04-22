//
//  APIClient.swift
//  LastFM Companion
//
//  Created by Ghiran Sergiu on 30.05.2021.
//

import Alamofire
import AlamofireImage

class APIClient {
    /**
     Executes an API request and decodes the response.
     
     - Parameters:
        - request: The request to be executed
        - completion: The response completion handler
     */
    func execute<T: Decodable>(request: Request, completion: @escaping (Result<T, APIError>) -> Void) {
        AF.request(request).responseDecodable(of: T.self) { response in
            guard let value = response.value,
                  response.error == nil
            else {
                if let code = response.error?.responseCode,
                   let error = APIError(rawValue: code) {
                    completion(.failure(error))
                } else {
                    completion(.failure(.undefined))
                }

                return
            }

            completion(.success(value))
        }
    }
}
