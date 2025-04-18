import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                
                Section("Support") {
                    Button(action: rateApp) {
                        HStack {
                            Text("Rate this app")
                            Spacer()
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                        }
                        .foregroundStyle(.primary)
                    }
                    .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
                    
                    Button(action: shareApp) {
                        HStack {
                            Text("Share this app")
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .foregroundStyle(.blue)
                        }
                        .foregroundStyle(.primary)
                    }
                    .listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
                    
                    NavigationLink(destination: TermsOfUseView()) {
                        HStack {
                            Text("Terms of Use")
                            Spacer()
                            Image(systemName: "doc.text")
                                .foregroundStyle(.gray)
                        }
                    }
                    
                    NavigationLink(destination: PrivacyPolicyView()) {
                        HStack {
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "lock.shield")
                                .foregroundStyle(.gray)
                        }
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .navigationTitle("Settings")
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
    
    private func rateApp() {
        guard let appStoreURL = URL(string: "https://apps.apple.com/app/id\(Constants.appStoreId)") else { return }
        UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
    }
    
    private func shareApp() {
        let appURL = URL(string: "https://apps.apple.com/app/id\(Constants.appStoreId)")!
        let activityVC = UIActivityViewController(
            activityItems: [appURL],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            activityVC.popoverPresentationController?.sourceView = rootVC.view
            rootVC.present(activityVC, animated: true)
        }
    }
}