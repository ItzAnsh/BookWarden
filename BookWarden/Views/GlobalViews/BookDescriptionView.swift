import SwiftUI

struct BookDescriptionView: View {
    var body: some View {
        NavigationStack {
            VStack {
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("GENRE")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("Fiction")
                            .font(.system(size: 15))
                            .padding(.top,1)
                           
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("LANGUAGE")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("English")
                            .font(.system(size: 15))
                            .padding(.top,1)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("LENGTH")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("380 Pages")
                            .font(.system(size: 15))
                            .padding(.top,1)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("PUBLISHER")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("Public Domain")
                            .font(.system(size: 15))
                            .padding(.top,1)
                    }
                }
                .padding()
                
                Divider()
                
                NavigationLink(destination: RatingsAndReviewsView()) {
                    HStack {
                        Text("Ratings and Reviews")
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 203 / 255, green: 205 / 255, blue: 255 / 255))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(red: 203 / 255, green: 205 / 255, blue: 255 / 255))
                    }
                    .padding()
                }
                
                HStack {
                    ReviewCardView()
                    ReviewCardView()
                }
                .padding(.horizontal)
                
                NavigationLink(destination: MoreInSeriesView()) {
                    HStack {
                        Text("More in the Series")
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 203 / 255, green: 205 / 255, blue: 255 / 255))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(red: 203 / 255, green: 205 / 255, blue: 255 / 255))
                    }
                    .padding()
                }
                
                HStack {
                    BookCoverView(imageName: "iphone_user_guide")
                    BookCoverView(imageName: "august_expenses")
                }
                .padding(.horizontal)
                
                Spacer()
                
                
               
            }
            .navigationTitle("Library")
            .navigationBarTitleDisplayMode(.inline)
        }
       
    }
}

struct ReviewCardView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Best")
                .fontWeight(.bold)
            Text("Just loved this book")
            HStack(spacing:1) {
                ForEach(0..<4) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                Image(systemName: "star")
                    .foregroundColor(.yellow)
               
            }
            .font(.system(size: 12))
            Text("YashThakur")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 160)
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
       
    }
}

struct BookCoverView: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: 100, height: 150)
            .cornerRadius(10)
    }
}

struct RatingsAndReviewsView: View {
    var body: some View {
        Text("Ratings and Reviews")
    }
}

struct MoreInSeriesView: View {
    var body: some View {
        Text("More in the Series")
    }
}


#Preview {
    BookDescriptionView()
}
