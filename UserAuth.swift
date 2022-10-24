//
//  UserAuth.swift
//  LoanCalc
//
//  Created by Mukhtar Myrzakhanov on 24.10.2022.
//

import SwiftUI

struct UserAuth: View {
    var body: some View {
        //Text("Login form")
        VStack {
            Text("User")
                .badge("User Name")

            Text("Password")
                .badge("Password")
            Button("Submit") {
                print("I Know. It is no ready")
            }

        }
    }
}

struct UserAuth_Previews: PreviewProvider {
    static var previews: some View {
        UserAuth()
    }
}
