import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            title: "Welcome to TaskFlow",
            description: "Organize your tasks and projects efficiently",
            imageName: "checklist"
        ),
        OnboardingPage(
            title: "Create Projects",
            description: "Group related tasks together in customizable projects",
            imageName: "folder"
        ),
        OnboardingPage(
            title: "Track Progress",
            description: "Monitor your productivity with detailed statistics",
            imageName: "chart.bar"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea()
            
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack(spacing: 32) {
                            Image(systemName: pages[index].imageName)
                                .font(.system(size: 100))
                                .foregroundStyle(.indigo)
                            
                            Text(pages[index].title)
                                .font(.title)
                                .bold()
                            
                            Text(pages[index].description)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.gray)
                                .padding(.horizontal)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                
                Button {
                    withAnimation {
                        hasCompletedOnboarding = true
                    }
                } label: {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.indigo)
                        .cornerRadius(12)
                }
                .padding()
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}