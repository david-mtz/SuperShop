//
//  APIClient.swift
//  SuperShop
//
//  Created by David on 5/7/19.
//  Copyright © 2019 David. All rights reserved.
//

import Foundation

class APIClient<T> where T: Codable {
    let client: Client
    let path: String

    typealias codableResponse = (T) -> Void
    typealias codableResponseList = ([T]) -> Void

    init(client: Client, path: String) {
        self.client = client
        self.path = path
    }

    func show(success: @escaping codableResponse) {
        request("GET", path: "\(path)", payload: nil, success: success, errorHandler: nil)
    }

    func show(id: Int, success: @escaping codableResponse) {
        show(id: "\(id)", success: success)
    }
    
    func show(id: String, success: @escaping codableResponse) {
        request("GET", path: "\(path)/show/\(id)", payload: nil, success: success, errorHandler: nil)
    }

    private func request(_ method: String, path: String, payload: T?, success: @escaping codableResponse, errorHandler: errorHandler?) {
        request(method, path: path, queryItems: nil, payload: payload, success: success, errorHandler: errorHandler)
    }

    private func request(_ method: String, path: String, queryItems: [String: String]?, payload: T?, success: @escaping codableResponse, errorHandler: errorHandler?) {
        let data = encode(payload: payload)
        client.request(method, path: path, queryItems: queryItems, body: data, completionHandler: { (response, data) in
            guard response.successful() else { return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                guard let data = data else { print("Empty response"); return }
                let json = try decoder.decode(JSONResponse<T>.self, from: data)
                //print("===================================================================")
                success(json.data)
            } catch let err {
                //print(path)
                print("Unable to parse successfull response: \(err.localizedDescription)")
                errorHandler?(err)
            }
        }, errorHandler: errorHandler)
    }


    private func encode(payload: T?) -> Data? {
        guard let payload = payload else { return nil }
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try? encoder.encode(payload)
    }


}
