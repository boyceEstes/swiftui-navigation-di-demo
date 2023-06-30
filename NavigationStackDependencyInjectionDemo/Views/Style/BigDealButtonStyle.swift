//
//  BigDealButtonStyle.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 6/29/23.
//

import SwiftUI


struct BigDealButtonStyle: ButtonStyle {
    
    let backgroundColor: Color
    let foregroundColor: Color
    
    init(
        backgroundColor: Color = .blue,
        foregroundColor: Color = .white
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(foregroundColor)
            .font(.headline)
            .padding(4)
            .padding(.horizontal, 6)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColor)
            )
    }
}
