//
//  NapView.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 7/3/23.
//

import SwiftUI

struct NapView: View {
    
    let dismissAllSheets: () -> Void
    
    var body: some View {
        VStack {
            Text("You close your eyes and drift off")
            Button("It Was All A Dream") {
                dismissAllSheets()
            }
            .buttonStyle(BigDealButtonStyle(backgroundColor: .purple))
        }
    }
}

struct NapView_Previews: PreviewProvider {
    static var previews: some View {
        NapView(dismissAllSheets: { })
    }
}
