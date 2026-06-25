import SwiftUI

extension Color {
    static let appAccent = Color.mint
}

struct Book: Identifiable, Codable {
    let id = UUID()
    var title: String
    var author: String
    var isRead: Bool
    var rating: Int = 0
    var description: String = ""
}

struct ContentView: View {
    @StateObject private var store = Store()
    @State private var showingAddSheet = false
    @State private var newTitle = ""
    @State private var newAuthor = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.books.indices, id: \.self) { index in
                    NavigationLink {
                        DetailView(book: $store.books[index])
                    } label: {
                        RowView(book: store.books[index])
                    }
                }
                .onDelete(perform: store.delete)
            }
            .navigationTitle("Список книг")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                NavigationStack {
                    Form {
                        TextField("Название", text: $newTitle)
                        TextField("Автор", text: $newAuthor)
                    }
                    .navigationTitle("Новая книга")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Отмена") {
                                showingAddSheet = false
                                newTitle = ""
                                newAuthor = ""
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Добавить") {
                                store.add(title: newTitle, author: newAuthor)
                                showingAddSheet = false
                                newTitle = ""
                                newAuthor = ""
                            }
                            .disabled(newTitle.isEmpty || newAuthor.isEmpty)
                        }
                    }
                }
            }
        }
        .tint(.appAccent)
    }
}

struct RowView: View {
    let book: Book

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "books.vertical")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(Color.appAccent, in: RoundedRectangle(cornerRadius: 9))
            VStack(alignment: .leading, spacing: 2) {
                Text(book.title)
                    .font(.headline)
                Text(book.author)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: book.isRead ? "bookmark.fill" : "bookmark")
                .font(.title3)
                .foregroundStyle(book.isRead ? Color.appAccent : Color.gray.opacity(0.4))
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
}
