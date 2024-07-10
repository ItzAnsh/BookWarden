//
//  LibrarianRequestsView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 31/05/24.
//


//  LibrarianRequestsView.swift
//  BookWarden
//
//  Created by Ansh Bhasin on 31/05/24.
//

import SwiftUI
import AVFoundation

struct LibrarianRequestsView: View {
    @State private var searchText = ""
    @State private var isShowingScanner = false
    @State private var qrCodeString: String? = nil
    @State private var qrCodeAlert = false
    @State private var showModal = false
    @State private var issueDetails: Issue?
    @State private var errorMessage: String?
    @ObservedObject var issueManager = IssueManager.shared
    
    @State private var issues: [Issue] = []
    @State var issueAlert: Bool = false
    @State var currentState: Bool = false
    @State var currentIssueId: String = ""
    

    private var filteredIssues: [Issue] {
        let requestedIssues = issues.filter { $0.getStatus() == .requested }
        if searchText.isEmpty {
            return requestedIssues
        } else {
            return requestedIssues.filter { $0.getUser().getName().localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(filteredIssues) { issue in
                        SingleIssueRequestView(
                            user: issue.getUser().getName(),
                            image: issue.getBook().imageURL,
                            bookTitle: issue.getBook().title,
                            bookAuthor: issue.getBook().author,
                            issueDate: issue.getIssuedDate(),
                            issueId: issue.getId(),
                            issueState: $issueAlert,
                            currentState: $currentState,
                            currentIssueId: $currentIssueId
                        )
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationBarTitle(Text("Requests"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingScanner = true
                    }) {
                        Image(systemName: "qrcode.viewfinder")
                            .imageScale(.large)
                    }
                    .fullScreenCover(isPresented: $isShowingScanner) {
                        CameraView(qrCodeAlert: $qrCodeAlert, qrCodeString: $qrCodeString)
                    }
                }
            }
            .searchable(text: $searchText)
            .alert(isPresented: $qrCodeAlert) {
                Alert(
                    title: Text("QR Code Scanned"),
                    message: Text(qrCodeString ?? "No QR code found"),
                    dismissButton: .default(Text("OK"), action: {
                        if let qrCodeString = qrCodeString {
                            issueManager.fetchIssueDetails(issueId: qrCodeString, accessToken: UserManager.shared.accessToken) { result in
                                switch result {
                                case .success(let details):
                                    print(details)
                                    self.issueDetails = details
                                    self.showModal = true
                                case .failure(let error):
                                    print(error)
                                    self.errorMessage = error.localizedDescription
                                }
                            }
                        }
                    })
                )
            }
            .alert("Are you sure?", isPresented: $issueAlert) {
                
                Button("Cancel", role: .cancel) {
                    
                }
                Button(currentState ? "Approve" : "Reject", role: .destructive) {
                    if !currentState {
                        issueManager.rejectIssue(issueId: currentIssueId, accessToken: UserManager.shared.accessToken) { result in
                            switch result {
                            case .success:
                                print("Heelo")
                            case .failure(let error):
                                print("Error rejecting issue: \(error.localizedDescription)")
                            }
                        }
                    } else {
                        issueManager.approveIssue(issueId: currentIssueId, accessToken: UserManager.shared.accessToken) { result in
                            switch result {
                            case .success:
                                print("Hello")
                                
                            case .failure(let error):
                                print("Error approving issue: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showModal) {
                IssueRequestModalView(issueDetails: $issueDetails, isPresented: $showModal)
            }
            .onAppear {
                IssueManager.shared.fetchLibraryIssues(accessToken: UserManager.shared.accessToken) { result in
                    switch result {
                    case .success(let fetchedIssues):
                        self.issues = fetchedIssues
                    case .failure(let error):
                        print("Error fetching issues: \(error)")
                    }
                }
            }
        }
    }
}

#Preview {
    LibrarianRequestsView()
}

import SwiftUI

struct IssueRequestModalView: View {
    @Binding var issueDetails: Issue?
    @Binding var isPresented: Bool
    
    let allowedStatuses: [IssueStatus] = [.issued, .fined, .fining, .renewrequested, .renewrejected, .renewapproved]
    
    var body: some View {
        VStack {
            if let issueDetails = issueDetails {
                Text("\(issueDetails.getUser().getName())'s Return")
                    .font(.system(size: 32, weight: .medium, design: .default))
                    .frame(maxWidth: .infinity, maxHeight: 100)
                
                VStack {
                    AsyncImage(url: issueDetails.getBook().imageURL) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 180, height: 200)
                    .padding(.bottom, 10)
                    
                    VStack(spacing: 6) {
                        Text(issueDetails.getBook().title)
                            .font(.system(size: 32, weight: .medium, design: .default))
                            .padding(.bottom, 20)
                        HStack {
                            Text("Issue Date")
                                .font(.system(size: 16, weight: .medium, design: .default))
                            Spacer()
                            Text(issueDetails.getIssuedDate(), style: .date)
                                .font(.system(size: 16, weight: .medium, design: .default))
                        }
                        Divider()
                        HStack {
                            Text("Deadline")
                                .font(.system(size: 16, weight: .medium, design: .default))
                            Spacer()
                            Text(issueDetails.getDeadline(), style: .date)
                                .font(.system(size: 16, weight: .medium, design: .default))
                        }
                        Divider()
                        HStack {
                            Text("Status")
                                .font(.system(size: 16, weight: .medium, design: .default))
                            Spacer()
                            Text(issueDetails.getStatus().rawValue.capitalized)
                                .font(.system(size: 16, weight: .medium, design: .default))
                        }
                        Divider()
                    }
                    .safeAreaPadding()
                    
                    Spacer()
                    
                    // Conditionally show the "Approve" button
                    if allowedStatuses.contains(issueDetails.getStatus()) {
                        HStack {
                            Button {
                                approveReturn(issueId: issueDetails.getId())
                            } label: {
                                Text("Approve")
                                    .frame(width: 140, height: 50)
                                    .background(Color.blue)
                                    .cornerRadius(25)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .padding()
//        .alert(isPresented: $)
    }
    
    // Function to approve return using IssueManager
    private func approveReturn(issueId: String) {
        IssueManager.shared.approveReturn(issueId: issueId, accessToken: UserManager.shared.accessToken) { result in
            switch result {
            case .success():
                DispatchQueue.main.async {
                    self.isPresented = false // Dismiss the modal
                }
            case .failure(let error):
                print("Error approving return: \(error)")
            }
        }
    }
}
