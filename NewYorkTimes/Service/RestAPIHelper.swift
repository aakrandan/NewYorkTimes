//
//  RestAPIHelper.swift
//  NewYorkTimes
//
//  Created by Ananth Kamath on 09/06/22.
//

import Foundation
import UIKit

class RestAPIHelper: NSObject {
    
    static let shared = RestAPIHelper()
    
    private override init() { }
    
    func getNewArticleDataFromURL(url: String, completion: @escaping(MostViewedNews) -> ()) {
        getJSONDataForURL(url: url) { data in
            
            do {
                let jsonResponse = try JSONDecoder().decode(MostViewedNews.self, from: data)
                completion(jsonResponse)
            }
            catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
            
        }
    }
    
    func imageFromServerURL(urlString: String, completion: @escaping(UIImage) -> ()) {
        var thumbNailImage = UIImage(named: "placeHolderImage")
        
        RestAPIHelper.shared.getJSONDataForURL(url: urlString) { imageDataResponse in
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: imageDataResponse)
                
                if let image = image {
                    thumbNailImage = image
                    completion(thumbNailImage ?? UIImage())
                }
            })
        }
    }
    
    func getJSONDataForURL(url: String, completion: @escaping(Data) -> ()) {
        if let URL = URL(string: url) {
            URLSession.shared.dataTask(with: URL) { data, response, error in
                if error != nil {
                    print(error?.localizedDescription ?? "An error occurred!")
                }
                
                if let data = data {
                    completion(data)
                }
            }.resume()
        }
    }
}





