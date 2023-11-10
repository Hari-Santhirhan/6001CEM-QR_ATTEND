import React, { useState } from "react"
import { Card, Button, Alert } from "react-bootstrap"
import { useAuth } from "../contexts/AuthContext"
import { Link, useHistory, useLocation } from "react-router-dom"

export default function AdminDashboard() {
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

  function goToAdminRegisterUser(){
    history.push("/AdminDashboard/AdminRegisterUser");
  }

  function goToAdminAttendanceInfo(){
    history.push("/AdminDashboard/AdminAttendanceInfo");
  }

  function goToAdminUserInfo(){
    history.push("AdminDashboard/AdminUserInfo");
  }

  function goToAdminSettings(){
    history.push("AdminDashboard/AdminSettings");
  }

  return (
    <>
      <Card style={{ width: '400px', height: '250px', backgroundColor: "#0075FF" }}>
        <Card.Body>
          <h2 style={{ color: "white" }} className="text-center mb-2">Welcome Admin</h2>
          {error && <Alert variant="danger">{error}</Alert>}
          <div style={{ color: "white" }} className="text-center">
            <h4 className="text-center">
              Please Select an Option
            </h4>
          </div>
          <div className="text-center">
            <Button style={{backgroundColor: '#18FF2F', color: 'black', width: 300}} variant="primary" onClick={goToAdminRegisterUser}>
              Register User
            </Button>
          </div>
          <div className="text-center">
            <Button style={{backgroundColor: '#DA59EF', color: 'black', width: 300}} variant="primary" onClick={goToAdminUserInfo}>
              User Info
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