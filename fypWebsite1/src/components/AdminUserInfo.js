import React, { useState } from "react"
import { Card, Button, Alert, Container, Row, Col } from "react-bootstrap"
import { useAuth } from "../contexts/AuthContext"
import { Link, useHistory } from "react-router-dom"

export default function AdminUserInfo(){
    const [error, setError] = useState("")
    const { currentUser, logout } = useAuth()
    const history = useHistory()

    function backToDashboard(){
        history.push("/AdminDashboard");
    }

    function goToSelectedUserRole(selectedRole){
        console.log(selectedRole);
        history.push({
            pathname: "/AdminDashboard/AdminUserInfo/AdminSelectedRole",
            state: {
                selectedUserRole: selectedRole,
            }
        });
    }

    return (
        <>
            <Card style={{ backgroundColor: "#0075FF" }}>
            <Card.Body>
                <h2 style={{ color: "white" }} className="text-center mb-4">Select a Role</h2>
                {error && <Alert variant="danger">{error}</Alert>}
                <div className="text-center">
                    <Button style={{backgroundColor: '#12E8E8', color: 'black', width: 300}} variant="primary" onClick={() => {
                        goToSelectedUserRole("Student");
                    }}>
                        Student
                    </Button>
                </div>
                <div className="text-center">
                    <Button style={{backgroundColor: '#12E8E8', color: 'black', width: 300}} variant="primary" onClick={() => {
                        goToSelectedUserRole("Lecturer");
                    }}>
                        Lecturer
                    </Button>
                </div>
                <div className="text-center">
                    <Button style={{backgroundColor: '#12E8E8', color: 'black', width: 300}} variant="primary" onClick={() => {
                        goToSelectedUserRole("Admin");
                    }}>
                        Admin
                    </Button>
                </div>
                <div className="text-center">
                    <Button style={{backgroundColor: '#12E8E8', color: 'black', width: 300}} variant="primary" onClick={() => {
                        goToSelectedUserRole("Technician");
                    }}>
                        Technician
                    </Button>
                </div>
                <div className="text-center">
                    <Button style={{backgroundColor: '#12E8E8', color: 'black', width: 300}} variant="primary" onClick={backToDashboard}>
                        Back to Dashboard
                    </Button>
                </div>
            </Card.Body>
            </Card>
        </>
    )
}