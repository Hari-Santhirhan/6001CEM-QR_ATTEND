import React, { useRef, useState, useEffect } from "react";
import { Card, Button, Alert, Container, Row, Col, Modal, Form } from "react-bootstrap";
import { useAuth } from "../contexts/AuthContext";
import { Link, useHistory } from "react-router-dom";
import firebase from "firebase";
import 'firebase/firestore';
import app from "../firebase";
import { useLocation } from "react-router-dom/cjs/react-router-dom.min";

export default function AddSemesterSession(){
  const startSemesterRef = useRef();
  const endSemesterRef = useRef();
  const history = useHistory();

  function backToSettings(){
    history.push("/AdminDashboard/AdminSettings");
  }

  function addSemesterSessionToFirestore(){
    
  }

  return (
    <>
      <Card style={{ backgroundColor: "#0075FF" }}>
        <Card.Body>
          <h1 className="text-center mb-4" style={{ color: 'white' }}>Add New Session</h1>
          <Form onSubmit={""}>
            <Form.Group id="startSem">
              <Form.Label style={{ color: 'white' }}>Start Session</Form.Label>
              <Form.Control type="text" ref={startSemesterRef} required />
            </Form.Group>
            <Form.Group id="endSem">
              <Form.Label style={{ color: 'white' }}>End Session</Form.Label>
              <Form.Control type="text" ref={endSemesterRef} required />
            </Form.Group>
            <Button className="w-100" type="submit" style={{ border: '1px solid white' }}>
              Add New Semester Session
            </Button>
          </Form>
          <div className="text-center">
              <Button style={{backgroundColor: '#12E8E8', color: 'black', width: 300}} variant="primary" onClick={backToSettings}>
                  Back to Settings
              </Button>
          </div>
        </Card.Body>
      </Card>
    </>
  )
}