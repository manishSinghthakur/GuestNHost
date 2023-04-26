//
//  BasicHeaderView.swift
//  Nisumapp (iOS)
//
//  Created by sboju on 10/13/21.
//  Copyright © 2021 Nisum. All rights reserved.
//

import SwiftUI

struct BasicHeaderView: View {
    var title:String
    var subtitle:String
    var body: some View {
        VStack(alignment: .leading, spacing: 20.0) {
            Spacer()
                .frame(height:40.0)
            Text(title)
                .font(.title)
                .bold()
                .layoutPriority(1)
                .foregroundColor(Color.label)
                .multilineTextAlignment(.leading)
            Text(subtitle)
                .foregroundColor(Color.secondaryLabel)
        }
        .padding(20.0)
    }
}

struct BasicHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        BasicHeaderView(title: "setup.location.title".localized, subtitle: "setup.location.subtitle".localized)
    }
}
