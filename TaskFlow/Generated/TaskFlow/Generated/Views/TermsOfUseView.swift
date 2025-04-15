import SwiftUI

struct TermsOfUseView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    Text("Terms of Use")
                        .font(.title)
                        .bold()
                    
                    Text("Last updated: \(Date.now.formatted(date: .long, time: .omitted))")
                        .foregroundStyle(.gray)
                    
                    Text("1. Acceptance of Terms")
                        .font(.headline)
                    Text("By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement.")
                    
                    Text("2. Use License")
                        .font(.headline)
                    Text("Permission is granted to temporarily download one copy of the application for personal, non-commercial transitory viewing only.")
                    
                    Text("3. Disclaimer")
                        .font(.headline)
                    Text("The application is provided on an 'as is' basis. The developer makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.")
                }
                
                Group {
                    Text("4. Limitations")
                        .font(.headline)
                    Text("In no event shall the developer be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the application.")
                    
                    Text("5. Privacy")
                        .font(.headline)
                    Text("Your use of the application is also governed by our Privacy Policy.")
                    
                    Text("6. Changes")
                        .font(.headline)
                    Text("We reserve the right, at our sole discretion, to modify or replace these terms at any time.")
                }
            }
            .padding()
        }
        .navigationTitle("Terms of Use")
        .navigationBarTitleDisplayMode(.inline)
    }
}