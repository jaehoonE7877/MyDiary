//
//  APIManager.swift
//  MyDiary
//
//  Created by Seo Jae Hoon on 2022/08/21.
//

import UIKit

import Alamofire
import SwiftyJSON

class UnsplashAPIManager {
    
    static let shared = UnsplashAPIManager()
    
    private init() { }
    
    func request(page: Int, query: String, completionHandler: @escaping ([String], Int) -> () ) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = "\(URL.baseURL)?page=\(page)&per_page=30&query=\(query)&client_id=\(APIKey.key)"
        AF.request(url, method: .get).validate().responseData(queue: .global()) { response in //앞쪽 접두어 AF로 바꿔야 함
            switch response.result {
            
            case .success(let value):
                let json = JSON(value)
                
                let imageList = json["results"].arrayValue.map { $0["urls"]["regular"].stringValue }
                let pageNum = json["total_pages"].intValue
                dump(pageNum)
                completionHandler(imageList, pageNum)
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
}
