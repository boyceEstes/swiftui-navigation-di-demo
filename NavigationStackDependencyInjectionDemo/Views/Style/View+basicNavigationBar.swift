//
//  View+basicNavigationBar.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 6/30/23.
//

import SwiftUI


struct BasicNavigationBarViewModifier: ViewModifier {
    
    let title: String
    let navigationBarColor: Color
    
    init(title: String, navigationBarColor: Color = .blue) {
        
        self.title = title
        self.navigationBarColor = navigationBarColor
    }
    
    func body(content: Content) -> some View {
        
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(navigationBarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
}


extension View {
    
    func basicNavigationBar(title: String, navigationBarColor: Color = .blue) -> some View {
        
        modifier(
            BasicNavigationBarViewModifier(
                title: title,
                navigationBarColor: navigationBarColor
            )
        )
    }
}
