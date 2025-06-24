//
//  AnimatedTab.swift
//  tinder
//
//  Created by Carla Madriz on 6/22/25.
//
import SwiftUI

struct AnimatedTabBar: View {
    @State private var selectedTab: Tab = .home
    @StateObject private var foodViewModel = FoodViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                switch selectedTab {
                case .home:
                    HomeView(selectedTab: $selectedTab, viewModel: foodViewModel)
                        .transition(.opacity.combined(with: .move(edge: .leading)))
                case .add:
                    AddFoodView(viewModel: foodViewModel)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                case .swipe:
                    SwipeView()
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                case .profile:
                    ProfileView(viewModel: foodViewModel)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedTab)
            
            TabBarView(selectedTab: $selectedTab)
        }
    }
}

