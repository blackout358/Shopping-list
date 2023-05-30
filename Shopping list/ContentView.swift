import SwiftUI

struct ContentView: View {
    @State var myItems = itemsList
    @State var strikethrough = false
    var body: some View {
        NavigationStack {
            ZStack {
                Color.mint
                    .edgesIgnoringSafeArea(.all)
                List{
                    ForEach(myItems.indices, id: \.self) { index in
                        Button(action: {
                            myItems[index].isCompleted.toggle()
                        }, label: {
                            Text("\(myItems[index].itemName)")
                                .strikethrough(myItems[index].isCompleted, color: .pink)
                        })

                    } .onDelete(perform: delete)
                       }

            }
            .navigationBarTitle("Shopping list") // Set the title after the toolbar
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        print(myItems)
                        myItems.append(Items(itemName: "Hallo", isCompleted: false))
                        print(myItems)
                        writeJSON(items: myItems)
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
                ToolbarItem(placement: .bottomBar) {
//                    Spacer()
                    Button(action: {
                        myItems.removeAll(where: { $0.isCompleted})
                        
                    }) {
                        Label("Refresh", systemImage: "trash")
                    }
                }
            }
            .foregroundColor(.brown)
        }
    }
    func delete(at offsets: IndexSet) {
        myItems.remove(atOffsets: offsets)
        writeJSON(items: myItems)
        print(myItems)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
