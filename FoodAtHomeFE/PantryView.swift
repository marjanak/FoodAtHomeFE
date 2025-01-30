//
//  PantryView.swift
//  Food_At_Home
//
//  Created by hi on 1/27/25.
//

import SwiftUI


struct PantryView: View {
    @Environment(DataManager.self) var dataManager: DataManager

    
    var body: some View {
        NavigationStack {
            List {
                Section(content: {
                    ForEach(dataManager.pantry, id: \.id) {
                        ingredient in
                        NavigationLink(ingredient.ingredient) {
                            DetailView(name: ingredient.ingredient)
                        }
                    }
                    .onDelete(perform: deleteIngredient)
                }, header: {
                    ItemSectionHeader(symbolSystemName: "", headerText: "Select an item to find a recipe")
                })
            }
            .task{
                await dataManager.fetchPantry()
            }
            .navigationTitle(Text("My Pantry"))
            .toolbar {
                HStack {
                    Button("Add Item") {
                        print("pressed")
                    }
                    Button("Find Recipe") {
                        print("pressed")
                    }
                }
            }
        }
    }


private func deleteIngredient(at offsets: IndexSet) {
    for index in offsets {
        let ingredient = dataManager.pantry[index]
        print(index, ingredient)
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
