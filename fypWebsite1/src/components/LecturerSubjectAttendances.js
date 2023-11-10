import React, { useState, useEffect } from "react";
import { Card, Button, Alert, Container, Row, Col, Modal, Form } from "react-bootstrap";
import { useAuth } from "../contexts/AuthContext";
import { Link, useHistory } from "react-router-dom";
import firebase from "firebase";
import 'firebase/firestore';
import app from "../firebase";
import { useLocation } from "react-router-dom/cjs/react-router-dom.min";

export default function LecturerSubjectAttendances(){
    const [error, setError] = useState("")
    const { currentUser } = useAuth()
    const history = useHistory()
    const location = useLocation();
    const { subjectName, subjectCode, semesterSession } = location.state
    const [attendanceList, setAttendanceList] = useState([]);

    // Initialize Firebase using the imported instance from firebase.js
    const db = app.firestore();

    useEffect(() => {
      // Fetch subjects data from Firestore
      const unsubscribeAttendance = db.collection('attendance')
        .where('subject_name', '==', subjectName)
        .where('subject_code', '==', subjectCode)
        .where('semester_session', '==', semesterSession)
        .onSnapshot((querySnapshot) => {
            const listOfAttendances = [];
            querySnapshot.forEach((doc) => {
            listOfAttendances.push(doc.data());
            });
            setAttendanceList(listOfAttendances);
        });
      // Cleanup the Firestore listeners
      return () => {
        unsubscribeAttendance(); // Unsubscribe from attendance data
      };
    }, []);

    function backToLecturerAttendance(){
        history.push('/LecturerDashboard/LecturerAttendanceInfo');
    }

    function goToLecturerAttendanceSession(subName2, subCode2, semSession2, timeCreated2, roomNumber2){
      console.log(subName2, subCode2, semSession2, timeCreated2, roomNumber2)
      history.push({
        pathname: '/LecturerDashboard/LecturerAttendanceInfo/LecturerSubjectAttendances/LecturerAttendanceSession',
        state: {
          subjectName1: subName2,
          subjectCode1: subCode2,
          semSession1: semSession2,
          timeCreated1: timeCreated2,
          roomNumber1: roomNumber2
        }
      });
    }

    return (
        <Container className="d-flex justify-content-center align-items-center" style={{ minHeight: "100vh" }}>
          <div>
            <p>Please select a session:</p>
            <Row>
              {attendanceList.map((attendance1, index) => (
                <Col
                  key={index}
                  xs={12}
                  style={{ backgroundColor: '#12E8E8', color: 'black', marginBottom: '5px', cursor: 'pointer' }}
                  onClick={() => {
                    goToLecturerAttendanceSession(
                      attendance1['subject_name'],
                      attendance1['subject_code'],
                      attendance1['semester_session'],
                      attendance1['time_created'],
                      attendance1['classroom_number']
                    );
                  }}>
                  <p>Time Created: {attendance1['time_created']}</p>
                  <p>Room Number: {attendance1['classroom_number']}</p>
                </Col>
              ))}
            </Row>
            <div className="mt-3 text-center">
              <Button style={{ backgroundColor: '#12E8E8', color: 'black', width: 300 }} variant="primary" onClick={backToLecturerAttendance}>
                Back
              </Button>
            </div>
          </div>
        </Container>
    );
}