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
        Text("Hello, world!")
            .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
