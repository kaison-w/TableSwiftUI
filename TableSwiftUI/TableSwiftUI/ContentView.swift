//
//  ContentView.swift
//  TableSwiftUI
//
//  Created by Ward, Kaison on 3/25/26.
//

import SwiftUI
import MapKit


let data = [
Item(name: "The Coffee Bar", neighborhood: "San Marcos Square", category: "Mayan Mocha", desc: "A sleek, modern spot right on the square perfect for people-watching or studying. It has a sophisticated vibe and high-quality beans.", address: "124 E San Antonio St", lat: 29.883077741823037, long: -97.93993752331315, imageName: "ct3"),
Item(name: "Babe's Doughnut and Coffee", neighborhood: "San Marcos Square", category: "Vietnamese Iced Coffee", desc: "While famous for their massive, creative doughnuts and hand-cut fries, their coffee program is top-tier and pairs perfectly with a morning pastry.", address: "214 N LBJ Dr.", lat: 29.88371893952302, long: -97.94007735891621, imageName: "ct2"),
Item(name: "Wake the Dead Coffee House", neighborhood: "Old Ranch Road", category: "The Mourning Shroud", desc: "A quirky, Nightmare Before Christmas-themed house with a massive outdoor patio. It’s the ultimate 'Keep San Marcos Weird' hangout.", address: "1432 Old Ranch Rd 12", lat: 29.891660676676697, long: -97.95664704487972, imageName: "ct4"),
Item(name: "Summer Moon Coffee", neighborhood: "Springtown Center", category: "The 02 Moon Latte ", desc: "Known for their unique wood-fired roasting process, this shop has a cozy, rustic aesthetic and a very loyal following.", address: "1101 Thorpe Ln", lat: 29.887347804155866, long:-97.92339257052457, imageName: "ct6"),
Item(name: "Mochas & Javas", neighborhood: "West Campus", category: "The Frozen Mocha ", desc: "A local staple for Texas State students. It offers a cozy, reliable atmosphere with plenty of seating and a great selection of healthy snacks.", address: "700 N LBJ Dr.",  lat: 29.89170755521295, long: -97.9408928901125, imageName: "ct5"),
Item(name: "Ollie's Market", neighborhood: "Edward Gary", category: "Honey Vanilla Matcha", desc: "Located on the outskirts of the Square, this is a chic neighborhood market and cafe offering gourmet goods and specialty caffeine.", address: "401 Edward Gary St.", lat: 29.885063355770175, long:-97.93882445723939, imageName: "ct1")
]

struct Item: Identifiable {
    let id = UUID()
    let name: String
    let neighborhood: String
    let category: String
    let desc: String
    let address: String
    let lat: Double
    let long: Double
    let imageName: String
}

struct ContentView: View {
// initialize variables for Map in List View abd set zoom and centering location
@State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 29.882783856546364, longitude: -97.94070522892835), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
   
    let categories = ["All"] + Array(Set(data.map { $0.neighborhood })).sorted()
       @State private var selectedCategory = "All"

       var filteredData: [Item] {
           if selectedCategory == "All" {
               return data
           } else {
               return data.filter { $0.neighborhood == selectedCategory }
           }
       } // end filteredData
    
    
var body: some View {
    NavigationView {
    VStack {
    Picker("Category", selection: $selectedCategory) {
          ForEach(categories, id: \.self) { category in
              Text(category).tag(category)
          }
      } // end Picker
      .pickerStyle(.menu)
      .padding()

        List(filteredData, id: \.name) { item in
            NavigationLink(destination: DetailView(item: item)) {
                HStack {
                    Image(item.imageName)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text("Try: \(item.category)")
                            .font(.subheadline)
                        Text(item.neighborhood)
                            .font(.subheadline)
                    } // end internal VStack
                } // end HStack
            } // end NavigationLink
        } // end List
    
// Map code inserted after list
Map(coordinateRegion: $region, annotationItems: data) { item in
MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
Image(systemName: "mappin.circle.fill")
    .foregroundColor(.red)
    .font(.title)
    .overlay(
Text(item.name)
       .font(.subheadline)
       .foregroundColor(.black)
       .fixedSize(horizontal: true, vertical: false)
       .offset(y: 25)
)
}
} // end Map
.frame(height: 300)
.padding(.bottom, -30)
            
            
        } // end VStack
        .listStyle(PlainListStyle())
             .navigationTitle("Coffee Trail")
             .navigationBarTitleDisplayMode(.inline)
        
         } // end NavigationView
    } // end body
}


struct DetailView: View {
// initialize variables for Map in Detail View abd set zoom and centering on specific item
@State private var region: MKCoordinateRegion
         
init(item: Item) {
self.item = item
_region = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long), span: MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)))
}
        
let item: Item
               
var body: some View {
VStack {
   Image(item.imageName)
       .resizable()
       .aspectRatio(contentMode: .fit)
       .frame(maxWidth: 200)
   Text("Neighborhood: \(item.neighborhood)")
       .font(.subheadline)
   Text("Try: \(item.category)")
       .font(.subheadline)
       
   Text((item.address))
       .font(.subheadline)
       .frame(maxWidth: .infinity, alignment: .leading)
       .padding()
   Text("Description: \(item.desc)")
       .font(.subheadline)
       .padding(10)
               
//Map code in Detail View
Map(coordinateRegion: $region, annotationItems: [item]) { item in
    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
    Image(systemName: "mappin.circle.fill")
      .foregroundColor(.red)
      .font(.title)
      .overlay(
    Text(item.name)
      .font(.subheadline)
      .foregroundColor(.black)
      .fixedSize(horizontal: true, vertical: false)
      .offset(y: 25)
    )
    }
} // end Map
    .frame(height: 300)
    .padding(.bottom, -60)
    Spacer()
           
    } // end VStack
    .navigationTitle(item.name)
   
        } // end body
     } // end DetailView
   

#Preview {
    ContentView()
}
           
                    
    
