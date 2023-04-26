//
//  BasicFooterView.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 10/13/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import SwiftUI

struct BasicFooterView: View {
    var actionTitle:String
    var skipTitle:String
    var action: ()-> Void
    var skip: ()-> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            Button {
                action()
            } label: {
                Text(actionTitle)
                    .font(.body)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .accentColor(Color.systemPink)
                    .background(Color.white)
                    .cornerRadius(6.0)
            }
            Button {
                skip()
            } label: {
                Text(skipTitle)
                    .font(.body)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .accentColor(Color.systemPink)
                    .cornerRadius(6.0)
            }
            Spacer()
                .frame(height:20.0)
        }
    }
}

struct BasicFooterView_Previews: PreviewProvider {
    static var previews: some View {
        BasicFooterView(actionTitle: "setup.location.turnon".localized, skipTitle: "setup.location.skip".localized, action: {()}, skip: {()})
    }
}
