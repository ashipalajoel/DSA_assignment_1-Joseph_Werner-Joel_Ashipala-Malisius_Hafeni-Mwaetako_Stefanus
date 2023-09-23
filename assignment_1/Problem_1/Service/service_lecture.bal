import ballerina/http;
import ballerina/io;
import ballerina/log;

type Lecturer record {
    string staffNumber;
    string name;
    string officeNumber;
    string courseCode;
};

// In-memory store to hold lecturer records
type lecturer record {
    
};

map<lecturer> lecturerStore;

// Add a new lecturer
public function addLecturer(endpoint http:Caller caller, lecturer newLecturer) {
    lecturerStore[newLecturer.staffNumber] = newLecturer;
    log:printInfo("Lecturer added: " + newLecturer.staffNumber);
    http:Response response = new;
    response.statusCode = 201;
    _ = caller->respond(response);
}

// Retrieve a list of all lecturers
public function getAllLecturers(endpoint http:Caller caller) {
    lecturer[] lecturers = lecturerStore.values();
    http:Response response = new;
    response.setJsonPayload(lecturers);
    _ = caller->respond(response);
}

// Update an existing lecturer's information
public function updateLecturerByStaffNumber(endpoint http:Caller caller, string staffNumber, lecturer updatedLecturer) {
    if (lecturerStore.hasKey(staffNumber)) {
        lecturerStore[staffNumber] = updatedLecturer;
        log:printInfo("Lecturer updated: " + staffNumber);
        http:Response response = new;
        response.statusCode = 200;
        _ = caller->respond(response);
    } else {
        http:Response response = new;
        response.statusCode = 404;
        _ = caller->respond(response);
    }
}

// Retrieve the details of a specific lecturer by their staff number
public function getLecturerByStaffNumber(endpoint http:Caller caller, string staffNumber) {
    if (lecturerStore.hasKey(staffNumber)) {
        lecturer lecturer = lecturerStore[staffNumber];
        http:Response response = new;
        response.setJsonPayload(lecturer);
        _ = caller->respond(response);
    } else {
        http:Response response = new;
        response.statusCode = 404;
        _ = caller->respond(response);
    }
}

// Delete a lecturer's record by their staff number
public function deleteLecturerByStaffNumber(endpoint http:Caller caller, string staffNumber) {
    if (lecturerStore.hasKey(staffNumber)) {
        lecturerStore.remove(staffNumber);
        log:printInfo("Lecturer deleted: " + staffNumber);
        http:Response response = new;
        response.statusCode = 204;
        _ = caller->respond(response);
    } else {
        http:Response response = new;
        response.statusCode = 404;
        _ = caller->respond(response);
    }
}

// Retrieve all the lecturers that teach a certain course
type endpoint record {
    
};

public function getLecturersByCourseCode(endpoint http:Caller caller, string courseCode) {
    lecturer[] lecturers = lecturerStore.values();
    lecturer[] filteredLecturers = lecturers.filter(function (lecturer l) returns boolean {
        return l.courseCode == courseCode;
    });
    http:Response response = new;
    response.setJsonPayload(filteredLecturers);
}