//
//  Menu.swift
//  Littlelemon
//
//  Created by Sarah Alkhamees on 16/11/1445 AH.
//

import SwiftUI
import CoreData

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Little Lemon")
                    .font(Font.custom("Markazi", size: 60).weight(.medium))
                Text("Chicago")
                    .font(Font.custom("Markazi", size: 32))
                Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                    .font(Font.custom("Markazi", size: 16).weight(.medium))
                    .padding()
                
                TextField("Search menu", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                FetchedObjects(predicate: buildPredicate(), sortDescriptors: buildSortDescriptors()) { (dishes: [Dish]) in
                    List{
                        ForEach(dishes, id: \.self){ dish in
                            NavigationLink(destination: DishDetails(dish: dish)){
                                HStack{
                                    VStack(alignment: .leading){
                                        Text(dish.title ?? "")
                                        Spacer(minLength: 5)
                                        Text(dish.description_dish ?? "")
                                            .font(Font.custom("Karla", size: 14))
                                        Spacer(minLength: 5)
                                        Text("$\(dish.price ?? "")")
                                        Spacer(minLength: 5)
                                    }
                                    Spacer()
                                    AsyncImage(url: URL(string: dish.image ?? "")){ image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                            }
                        }
                    }
                }
                .onAppear{
                    getMenuData()
                }
            }
        }
    }
    
    func getMenuData(){
        //        PersistenceController.shared.clear()
        let menuAddress = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        guard let menuURL = URL(string: menuAddress) else {
            print("Invalid URL: \(menuAddress)")
            return
        }
        let urlRequest = URLRequest(url: menuURL)
        let task = URLSession.shared.dataTask(with: urlRequest){ data, response, error in
            if let error = error {
                print("Error fetching menu data: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                print("Invalid response")
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(MenuList.self, from: data)
                    print("Decoded Menu Data: \(decodedData)")
                    for menuItem in decodedData.menu{
                        if notCachedData(for: menuItem){
                            let dish = Dish(context: viewContext)
                            dish.title = menuItem.title
                            dish.image = menuItem.image
                            dish.price = menuItem.price
                            dish.description_dish = menuItem.description_dish
                        }
                    }
                    try? viewContext.save()
                } catch {
                    print("Error decoding menu data: \(error)")
                }
            } else {
                print("Invalid data")
                return
            }
        }
        task.resume()
    }
    
    func notCachedData(for menuItem: MenuItem) -> Bool{
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title == %@", menuItem.title)
            do {
                let existingDishes = try viewContext.fetch(fetchRequest)
                return existingDishes.isEmpty // If there are no existing dishes with the same title, return true
            } catch {
                print("Error fetching existing dishes: \(error)")
                return true
            }
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor]{
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true, selector:  #selector(NSString.localizedStandardCompare))
        return [sortDescriptor]
    }
    
    func buildPredicate() -> NSPredicate{
        if searchText.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }
}

#Preview {
    Menu()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
