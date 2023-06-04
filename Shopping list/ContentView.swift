import SwiftUI

struct ContentView: View {
    @State var myItems = itemsList
    @State var strikethrough = false
    @State var addText = ""
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                List {
                    ForEach(myItems, id: \.id) { item in
                        Button(action: {
                            if let index = myItems.firstIndex(where: { $0.id == item.id }) {
                                myItems[index].isCompleted.toggle()
                                writeJSON(items: myItems)
                            }
                        }) {
                            Text("\(item.itemName)")
                                .strikethrough(item.isCompleted, color: .pink)
                        }
                        .swipeActions(edge: .leading) {
                            Button(action: {
//                                myItems.append(Items(itemName: "Edit Button Added This", isCompleted: false))
//                                print(myItems)
//                                writeJSON(items: myItems)
                                print("Edit")
                            }) {
                                Label("Delete", systemImage: "square.and.pencil")
                            }
                        }
                    }
                    .onDelete(perform: delete)
                    .onMove(perform: onMove)
                }

                .scrollContentBackground(.hidden)

            }
            .navigationBarTitle("Shopping list") // Set the title after the toolbar
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        addItem()
                        hideKeyboard()
                        addText = ""
                    }) {
                        Label("Send", systemImage: "plus")
                    }
                }
                    ToolbarItem(placement: .navigationBarLeading) {
                        TextField("Add an item", text: $addText)
                            .frame(minWidth: 300)
                            .submitLabel(.done)
                            .onSubmit {
                                addItem()
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
                    Button(action: {
                        myItems.removeAll(where: { $0.isCompleted})
                        writeJSON(items: myItems)
                        
                    }) {
                        Label("Refresh", systemImage: "trash")
                    }
                }
                ToolbarItem(placement: .keyboard) {
                    HStack{
                        Button(action: {
                            hideKeyboard()
                        }) {
                            Text("Done")
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                    }
                }
            }
            .foregroundColor(.brown)
        }
    }
//        .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
//    }
    func delete(at offsets: IndexSet) {
        myItems.remove(atOffsets: offsets)
        writeJSON(items: myItems)
        print(myItems)
    }
    func onMove(source: IndexSet, destination: Int) {
            myItems.move(fromOffsets: source, toOffset: destination)
        }
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    func addItem() {
        if addText != "" {
            myItems.append(Items(itemName: addText, isCompleted: false))
            print(myItems)
            writeJSON(items: myItems)
            addText = ""
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
