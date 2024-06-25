//
//  FormSubmitServies.swift
//  post-network-call-ios
//
//  Created by Bholanath Barik on 23/06/24.
//

import Foundation

// ViewModel class to handle form submission and alert state
class FormSubmitServies: ObservableObject {
    @Published var alertMessage: String = ""  // Message to be shown in alert
    @Published var showAlert: Bool = false    // Boolean to control alert visibility
    
    // Function to post feedback data to server
    func postFeedback(feedback: feedbackForm) {
        // Ensure the URL is valid
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"  // HTTP method is POST
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")  // Setting the content type to JSON
        
        do {
            // Encode the feedback object to JSON data
            let jsonData = try JSONEncoder().encode(feedback)
            request.httpBody = jsonData  // Set the request body with JSON data
            
            // Create a data task to perform the network call
            URLSession.shared.dataTask(with: request) { data, response, error in
                // Handle errors in the network call
                if let error = error {
                    DispatchQueue.main.async {
                        self.alertMessage = "Failed to send feedback: \(error.localizedDescription)"
                        self.showAlert = true
                    }
                    return
                }
                
                // Check if the response status code is 201 (Created)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                    DispatchQueue.main.async {
                        self.alertMessage = "Failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)"
                        self.showAlert = true
                    }
                    return
                }
                
                // If the feedback is successfully sent
                DispatchQueue.main.async {
                    self.alertMessage = "Feedback sent successfully!"
                    self.showAlert = true
                }
            }.resume()  // Start the network task
        } catch {
            // Handle errors in JSON encoding
            DispatchQueue.main.async {
                self.alertMessage = "Failed to encode feedback"
                self.showAlert = true
            }
        }
    }
}
