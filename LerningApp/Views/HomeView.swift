//
//  HomeView.swift
//  LerningApp
//
//  Created by Brady Robshaw on 1/15/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        
        NavigationView {
            VStack(alignment: .leading){
                Text("What do you what to do today?")
                    .padding(.leading)
                ScrollView {
                    LazyVStack {
                        ForEach(model.modules) { module in
                            VStack (spacing: 20) {
                                // Lerning Card
                                HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) Lessons", time: module.content.time)
                                
                                // Test Card
                                HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) Lessons", time: module.test.time)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Get Started")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
