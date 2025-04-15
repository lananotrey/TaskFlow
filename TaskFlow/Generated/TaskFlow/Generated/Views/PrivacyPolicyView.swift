import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    Text("Privacy Policy")
                        .font(.title)
                        .bold()
                    
                    Text("Last updated: \(Date.now.formatted(date: .long, time: .omitted))")
                        .foregroundStyle(.gray)
                    
                    Text("1. Information Collection")
                        .font(.headline)
                    Text("We collect information that you provide directly to us when using the application. This may include task and project data that you create and manage within the app.")
                    
                    Text("2. Use of Information")
                        .font(.headline)
                    Text("The information we collect is used to provide, maintain, and improve our services, and to develop new ones.")
                    
                    Text("3. Data Storage")
                        .font(.headline)
                    Text("All your task and project data is stored locally on your device. We do not store any personal information on our servers.")
                }
                
                Group {
                    Text("4. Third-Party Services")
                        .font(.headline)
                    Text("Our application may contain links to other sites that are not operated by us. We strongly advise you to review the Privacy Policy of every site you visit.")
                    
                    Text("5. Children's Privacy")
                        .font(.headline)
                    Text("We do not knowingly collect personal information from children under 13. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact us.")
                    
                    Text("6. Changes to This Policy")
                        .font(.headline)
                    Text("We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.")
                }
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}