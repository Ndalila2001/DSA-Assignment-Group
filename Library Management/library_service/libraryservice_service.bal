import ballerina/grpc;

listener grpc:Listener ep = new (9090);

type book record {
    readonly string title;
    int isbn;
    string auhtor;
    string location;
    boolean available;
};

type user record {
    readonly string user_id;
    string profile;
};

table<user> key(user_id) userTable = table[];
table<book> key(title)  bookTable = table[];

@grpc:Descriptor {value: LIBRARY_DESC}
service "LibraryService" on ep {

    remote function AddBook(Book newBook) returns AddBookResponse|error {
        error? addNewBook = bookTable.add(newBook);
        if addNewBook is error {
            return addNewBook;
        } else {
            return newBook.isbn;
        }
    }
    remote function UpdateBook(Book value) returns UpdateBookResponse|error {
        error? addNewBook = bookTable.put(value);
        if addNewBook is error {
            return addNewBook;
        } else {
            return {message: "saved successfully"};
        }
    }
    remote function LocateBook(LocateBookRequest value) returns LocateBookResponse|error {
        book   getBook = bookTable.get(value);
        if (getBook.isbn === "") {
            return error("Book cannot be found");
        } else {
            return getBook;
        }
    }

    remote function CreateUsers(stream<User, grpc:Error?> clientStream) returns CreateUserResponse|error {
        error? addNewUser = userTable.add(value);
        if addNewUser is error {
            return addNewUser;
        } else {
            return {message: "User created successfully"};
        }
    }
    remote function RemoveBook(string value) returns stream<Book, error?>|error {
        book deletedBook = bookTable.remove(value);
        return {
            bookTable
        };
    }
    remote function ListAvailableBooks() returns stream<Book, error?>|error {
        stream<book, error?> courseStream = stream from var book in bookTable.toArray()
            select book;

    return BookStream;
    }
}

