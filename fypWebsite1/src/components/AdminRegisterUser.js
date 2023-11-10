import React, { useState, useEffect, useRef, useCallback } from "react";
import { Card, Button, Alert, Container, Row, Col } from "react-bootstrap";
import { useAuth } from "../contexts/AuthContext";
import { Link, useHistory } from "react-router-dom";
import firebase from "firebase";
import Login from "./Login";
import sha256 from 'crypto-js/sha256';

export default function AdminRegisterUser() {
  const [error, setError] = useState("");
  const { currentUser, logout } = useAuth();
  const history = useHistory();
  const [role, setRole] = useState("Role"); // Initially set to "Role"
  const [fullName, setFullName] = useState("");
  const [email, setEmail] = useState("");
  const [initialPassword, setInitialPassword] = useState("");
  const [studentId, setStudentId] = useState("");
  const [isStudentRole, setIsStudentRole] = useState(false);
  const [adminEmail, setAdminEmail] = useState("");
  const [adminPassword, setAdminPassword] = useState("");

  const roleRef = useRef(null);
  const fullNameRef = useRef(null);
  const emailRef = useRef(null);
  const initialPasswordRef = useRef(null);
  const studentIdRef = useRef("");

  useEffect(() => {
    const db = firebase.firestore();

    // Query the Firestore collection "users" based on the email
    const unsubscribe = db.collection("users")
      .where("email", "==", currentUser.email)
      .onSnapshot((snapshot) => {
        if (snapshot.docs.length === 0) {
          console.log("No user found with this email.");
          return;
        }

        // Get the data of the first document (should be unique based on email)
        const userDoc = snapshot.docs[0];
        const userDocument = userDoc.data();
        setAdminEmail(userDocument['email']);
        setAdminPassword(userDocument['password']);
      });

    return () => {
      // Unsubscribe from the snapshot listener when the component unmounts
      unsubscribe();
    };
  }, []);

  function encryptPassword(plainTextPassword){
    const utf8Bytes = Buffer.from(plainTextPassword, 'utf-8').toString();
    const hash = sha256(utf8Bytes).toString();
    return hash;
  }

  function backToDashboard() {
    history.push("/AdminDashboard");
  }

  const handleRoleChange = (event) => {
    const selectedRole = event.target.value;
    setRole(selectedRole);
    if (selectedRole === "Student") {
      setIsStudentRole(true);
    } else {
      setIsStudentRole(false);
    }
  };

  const handleRegister = async () => {
    // Access the values using refs
    const selectedRole = roleRef.current.value;
    const enteredFullName = fullNameRef.current.value;
    const enteredEmail = emailRef.current.value;
    const enteredInitialPassword = initialPasswordRef.current.value;
    const studentIdValue = studentIdRef.current ? studentIdRef.current.value : "";
    try {
      const encryptedPassword = encryptPassword(enteredInitialPassword);
      const userSignedInfo = await firebase.auth().createUserWithEmailAndPassword(enteredEmail, encryptedPassword);
      const userInfo = userSignedInfo.user;
      const userID = userInfo.uid;
      await firebase.auth().signOut();
      await firebase.auth().signInWithEmailAndPassword(adminEmail, adminPassword);
      
      const db = firebase.firestore();
      const collectionRef = db.collection('users');
      
      const dataToSend = {
        email: enteredEmail,
        id: studentIdValue,
        name: enteredFullName,
        password: encryptedPassword,
        role: selectedRole,
      }

      collectionRef.doc(userID).set(dataToSend);
    } catch (error) {
      // Handle any other errors that might occur during the asynchronous task
      console.error('An error occurred:', error);
    }
  };  

  return (
    <div className="App">
      <h1>User Registration</h1>
      <label>
        Select Role:
        <select value={role} onChange={handleRoleChange} ref={roleRef}>
          <option value="Role" disabled>
            Role
          </option>
          <option value="Student">Student</option>
          <option value="Lecturer">Lecturer</option>
          <option value="Admin">Admin</option>
          <option value="Technician">Technician</option>
        </select>
      </label>

      <br />

      <label>
        Full Name:
        <input
          type="text"
          value={fullName}
          onChange={(e) => setFullName(e.target.value)}
          ref={fullNameRef}
        />
      </label>

      <br />

      <label>
        Email Address:
        <input
          type="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          ref={emailRef}
        />
      </label>

      <br />

      <label>
        Initial Password:
        <input
          type="password"
          value={initialPassword}
          onChange={(e) => setInitialPassword(e.target.value)}
          ref={initialPasswordRef}
        />
      </label>

      {isStudentRole && (
        <div>
          <label>
            Student ID:
            <input
              type="text"
              value={studentId}
              onChange={(e) => setStudentId(e.target.value)}
              ref={studentIdRef}
            />
          </label>
        </div>
      )}

      <br />

      <button
        style={{
          backgroundColor: "blue",
          border: "1px solid black",
          color: "white",
          padding: "10px 20px",
          margin: "30px",
          cursor: "pointer",
        }}
        onClick={handleRegister}
      >
        Register
      </button>
      <button
        style={{
          backgroundColor: "orange",
          border: "1px solid black",
          color: "white",
          padding: "10px 20px",
          cursor: "pointer",
        }}
        onClick={backToDashboard}
      >
        Back to Dashboard
      </button>
    </div>
  );
}
