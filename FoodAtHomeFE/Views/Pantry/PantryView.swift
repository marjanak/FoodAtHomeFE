//
//  PantryView.swift
//  Food_At_Home
//
//  Created by hi on 1/27/25.
//

import SwiftUI

struct PantryView: View {
    @Environment(DataManager.self) var dataManager: DataManager
    @State private var showAddPopover = false
    @State private var showEditPopover = false
    @State private var pantryItem = ""
    @State private var expirationDate: Date? = nil
    @State private var selectedIngredient: Ingredient?
    @State private var editExpirationDate: Date? = nil
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(dataManager.pantry, id: \.id) { ingredient in
                        PantryRowView(ingredient: ingredient)
                            .onTapGesture {
                                selectedIngredient = ingredient
                                editExpirationDate = convertStringToDate(ingredient.expiration_date)
                                showEditPopover = true
                            }
                    }
                    .onDelete(perform: deleteIngredient)
                }
            }
            .task {
                await dataManager.fetchPantry()
            }
            .navigationTitle("My Pantry")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Item") {
                        showAddPopover = true
                    }
                    .buttonStyle(AddButtonStyle())
                }
                
            }
            
        }
        .popover(isPresented: $showAddPopover) {
            AddPantryView(
                pantryItem: $pantryItem,
                expirationDate: $expirationDate,
                onSave: {
                    addPantryItem()
                    updateExpirationDate()
//                    resetAddForm()
                }
            )
        }
        .popover(isPresented: $showEditPopover) {
            EditPopoverView(
                expirationDate: Binding<Date>(
                    get: { editExpirationDate ?? Date() },
                    set: { editExpirationDate = $0 }
                ),
                onUpdate: {
                    updateExpirationDate()
                    resetEditForm()
                }
            )
        }
    }

    private func convertStringToDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }
    
    private func resetAddForm() {
        pantryItem = ""
        expirationDate = nil
        showAddPopover = false
    }
    
    private func resetEditForm() {
        selectedIngredient = nil
        editExpirationDate = nil
        showEditPopover = false
    }
    
    private func addPantryItem() {
        Task {
            await dataManager.addPantryItem(pantryItem: pantryItem, expirationDate: expirationDate)
            await dataManager.fetchPantry()
            resetAddForm()
        }
    }
    
    private func updateExpirationDate() {
        guard let ingredient = selectedIngredient,
              let editExpirationDate = editExpirationDate else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: editExpirationDate)
        
        Task {
            await dataManager.updateExpirationDate(ingredientID: ingredient.id, expirationDate: dateString)
            await dataManager.fetchPantry()
        }
    }
    
    private func deleteIngredient(at offsets: IndexSet) {
        offsets.forEach { index in
            let ingredient = dataManager.pantry[index]
            Task {
                await dataManager.deleteIngredient(ingredientID: ingredient.id)
            }
        }
    }
}


struct PantryRowView: View {
    let ingredient: Ingredient
    
    var body: some View {
        HStack {
            Text(ingredient.ingredient)
            Spacer()
            Text(ingredient.expiration_date ?? "No Expiration Date")
                .foregroundColor(.gray)
        }
    }
}


struct AddButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal)
            .background(Color(red: 207/255, green: 92/255, blue: 54/255))
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct SaveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
