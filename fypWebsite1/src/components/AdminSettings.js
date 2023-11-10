import React, { useState } from "react"
import { Card, Button, Alert, Container, Row, Col } from "react-bootstrap"
import { useAuth } from "../contexts/AuthContext"
import { Link, useHistory } from "react-router-dom"

export default function AdminSettings(){
    const [error, setError] = useState("")
    const { currentUser, logout } = useAuth()
    const history = useHistory()

    function backToDashboard(){
        history.push("/AdminDashboard");
    }

    function goToAddSemSession(){
        history.push("/AdminDashboard/AdminSettings/AddSemesterSession");
    }

    function goToSubjects(){

    }

    return (
        <>
            <Card style={{ backgroundColor: "#0075FF" }}>
            <Card.Body>
                <h2 style={{ color: "white" }} className="text-center mb-4">Settings</h2>
                {error && <Alert variant="danger">{error}</Alert>}
                <div className="text-center">
                    <Button style={{backgroundColor: 'yellow', color: 'black', width: 300}} variant="primary" onClick={goToSubjects}>
                        Subjects
                    </Button>
                </div>
                <div className="text-center">
                    <Button style={{backgroundColor: '#18FF2F', color: 'black', width: 300}} variant="primary" onClick={goToAddSemSession}>
                        Add Semester Session
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