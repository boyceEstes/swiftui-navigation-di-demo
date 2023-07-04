//
//  NavigationFlow.swift
//  NavigationStackDependencyInjectionDemo
//
//  Created by Boyce Estes on 7/3/23.
//

import Foundation

protocol StackNavigationFlow: ObservableObject {
    
    associatedtype StackIdentifier: Hashable
    
    var path: [StackIdentifier] { get set }
    
    func push(_ viewIdentifier: StackIdentifier)
}


extension StackNavigationFlow {
    
    
    func push(_ viewIdentifier: StackIdentifier) {

        path.append(viewIdentifier)
    }
}



protocol SheetyNavigationFlow: ObservableObject {
    
    associatedtype SheetyIdentifier: Identifiable
    
    var displayedSheet: SheetyIdentifier? { get set }
}


extension SheetyNavigationFlow {
    
    func dismiss() async {
        DispatchQueue.main.async { [weak self] in
            self?.displayedSheet = nil
        }
    }
}
