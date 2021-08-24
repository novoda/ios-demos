//
//  ErrorView.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-08-24.
//  Copyright © 2021 Novoda. All rights reserved.
//

import SwiftUI

struct ErrorView: View {
    let errorMessage: String?
    let refreshAction: () -> ()
    
    var body: some View {
        if let error = errorMessage {
            VStack {
                Text(error)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
                Button(action: refreshAction, label: {
                    Image(systemName: "arrow.clockwise")
                        .resizable()
                        .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                })
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(errorMessage: "Wubba Lubba Dub Dub! There was a problem loading. Tap the button to try again.", refreshAction: {})
        
    }
}
