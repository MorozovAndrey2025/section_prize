import SwiftUI
import Combine

class Store: ObservableObject {
    @Published var books: [Book] = []
    
    private let saveKey = "SavedBooks"
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadBooks()
        
        // Автоматически сохраняем при любом изменении массива books
        $books.sink { [weak self] _ in
            self?.saveBooks()
        }.store(in: &cancellables)
    }

    func loadBooks() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Book].self, from: data) {
            books = decoded
        } else {
            books = [
                Book(title: "Мастер и Маргарита", author: "Булгаков", isRead: false, rating: 0, description: ""),
                Book(title: "1984", author: "Оруэлл", isRead: false),
                Book(title: "Дюна", author: "Херберт", isRead: false),
                Book(title: "Маленький принц", author: "Экзюпери", isRead: false, rating: 0, description: "")
            ]
        }
    }

    func saveBooks() {
        if let encoded = try? JSONEncoder().encode(books) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    func add(title: String, author: String) {
        let newBook = Book(title: title, author: author, isRead: false)
        books.append(newBook)
        // saveBooks вызовется автоматически благодаря sink
    }

    func delete(at offsets: IndexSet) {
        books.remove(atOffsets: offsets)
        // saveBooks вызовется автоматически благодаря sink
    }
}
