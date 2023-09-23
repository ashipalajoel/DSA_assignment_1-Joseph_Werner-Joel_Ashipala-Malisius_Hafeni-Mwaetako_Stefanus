import ballerina/grpc;

endpoint grpc:Client libraryClient {
    targetUrl: "grpc://localhost:9090",
    clientConfig: {}
};

// Add a book
function addBook(string title, string author, string isbn) returns int32? {
    var addBookRequest = new AddBookRequest();
    addBookRequest.title = title;
    addBookRequest.author = author;
    addBookRequest.isbn = isbn;

    var addBookResponse = libraryClient->addBook(addBookRequest);
    if (addBookResponse is AddBookResponse) {
        return addBookResponse.bookId;
    } else {
        return ();
    }
}

// Create users
function createUsers(stream<CreateUserRequest> userStream) returns int32? {
    var createUserResponse = libraryClient->createUsers(userStream);
    if (createUserResponse is CreateUserResponse) {
        return createUserResponse.userId;
    } else {
        return ();
    }
}

// Update a book
function updateBook(int32 bookId, string title, string author, string isbn) returns boolean {
    var updateBookRequest = new UpdateBookRequest();
    updateBookRequest.bookId = bookId;
    updateBookRequest.title = title;
    updateBookRequest.author = author;
    updateBookRequest.isbn = isbn;

    var updateBookResponse = libraryClient->updateBook(updateBookRequest);
    return updateBookResponse.success;
}

// Remove a book
function removeBook(int32 bookId) returns Book[]? {
    var removeBookRequest = new RemoveBookRequest();
    removeBookRequest.bookId = bookId;

    var removeBookResponse = libraryClient->removeBook(removeBookRequest);
    if (removeBookResponse is RemoveBookResponse) {
        return removeBookResponse.bookList;
    } else {
        return ();
    }
}

// List available books
function listAvailableBooks() returns Book[]? {
    var listAvailableBooksRequest = new ListAvailableBooksRequest();

    var availableBooksStream = libraryClient->listAvailableBooks(listAvailableBooksRequest);
    var bookList = [];
    while (true) {
        var availableBooksResponse = availableBooksStream.next();
        if (availableBooksResponse is ListAvailableBooksResponse) {
            bookList.addAll(availableBooksResponse.bookList);
        } else {
            break;
        }
    }

    if (bookList.length() > 0) {
        return bookList;
    } else {
        return ();
    }
}

// Locate a book
function locateBook(string isbn) returns LocateBookResponse? {
    var locateBookRequest = new LocateBookRequest();
    locateBookRequest.isbn = isbn;

    var locateBookResponse = libraryClient->locateBook(locateBookRequest);
    return locateBookResponse;
}

// Borrow a book
function borrowBook(int32 bookId, int32 userId) returns BorrowBookResponse? {
    var borrowBookRequest = new BorrowBookRequest();
    borrowBookRequest.bookId = bookId;
    borrowBookRequest.userId = userId;

    var borrowBookResponse = libraryClient->borrowBook(borrowBookRequest);
    return borrowBookResponse;
}
