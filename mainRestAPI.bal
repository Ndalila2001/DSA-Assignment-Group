import ballerina/http;
import ballerina/io;

type Lecturer record{
    readonly int staff_number;
    string lecturer_name;
    int office_number;
    string course_name;
    string course_code;
};

type Course record{
    readonly string course_code;
    string course_name;

};

type CourseLecturer record{
    readonly int staff_number;
    string course_name;
    string course_code;


};

table<Lecturer> key(staff_number) lecturerTable = table[];
table<Course> key(course_code) courseTable = table[];
table<CourseLecturer> key(staff_number) course_lecturerTable = table[];

service / on new http:Listener(5000) {

    resource function post addLecturer(Lecturer newLecturer) returns string|error {
    error? addLecturer = lecturerTable.add(newLecturer);
        if addLecturer is error {
            return error ("Failed to add lecturer!");
        }
            return newLecturer.lecturer_name + " added successfully!";
    }
   
    

    resource function put updateLecturer(Lecturer updatedLecturer) returns string|error {
        error? updateLecturer = lecturerTable.put(updatedLecturer);
        if updateLecturer is error {
            return error ("Failed to update lecturer information!");
        }
            return updatedLecturer.lecturer_name + "updated successfully!";
    }

    resource function delete deleteLecturer/[int staff_number]() returns string|error {
        Lecturer|error deleteLecturer = lecturerTable.remove(staff_number);
        if deleteLecturer is error {
            return error("Failed to delete lecturer record!");
        }
            return deleteLecturer.lecturer_name + "deleted successfully!";
    }
 resource function get getLecturer(http:Caller caller, http:Request req, string lecturer_name, int staff_number, string course_name, string course_code, int office_number) {
    Lecturer? lecturer = lecturerTable.get(staff_number);
    
    json payload;
    if (lecturer is Lecturer) {
        payload = {
            "name": lecturer_name,
            "staff number": staff_number,
            "Course": course_name,
            "Course code": course_code,
            "Office number": office_number
        };
    }
    
    http:Response response = new;
    _ = response.setJsonPayload(payload);
    _ = caller_respond(response);
}

    
    resource function get getLecturerWithStaffNumber() returns string|error {

        var lecturerStaffNumber = from var lecturer in lecturerTable
            join var lecturerStaffNum in lecturerTable
        on lecturer.staff_number equals lecturerStaffNum.staff_number
            join var staff_number in lecturerTable
        on lecturerStaffNum.staff_number equals lecturer.staff_number
            select {
            staff_number: lecturer.staff_number,
            lecturer_name: lecturer.lecturer_name,
            office_number: lecturer.office_number,
            course_name: lecturer.course_name,
            course_code: lecturer.course_code
        };

        io:println("lecturerStaffNumber", lecturerStaffNumber);

       
}

resource function get getLecturerWithCourse() returns string|error {
    
    var lecturerCourseName = from var lecturer in lecturerTable
        join var lecturerCourse in course_lecturerTable
     on lecturer.course_name equals lecturerCourse.course_name
        join var course_name in lecturerTable
    on lecturerCourse.course_name equals lecturer.course_name
       select {
            staff_number: lecturer.staff_number,
            lecturer_name: lecturer.lecturer_name,
            office_number: lecturer.office_number,
            course_name: lecturer.course_name,
            course_code: lecturer.course_code
       };
        io:println("lecturerCourseName", lecturerCourseName);


}
resource function get getLecturerWithOfficeNumber(http:Caller caller, http:Request req, string lecturer_name, int staff_number, string course_name, string course_code, int office_number) {
    Lecturer? lecturer = lecturerTable.get(office_number);
    
    json payload;
    if (lecturer is Lecturer) {
        payload = {
            "name": lecturer_name,
            "staff number": staff_number,
            "Course": course_name,
            "Course code": course_code,
            "Office number": office_number
        };
    }
     http:Response response = new;
    _ = response.setJsonPayload(payload);
    _ = caller_respond(response);

}
}