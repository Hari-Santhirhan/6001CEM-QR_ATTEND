import React, { useState, useEffect } from "react";
import { Card, Button, Alert, Container, Row, Col, Modal, Form } from "react-bootstrap";
import { useAuth } from "../contexts/AuthContext";
import { Link, useHistory } from "react-router-dom";
import firebase from "firebase";
import 'firebase/firestore';
import app from "../firebase";

export default function LecturerAttendanceInfo(){
  const [error, setError] = useState("")
  const { currentUser } = useAuth()
  const history = useHistory()
  const [classSubjects, setClassSubjects] = useState([]);

  // Initialize Firebase using the imported instance from firebase.js
  const db = app.firestore();

  useEffect(() => {
    // Fetch subjects data from Firestore
    const unsubscribeSubjects1 = db.collection('subjects')
      .where('subject_lecturers', 'array-contains', currentUser.email)
      .onSnapshot((querySnapshot) => {
        const subjectList = [];
        querySnapshot.forEach((doc) => {
          subjectList.push(doc.data());
        });
        setClassSubjects(subjectList);
      });
    // Cleanup the Firestore listeners
    return () => {
      unsubscribeSubjects1(); // Unsubscribe from subjects data
    };
  }, []);

  function backToDashboard(){
      history.push("/LecturerDashboard");
  }

  function goToLecturerSubjectAttendances(subName, subCode, semSession){
    history.push({
      pathname: '/LecturerDashboard/LecturerAttendanceInfo/LecturerSubjectAttendances',
      state: {
        subjectName: subName,
        subjectCode: subCode,
        semesterSession: semSession
      }
    });
  }

  return (
    <Container className="d-flex justify-content-center align-items-center" style={{ minHeight: "100vh" }}>
      <div>
        <p>Please select a subject:</p>
        <Row>
          {classSubjects.map((subject, index) => (
            <Col
              key={index}
              xs={12}
              style={{ backgroundColor: '#0075FF', color: 'white', marginBottom: '5px', cursor: 'pointer' }}
              onClick={() => {
                goToLecturerSubjectAttendances(
                  subject['subject_name'],
                  subject['subject_code'],
                  subject['semester_session']
                );
              }}>
              <p>Subject Name: {subject['subject_name']}</p>
              <p>Subject Code: {subject['subject_code']}</p>
              <p>Semester Session: {subject['semester_session']}</p>
            </Col>
          ))}
        </Row>
        <div className="mt-3 text-center">
          <Button style={{ backgroundColor: 'orange', color: 'black', width: 300 }} variant="primary" onClick={backToDashboard}>
            Back to Dashboard
          </Button>
        </div>
      </div>
    </Container>
  );
}