//
//  ContentDetailView.swift
//  LerningApp
//
//  Created by Brady Robshaw on 1/20/22.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        
        VStack {
            //only show video if url is valid
            if url != nil {
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            
            //description
            CodeTextView()
            
            //next lesson button
            if model.hasNextLesson() {
                Button (action: {
                    model.nextLesson()
                }, label: {
                    
                    ZStack {
                        Rectangle()
                            .frame(height: 48)
                            .foregroundColor(.green)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        
                        Text("Next Lesson \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                            .foregroundColor(.white)
                            .bold()
                    }
                })
            }
        }
        .padding()
        .navigationTitle(lesson?.title ?? "")
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
