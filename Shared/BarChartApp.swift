//
//  BarChartApp.swift
//  Shared
//
//  Created by Vishnu Vijayan on 2022-02-07.
//

import SwiftUI

@main
struct BarChartApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
