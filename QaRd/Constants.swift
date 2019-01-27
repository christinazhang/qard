//
//  Constants.swift
//  QaRd
//
//  Created by Christina Zhang on 2019-01-26.
//  Copyright © 2019 Christina Zhang. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

class Constants {
    static let fontAwesomeIconSize: CGFloat = 20
    static let qrGeneratorURL: String = "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data="
    static let gradients: [[CGColor]] = [
        [UIColor(hex: 0x303395).cgColor,
         UIColor(hex: 0x27F0F0).cgColor],
        [UIColor(hex: 0x009900).cgColor,
         UIColor(hex: 0xFFFF92).cgColor],
        [UIColor(hex: 0xCF396F).cgColor,
         UIColor(hex: 0xF6E28B).cgColor],
        [UIColor(hex: 0x421057).cgColor,
         UIColor(hex: 0xF45509).cgColor],
        [UIColor(hex: 0x2E266F).cgColor,
         UIColor(hex: 0x7C2289).cgColor]
    ]
    
    typealias IconInfo = (style: FontAwesomeStyle, icon: FontAwesome)
    static let iconMap: [String : IconInfo] = [
//        "github.com" : (.brands, .github),
        "facebook.com" : (.brands, .facebookF),
        "500px.com" : (.brands, .fiveHundredPixels),
        "amazon" : (.brands, .amazon),
        "android" : (.brands, .android),
        "apple" : (.brands, .apple),
        "behance.com" : (.brands, .behance),
        "discordapp.com" : (.brands, .discord),
        "discord.gg" : (.brands, .discord),
        "dribbble.com" : (.brands, .dribbble),
        "etsy" : (.brands, .etsy),
        "flickr" : (.brands, .flickr),
        "github.com" : (.brands, .github),
        "plus.google.com" : (.brands, .googlePlusG),
        "linkedin.com" : (.brands, .linkedinIn),
        "medium.com" : (.brands, .mediumM),
        "pinterest" : (.brands, .pinterestP),
        "qq.com" : (.brands, .qq),
        "snapchat" : (.brands, .snapchatGhost),
        "slack.com" : (.brands, .slackHash),
        "soundcloud.com" : (.brands, .soundcloud),
        "steampowered.com" : (.brands, .steamSymbol),
        "twitter.com" : (.brands, .twitter),
        "tumblr.com" : (.brands, .tumblr),
        "twitch.tv" : (.brands, .twitch),
        "weibo.com" : (.brands, .weibo)
    ]
}

extension UIColor {
    convenience init(hex: Int) {
        self.init(
            red: CGFloat((hex >> 16) & 0xff) / 255,
            green: CGFloat((hex >> 8) & 0xff) / 255,
            blue: CGFloat(hex & 0xff) / 255,
            alpha: 1)
    }
}
