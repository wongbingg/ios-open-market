//
//  URLSession.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/12.
//

import Foundation

class Manager {
    var fetchedData1: ProductPage?

    func dataTask(_ completion: @escaping (ProductPage) -> Void ) { // 내부에서 값이 올때까지 기다려야 한다. escaping closure를 이용해서
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var urlComponents = URLComponents(string: UrlData.urlHost.rawValue + "api/products?")
        let pageNo = URLQueryItem(name: "page_no", value: "1")
        let itemsPerPage = URLQueryItem(name: "items_per_page", value: "100")
        urlComponents?.queryItems?.append(pageNo)
        urlComponents?.queryItems?.append(itemsPerPage)
        guard let requestURL = urlComponents?.url else {
            return
        }
        let dataTask = session.dataTask(with: requestURL) { (data, response, error) in // escaping closure
            guard error == nil else {
                return
            }
            let successsRange = 200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successsRange.contains(statusCode) else {
                return
            }
            guard let resultData = data else {
                return
            }
            guard let fetchedData = decode(from: resultData, to: ProductPage.self) else {
                debugPrint("ERROR: FAILURE DECODING ")
                return
            }
            completion(fetchedData)
        }
        dataTask.resume()
//        Thread.sleep(forTimeInterval: 0.5) // 메인스레드 멈추면 x
    }
}
