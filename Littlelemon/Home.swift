//
//  Home.swift
//  Littlelemon
//
//  Created by Sarah Alkhamees on 16/11/1445 AH.
//

import SwiftUI

struct Home: View {
    var body: some View {
        TabView{
            Menu()
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Home()
}
