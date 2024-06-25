//
//  ContentView.swift
//  post-network-call-ios
//
//  Created by Bholanath Barik on 23/06/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var services = FormSubmitServies();
    @State private var feedbackFormData: feedbackForm = feedbackForm(name : "", feedback: "");
    @State private var inputName = "";
    @State private var inputFeedback = "";
    
    var body: some View {
        VStack {
            Form {
                Section(header : Text("Your Form")){
                    TextField("Name", text: $feedbackFormData.name)
                    TextField("Feedback", text: $feedbackFormData.feedback)
                }
                
                Button(action: {
                    services.postFeedback(feedback: feedbackFormData)
                }) {
                    Text("Button post request");
                }
                .alert(isPresented: $services.showAlert, content: {
                    Alert(
                        title: Text("Feedback Status"),
                        message: Text(services.alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                })
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
