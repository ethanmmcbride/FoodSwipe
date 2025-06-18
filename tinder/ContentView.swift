//
//  ContentView.swift
//  tinder
//
//  Created by Ethan McBride on 6/11/25.
//

import SwiftUI



struct ContentView : View {
   
    var body : some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home Page", systemImage: "house.fill")
                }
            AddFoodView()
                .tabItem {
                    Label("Add Food", systemImage: "fork.knife.circle.fill")
                }
            
            SwipeView()
                .tabItem {
                    Label("Swipe", systemImage: "hand.draw")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}


#Preview {
    ContentView()
}
