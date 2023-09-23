import ballerina/http;
import ballerina/io;

// Define the base URL of the lecturer management API
string baseUrl = "https://api.example.com/lecturers";

// Function to add a new lecturer
public function addLecturer() returns error? {
    http:Request addLecturerRequest = new;
    addLecturerRequest.method = http:POST;
    addLecturerRequest.setJsonPayload({
        "staffNumber": "123456",
        "name": "John Doe",
        "faculty": "Engineering",
        // Add other lecturer details here
    });
    
    var addLecturerResponse = check http:ClientConnector(baseUrl).send(addLecturerRequest);
    if (addLecturerResponse is http:Response) {
        io:println("Lecturer added successfully");
    } else {
        io:println("Failed to add lecturer: ", addLecturerResponse.toString());
    }
}

// Function to retrieve a list of all lecturers within the faculty
public function getAllLecturersInFaculty(string faculty) returns json|error? {
    http:Request getLecturersRequest = new;
    getLecturersRequest.method = http:GET;
    getLecturersRequest.setQueryParam("faculty", faculty);
    
    var getLecturersResponse = check http:ClientConnector(baseUrl).send(getLecturersRequest);
    if (getLecturersResponse is http:Response) {
        return check getLecturersResponse.getJsonPayload();
    } else {
        io:println("Failed to retrieve lecturers: ", getLecturersResponse.toString());
        return ();
    }
}

// Add similar functions for other operations (update, retrieve by staff number, delete, retrieve by course, retrieve by office)

public function main() {
    // Call the functions to perform the desired operations
    error? lecturer = addLecturer();
    if lecturer is error {

    }
    
    // Example: Retrieve all lecturers in the "Engineering" faculty
    json|error? lecturerList = getAllLecturersInFaculty("Engineering");
    if (lecturerList is json) {
        io:println("List of lecturers in Engineering faculty:", lecturerList.toString());
    } else {
        io:println("Error while retrieving lecturers.");
    }
}