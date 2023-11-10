import React, { useState, useEffect } from "react";
import { Card, Button, Alert, Container, Row, Col, Modal, Form } from "react-bootstrap";
import { useAuth } from "../contexts/AuthContext";
import { Link, useHistory, useLocation } from "react-router-dom";
import firebase from "firebase";
import 'firebase/firestore';
import app from "../firebase";

export default function AdminSelectedUser(){
    const location = useLocation();
    const history = useHistory();
    const { currentUser } = useAuth();
    const {selectedUserName2, selectedUserEmail2, selectedUserRole2} = location.state;
    const [showEditModal, setShowEditModal] = useState(false);
    const [showDeleteModal, setShowDeleteModal] = useState(false);
    const [newName, setNewName] = useState(""); // Store the new name in state
    const [adminEmail, setAdminEmail] = useState();
    const [adminPassword, setAdminPassword] = useState();
    // let userDocument = null;

    // useEffect(() => {
    //     const db = app.firestore();
    //     // Query the Firestore collection "users" based on the email
    //     const unsubscribeAdmin = db.collection("users").doc(currentUser.uid)
    //     .onSnapshot((doc) => {
    //         if (doc.exists) {
    //             userDocument = doc.data();
    //             console.log("User data:", userDocument);
    //         }
    //       });
    
    //     return () => {
    //       // Unsubscribe from the snapshot listener when the component unmounts
    //       unsubscribeAdmin();
    //     };
    //   }, []);

    const handleShowEditModal = () => {
        setShowEditModal(true);
    }

    const handleCloseEditModal = () => {
        setShowEditModal(false);
    }

    const handleShowDeleteModal = () => {
        setShowDeleteModal(true);
    }

    const handleCloseDeleteModal = () => {
        setShowDeleteModal(false);
    }

    function editUser() {
        handleShowEditModal(); // Show the edit user modal
    }

    function deleteUser() {
        handleShowDeleteModal(); // Show the delete user modal
    }

    function backToSelectedRole(){
        history.push({
            pathname: "/AdminDashboard/AdminUserInfo/AdminSelectedRole",
            state: {
                selectedUserRole: selectedUserRole2,
            }
        });
    }

    async function handleEditUserName(newEnteredName, currentUserEmail){
        const db = app.firestore();
        try {
            const usersRef = db.collection('users'); // Replace 'users' with your Firestore collection name
        
            // Use a where clause to filter documents by email
            const querySnapshot = await usersRef.where('email', '==', currentUserEmail).get();
        
            if (!querySnapshot.empty) {
              // If there are matching documents (should be only one), update the name field of the first one
              const doc = querySnapshot.docs[0];
              await usersRef.doc(doc.id).update({ name: newEnteredName });
              console.log('User name updated successfully.');
              handleCloseEditModal();
              history.replace("/AdminDashboard/AdminUserInfo");
            } else {
              console.log('No matching documents.');
            }
        } catch (error) {
        console.error('Error updating user name:', error);
        }
    }

    async function handleDeleteUser(currentUserEmail4, currentAdminEmail4) {
        const db = app.firestore();
        const auth = app.auth();

        try{
            const usersRef = db.collection('users');
            const querySnapshot = await usersRef.where("email", "==", currentUserEmail4).get();

            const adminRef = db.collection('users');
            const querySnapshotAdmin = await adminRef.where("email", "==", currentAdminEmail4).get();

            if (!querySnapshotAdmin.empty){
                const adminData = querySnapshotAdmin.docs[0].data();
                const adminPass1 = adminData.password;

                if (!querySnapshot.empty) {
                    const userData = querySnapshot.docs[0].data();
                    const password = userData.password;

                    try {
                        if (!querySnapshot.empty) {
                            const doc = querySnapshot.docs[0];
                            const userId = doc.id; // Get the document's ID
            
                            // Delete user's data from Firestore
                            await usersRef.doc(userId).delete();
                            await auth.signInWithEmailAndPassword(currentUserEmail4, password)
                                .then(async () => {
                                    const user1 = firebase.auth().currentUser;
                                    await user1.delete();
                                })
                            await auth.signInWithEmailAndPassword(currentAdminEmail4, adminPass1)
                                .then(() => {
                                    console.log('User deleted successfully from Firestore and Authentication');
                                    handleCloseDeleteModal();
                                    history.replace("/AdminDashboard/AdminUserInfo");
                                })
                                .catch((error) => {
                                    console.error('Error deleting user:', error);
                                });
                        } else {
                            console.log('No matching documents.');
                        }
                    } catch (error) {
                        console.error('Error deleting user:', error);
                    }
                } else {
                console.log("No matching documents.");
                }
            }
        }catch(error){console.log(error)}
    }

    return (
        <>
            <Container className="d-flex justify-content-center align-items-center" style={{ minHeight: "100vh" }}>
                <div>
                    <p>User's Name: {selectedUserName2}</p>
                    <p>Email: {selectedUserEmail2}</p>
                    <p>Role: {selectedUserRole2}</p>
                    <div className="text-center">
                        <Button style={{ backgroundColor: 'orange', color: 'black', width: 300 }} variant="primary" onClick={editUser}>
                            Edit User Info
                        </Button>
                    </div>
                    <div className="text-center">
                        <Button style={{ backgroundColor: 'orange', color: 'black', width: 300 }} variant="primary" onClick={deleteUser}>
                            Delete User
                        </Button>
                    </div>
                    <div className="text-center">
                        <Button style={{ backgroundColor: '#12E8E8', color: 'black', width: 300 }} variant="primary" onClick={backToSelectedRole}>
                            Back to Select User
                        </Button>
                    </div>
                </div>
            </Container>

            <Modal show={showEditModal} onHide={handleCloseEditModal}>
                <Modal.Header closeButton>
                    <Modal.Title>Edit User</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <p>User's Name: {selectedUserName2}</p>
                    <p>Email: {selectedUserEmail2}</p>
                    <p>Role: {selectedUserRole2}</p>
                    <Form.Group>
                        <Form.Label>Enter new name</Form.Label>
                        <Form.Control
                            type="text"
                            placeholder="New Name"
                            value={newName}
                            onChange={(e) => setNewName(e.target.value)}
                        />
                    </Form.Group>
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={handleCloseEditModal}>
                        Close
                    </Button>
                    <Button variant="primary" onClick={() => {handleEditUserName(newName, selectedUserEmail2)}}>
                        Edit User's Name
                    </Button>
                </Modal.Footer>
            </Modal>
            <Modal show={showDeleteModal} onHide={handleCloseDeleteModal}>
                <Modal.Header closeButton>
                    <Modal.Title>Delete User</Modal.Title>
                </Modal.Header>
                <Modal.Body>
                    <p>Are you sure you want to delete this user?</p>
                </Modal.Body>
                <Modal.Footer>
                    <Button variant="secondary" onClick={handleCloseDeleteModal}>
                        Cancel
                    </Button>
                    <Button variant="danger" onClick={() => { handleDeleteUser(selectedUserEmail2, currentUser.email) }}>
                        Delete User
                    </Button>
                </Modal.Footer>
            </Modal>
        </>
    )
}