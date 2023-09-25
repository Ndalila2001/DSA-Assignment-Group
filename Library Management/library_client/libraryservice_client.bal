import ballerina/io;

LibraryServiceClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    Book addBookRequest = {title: "ballerina", author: "ballerina", location: "ballerina", isbn: 1, available: true};
    AddBookResponse addBookResponse = check ep->AddBook(addBookRequest);
    io:println(addBookResponse);

    Book updateBookRequest = {title: "ballerina", author: "ballerina", location: "ballerina", isbn: 1, available: true};
    UpdateBookResponse updateBookResponse = check ep->UpdateBook(updateBookRequest);
    io:println(updateBookResponse);

    LocateBookRequest locateBookRequest = {isbn: 1};
    LocateBookResponse locateBookResponse = check ep->LocateBook(locateBookRequest);
    io:println(locateBookResponse);

    BorrowBookRequest borrowBookRequest = {user_id: "ballerina", isbn: 1};
    BorrowBookResponse borrowBookResponse = check ep->BorrowBook(borrowBookRequest);
    io:println(borrowBookResponse);

    string removeBookRequest = "ballerina";
    stream<Book, error?> removeBookResponse = check ep->RemoveBook(removeBookRequest);
    check removeBookResponse.forEach(function(Book value) {
        io:println(removeBookResponse);
    });
    stream<

Book, error?> listAvailableBooksResponse = check ep->ListAvailableBooks();
    check listAvailableBooksResponse.forEach(function(Book value) {
        io:println(value);
    });

    User createUsersRequest = {user_id: "ballerina", profile: "ballerina"};
    CreateUsersStreamingClient createUsersStreamingClient = check ep->CreateUsers();
    check createUsersStreamingClient->sendUser(createUsersRequest);
    check createUsersStreamingClient->complete();
    CreateUserResponse? createUsersResponse = check createUsersStreamingClient->receiveCreateUserResponse();
    io:println(createUsersResponse);
}

