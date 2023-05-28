import SwiftUI

struct ContentView: View {
    @State var myItems = itemsList
    var body: some View {
        NavigationStack {
            ZStack {
                Color.mint
                    .edgesIgnoringSafeArea(.all)
                
                
                List{
                    ForEach(itemsList, id: \.self) { itemName in
                        Button(action: {
                            itemsList.append(Items(item: "Hallo"))
                            print("[pp[")
                        }, label: {
                            Text("\(itemName.item)")
                        })

                    } .onDelete(perform: delete)
                       }
                
                //                .padding()
            }
            .navigationBarTitle("Shopping list") // Set the title after the toolbar
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print("Send button tapped")
                    }) {
                        Label("Send", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Refresh button tapped")
                    }) {
                        Label("Refresh", systemImage: "questionmark.circle")
                    }
                }
            }
            .foregroundColor(.brown)
        }
    }
    func delete(at offsets: IndexSet) {
        itemsList.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
