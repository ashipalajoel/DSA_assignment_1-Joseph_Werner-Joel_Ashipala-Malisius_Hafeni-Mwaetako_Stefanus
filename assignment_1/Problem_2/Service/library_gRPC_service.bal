import ballerina/grpc;
import ballerina/io;

type BookRecord record {
    string title;
    string author_1;
    string author_2?;
    string location;
    string isbn;
    boolean available;
};

map<string> booksMap = {};

type LibraryService record {
    
};

service LibraryService on new grpc:Service(9090) {
    resource function addBook(grpc:Caller caller, BookRecord book) returns (BookRecord|error) {
        // Generate a unique ISBN for the book
        string isbn = generateISBN();
        book.isbn = isbn;

        // Add the book to the books map
        booksMap[isbn] = book;
        
        // Set the book as available by default
        book.available = true;

        // Return the added book with the assigned ISBN
        return book;
    }

    resource function createUsers(stream<grpc:Caller> callerStream) returns error? {
        // Read the user stream
        foreach grpc:Caller caller in callerStream {
            // Process each user
            // ... your implementation here ...
        }
        
        // Return without errors
        return ();
    }

    resource function updateBook(grpc:Caller caller, string isbn, BookRecord book) returns error? {
        // Check if the book exists
        if (booksMap.hasKey(isbn)) {
            // Update the book details
            booksMap[isbn] = book;
        } else {
            // Book not found
            return grpc:Error("Book not found");
        }
        
        // Return without errors
        return ();
    }

    resource function removeBook(grpc:Caller caller, string isbn) returns BookRecord[]|error {
        // Check if the book exists
        if (booksMap.hasKey(isbn)) {
            // Remove the book from the map
            _ = booksMap.remove(isbn);
        } else {
            // Book not found
            return grpc:Error("Book not found");
        }
        
        // Return the updated list of books
        return booksMap.values();
    }

    resource function listAvailableBooks(grpc:Caller caller) returns BookRecord[] {
        // Filter and return the available books
        BookRecord[] availableBooks = booksMap.values()
            .filter((BookRecord book) => book.available == true);
        
        return availableBooks;
    }

    resource function locateBook(grpc:Caller caller, string isbn) returns (string|error) {
        // Check if the book exists
        if (booksMap.hasKey(isbn)) {
            // Retrieve the book
            BookRecord book = booksMap[isbn];
            
            if (book.available) {
                // Book is available, return the location
                return book.location;
            } else {
                // Book is not available
                return grpc:Error("Book is not available");
            }
        } else {
            // Book not found
            return grpc:Error("Book not found");
        }
    }

    resource function borrowBook(grpc:Caller caller, string isbn, string borrower) returns (boolean|error) {
        // Check if the book exists
        if (booksMap.hasKey(isbn)) {
            // Retrieve the book
            BookRecord book = booksMap[isbn];
            
            if (book.available) {
            }
        }
    }
function generateISBN() returns string {
    return "";
}
}