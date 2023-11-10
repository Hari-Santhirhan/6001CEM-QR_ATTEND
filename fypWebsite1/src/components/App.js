import React from "react"
import { Container } from "react-bootstrap"
import { AuthProvider } from "../contexts/AuthContext"
import { BrowserRouter as Router, Switch, Route } from "react-router-dom"
import Login from "./Login"
import PrivateRoute from "./PrivateRoute"
import LecturerDashboard from "./LecturerDashboard"
import AdminDashboard from "./AdminDashboard"
import LecturerAttendance from "./LecturerAttendance"
import LecturerAttendanceInfo from "./LecturerAttendanceInfo"
import LecturerStudentInfo from "./LecturerStudentInfo"
import LecturerSettings from "./LecturerSettings"
import AdminRegisterUser from "./AdminRegisterUser"
import AdminAttendanceInfo from "./AdminAttendanceInfo"
import AdminUserInfo from "./AdminUserInfo"
import AdminSettings from "./AdminSettings"
import GenerateQR from "./GenerateQR"
import LecturerSubjectAttendances from "./LecturerSubjectAttendances"
import LecturerAttendanceSession from "./LecturerAttendanceSession"
import AddSemesterSession from "./AdminAddSemSession"
import AdminSelectedRole from "./AdminSelectedRole"
import AdminSelectedUser from "./AdminSelectedUser"

function App() {
  return (
    <Container
      className="d-flex align-items-center justify-content-center"
      style={{ minHeight: "100vh" }}
    >
      <div className="w-100" style={{ maxWidth: "400px" }}>
        <Router>
          <AuthProvider>
            <Switch>
              <PrivateRoute exact path="/LecturerDashboard" component={LecturerDashboard} />
              <PrivateRoute exact path="/AdminDashboard" component={AdminDashboard} />
              <PrivateRoute exact path="/LecturerDashboard/LecturerAttendance" component={LecturerAttendance} />
              <PrivateRoute exact path="/LecturerDashboard/LecturerAttendanceInfo" component={LecturerAttendanceInfo} />
              <PrivateRoute exact path="/LecturerDashboard/LecturerStudentInfo" component={LecturerStudentInfo} />
              <PrivateRoute exact path="/LecturerDashboard/LecturerSettings" component={LecturerSettings} />
              <Route exact path="/AdminDashboard/AdminRegisterUser" component={AdminRegisterUser} />
              <PrivateRoute exact path="/AdminDashboard/AdminAttendanceInfo" component={AdminAttendanceInfo} />
              <PrivateRoute exact path="/AdminDashboard/AdminUserInfo" component={AdminUserInfo} />
              <PrivateRoute exact path="/AdminDashboard/AdminUserInfo/AdminSelectedRole" component={AdminSelectedRole} />
              <Route exact path="/AdminDashboard/AdminUserInfo/AdminSelectedRole/AdminSelectedUser" component={AdminSelectedUser} />
              <PrivateRoute exact path="/AdminDashboard/AdminSettings" component={AdminSettings} />
              <PrivateRoute exact path="/AdminDashboard/AdminSettings/AddSemesterSession" component={AddSemesterSession} />
              <PrivateRoute exact path="/LecturerDashboard/LecturerAttendance/GenerateQR" component={GenerateQR} />
              <PrivateRoute exact path="/LecturerDashboard/LecturerAttendanceInfo/LecturerSubjectAttendances" component={LecturerSubjectAttendances} />
              <PrivateRoute exact path="/LecturerDashboard/LecturerAttendanceInfo/LecturerSubjectAttendances/LecturerAttendanceSession" component={LecturerAttendanceSession} />
              <Route path="/" component={Login} />
            </Switch>
          </AuthProvider>
        </Router>
      </div>
    </Container>
  )
}

export default App
