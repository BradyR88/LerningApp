//
//  ContentView.swift
//  LerningApp
//
//  Created by Brady Robshaw on 1/19/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        ScrollView {
            
            LazyVStack {
                // Confirm that currentModule is set
                if model.currentModule != nil {
                    ForEach(0..<model.currentModule!.content.lessons.count) { index in
                        
                        NavigationLink {
                            ContentDetailView()
                                .onAppear {
                                    model.beginLesson(index)
                                }
                        } label: {
                            
                            let lesson = model.currentModule!.content.lessons[index]
                            
                            //lesson card
                            ZStack (alignment: .leading) {
                                Rectangle()
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .frame(height: 66)
                                
                                HStack (spacing: 30) {
                                    Text(String(index+1))
                                        .bold()
                                    
                                    VStack (alignment: .leading){
                                        Text(lesson.title)
                                            .bold()
                                        Text(lesson.duration)
                                    }
                                }
                                .padding()
                                .foregroundColor(.black)
                            }
                            .padding(.bottom,5)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Learn \(model.currentModule?.category ?? "")")
        }
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(model: )
//    }
//}
