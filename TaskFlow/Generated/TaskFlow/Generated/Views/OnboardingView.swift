import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    @State private var iconScale: CGFloat = 1.0
    
    let pages = [
        OnboardingPage(
            title: "Organize Tasks",
            description: "Create and manage your daily tasks with priority levels and due dates",
            imageName: "checklist.checked"
        ),
        OnboardingPage(
            title: "Project Management",
            description: "Group related tasks into projects and track progress for each project",
            imageName: "folder.fill.badge.person.crop"
        ),
        OnboardingPage(
            title: "Track Progress",
            description: "View detailed statistics and completion rates for your tasks and projects",
            imageName: "chart.bar.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()
            
            VStack {
                Spacer()
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack(spacing: 32) {
                            Image(systemName: pages[index].imageName)
                                .font(.system(size: 80))
                                .foregroundStyle(.indigo)
                                .scaleEffect(iconScale)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1.0).repeatForever()) {
                                        iconScale = 1.2
                                    }
                                }
                            
                            VStack(spacing: 16) {
                                Text(pages[index].title)
                                    .font(.title)
                                    .bold()
                                    .transition(.opacity)
                                
                                Text(pages[index].description)
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.gray)
                                    .padding(.horizontal, 32)
                                    .transition(.opacity)
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .animation(.easeInOut, value: currentPage)
                
                Spacer()
                
                VStack(spacing: 20) {
                    if currentPage < pages.count - 1 {
                        Button {
                            withAnimation {
                                currentPage += 1
                            }
                        } label: {
                            Text("Next")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.indigo)
                                .cornerRadius(12)
                        }
                    } else {
                        Button {
                            withAnimation(.spring) {
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
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
        .preferredColorScheme(.light)
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}