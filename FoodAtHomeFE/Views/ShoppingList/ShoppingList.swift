//
//  ShoppingList.swift
//  FoodAtHomeFE
//
//  Created by New Student on 2/5/25.
//

//import SwiftUI
//
//struct ShoppingList: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    ShoppingList()
//}
import SwiftUI

struct ShoppingList: View {

    @Environment(DataManager.self) var dataManager: DataManager
    @State private var newNote: String = ""
    
    var body: some View {
           NavigationStack {
               VStack {
                   TextField("Enter new item", text: $newNote)
                       .textFieldStyle(RoundedBorderTextFieldStyle())
                       .padding()
                   
                   Button("Add Item") {
                       Task {
                           await dataManager.addShoppingNote(note: newNote)
                           newNote = "" // Clear input field after adding
                       }
                   }
                   .padding()
                   .buttonStyle(.bordered)
                   
                   List {
                       Section(header: Text("Write a shopping list")) {
                           ForEach(dataManager.shoppinglist, id: \.id) { item in
                               HStack {
                                   Text(item.note)
                                   Spacer()
                                   Button(action: {
                                       Task {
                                           await dataManager.deleteShoppingNote(id: item.id ?? 0)
                                       }
                                   }) {
                                       Image(systemName: "trash")
                                           .foregroundColor(.red)
                                   }
                               }
                           }
                       }
                   }
               }
               .task {
                   await dataManager.fetchShoppingList()
               }
               .navigationTitle("Shopping Notes")
           }
       }
   }

   


#Preview {
    ShoppingList()
}
