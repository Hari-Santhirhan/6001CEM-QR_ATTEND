import React, { useState, useEffect } from "react";
import { Card, Button, Alert, Container, Row, Col, Modal, Form } from "react-bootstrap";
import { useAuth } from "../contexts/AuthContext";
import { Link, useHistory } from "react-router-dom";
import firebase from "firebase";
import 'firebase/firestore';
import app from "../firebase";
import { useLocation } from "react-router-dom/cjs/react-router-dom.min";
import FileSaver from 'file-saver'; // Import the file-saver library
const Excel = require('excel4node'); // Import the excel4node library

export default function LecturerAttendanceSession() {
    const [error, setError] = useState("");
    const { currentUser } = useAuth();
    const history = useHistory();
    const location = useLocation();
    const { subjectName1, subjectCode1, semSession1, timeCreated1, roomNumber1 } = location.state;
    const [attendanceDetails, setAttendanceDetails] = useState([]);
    const [arrays2D, setArrays2D] = useState([]);

    // Initialize Firebase using the imported instance from firebase.js
    const db = app.firestore();

    useEffect(() => {
        const fetchData = async () => {
            try {
                const querySnapshot = await db.collection('attendance')
                    .where('subject_code', '==', subjectCode1)
                    .where('subject_name', '==', subjectName1)
                    .where('semester_session', '==', semSession1)
                    .where('time_created', '==', timeCreated1)
                    .where('classroom_number', '==', roomNumber1)
                    .get();

                if (!querySnapshot.empty) {
                    const document = querySnapshot.docs[0];
                    const data = document.data();

                    if (data) {
                        for (const value of Object.values(data)) {
                            if (Array.isArray(value) && value.length === 5) {
                                setArrays2D((prevArrays2D) => [...prevArrays2D, value]);
                            }
                        }
                    } else {
                        console.log('Document data is null.');
                    }
                } else {
                    console.log('No documents found.');
                }
            } catch (error) {
                console.error('Error fetching data from Firestore:', error);
            }
        };

        fetchData();
    }, [db, subjectCode1, subjectName1, semSession1, timeCreated1, roomNumber1]);

    function backToSubjectAttendances(){
        history.push({
            pathname: "/LecturerDashboard/LecturerAttendanceInfo/LecturerSubjectAttendances",
            state: {
                subjectName: subjectName1,
                subjectCode: subjectCode1,
                semesterSession: semSession1,
            },
        });
    }

    async function downloadFileAsExcel(arrays2D){
        try {
            const wb = new Excel.Workbook();
            const ws = wb.addWorksheet('Attendance Data');
            
            // Set column widths and autofit
            ws.column(1).setWidth(20);
            ws.column(2).setWidth(15);
            ws.column(3).setWidth(20);
            ws.column(4).setWidth(15);
            ws.column(5).setWidth(15);
            ws.column(6).setWidth(15);
            
            // Set headers
            ws.cell(1, 1).string("Student's Email");
            ws.cell(1, 2).string("Student ID");
            ws.cell(1, 3).string("Attendance Status");
            ws.cell(1, 4).string("Scan Status");
            ws.cell(1, 5).string("Scan Time");
            
            arrays2D.forEach((data, index) => {
                ws.cell(index + 2, 1).string(data[0].toString());
                ws.cell(index + 2, 2).string(data[1].toString());
                ws.cell(index + 2, 3).string(data[2].toString());
                ws.cell(index + 2, 4).string(data[3].toString());
                ws.cell(index + 2, 5).string(data[4].toString());
            });
            
            // Save the Excel file
            const excelBuffer = await wb.writeToBuffer();
            const blob = new Blob([excelBuffer], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
            
            FileSaver.saveAs(blob, 'AttendanceData.xlsx'); // FileSaver is used to prompt the user to download the file

            console.log("SAVE SUCCESSFUL");
        } catch (e) {
            console.error("EXCEL ERROR:", e);
        }
    }

    return (
        <>
            <hr />
            <div>
                {arrays2D.map((array, index) => (
                    // Render the array data here as needed
                    <div key={index}>
                        {array.map((item, itemIndex) => (
                            <div key={itemIndex}>
                                <p>{item}</p>
                            </div>
                        ))}
                        {index < arrays2D.length - 1 && <hr />} {/* Add a line if not the last array */}
                    </div>
                ))}
            </div>
            <hr />
            <div>
                <Button style={{ backgroundColor: '#18FF2F', color: 'black', width: 300 }} variant="primary" onClick={() => {downloadFileAsExcel(arrays2D)}}>
                    Download as Excel
                </Button>
                <Button style={{ backgroundColor: '#12E8E8', color: 'black', width: 300 }} variant="primary" onClick={backToSubjectAttendances}>
                    Back
                </Button>
            </div>
        </>
    );
}
