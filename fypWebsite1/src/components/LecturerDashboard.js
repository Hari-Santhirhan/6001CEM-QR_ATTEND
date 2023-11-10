import React, { useState } from "react"
import { Card, Button, Alert, Container, Row, Col } from "react-bootstrap"
import { useAuth } from "../contexts/AuthContext"
import { Link, useHistory } from "react-router-dom"

export default function LecturerDashboard() {
  const [error, setError] = useState("")
  const { currentUser, logout } = useAuth()
  const history = useHistory()

  async function handleLogout() {
    setError("")

    try {
      await logout()
      history.replace("/")
    } catch {
      setError("Failed to log out")
    }
  }

  function goToCreateAttendance(){
    history.push("/LecturerDashboard/LecturerAttendance");
  }

  function goToAttendanceInfoLecturer(){
    history.push("/LecturerDashboard/LecturerAttendanceInfo");
  }

  function goToLecturerStudentInfo(){
    history.push("/LecturerDashboard/LecturerStudentInfo");
  }

  function goToLecturerSettings(){
    history.push("/LecturerDashboard/LecturerSettings");
  }

  return (
    <>
      <Card style={{ width: '400px', height: '250px', backgroundColor: "#0075FF" }}>
        <Card.Body>
          <h2 style={{ color: "white" }} className="text-center mb-2">Welcome Lecturer</h2>
          {error && <Alert variant="danger">{error}</Alert>}
          <div style={{ color: "white" }} className="text-center">
            <h4 className="text-center">
              Please Select an Option
            </h4>
          </div>
          <div className="text-center">
            <Button style={{backgroundColor: '#18FF2F', color: 'black', width: 300}} variant="primary" onClick={goToCreateAttendance}>
              Take Attendance
            </Button>
          </div>
          <div className="text-center">
            <Button style={{backgroundColor: '#12E8E8', color: 'black', width: 300}} variant="primary" onClick={goToAttendanceInfoLecturer}>
              Attendance Info
            </Button>
          </div>
          <div className="w-100 text-center mb-2">
            <Button style={{backgroundColor: 'orange', color: 'black', width: 300}} variant="primary" onClick={handleLogout}>
              Log Out
            </Button>
          </div>
        </Card.Body>
      </Card>
    </>
  )
}