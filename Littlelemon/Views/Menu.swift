//
//  Menu.swift
//  Littlelemon
//
//  Created by Sarah Alkhamees on 16/11/1445 AH.
//

import SwiftUI
import CoreData

enum MenuCategory: String, CaseIterable {
    case starters
    case mains
    case desserts
    case drinks
}

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var searchText: String = ""
    @State var selectedCategory: MenuCategory? = nil
    
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    Image("logo-image")
                    HStack{
                        Spacer()
                        Button {} label: {
                            Image("profile-image-placeholder")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 65, height: 65)
                                .padding(.trailing, 10)
                        }
                    }
                }
                VStack(alignment: .leading) {
                    Text("Little Lemon")
                        .font(Font.custom("Markazi", size: 50).weight(.medium))
                        .foregroundStyle(.primaryColor2)
                    HStack(){
                        VStack(alignment: .leading){
                            Text("Chicago")
                                .font(Font.custom("Markazi", size: 32))
                                .foregroundStyle(.secondaryColor3)
                            Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                                .font(Font.custom("Markazi", size: 16).weight(.medium))
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundStyle(.secondaryColor3)
                        }
                        Image("hero-image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 110, maxHeight: 120)
                            .cornerRadius(8)
                    }
                    Spacer()
                    
                    TextField("Search menu", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                .padding()
                .background(.primaryColor1)
                
                VStack(alignment: .leading){
                    Text("ORDER FOR DELIVERY!")
                        .bold()
                    ScrollView(.horizontal ,showsIndicators: false){
                        HStack{
                            ForEach(MenuCategory.allCases, id: \.self){ category in
                                Button(category.rawValue){
                                    if selectedCategory == category {
                                        selectedCategory = nil
                                    } else {
                                        selectedCategory = category
                                    }
                                }
                                .foregroundStyle(Color.primaryColor1)
                                .background(selectedCategory == category ? Color.primaryColor2 : Color.secondaryColor3)
                                .buttonStyle(.bordered)
                                .clipShape(Capsule())
                                .bold()
                            }
                        }
                    }
                }
                .padding()
                
                FetchedObjects(predicate: buildPredicate(), sortDescriptors: buildSortDescriptors()) { (dishes: [Dish]) in
                    List{
                        if dishes.isEmpty{
                            Text("No items found!")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(dishes, id: \.self){ dish in
                                NavigationLink(destination: DishDetails(dish: dish)){
                                    HStack{
                                        VStack(alignment: .leading){
                                            Text(dish.title ?? "")
                                                .foregroundStyle(Color.secondaryColor4)
                                            Spacer(minLength: 5)
                                            Text(dish.description_dish ?? "")
                                                .font(Font.custom("Karla", size: 14))
                                                .foregroundStyle(Color.primaryColor1)
                                            Spacer(minLength: 5)
                                            Text("$\(dish.price ?? "")")
                                                .foregroundStyle(Color.primaryColor1)
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
                            dish.category = menuItem.category
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
        var predicates = [NSPredicate]()
        
        let searchField = searchText.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        predicates.append(searchField)
        
        switch selectedCategory {
        case .starters:
            predicates.append(NSPredicate(format: "category == %@", MenuCategory.starters.rawValue))
        case .mains:
            predicates.append(NSPredicate(format: "category == %@", MenuCategory.mains.rawValue))
        case .desserts:
            predicates.append(NSPredicate(format: "category == %@", MenuCategory.desserts.rawValue))
        case .drinks:
            predicates.append(NSPredicate(format: "category == %@", MenuCategory.drinks.rawValue))
        case nil:
            break
        }
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
}

#Preview {
    Menu()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
