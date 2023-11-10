import React, { useState, useEffect } from "react";
import { Card, Button, Alert, Container, Row, Col, Modal, Form } from "react-bootstrap";
import { useAuth } from "../contexts/AuthContext";
import { Link, useHistory, useLocation } from "react-router-dom";
import firebase from "firebase";
import 'firebase/firestore';
import app from "../firebase";
import QRCode from "react-qr-code";
import { wait } from "@testing-library/react";

export default function GenerateQR(){
    const history = useHistory();
    const location = useLocation();
    const {subjectName1, subjectCode1, semesterSession1, roomNumber} = location.state;
    const db = app.firestore();
    const [bleValue, setBleValue] = useState('');
    const studentNamesArray = []; // Collect names in an array
    const studentEmailsArray = []; // Collect emails in an array
    const absentEmailsArray = []; // Collect absent student emails
    const [studentNames2, setStudentNames2] = useState([]);
    const [studentEmail2, setStudentEmails2] = useState([]);
    const absentStudentEmails3 = [];
    const [qrCodeSessionID, setQrCodeSessionID] = useState('');
    const [absentStudentEmails2, setAbsentStudentEmails2] = useState([]);
    const [timeCreatedQR, setTimeCreatedQR] = useState('');
    const dateTimeInfo = [];
    const [currentStudentEmail1, setCurrentStudentEmail1]  = useState('');
    const [currentUserName1, setCurrentUserName1] = useState('');
    let currentStudentEmailNew2 = '';
    let currentStudentNameNew2 = '';
    let qrCodeCreatedTime1 = '';

    // useEffect(() => {
    //   let isMounted = true; // NEW ADDED

    //   db.collection('ble')
    //   .where('ble_room', '==', roomNumber)
    //   .get()
    //   .then((querySnapshot) => {
    //       if (!querySnapshot.empty && isMounted) { // NEW ADDED
    //       // If a document was found, querySnapshot will not be empty
    //       const doc = querySnapshot.docs[0]; // Only one document will be found
    //       const data = doc.data();
    //       setBleValue(data['ble_device_id']);

    //       // You can access the document data using data
    //       console.log(data);
    //       } else if (isMounted) { // NEW ADDED
    //       // Handle the case where no document was found
    //       console.log('No document found with the specified roomNumber.');
    //       }
    //   })
    //   .catch((error) => {
    //     if (isMounted) { // NEW ADDED
    //       console.error('Error querying Firestore:', error);
    //     }
    //   });

    //   db.collection('subjects')
    //   .where('subject_code', '==', subjectCode1)
    //   .where('semester_session', '==', semesterSession1)
    //   .get()
    //   .then((querySnapshot) => {
    //       if (!querySnapshot.empty && isMounted) { // NEW ADDED
    //       // If a document was found, querySnapshot will not be empty
    //       const doc = querySnapshot.docs[0]; // Only one document will be found
    //       const data = doc.data();
    //       const subjectStudentDetails = data['subject_students']

    //       if (subjectStudentDetails != null && isMounted){ // NEW ADDED
    //         const stringValues = subjectStudentDetails
    //         .map(student => student.email)
    //         .filter(email => email != null);
    //         getStudents(stringValues);
    //       }

    //       } else if (isMounted) { // NEW ADDED
    //       // Handle the case where no document was found
    //       console.log('No document found with the specified roomNumber.');
    //       }
    //   })
    //   .catch((error) => {
    //     if (isMounted) { // NEW ADDED
    //       console.error('Error querying Firestore:', error);
    //     }
    //   });
    //   return () => {
    //     // This cleanup function will run when the component unmounts
    //     isMounted = false;
    //   };
    // }, [roomNumber, subjectCode1, semesterSession1]);

    useEffect(() => {
      let isMounted = true;
  
      // Firestore query for 'ble' collection
      const bleQuery = db.collection('ble')
        .where('ble_room', '==', roomNumber);
  
      // Firestore query for 'subjects' collection
      const subjectsQuery = db.collection('subjects')
        .where('subject_code', '==', subjectCode1)
        .where('semester_session', '==', semesterSession1);
  
      const fetchBleData = async () => {
        try {
          const bleSnapshot = await bleQuery.get();
          if (!bleSnapshot.empty && isMounted) {
            const doc = bleSnapshot.docs[0];
            const data = doc.data();
            setBleValue(data['ble_device_id']);
          }
        } catch (error) {
          if (isMounted) {
            console.error('Error fetching ble data:', error);
          }
        }
      };
  
      const fetchSubjectData = async () => {
        try {
          const subjectsSnapshot = await subjectsQuery.get();
          if (!subjectsSnapshot.empty && isMounted) {
            const doc = subjectsSnapshot.docs[0];
            const data = doc.data();
            const subjectStudentDetails = data['subject_students'];
  
            if (subjectStudentDetails != null && isMounted) {
              const stringValues = subjectStudentDetails
                .map(student => student.email)
                .filter(email => email != null);
              getStudents(stringValues);
            }
          }
        } catch (error) {
          if (isMounted) {
            console.error('Error fetching subject data:', error);
          }
        }
      };
  
      // Fetch data from Firestore
      fetchBleData();
      fetchSubjectData();
  
      return () => {
        // Cleanup function to run when the component unmounts
        isMounted = false;
      };
    }, [roomNumber, subjectCode1, semesterSession1]);

    function backToAttendance(){
        history.replace('/LecturerDashboard/LecturerAttendance');
    }

    function pushNameAndEmail(studentArrayNames1, studentArrayEmails1){
      setStudentNames2((prevNames) => [...prevNames, studentArrayNames1]);
      setStudentEmails2((prevEmails) => [...prevEmails, studentArrayEmails1]);
    }

    function pushSessionID(qrSessionID){
      setQrCodeSessionID(qrSessionID);
    }

    function pushAbsentEmails(absentStudentEmails1){
      // console.log("CHECKING: " + absentStudentEmails1);
      // setAbsentStudentEmails2((prevAbsent) => [...prevAbsent, absentStudentEmails1]);
      absentStudentEmails3.push(absentStudentEmails1);
      // absentStudentEmails3.push("student1@gmail.com");
      // setAbsentStudentEmails3(absentStudentEmails1);
      // console.log("CHECKING 2: " + absentStudentEmails2);
      // console.log("CHECKING 3: " + absentStudentEmails3[1]);
      // console.log("TEST CHECKING 3: " + absentStudentEmails3);
    }

    function pushDateTime(DateTimeDetails){
      dateTimeInfo.push(DateTimeDetails);
    }

    // function pushStudentEmail(emailToPush) {
    //   // setCurrentStudentEmail1(emailToPush[0]);
    //   currentStudentEmailNew2 = emailToPush[0].toString();
    //   console.log("STUDENT FINAL EMAIL: " + currentStudentEmail1);
    // }

    // function pushCurrentUserName(userNameToPush){
    //   console.log("STUDENT USER NAME: " + userNameToPush);
    //   setCurrentUserName1(userNameToPush);
    //   console.log("STUDENT USER NAME: " + currentUserName1);
    // }

    async function updateAttendance(){
      try {
        const subjectsCollection = firebase.firestore().collection('subjects');

        const querySnapshot = await subjectsCollection
          .where('subject_code', '==', subjectCode1)
          .where('subject_name', '==', subjectName1)
          .where('semester_session', '==', semesterSession1)
          .get();

        if (!querySnapshot.empty) {
          const subjectDocument = querySnapshot.docs[0].ref;
          const subjectData = querySnapshot.docs[0].data();

          if (subjectData && subjectData.hasOwnProperty('subject_students')) {
            const subjectStudents = subjectData.subject_students;

            for (let i = 0; i < subjectStudents.length; i++) {
              const studentInfo = subjectStudents[i];
              const studentEmail = studentInfo.email;

              if (studentEmail2.includes(studentEmail)) {
                let scanCount = studentInfo.scan || 0;
                scanCount++; // Increment the 'scan' count by 1
                subjectStudents[i].scan = scanCount;
                subjectStudents[i]['scan'] = studentInfo.scan;
              }
            }
            await subjectDocument.update({ subject_students: subjectStudents });
          }
        }
      } catch (error) {
        console.error('ERROR:', error);
      }
    }

    async function updateLateCount(){

      try {
        // Reference to the 'subjects' collection
        const subjectsCollection = db.collection('subjects');
        // Query the document with the subject code, name, and semester session
        const querySnapshot = await subjectsCollection
          .where('subject_code', '==', subjectCode1)
          .where('subject_name', '==', subjectName1)
          .where('semester_session', '==', semesterSession1)
          .get();

        if (!querySnapshot.empty) {
          const subjectDocument = querySnapshot.docs[0].ref;
          const subjectData = querySnapshot.docs[0].data();
          
          if (subjectData && subjectData.subject_students) {
            const subjectStudents = subjectData.subject_students;

            for (let i = 0; i < subjectStudents.length; i++) {
              const studentInfo = subjectStudents[i];
              const studentEmail = studentInfo.email;
              if (absentStudentEmails3.includes(studentEmail)) {
                // Update the 'late' field for the matching student email
                let lateCount = studentInfo.late || 0;
                lateCount++;
                studentInfo.late = lateCount;
                subjectStudents[i]['late'] = studentInfo.late;
                if (lateCount == 5) {
                  const currentStudentName = studentNames2[i];
                  await warningLetter(currentStudentName);
                }
              }
            }
            await subjectDocument.update({ subject_students: subjectStudents });
          }
        }
        await updateAttendance();
      } catch (e) {
        console.log(`ERROR: ${e}`);
      }

    }

    async function getStudents(stringValues1) {
      for (var a = 0; a < stringValues1.length; a++) {
        try {
          const userSnapshot2 = await db.collection('users')
            .where('email', '==', stringValues1[a])
            .get();
          if (userSnapshot2 != null) {
            const userDocument2 = userSnapshot2.docs[0];
            const userDocument3 = userDocument2.data();
            studentNamesArray.push(userDocument3['name']);
            studentEmailsArray.push(userDocument3['email']);
          }
        } catch (error) {
          console.error('Error fetching user data:', error);
        }
      }
      await setStudentDetails(studentNamesArray);
    }

    async function warningLetter(currentName1){
      console.log(subjectCode1);
      const collectionReference = db.collection('attendance');
      console.log(subjectName1);
      try {
        console.log(semesterSession1);
        const querySnapshot = await collectionReference
          .where('subject_code', '==', subjectCode1)
          .where('subject_name', '==', subjectName1)
          .where('semester_session', '==', semesterSession1)
          .orderBy('time_created', 'desc')
          .get();
        querySnapshot.forEach(doc => {
          const data = doc.data();

          if (data) {
            const values = Object.values(data);
            if (values.length > 5) {
              for (let c = 0; c < values.length; c++) {
                if (Array.isArray(values[c]) && values[c][2] === 'Absent') {
                  pushDateTime(data['time_created'].toString());
                  const currentEmail = values[c];
                  // pushStudentEmail(currentEmail);
                  currentStudentEmailNew2 = currentEmail[0];
                }
              }
            }
          }
        });
      } catch (error) {
        console.error('Error fetching data:', error);
      }

      const usersCollection = db.collection('users');
      try {
        const querySnapshot = await usersCollection.where('email', '==', currentStudentEmailNew2).get();

        if (!querySnapshot.empty) {
          const userDoc = querySnapshot.docs[0];
          const userName1 = userDoc.get('name');
          currentStudentNameNew2 = userName1;
        }
      } catch (error) {
        console.error('Error fetching user data:', error);
      }

      const collectionRef = db.collection('warning');

      const data = {
        student_name: currentStudentNameNew2,
        student_email: currentStudentEmailNew2,
        subject_code: subjectCode1,
        subject_name: subjectName1,
        semester_session: semesterSession1,
        warning_msg: `This warning letter has been auto-generated for the user ${currentStudentNameNew2} for the email address ${currentStudentEmailNew2}. You have missed 5 classes for the subject ${subjectCode1} ${subjectName1} for the dates:\n${dateTimeInfo.slice(0, 5).reverse().join(',\n')}`,
      };

      try {
        await collectionRef.add(data);
        console.log('Data added to Firestore successfully!');
      } catch (error) {
        console.error('Error adding data to Firestore:', error);
      }
    }

    async function updateIfAbsent(){
      const collectionReference = db.collection('attendance');
      const documentRef = collectionReference.doc(qrCodeSessionID);

      try{

        const snapshot = await documentRef.get();

        if (!snapshot.exists) {
          return; // Document doesn't exist, nothing to update.
        }

        const data = snapshot.data();

        if (!data) {
          return; // Data is null, nothing to update.
        }

        for (let i = 0; i < studentNames2.length; i++){

          const name = studentNames2[i];
          let email = '';
          let studentID = '';

          if (data.hasOwnProperty(name) && Array.isArray(data[name]) && data[name].length === 0) {
            email = studentEmail2[i];

            const collectionReference2 = db.collection('users');

            try {
              const querySnapshot = await collectionReference2
                .where('email', '==', email)
                .get();

              const userData2 = querySnapshot.docs[0].data();

              studentID = userData2['id'];
            } catch (e) {}

            const currentDate = new Date();
            const year = currentDate.getFullYear();
            const month = String(currentDate.getMonth() + 1).padStart(2, '0');
            const day = String(currentDate.getDate()).padStart(2, '0');
            const hours = String(currentDate.getHours()).padStart(2, '0');
            const minutes = String(currentDate.getMinutes()).padStart(2, '0');
            const seconds = String(currentDate.getSeconds()).padStart(2, '0');
            const formattedDate = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;

            await documentRef.update({
              [name]: [
                email,
                studentID,
                'Absent',
                'Done',
                formattedDate,
              ],
            });
            pushAbsentEmails(email);
          }
        }
        updateLateCount();
      }catch(e){console.log(e)}
    }

    function storeAttendanceDateTime(currentDateTimeToStore){
      setTimeCreatedQR(currentDateTimeToStore);
    }

    async function setStudentDetails(studentNames1) {
      const qrSessionId = Date.now().toString();
      pushSessionID(qrSessionId);
      const currentDate = new Date();
      const year = currentDate.getFullYear();
      const month = String(currentDate.getMonth() + 1).padStart(2, '0'); // Month is zero-based
      const day = String(currentDate.getDate()).padStart(2, '0');
      const hours = String(currentDate.getHours()).padStart(2, '0');
      const minutes = String(currentDate.getMinutes()).padStart(2, '0');
      const seconds = String(currentDate.getSeconds()).padStart(2, '0');

      const formattedDate = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
      storeAttendanceDateTime(formattedDate);

      try {
        // Reference to the Firestore document using sessionId as the document ID
        const docRef = db.collection('attendance').doc(qrSessionId);
        // Create a map to update the document
        const dataToUpdate = {
          'subject_name': subjectName1,
          'subject_code': subjectCode1,
          'semester_session': semesterSession1,
          'classroom_number': roomNumber,
          'time_created': formattedDate,
        };
        // Add the arrays to the map with specific field names
        for (var i = 0; i < studentNames1.length; i++) {
          dataToUpdate[studentNames1[i]] = [];
          pushNameAndEmail(studentNames1[i], studentEmailsArray[i]);
        }
        // Update the Firestore document or create it if it doesn't exist
        await docRef.set(dataToUpdate, { merge: true });
    
        console.log('Document updated or created successfully');
      } catch (error) {
        console.error(error);
      }
    } 

    return(
      <div className="mt-3 text-center">
        <QRCode value= {subjectCode1 + "\n" + subjectName1 + "\n" + semesterSession1 + "\n" + roomNumber + "\n" + bleValue + "\n" + timeCreatedQR + "\n" + qrCodeSessionID}></QRCode>
        <Button style={{ backgroundColor: 'orange', color: 'black', width: 300 }} variant="primary" onClick={updateIfAbsent}>
          End Attendance
        </Button>
        <Button style={{ backgroundColor: '#12E8E8', color: 'black', width: 300 }} variant="primary" onClick={backToAttendance}>
          Back to Dashboard
        </Button>
      </div>
    );
}