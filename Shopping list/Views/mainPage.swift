import SwiftUI
import Foundation

struct mainPage: View {
    @State var myItems = itemsList
//    @State var quickItems = defaultItemList
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
                darkMode ?
                Color.black .ignoresSafeArea() .preferredColorScheme(.dark) :
                Color.white .ignoresSafeArea() .preferredColorScheme(.light)
                
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
                                writeJSON(items: myItems, destinationFile: "itemsData.json")
                                print(itemsList)
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
                                else if (item.isCompleted) {
                                    Text("\(item.itemName)")
                                        .strikethrough(item.isCompleted, color: .gray)
                                        .foregroundColor(.gray)
                                }
                                else {
                                    Text("\(item.itemName)")
                                        .foregroundColor(darkMode == true ? .white : .black)
                                }
                            }
                            else if (item.isCompleted) {
                                Text("\(item.itemName)")
                                    .strikethrough(item.isCompleted, color: .gray)
//                                    .foregroundColor(.gray)
                            }
                            else {
                                Text("\(item.itemName)")
                                    .foregroundColor(darkMode == true ? .white : .black)
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
            .navigationBarTitle("Shopping list")
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
                            .padding(6)
                            .frame(width: 150, height: 30)
                            .foregroundColor(.pink)
                            .background(Color.gray .opacity(0.2))
                            .cornerRadius(5)
                            .submitLabel(.done)
                            .onSubmit {
                                addItem()
                            }
                    }
//                    .padding(12)
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                    defaultItemList = checkAndLoadJSON("quickAddItems.json", sourceFile: "quickAddItems.json", destinationFile: "quickAddItems.json")
                        myItems.append(contentsOf: defaultItemList)
                        writeJSON(items: myItems, destinationFile: "itemsData.json")
                        
                    }) {
                        Label("Add quick add", systemImage: "arrow.counterclockwise")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        myItems.removeAll(where: { $0.isCompleted})
                        writeJSON(items: myItems, destinationFile: "itemsData.json")

                    }) {
                        Label("Trash", systemImage: "trash")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        showingSheet.toggle()
//                        loadData()
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
            .sheet(isPresented: $showingSheet) {
                SettingsPage(darkMode: $darkMode)
            }
            
        }
        .tint(.brown)
        .onAppear(perform: loadData)
    }
//        .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
//    }
    func delete(at offsets: IndexSet) {
        myItems.remove(atOffsets: offsets)
        writeJSON(items: myItems, destinationFile: "itemsData.json")
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
            writeJSON(items: myItems, destinationFile: "itemsData.json")
            addText = ""
        }
    }
    func loadData() {
//    itemsList = checkAndLoadJSON("itemsData.json", sourceFile: "itemsData.json", destinationFile: "itemsData.json")
        print("POOP")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        mainPage()
    }
}
