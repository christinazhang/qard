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
    let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
    
    private static var sharedQServerManager: QServerManager = {
        let qServerManager = QServerManager()
        return qServerManager
    }()
    
    // Initialization
    
    private init() {
    }
    
    // MARK: - Accessors
    
    class func shared() -> QServerManager {
        return sharedQServerManager
    }
    
    func createUser(userId: String) -> DataRequest{
        
        
        let getSavedCardsURL: String = "https://qard.lib.id/qard@dev/createUser/?userId=\(userId)"
        let encodedURL = getSavedCardsURL.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
        
        return Alamofire.request(encodedURL)
    }
    
    func createCard(userId: String, qard: Qard) -> DataRequest {
        
//        let jsonData = try JSONSerialization.data(withJSONObject: qard.toJSON(), options: [])
        
        

        let getSavedCardsURL: String = " https://qard.lib.id/qard@dev/createCard/?userId=\(userId)&cardId=\(qard.id)&cardData="
        let encodedURL = getSavedCardsURL.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
        
        return Alamofire.request(encodedURL)
    }
    
    func getSavedCards(userId: String) -> DataRequest {
        let getSavedCardsURL: String = "https://qard.lib.id/qard@dev/getSavedCards/?userId=\(userId)"
        let encodedURL = getSavedCardsURL.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
        
        return Alamofire.request(encodedURL)
    }
    
    func getUserCard(userId: String, qard: Qard) -> DataRequest {
        let getUserCardURL: String = "https://qard.lib.id/qard@dev/getUserCard/?userId=\(userId)&cardId=\(qard.id ?? "")"
        let encodedURL = getUserCardURL.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
        
        return Alamofire.request(encodedURL)
    }
    
    func getUserCards(userId: String) -> DataRequest {
        let userCardsURL: String =  "https://qard.lib.id/qard@dev/getUserCards/?userId=\(userId)"
        let encodedURL = userCardsURL.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
        
        return Alamofire.request(encodedURL)
    }
    
    func saveCard(userId: String, otherUserId: String, qard: Qard) -> DataRequest {
        let saveCardURL: String =  "https://qard.lib.id/qard@dev/saveCard/?userId=\(userId)&otherUserId=\(otherUserId)&cardId=\(qard.id)"
        let encodedURL = saveCardURL.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
        
        return Alamofire.request(encodedURL)
    }
    
    func updateCard(userId: String, qard: Qard) -> DataRequest {
        let updateCardURL: String = "https://qard.lib.id/qard@dev/updateCard/?userId=a&cardId=b&cardData=%7B%7D"
        let encodedURL = updateCardURL.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
        
        return Alamofire.request(encodedURL)
    }

    func generateQRCode(userId: String, qard: Qard) -> DataRequest {
        let getUserCardURL: String = "https://qard.lib.id/qard@dev/getUserCard/?userId=\(userId)&cardId=\(qard.id ?? "")"
        let encodedURL = getUserCardURL.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        
        // Yay for force unwraps~
        let URL: String = self.QR + encodedURL!
        return Alamofire.request(URL)
    }
    
}
