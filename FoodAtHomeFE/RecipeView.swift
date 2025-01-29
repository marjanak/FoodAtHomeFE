//
//  RecipeView.swift
//  Food_At_Home
//
//  Created by hi on 1/28/25.
//

import SwiftUI


struct RecipeView: View {
    @Environment(DataManager.self) var dataManager: DataManager
    
    let recipes = [
        "Spaghetti with Meatballs",
        "Chicken Tacos",
        "Greek Salad",
        "Beef Stew",
        "Margherita Pizza",
        "Chicken Alfredo",
        "Sushi Rolls",
        "Tuna Sandwich",
        "Veggie Stir Fry",
        "Chocolate Cake"
    ]
    
    let imageURL = URL(string: "https://img.spoonacular.com/recipes/673463-312x231.jpg")
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.fixed(100)),
                    GridItem(.fixed(100)),
                    GridItem(.fixed(100))
                ]) {
                    ForEach(dataManager.recipes, id: \.id) { recipe in
                        RecipeCardView(recipeName: recipe.name, imageURL: imageURL)
                    }
                }
            }
            .onAppear {
                Task {
                    await dataManager.fetchRecipes()
                }
            }
            .navigationTitle("My Recipes")
            .toolbar {
                HStack {
                    Button("Find Pantry Recipe") {
                        print("Pressed Find Pantry Recipe")
                    }
                    Button("Find Recipe") {
                        print("Pressed Find Recipe")
                    }
                }
            }
        }
    }
}


//struct RecipeView: View {
//    @Environment(DataManager.self) var dataManager: DataManager
//    
//    let recipes = [
//        "Spaghetti with Meatballs",
//        "Chicken Tacos",
//        "Greek Salad",
//        "Beef Stew",
//        "Margherita Pizza",
//        "Chicken Alfredo",
//        "Sushi Rolls",
//        "Tuna Sandwich",
//        "Veggie Stir Fry",
//        "Chocolate Cake"
//    ]
//    let imageURL = URL(string: "https://img.spoonacular.com/recipes/673463-312x231.jpg")
//    
//    var body: some View {
//        NavigationStack {
//            
//            ScrollView {
//                LazyVGrid(columns: [
//                    GridItem(.fixed(100)),
//                    GridItem(.fixed(100)),
//                    GridItem(.fixed(100))
//                ]) {
//                    
//                    ForEach(recipes, id:\.self) {
//                        recipeName in
//                        VStack {
//                        NavigationLink(recipeName) {
//                            DetailRecipeView(taskName: recipeName)
//                        }
//                            AsyncImage(url: imageURL) { image in
//                                image
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                            } placeholder: {
//                                Image(systemName: "photo.fill")
//                            }
//                            .frame(width: 250, height: 250)
//                            .border(Color.gray)
////                            AsyncImage(url: imageURL) { phase in
////                                switch phase {
////                                case .empty:
//////                                    ProgressView()
////                                    print("empty")
////                                case .success(let image):
////                                    image.resizable()
////                                        .aspectRatio(contentMode: .fit)
////                                        .frame(maxWidth: 300, maxHeight: 100)
////                                case .failure:
////                                    Image(systemName: "photo")
////                                @unknown default:
//////                                    EmptyView()
////                                        print("empty")
////                                }
////                            }
//                        }
//                    }
//                }
//            }
//            .navigationTitle(Text("My Recipes"))
//            .toolbar {
//                HStack {
//                    Button("Find Pantry Recipe") {
//                        print("pressed")
//                    }
//                    Button("Find Recipe") {
//                        print("pressed")
//                    }
//                }
//            }
//
//        }
//        
//    }
//}

//struct HeaderStyle: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .font(.title3)
//            .fontWeight(.heavy)
//            .foregroundStyle(.green)
//            .textCase(.uppercase)
//    }
//}

//extension View {
//    func headerStyle() -> some View {
//        self.modifier(HeaderStyle())
//    }
//}

//struct RecipeSectionHeader: View {
//    let symbolSystemName: String
//    let headerText: String
//    
//    var body: some View {
//        HStack {
//            Image(systemName: symbolSystemName)
//            Text(headerText)
//        }
////        .headerStyle()
//    }
//}

#Preview {
    RecipeView()
//        .environment(DataManager())
}

#Preview("RecipeView Landscape", traits: .landscapeRight, body: {
    RecipeView()
//        .environment(DataManager())
})

//struct RecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeView()
//            .environment(DataManager())
//    }
//}



//import SwiftUI
//
//struct RecipeView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    RecipeView()
//}
