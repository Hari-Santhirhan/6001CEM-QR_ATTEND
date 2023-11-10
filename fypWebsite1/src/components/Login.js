import React, { useRef, useState, useEffect, useCallback } from "react"
import { Form, Button, Card, Alert } from "react-bootstrap"
import { useAuth } from "../contexts/AuthContext"
import { Link, useHistory } from "react-router-dom"
import firebase from "firebase"
import sha256 from 'crypto-js/sha256'

export default function Login() {
  const emailRef = useRef()
  const passwordRef = useRef()
  const { login } = useAuth()
  const [error, setError] = useState("")
  const [loading, setLoading] = useState(false)
  const history = useHistory()
  const db = firebase.firestore()

  const userRoleCheck = useCallback(async (user) => {
    try {
      const userDoc = await db.collection("users").doc(user.uid).get();
      const userData = userDoc.data();
      if (userData && userData.role) {
        const role = userData.role;
        switch (role) {
          case "Lecturer":
            history.replace("/LecturerDashboard");
            break;
          case "Admin":
            history.replace("/AdminDashboard");
            break;
          default:
            history.replace("/");
        }
      }
    } catch (error) {
      console.error("Error checking user role:", error.message);
    }
  }, [db, history]);

  useEffect(() => {
    const unsubscribe = firebase.auth().onAuthStateChanged((user) => {
      if (user) {
        userRoleCheck(user);
      }
    });
  
    return () => unsubscribe();
  }, [userRoleCheck]);

  function encryptPassword(plainTextPassword){
    const utf8Bytes = Buffer.from(plainTextPassword, 'utf-8').toString();
    const hash = sha256(utf8Bytes).toString();
    return hash;
  }

  async function handleSubmit(e) {
    e.preventDefault()

    try {
      setError("")
      setLoading(true)
      const cipherTextPassword = encryptPassword(passwordRef.current.value);
      const userCredential = await login(emailRef.current.value, cipherTextPassword);
      const user = userCredential.user;
      userRoleCheck(user);
    } catch {
      setError("Failed to log in")
    }

    setLoading(false)
  }

  return (
    <>
      <Card style={{backgroundColor: "#0075FF"}}>
        <Card.Body>
          <h1 className="text-center mb-4" style={{ color: 'white' }}>QR Attend</h1>
          <h2 className="text-center mb-4" style={{ color: 'white' }}>Log In</h2>
          {error && <Alert variant="danger">{error}</Alert>}
          <Form onSubmit={handleSubmit}>
            <Form.Group id="email">
              <Form.Label style={{ color: 'white' }}>Email</Form.Label>
              <Form.Control type="email" ref={emailRef} required />
            </Form.Group>
            <Form.Group id="password">
              <Form.Label style={{ color: 'white' }}>Password</Form.Label>
              <Form.Control type="password" ref={passwordRef} required />
            </Form.Group>
            <Button disabled={loading} className="w-100" type="submit" style={{ border: '1px solid white' }}>
              Log In
            </Button>
          </Form>
        </Card.Body>
      </Card>
    </>
  )
}
