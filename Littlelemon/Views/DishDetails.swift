//
//  DishDetails.swift
//  Littlelemon
//
//  Created by Sarah Alkhamees on 17/11/1445 AH.
//

import SwiftUI

struct DishDetails: View {
    let dish: Dish
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: dish.image ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(minHeight: 200)
                
                Text(dish.title ?? "")
                    .font(Font.custom("Markazi", size: 32))
                    .foregroundStyle(.secondaryColor4)
                    .padding()
                
                Text(dish.category ?? "")
                    .font(Font.custom("Markazi", size: 16))
                    .foregroundStyle(.secondaryColor4)
                
                Text(dish.description_dish ?? "")
                    .font((Font.custom("Markazi", size: 18)))
                    .foregroundStyle(.primaryColor1)
                    .padding()
                
                Text("$\(dish.price ?? "")")
                    .font(Font.custom("Karla", size: 14))
                    .foregroundStyle(.primaryColor1)
                    .monospaced()
                
                Spacer()
            }
        }
    }
}

#Preview {
    DishDetails(dish: Dish())
}
