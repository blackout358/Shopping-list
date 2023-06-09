import SwiftUI

struct defaultItemCustomisation: View {
    @State var myItems = defaultItemList
    @State var strikethrough = false
    @State var addText = ""
    @State var editMode = false
    @State var editText = ""
    @State var editID: UUID = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
    @AppStorage("darkMode") var darkMode:Bool = false
    @FocusState var isFocused: Bool
    var body: some View {
                    List {
                        ForEach($myItems, id: \.id) { $item in
                            Button(action: {
                                
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
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
            }//hh
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    addItem()
                    hideKeyboard()
                    addText = ""
                }) {
                    Label("Send", systemImage: "plus")
                }
            }
        }
        .tint(.brown)
        .onAppear(perform: loadData)
    }
    func delete(at offsets: IndexSet) {
        myItems.remove(atOffsets: offsets)
        writeJSON(items: myItems, destinationFile: "quickAddItems.json")
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
            writeJSON(items: myItems, destinationFile: "quickAddItems.json")
            addText = ""
        }
    }
    func loadData() {
    myItems = checkAndLoadJSON("quickAddItems.json", sourceFile: "quickAddItems.json", destinationFile: "quickAddItems.json")
    }
}
    

struct defaultItemCustomisation_Previews: PreviewProvider {
    static var previews: some View {
        defaultItemCustomisation()
    }
}
