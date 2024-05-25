//
//  MenuList.swift
//  Littlelemon
//
//  Created by Sarah Alkhamees on 17/11/1445 AH.
//

import Foundation

struct MenuList: Decodable {
    let menu: [MenuItem]
    
    enum CodingKeys: String, CodingKey {
        case menu = "menu"
    }
}
