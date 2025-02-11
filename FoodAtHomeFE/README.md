# FoodAtHome

FoodAtHomeFE is an iOS application designed  fetch resipes from the SPOONACULAR API to help users get the resipes 
they what based on the ingredients they want to use, users can also login and save recipes they choose for later use,
they can manage their pantry items and also create a shopping list.The app is built using Swift and interacts with a 
Flask backend deployed on Render to handle data storage and processing.

<img src="/Images/recipe.png" alt="Recipe" width="250" height="500">.  <img src="/Images/recipeSearch.png" alt="Recipe Search" width="250" height="500">

# Features

1.Generate food recipes given ingredients.
2.Track available food items at home.
3.Generate grocery lists based on inventory.
4.Connects to a Flask backend for data management.
5.User-friendly interface for easy navigation.
6.User can login using session based authentication.
7.Users can save recipes for later use and also delete them.
8.Users can favorite recipes.
9.Users can input expiration dates in their inventory.

# Xcode Installation

Xcode is a complete developer toolset for creating apps for iphone.

# Dependencies

Swift
SwiftUI
URLSession for API requests

# Backend Integration

This app is already configured to communicate with a Flask backend hosted on Render. The API endpoints are 
integrated within the app, ensuring smooth interaction between the frontend and backend.


# Setup Instructions

To set up and run the FoodAtHomeFE application locally, follow these steps:

1.Clone the Repository

Open your terminal and run:
git clone https://github.com/marjanak/FoodAtHomeFE.git
This command will create a local copy of the repository on your machine.

2.Open the Project in Xcode

Navigate to the project directory and open the .xcodeproj file:
cd FoodAtHomeFE
open FoodAtHomeFE.xcodeproj

3. For Swift Package Manager:
Dependencies should resolve automatically when you open the project in Xcode.

4. Run the App
Select a simulator or physical device in Xcode
Press Cmd + R to build and run the application

# Backend URL

The app is connected to a Flask backend deployed on Render. If needed, update the backend URL in the Swift code:
let baseURL = "https://food-at-home-api.onrender.com"

