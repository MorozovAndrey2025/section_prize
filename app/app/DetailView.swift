import SwiftUI

struct DetailView: View {
    @Binding var book: Book

    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    Image(systemName: "books.vertical")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 76, height: 76)
                        .background(Color.appAccent, in: RoundedRectangle(cornerRadius: 22))
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }
            Section {
                LabeledContent("Автор", value: book.author)
            }
            Section {
                Toggle("Прочитана", isOn: $book.isRead)
            }
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Оценка")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    StarRatingView(rating: $book.rating)
                }
                .padding(.vertical, 4)
            }
            Section("О чем книга?") {
                TextEditor(text: $book.description)
                    .frame(minHeight: 120)
            }
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StarRatingView: View {
    @Binding var rating: Int
    private let maxRating = 5

    var body: some View {
        HStack(spacing: 10) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .font(.title)
                    .foregroundStyle(index <= rating ? .yellow : .gray.opacity(0.5))
                    .onTapGesture {
                        rating = (rating == index) ? 0 : index
                    }
                    .accessibilityLabel("\(index) из \(maxRating)")
            }
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(book: .constant(Book(title: "Мастер и Маргарита", author: "Булгаков", isRead: false)))
    }
}
