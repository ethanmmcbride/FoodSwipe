//
//  TabBarView.swift
//  tinder
//
//  Created by Carla Madriz on 6/22/25.
//

import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: Tab
    private var tabs: [Tab] = Tab.allCases
    private var fillColor: Color = .white
    
    init(selectedTab: Binding<Tab>) {
            self._selectedTab = selectedTab
        }
    var body: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                Spacer()
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        ZStack {
                            if selectedTab == tab {
                                Circle()
                                    .fill(Color.blue.opacity(0.15))
                                    .frame(width: 50, height: 50)
                                    .scaleEffect(selectedTab == tab ? 1.1 : 1.0)
                            }

                            Image(systemName: tab.rawValue)
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(selectedTab == tab ? .blue : .gray)
                                .scaleEffect(selectedTab == tab ? 1.2 : 1.0)
                        }

                        if selectedTab == tab {
                            Text(String(describing: tab).capitalized)
                                .font(.caption2)
                                .foregroundColor(.blue)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                }
                Spacer()
            }
        }
        .padding(.vertical, 10)
        .background(fillColor.shadow(radius: 5))
        .clipShape(Capsule())
        .padding(.horizontal, 20)
    }
}
