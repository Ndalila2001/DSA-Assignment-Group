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
 
    resource function get getLecturerWithStaffNumber() returns string|error {

        var lecturerStaffNumber = from var lecturer in lecturerTable
            join var lecturerStaffNum in course_lecturerTable
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

