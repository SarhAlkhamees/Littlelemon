//
//  Menu.swift
//  Littlelemon
//
//  Created by Sarah Alkhamees on 16/11/1445 AH.
//

import SwiftUI

struct Menu: View {
    var body: some View {
        VStack{
            Text("Little Lemon")
                .font(Font.custom("Markazi", size: 60).weight(.medium))
            Text("Chicago")
                .font(Font.custom("Markazi", size: 32))
            Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                .font(Font.custom("Markazi", size: 16).weight(.medium))
                .padding()
            
            List{
                
            }
        }
    }
}

#Preview {
    Menu()
}
