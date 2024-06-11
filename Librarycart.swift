import SwiftUI

struct Librarycart: View {
    var Total: String
    var Percentage: Int
    var image: String
    var Books: Int
    
    // Default initializer
    init() {
        self.Percentage = 8
        self.Total = "Users"
        self.image = "book.closed"
        self.Books = 3689
    }
    
    // Custom initializer
    init(Percentage: Int, Total: String, image: String, Books: Int) {
        self.Percentage = Percentage
        self.Total = Total
        self.image = image
        self.Books = Books
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 1) {
                Text(Total)
                    .font(.custom("SF Pro", size: 12))
                    .foregroundColor(Color(.lightGray))
                
                Image(systemName: image)
                    .resizable()
                    .font(.system(size: 36, weight: .regular))
                    .frame(width: 52, height: 51)
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            VStack(alignment: .leading, spacing: 1) {
                Text("\(Percentage)% ^")
                    .font(.custom("SF Pro Bold", size: 18))
                    .foregroundColor(.green)
                
                Text("\(Books)")
                    .font(.custom("SF Pro Semibold", size: 18))
            }
            .padding([.leading, .bottom, .trailing])
        }
        .frame(width: 173.0, height: 100.0)
    }
}

struct Librarycart_Previews: PreviewProvider {
    static var previews: some View {
        Librarycart()
    }
}

