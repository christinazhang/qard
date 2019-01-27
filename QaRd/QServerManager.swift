//
//  QServerManager.swift
//  QaRd
//
//  Created by Kevin Wong on 2019-01-27.
//  Copyright © 2019 Christina Zhang. All rights reserved.
//

import Foundation
import Alamofire


class QServerManager {
    
    let QR: String = Constants.qrGeneratorURL
    let userId: String = "testUser1"
    let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]{} ").inverted)
    
    private static var sharedQServerManager: QServerManager = {
        let qServerManager = QServerManager()
        return qServerManager
    }()
    
    // MARK: - Accessors
    
    class func shared() -> QServerManager {
        return sharedQServerManager
    }
    
    func asString(jsonDictionary: [String : Any]) -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .sortedKeys)
            return String(data: data, encoding: String.Encoding.utf8) ?? ""
        } catch {
            return ""
        }
    }
    
    func createUser(userId: String) -> DataRequest{
        
        let getSavedCardsURL: String = "https://qard.lib.id/qard@dev/createUser/?userId=\(userId)"
        let encodedURL = getSavedCardsURL.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
        
        return Alamofire.request(encodedURL)
    }
    
    func createCard(userId: String, qard: Qard) -> DataRequest {
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(qard)
        let jsonString = String(data: jsonData, encoding: .utf8)
        
    
        let getSavedCardsURL: String = "https://qard.lib.id/qard@dev/createCard/?userId=\(userId)&cardId=\(qard.id ?? "")&cardData=\(jsonString ?? "")"
        
        let encodedUrl = getSavedCardsURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

        print("encodedURL", encodedUrl)

        return Alamofire.request(encodedUrl)
    }
    
    func getSavedCards(userId: String) -> DataRequest {
        let getSavedCardsURL: String = "https://qard.lib.id/qard@dev/getSavedCards/?userId=\(userId)"
        let encodedURL = getSavedCardsURL.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
        
        return Alamofire.request(encodedURL)
    }
    
    func getUserCard(userId: String, qardId: String) -> DataRequest {
        let getUserCardURL: String = "https://qard.lib.id/qard@dev/getUserCard/?userId=\(userId)&cardId=\(qardId)"
        
        return Alamofire.request(getUserCardURL)
    }
    
    func getUserCards(userId: String) -> DataRequest {
        let userCardsURL: String =  "https://qard.lib.id/qard@dev/getUserCards/?userId=\(userId)"
        let encodedURL = userCardsURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        print("encodedURL", encodedURL)
        
        return Alamofire.request(encodedURL)
    }
    
    func saveCard(userId: String, otherUserId: String, qard: Qard) -> DataRequest {
        let saveCardURL: String =  "https://qard.lib.id/qard@dev/saveCard/?userId=\(userId)&otherUserId=\(otherUserId)&cardId=\(qard.id ?? "")"
        let encodedURL = saveCardURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        return Alamofire.request(encodedURL)
    }
    
    func updateCard(userId: String, qard: Qard) -> DataRequest {

        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(qard)
        let jsonString = String(data: jsonData, encoding: .utf8)
        
        
        let getSavedCardsURL: String = "https://qard.lib.id/qard@dev/updateCard/?userId=\(userId)&cardId=\(qard.id ?? "")&cardData=\(jsonString ?? "")"
        
        let encodedUrl = getSavedCardsURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        print("encodedURL", encodedUrl)
        return Alamofire.request(encodedUrl)
    }

    func generateQRCode(userId: String = "wiji", qard: Qard) -> DataRequest {
        let getUserCardURL: String = "\(userId),\(qard.id ?? "")"
        let encodedURL = getUserCardURL.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        
        // Yay for force unwraps~
        let URL: String = self.QR + encodedURL!
        return Alamofire.request(URL)
    }
    
    public struct MyCustomEncoding: ParameterEncoding {
        
        public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
            
            let urlRequest = try urlRequest.asURLRequest()
            
            guard parameters != nil else { return urlRequest }
            
            return urlRequest
        }
    }

}
