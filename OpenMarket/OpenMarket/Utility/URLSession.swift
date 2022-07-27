//
//  URLSession.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/12.
//

import Foundation
import UIKit

class NetworkManager {
    
    func dataTask(_ completion: @escaping ([Product]) -> Void ) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var urlComponents = URLComponents(string: URLData.host.rawValue + URLData.lookUpProductList.rawValue)
        let pageNo = URLQueryItem(name: "page_no", value: "1")
        let itemsPerPage = URLQueryItem(name: "items_per_page", value: "20")
        urlComponents?.queryItems?.append(pageNo)
        urlComponents?.queryItems?.append(itemsPerPage)
        guard let requestURL = urlComponents?.url else {
            return
        }
        let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
            guard error == nil else {
                return
            }
            let successsRange = 200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successsRange.contains(statusCode) else {
                return
            }
            guard let resultData = data,
                  let fetchedData = decode(from: resultData, to: ProductPage.self) else {
                debugPrint("ERROR: FAILURE DECODING ")
                return
            }
            completion(fetchedData.pages)
        }
        dataTask.resume()
    }
    
    func requestPost(components: [Any]?, _ completion: @escaping (ProductDetail) -> Void ) throws {
        //post URL = API HOST + PATH
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let urlComponents = URLComponents(string: URLData.host.rawValue + URLData.registProduct.rawValue)
        guard let url = urlComponents?.url else {
            return
        }
        //post body에 들어갈 데이터 생성
        let param = ProductRegistration(name: "곧 지워질 국밥", price: 8000, discountedPrice: 7500, stock: 1, currency: Currency.krw, secret: URLData.secretKey.rawValue , descriptions: "먹고싶다")
        guard let paramData = try? JSONEncoder().encode(param) else {
            return
        }
        let images = [UIImage(named: "국밥")] // 이름이 두번 쓰임
        
        // HTTP Body에 들어갈 내용 작성
        let boundary = UUID().uuidString
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(URLData.boryIdentifier.rawValue, forHTTPHeaderField: "identifier")
        
        var data = Data()
        guard let startBoundaryData = "\r\n--\(boundary)\r\n".data(using: .utf8) else {
            return
        }
        data.append(startBoundaryData)
        
        // params 설정
        guard let paramsAttribute = "Content-Disposition: form-data; name=\"params\"\r\n\r\n".data(using: .utf8) else {
            return
        }
        data.append(paramsAttribute)
        data.append(paramData)
        
        // images 설정
        for (index, image) in images.enumerated() {
            data.append(startBoundaryData)
            let fileName = "국밥" // 이름이 두번 쓰임
            
            data.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(fileName).png\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append((image?.jpegData(compressionQuality: 0.2))!)
        }
        guard let endBoundaryData = "\r\n--\(boundary)--\r\n".data(using: .utf8) else {
            return
        }
        data.append(endBoundaryData)
        
        // 만든 data를 바디에 주입
        request.httpBody = data
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            let successsRange = 200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successsRange.contains(statusCode) else {
                return
            }
            guard let resultData = data else {
                debugPrint("ERROR: FAILURE DECODING ")
                return
            }
            print(String(data: resultData, encoding: .utf8))
        }
        dataTask.resume()
    }
    
    func searchSecretKey(id: Int, completion: @escaping (Int, String) -> ()) {
        //post URL = API HOST + PATH
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let urlComponents = URLComponents(string: URLData.host.rawValue + URLData.registProduct.rawValue + "/\(id)/secret")
        guard let url = urlComponents?.url else {
            return 
        }
        let parameters = "{\"secret\": \"\(URLData.secretKey.rawValue)\"}"
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(URLData.boryIdentifier.rawValue, forHTTPHeaderField: "identifier")
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            let successsRange = 200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successsRange.contains(statusCode) else {
                return
            }
            guard let resultData = data else {
                debugPrint("ERROR: FAILURE DECODING ")
                return
            }
            completion(id, String(data: resultData, encoding: .utf8)!)
        }
        dataTask.resume()
    }
    
    func deleteItem(id: Int, secretKey: String) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let urlComponents = URLComponents(string: URLData.host.rawValue + URLData.registProduct.rawValue + "/\(id)/\(secretKey)")
        guard let url = urlComponents?.url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(URLData.boryIdentifier.rawValue, forHTTPHeaderField: "identifier")
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            let successsRange = 200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successsRange.contains(statusCode) else {
                return
            }
            guard let resultData = data else {
                debugPrint("ERROR: FAILURE DECODING ")
                return
            }
            print(String(data: resultData, encoding: .utf8)!)
        }
        dataTask.resume()
    }
    
    func modifyItem(id: Int, secret: String = URLData.secretKey.rawValue, name: String? = nil, descriptions: String? = nil,
                    thumbnailId: String? = nil, price: Int? = nil, currency: Currency? = nil,
                    discountedPrice: Int? = nil, stock: Int? = nil) {
        var dic = ["secret": nil, "name": nil, "descriptions": nil, "thumbnail_id": nil, "price": nil, "currency": nil, "discounted_price": nil, "stock": nil] as [String : Any?]
        dic["secret"] = secret
        dic["name"] = name
        dic["descriptions"] = descriptions
        dic["thumbnail_id"] = thumbnailId
        dic["price"] = price
        dic["currency"] = currency?.rawValue
        dic["discounted_price"] = discountedPrice
        dic["stock"] = stock

        var result: [String] = []
        for (key, value) in dic {
            if value != nil {
                if value is String || value is Currency {
                    result.append("\"\(key)\": \"\(value!)\"")
                } else {
                    result.append("\"\(key)\": \(value!)")
                }
            }
        }
        modifyData(id: id, modifyData: "{\(result.joined(separator: ","))}")
    }
    
    func modifyData(id: Int, modifyData: String) {
        //post URL = API HOST + PATH
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let urlComponents = URLComponents(string: URLData.host.rawValue + URLData.registProduct.rawValue + "/\(id)")
        guard let url = urlComponents?.url else {
            return
        }
        let parameters = modifyData
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.httpBody = postData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(URLData.boryIdentifier.rawValue, forHTTPHeaderField: "identifier")
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            let successsRange = 200..<300
            print(String(data: data!, encoding: .utf8)!)
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successsRange.contains(statusCode) else {
                return
            }
            guard let resultData = data else {
                debugPrint("ERROR: FAILURE DECODING ")
                return
            }
        }
        dataTask.resume()
    }
}
