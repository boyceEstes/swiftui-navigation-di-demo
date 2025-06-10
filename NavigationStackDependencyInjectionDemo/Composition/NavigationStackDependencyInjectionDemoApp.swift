//
//  NavigationStackDependencyInjectionDemoApp.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 6/29/23.
//

import SwiftUI

/*
 * This is where all of the magic happens. This should be completely separate from the rest of the iOS components
 * so that each app can have their components referenced and composed entirely independently.
 *
 * Composition AND navigation should happen in this tab. We want the views to be as dumb as possible
 *
 * We can do this using composers with static functions to make the view.
 */

@main
struct NavigationStackDependencyInjectionDemoApp: App {
    
    let backpackRepository = BackpackRepository()
    
    var body: some Scene {
        WindowGroup {
            ContentView(backpackRepository: backpackRepository)
        }
    }
}
