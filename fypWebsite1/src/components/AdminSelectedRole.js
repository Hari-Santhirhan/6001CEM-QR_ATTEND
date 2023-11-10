import React, { useState, useEffect } from "react";
import { Card, Button, Alert, Container, Row, Col, Modal, Form } from "react-bootstrap";
import { useAuth } from "../contexts/AuthContext";
import { Link, useHistory, useLocation } from "react-router-dom";
import firebase from "firebase";
import 'firebase/firestore';
import app from "../firebase";

export default function AdminSelectedRole() {
    const location = useLocation();
    const history = useHistory();
    const { selectedUserRole } = location.state;
    const [userList, setUserList] = useState([]);

    // Initialize Firebase using the imported instance from firebase.js
    const db = app.firestore();

    useEffect(() => {
      // Fetch subjects data from Firestore
      const unsubscribeUsers = db.collection('users')
        .where('role', '==', selectedUserRole)
        .onSnapshot((querySnapshot) => {
            const listOfUsers = [];
            querySnapshot.forEach((doc) => {
            listOfUsers.push(doc.data());
            });
            setUserList(listOfUsers);
        });
      // Cleanup the Firestore listeners
      return () => {
        unsubscribeUsers(); // Unsubscribe from attendance data
      };
    }, []);

    function backToUserInfo() {
        history.push("/AdminDashboard/AdminUserInfo");
    }

    function goToAdminSelectedUser(selectedName1, selectedEmail1, selectedRole1){
        history.push({
            pathname: "/AdminDashboard/AdminUserInfo/AdminSelectedRole/AdminSelectedUser",
            state: {
                selectedUserName2: selectedName1,
                selectedUserEmail2: selectedEmail1,
                selectedUserRole2: selectedRole1,
            }
        });
    }

    return (
        <>
            <Container className="d-flex justify-content-center align-items-center" style={{ minHeight: "100vh" }}>
                <div>
                    <p>Select a user</p>
                    <Row>
                    {userList.map((user1, index) => (
                        <Col
                        key={index}
                        xs={12}
                        style={{ backgroundColor: '#12E8E8', color: 'black', marginBottom: '5px', cursor: 'pointer' }}
                        onClick={() => {goToAdminSelectedUser(user1['name'], user1['email'], user1['role'])}}>
                        <p>Name: {user1['name']}</p>
                        </Col>
                    ))}
                    </Row>
                    <div className="text-center">
                        <Button style={{ backgroundColor: '#12E8E8', color: 'black', width: 300 }} variant="primary" onClick={backToUserInfo}>
                            Back to Select Role
                        </Button>
                    </div>
                </div>
            </Container>
        </>
    )
}
