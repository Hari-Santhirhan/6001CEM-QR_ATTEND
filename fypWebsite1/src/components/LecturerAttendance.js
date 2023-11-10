import React, { useState, useEffect } from "react";
import { Card, Button, Alert, Container, Row, Col, Modal, Form } from "react-bootstrap";
import { useAuth } from "../contexts/AuthContext";
import { Link, useHistory } from "react-router-dom";
import firebase from "firebase";
import 'firebase/firestore';
import app from "../firebase";
import GenerateQR from "./GenerateQR";

export default function LecturerAttendance() {
  const [error, setError] = useState("");
  const { currentUser, logout } = useAuth();
  const history = useHistory();
  const [rooms, setRooms] = useState([]);
  const [selectedRoom, setSelectedRoom] = useState('');
  const [subjects, setSubjects] = useState([]);
  const [selectedSubject, setSelectedSubject] = useState(null);
  const [showAlertDialog, setShowAlertDialog] = useState(false);

  // Initialize Firebase using the imported instance from firebase.js
  const db = app.firestore();

  // useEffect(() => {
  //   // Fetch room data from Firestore
  //   const unsubscribeRooms = db.collection('ble')
  //     .get()
  //     .then((querySnapshot) => {
  //       const roomOptions = querySnapshot.docs.map((doc) => doc.data().ble_room);
  //       setRooms(roomOptions);
  //     })
  //     .catch((error) => {
  //       console.error('Error fetching rooms:', error);
  //     });

  //   // Fetch subjects data from Firestore
  //   const unsubscribeSubjects = db.collection('subjects')
  //     .where('subject_lecturers', 'array-contains', currentUser.email)
  //     .onSnapshot((querySnapshot) => {
  //       const subjectList = [];
  //       querySnapshot.forEach((doc) => {
  //         subjectList.push(doc.data());
  //       });
  //       setSubjects(subjectList);
  //     });
  //     // Cleanup the Firestore listeners
  //     return () => {
  //       // if (roomListener) roomListener();
  //       // if (subjectsListener) subjectsListener();
  //     };
  // }, []);

  useEffect(() => {
    // Fetch room data from Firestore
    const unsubscribeRooms = db.collection('ble')
      .onSnapshot((querySnapshot) => {
        const roomOptions = querySnapshot.docs.map((doc) => doc.data().ble_room);
        setRooms(roomOptions);
      });

    // Fetch subjects data from Firestore
    const unsubscribeSubjects = db.collection('subjects')
      .where('subject_lecturers', 'array-contains', currentUser.email)
      .onSnapshot((querySnapshot) => {
        const subjectList = [];
        querySnapshot.forEach((doc) => {
          subjectList.push(doc.data());
        });
        setSubjects(subjectList);
      });

    // Cleanup the Firestore listeners
    return () => {
      unsubscribeRooms(); // Unsubscribe from room data
      unsubscribeSubjects(); // Unsubscribe from subjects data
    };
  }, []);

  function backToDashboard() {
    history.push("/LecturerDashboard");
  }

  function handleSubjectClick(subject) {
    setSelectedSubject(subject);
    setShowAlertDialog(true);
  }

  function handleCloseAlertDialog() {
    setShowAlertDialog(false);
  }

  function goToGenerateQR(SubjectName, SubjectCode, SemesterSession, RoomNumber){
    history.push({
      pathname: '/LecturerDashboard/LecturerAttendance/GenerateQR',
      state: { 
        subjectName1: SubjectName,
        subjectCode1: SubjectCode,
        semesterSession1: SemesterSession,
        roomNumber: RoomNumber 
      }
    });
  }

  return (
    <Container className="d-flex justify-content-center align-items-center" style={{ minHeight: "100vh" }}>
      <div>
        <p>Please choose a room number:</p>
        <select value={selectedRoom} onChange={(e) => setSelectedRoom(e.target.value)}>
          <option value="">Select a room</option>
          {rooms.map((room, index) => (
            <option key={index} value={room}>
              {room}
            </option>
          ))}
        </select>

        <p>Please select a subject:</p>
        <Row>
          {subjects.map((subject, index) => (
            <Col
              key={index}
              xs={12}
              style={{ backgroundColor: '#0075FF', color: 'white', marginBottom: '5px', cursor: 'pointer' }}
              onClick={() => {
                handleSubjectClick(subject)
              }}>
              <p>Subject Name: {subject['subject_name']}</p>
              <p>Subject Code: {subject['subject_code']}</p>
              <p>Semester Session: {subject['semester_session']}</p>
            </Col>
          ))}
        </Row>
        <div className="mt-3 text-center">
          <Button style={{ backgroundColor: '#12E8E8', color: 'black', width: 300 }} variant="primary" onClick={backToDashboard}>
            Back to Dashboard
          </Button>
        </div>
      </div>

      <Modal show={showAlertDialog} onHide={handleCloseAlertDialog}>
        <Modal.Header closeButton>
          <Modal.Title>Subject Selection Confirmation</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <p>Room Number: {selectedRoom}</p>
          <p>Subject Name: {selectedSubject ? selectedSubject.subject_name : ''}</p>
          <p>Subject Code: {selectedSubject ? selectedSubject.subject_code : ''}</p>
          <p>Semester Session: {selectedSubject ? selectedSubject.semester_session : ''}</p>
        </Modal.Body>
        <Modal.Footer>
          <Button variant="primary" onClick={() => goToGenerateQR(
            selectedSubject.subject_name,
            selectedSubject.subject_code,
            selectedSubject.semester_session,
            selectedRoom
            )}>Generate QR Code</Button>
          <Button variant="secondary" onClick={handleCloseAlertDialog}>Cancel</Button>
        </Modal.Footer>
      </Modal>
    </Container>
  );
}
