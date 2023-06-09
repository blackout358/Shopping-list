import SwiftUI

struct SettingsPage: View {
    @Binding var darkMode: Bool
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
                    Toggle("Dark Mode", isOn: self.$darkMode)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    NavigationLink(destination: defaultItemCustomisation()) {
                        Text("Quick add items")
                    }
                    Button(action: {
                        itemsList.removeAll()
                        defaultItemList.removeAll()
                        clearAll.toggle()
                        writeJSON(items: itemsList, destinationFile: "itemsData.json")
                        writeJSON(items: defaultItemList, destinationFile: "quickAddItems.json")
                        itemsList = loadJSON("itemsData.json")
                    }) {
                        Text("Reset")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPage(darkMode: .constant(false))
    }
}
