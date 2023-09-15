
import ballerina/http;
import ballerina/io;
import ballerina/log;

// Struct to represent a lecturer
type Lecturer record {
    string staffNumber;
    string name;
    string course;
    string office;
};

// In-memory data structure to store lecturer records
map<json> lecturerStore;

endpoint http:Listener listener {
    port: 9090
};

@http:ServiceConfig {
    basePath: "/lecturers"
}
service LecturersService on listener {

    @http:ResourceConfig {
        methods: ["POST"],
        path: "/"
    }
    resource function addLecturer(http:Caller caller, http:Request request) {
        // Read the lecturer's details from the request payload
        json payload = check request.getJsonPayload();
        Lecturer lecturer = {
            staffNumber: payload["staffNumber"].toString(),
            name: payload["name"].toString(),
            course: payload["course"].toString(),
            office: payload["office"].toString()
        };

        // Store the lecturer record in the in-memory data structure
        lecturerStore[lecturer.staffNumber] = jsonToMap(lecturer);

        // Send a response back to the client
        http:Response response = new;
        response.setPayload(json`{"message": "Lecturer added successfully"}`);
        _ = caller->respond(response);
    }

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/"
    }
    resource function getAllLecturers(http:Caller caller, http:Request request) {
        // Retrieve all lecturers from the in-memory data structure
        json[] lecturers = [];
        foreach var lecturer in lecturerStore {
            lecturers.push(<json>lecturer.value);
        }

        // Send the list of lecturers as the response payload to the client
        http:Response response = new;
        response.setPayload(json`{"lecturers": ${lecturers}}`);
        _ = caller->respond(response);
    }

    @http:ResourceConfig {
        methods: ["PUT"],
        path: "/{staffNumber}"
    }
    resource function updateLecturer(http:Caller caller, http:Request request, string staffNumber) {
        // Read the updated lecturer's details from the request payload
        json payload = check request.getJsonPayload();
        Lecturer lecturer = {
            staffNumber: staffNumber,
            name: payload["name"].toString(),
            course: payload["course"].toString(),
            office: payload["office"].toString()
        };

        // Update the lecturer record in the in-memory data structure
        lecturerStore[staffNumber] = jsonToMap(lecturer);

        // Send a response back to the client
        http:Response response = new;
        response.setPayload(json`{"message": "Lecturer updated successfully"}`);
        _ = caller->respond(response);
    }

    @http:ResourceConfig {
        methods: ["GET"],
        path: "/{staffNumber}"
    }
    resource function getLecturerByStaffNumber(http:Caller caller, http:Request request, string staffNumber) {
        // Retrieve the lecturer record by staff number from the in-memory data structure
        var lecturer = lecturerStore[staffNumber];

        // Send the lecturer details as the response payload to the client
        if (is lecturer) {
            http:Response response = new;
            response.setPayload(<json>lecturer);
            _ = caller->respond(response);
        } else {
            // Send a 404 not found response if the lecturer is not found
            http:Error error = {
                message: "Lecturer not found",
                status: http:NOT_FOUND
            };
            _ = caller->respond(error);
        }
    }

    @http:ResourceConfig {
        methods: ["DELETE"],
        path: "/{staffNumber}"
    }
    resource function deleteLecturerByStaffNumber(http:Caller caller, http:Request request, string staffNumber) {
        // Remove the lecturer record by staff number from the in-memory data structure
        var lecturer = lecturerStore[staffNumber];
        if (is lecturer) {
            lecturerStore.remove(staffNumber);

            // Send a response back to the client
            http:Response response = new;
            response.setPayload(json`{"message": "Lecturer deleted successfully"}`);
            _ = caller->respond(response);
        } else {
            // Send a 404 not found response if the lecturer is not found
            http:Error error = {
                message: "Lecturer not found",
                status: http:NOT_FOUND
            };
            _ = caller->respond(error);
        }
    }

    