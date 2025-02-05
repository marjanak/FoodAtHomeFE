//
//  PantryView.swift
//  Food_At_Home
//
//  Created by hi on 1/27/25.
//

import SwiftUI


struct PantryView: View {
    @Environment(DataManager.self) var dataManager: DataManager
    @State private var showPopUp  = false
    @State private var pantryItem = ""

    
    var body: some View {
        NavigationStack {
            List {
                Section(content: {
                    ForEach(dataManager.pantry, id: \.id) {
                        ingredient in
                            Text(ingredient.ingredient)
                    }
                    .onDelete(perform: deleteIngredient)
                }, header: {
                    ItemSectionHeader(symbolSystemName: "", headerText: "Select an item to find a recipe")
                })
            }.popover(isPresented: $showPopUp){
                VStack{
                    TextField("Enter your pantry item", text: $pantryItem)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Save"){
                        addPantryRecipe(item: pantryItem)
                        showPopUp = false
                        pantryItem = ""
                    }
                    
                }
            }
            .task{
                await dataManager.fetchPantry()
            }
            .navigationTitle(Text("My Pantry"))
            .toolbar {
                HStack {
                    Button("", systemImage: "plus.app.fill") {
                        showPopUp = true
                    }
                }
            }
        }
    }

    private func addPantryRecipe(item: String) {
            Task {
                await dataManager.addPantryItem(pantryItem: item)
                await dataManager.fetchPantry()
            }
    }

    
private func deleteIngredient(at offsets: IndexSet) {
    for index in offsets {
        let ingredient = dataManager.pantry[index]
        Task {
            await dataManager.deleteIngredient(ingredientID: ingredient.id)
        }
    }
}
}

struct SubHeaderStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .fontWeight(.heavy)
            .foregroundStyle(Color.black)
//            .textCase(.uppercase)
    }
}

extension View {
    func subHeaderStyle() -> some View {
        self.modifier(SubHeaderStyle())
    }
}

struct ItemSectionHeader: View {
    let symbolSystemName: String
    let headerText: String
    
    var body: some View {
        HStack {
            Image(systemName: symbolSystemName)
            Text(headerText)
        }
        .subHeaderStyle()
    }
}

#Preview {
    PantryView()
        .environment(DataManager())
}

#Preview("PantryView Landscape", traits: .landscapeRight, body: {
    PantryView()
        .environment(DataManager())
})

struct PantryView_Previews: PreviewProvider {
    static var previews: some View {
        PantryView()
            .environment(DataManager())
    }
}
