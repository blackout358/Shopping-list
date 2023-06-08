import SwiftUI
import Foundation

struct mainPage: View {
    @State var myItems = itemsList
    @State var strikethrough = false
    @State var addText = ""
    @State var editMode = false
    @State var editText = ""
    @State var editID: UUID = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
    @AppStorage("darkMode") var darkMode:Bool = false
    @FocusState var isFocused: Bool
    @State var showingSheet = false
    var body: some View {
        NavigationStack {
            ZStack {
                if (darkMode) {
                    Color.black
                        .ignoresSafeArea()
                        .preferredColorScheme(.dark)
                }
                else {
                    Color.white
                        .ignoresSafeArea()
                        .preferredColorScheme(.light)
                }
                List {
                    /*
                     If striked out is moved to none striked out, move item up and down
                     function is broken until the trash can is pressed to clear striked out items
                     
                     If item is striked out, then rearrange doesnt work until nothing is striked out
                    */
                    ForEach(myItems.sorted(by: { !$0.isCompleted && $1.isCompleted}) , id: \.id) { item in
                        Button(action: {
                            if let index = myItems.firstIndex(where: { $0.id == item.id }) {
                                myItems[index].isCompleted.toggle()
                                writeJSON(items: myItems)
                            }
                        }) {
                            if let index = myItems.firstIndex(where: { $0.id == editID }) {
                                if (editMode && editID == item.id) {
                                    TextField(myItems[index].itemName, text: $editText)
                                        .focused($isFocused)
                                        .frame(minWidth: 300)
                                        .submitLabel(.done)
                                        .onSubmit {
                                            myItems[index].itemName = editText
                                            editText = ""
                                            editMode = false
                                            editID = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
                                            isFocused.toggle()
                                        }
                                }
                                else {
                                    Text("\(item.itemName)")
                                        .strikethrough(item.isCompleted, color: .gray)
                                }
                            }
                            else {
                                Text("\(item.itemName)")
                                    .strikethrough(item.isCompleted, color: .gray)
                            }
                        }
                        .listRowBackground(darkMode ? nil : Color.gray .opacity(0.2))
                        .swipeActions(edge: .leading) {
                            Button(action: {
                                editMode.toggle()
                                isFocused.toggle()
                                print(item.id)
                                if (editMode) {
                                    editID = item.id
                                }
                                else {
                                    editID = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
                                }
                            }) {
                                Label("Edit", systemImage: "square.and.pencil")
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
//                        TextField(String(showingSheet), text: $addText)
                            .frame(minWidth: 300)
//                            .fixedSize()
                            .foregroundColor(.pink)
//                            .background(Color.blue)
                            .submitLabel(.done)
                            .onSubmit {
                                addItem()
                            }
                    }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("Refresh button tapped")
                        myItems.append(Items(itemName: "Egg", isCompleted: false))
                        myItems.append(Items(itemName: "Apple", isCompleted: false))
                        myItems.append(Items(itemName: "Orange", isCompleted: false))
                        myItems.append(Items(itemName: "Milk", isCompleted: false))
                        myItems.append(Items(itemName: "Sugar", isCompleted: false))
                        myItems.append(Items(itemName: "Bread", isCompleted: false))
                        writeJSON(items: myItems)
                        
                    }) {
                        Label("Refresh", systemImage: "questionmark.circle")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        myItems.removeAll(where: { $0.isCompleted})
                        writeJSON(items: myItems)

                    }) {
                        Label("Trash", systemImage: "trash")
                    }
                }
//                ToolbarItem(placement: .bottomBar) {
//                    Toggle("", isOn: $darkMode)
//                        .toggleStyle(SwitchToggleStyle(tint: .red))
//                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        showingSheet.toggle()
                    }) {
                        Label("Settings", systemImage: "gearshape")
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
            .sheet(isPresented: $showingSheet) {
                SettingsPage(darkMode: $darkMode)
                
            }
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
        mainPage()
    }
}
