import SwiftUI

struct Librarycart: View {
    var Heading: String
    var Percentage: Int
    var image: String
    var Value: Int
    
    // Default initializer
    init() {
        self.Percentage = 8
        self.Heading = "Users"
        self.image = "book.closed"
        self.Value = 3689
    }
    
    // Custom initializer
    init(Percentage: Int, Heading: String, image: String, Value: Int) {
        self.Percentage = Percentage
        self.Heading = Heading
        self.image = image
        self.Value = Value
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 1) {
                Text(Heading)
                    .fontWeight(.light)
                    .font(.system(size: 14))
                    .foregroundColor(Color(.black))
                Spacer()
                Text(Image(systemName: image))
                    .font(.system(size: 36))
            }
            .padding(.vertical, 5)
            .frame(width:93,height: 60)
            
            VStack(alignment: .leading, spacing: 1) {
                Text("\(Percentage)%^")
                    .fontWeight(.semibold)
                    .font(.system(size: 15))
                    .foregroundColor(.green)
                Spacer()
                Text("\(Value)")
                    .fontWeight(.bold)
                    .font(.system(size: 14))
            }
            .padding([.trailing])
            .frame(width:62,height: 66)
        }
        .frame(width: 173.0, height: 100.0)
        .background(Color(.systemGray6))
        .cornerRadius(20)
    }
}

struct Librarycart_Previews: PreviewProvider {
    static var previews:some View {
        Librarycart(Percentage:15,Heading:"Total Users",image:"person.circle.fill",Value: 3689)
        Librarycart(Percentage:24,Heading:"Total Users",image:"book.closed",Value:1200)
        Librarycart(Percentage:8,Heading:"Fine collected",image:"indianrupeesign", Value:2048)
        Librarycart(Percentage:7,Heading:"Fine pending",image:"indianrupeesign", Value:2200)
        Librarycart(Percentage:14,Heading:"Issue requests",image:"book.pages",Value:2048)
        


    }
}

