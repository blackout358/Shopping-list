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
