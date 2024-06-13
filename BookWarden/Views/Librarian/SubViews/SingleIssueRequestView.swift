import SwiftUI

struct SingleIssueRequestView: View {
    var user: String
    var image: URL?
    var bookTitle: String
    var bookAuthor: String
    var issueDate: Date
    var issueId: String
    @Binding var issueState: Bool
    @Binding var currentState: Bool
    @Binding var currentIssueId: String
    @ObservedObject var issueManager = IssueManager.shared
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(user)
                .foregroundColor(.primary)
                .font(.system(size: 19))
                .fontWeight(.bold)
            Divider()
            HStack {
                if let image = image {
                    AsyncImage(url: image) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 80, height: 95)
                } else {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 80, height: 95)
                }
                Spacer()
                    .frame(width: 35)
                VStack(alignment: .leading) {
                    Text(bookTitle)
                        .fontWeight(.bold)
                        .font(.system(size: 19))
                    Spacer()
                        .frame(height: 2)
                    Text(bookAuthor)
                        .fontWeight(.thin)
                        .font(.system(size: 17))
                    Spacer()
                        .frame(height: 9)
                    Text("Issue Date: \(issueDate, formatter: dateFormatter)")
                }
            }
            Divider()
            HStack {
                Button(action: {
                    issueState = true
                    currentState = false
                    currentIssueId = issueId
//                    rejectIssue()
                }) {
                    Text("REJECT")
                        .font(.system(size: 12))
                        .frame(width: 50, height: 10)
                }
                .padding()
                .foregroundColor(.white)
                .fontWeight(.bold)
                .background(Color.blue)
                .cornerRadius(.infinity)
                .frame(width: 100, height: 10)

                Spacer()

                Button(action: {
                    issueState = true
                    currentState = true
                    currentIssueId = issueId
//                    approveIssue()
                }) {
                    Text("ACCEPT")
                        .font(.system(size: 12))
                        .frame(width: 50, height: 10)
                }
                .padding()
                .foregroundColor(.white)
                .fontWeight(.bold)
                .background(Color.blue)
                .cornerRadius(.infinity)
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(red: 242 / 255, green: 242 / 255, blue: 247 / 255))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
    
    private func rejectIssue() {
        issueManager.rejectIssue(issueId: issueId, accessToken: UserManager.shared.accessToken) { result in
            switch result {
            case .success:
                print("Heelo")
            case .failure(let error):
                print("Error rejecting issue: \(error.localizedDescription)")
            }
        }
    }
    private func approveIssue() {
            issueManager.approveIssue(issueId: issueId, accessToken: UserManager.shared.accessToken) { result in
                switch result {
                case .success:
                    print("Hello")
                case .failure(let error):
                    print("Error approving issue: \(error.localizedDescription)")
                }
            }
        }
}
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()
