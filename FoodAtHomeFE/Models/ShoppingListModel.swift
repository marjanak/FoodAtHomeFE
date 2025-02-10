//
//  ShoppingListModel.swift
//  FoodAtHomeFE
//
//  Created by New Student on 2/5/25.
//

import Foundation
struct ShoppingNotesResponse: Codable {
    let shoppingnote: [ShoppingNote]
}


struct ShoppingNoteRequest: Codable {
    let note: String    
}

struct ShoppingNote: Codable, Identifiable {
    let id: Int?
    let note : String
}
