import SwiftUI

struct SettingsPage: View {
    @Binding var darkMode: Bool
    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
            }
        }
    }
}

struct SettingsPage_Previews: PreviewProvider {
//    @State static var darkMode
    static var previews: some View {
        SettingsPage(darkMode: .constant(false))
        SettingsPage(darkMode: .constant(true))
    }
}
