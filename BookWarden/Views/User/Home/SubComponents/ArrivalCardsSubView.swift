import SwiftUI

struct RecentBooksCard: View {
    var image: URL
    var name: String
    var authorName: String
    
    var body: some View {
        HStack {
            AsyncImage(url:  image) { image in
                image
                    .resizable()
                    .frame(width: 57, height: 57)
                    .scaledToFill()
                    .cornerRadius(8.0)
            } placeholder: {
                ProgressView() // Placeholder while loading image
            }
            
            VStack(alignment: .leading) {
                Text(name)
                    .fontWeight(.bold)
                    .font(.system(size: 13))
                    .lineLimit(2)
                Text(authorName)
                    .fontWeight(.light)
                    .font(.system(size: 13))
                    .lineLimit(1)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.trailing)
        .background(Color(.systemBackground))
        .cornerRadius(8.0)
    }
}

//#Preview {
//    RecentBooksCard(
//        image: "https://m.media-amazon.com/images/I/81w7a13pbnL.AC_SX500.jpg",
//        name: "The Black Orphan",
//        authorName: "S. Hussain Zaidi"
//    )
//}
