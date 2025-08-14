from PyQt6 import QtWidgets, uic
import sys
import pyodbc

# Database Connection Details


# Replace these with your own database connection details
server = 'DESKTOP-BRH2KGB\\SQLSERVER1'
database = 'hms2'
use_windows_authentication = True  # Set to True to use Windows Authentication
username = 'sa'  # Specify a username if not using Windows Authentication
password = 'Fall2022.dbms'  # Specify a password if not using Windows Authentication



# Create the connection string based on the authentication method chosen
if use_windows_authentication:
    connection_string = f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={server};DATABASE={database};Trusted_Connection=yes;'
else:
    connection_string = f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={server};DATABASE={database};UID={username};PWD={password}'

# Main Login Window
class LoginUI(QtWidgets.QMainWindow):
    def __init__(self):
        super().__init__()
        uic.loadUi('first_sample_screen.ui', self)  # Load your login UI file

        # Connect the login button to the login function
        self.pushButton_2.clicked.connect(self.authenticate_user)

    def authenticate_user(self):
        username = self.lineEdit_3.text()  # Use lineEdit_3 for username
        password = self.lineEdit_4.text()  # Use lineEdit_4 for password
        role = self.comboBox.currentText()  # Use comboBox for role selection

        if not username or not password:
            QtWidgets.QMessageBox.warning(self, "Login Failed", "Please enter all fields.")
            return

        try:
            # Connect to the database
            connection = pyodbc.connect(connection_string)
            cursor = connection.cursor()

            if role == "Doctor":
                cursor.execute("SELECT * FROM Doctor WHERE email = ? AND password = ?", (username, password))
                result = cursor.fetchone()
                if result:
                    QtWidgets.QMessageBox.information(self, "Login Success", "Welcome, Doctor!")
                    self.open_doctor_dashboard()
                else:
                    QtWidgets.QMessageBox.warning(self, "Login Failed", "Invalid credentials for Doctor.")
            elif role == "Admin":
                cursor.execute("SELECT * FROM [Admin] WHERE email = ? AND password = ?", (username, password))
                result = cursor.fetchone()
                if result:
                    QtWidgets.QMessageBox.information(self, "Login Success", "Welcome, Admin!")
                    self.open_admin_dashboard()
                else:
                    QtWidgets.QMessageBox.warning(self, "Login Failed", "Invalid credentials for Admin.")
            elif role == "Staff":
                cursor.execute("SELECT * FROM Staff WHERE email = ? AND password = ?", (username, password))
                result = cursor.fetchone()
                if result:
                    QtWidgets.QMessageBox.information(self, "Login Success", "Welcome, Staff!")
                    self.open_staff_dashboard()
                else:
                    QtWidgets.QMessageBox.warning(self, "Login Failed", "Invalid credentials for Staff.")
            else:
                QtWidgets.QMessageBox.warning(self, "Login Failed", "Invalid role selected.")

            connection.close()

        except pyodbc.Error as e:
            QtWidgets.QMessageBox.critical(self, "Database Error", f"An error occurred: {e}")

    def open_doctor_dashboard(self):
        # Load Doctor Dashboard
        self.doctor_dashboard = DoctorDashboard()
        self.doctor_dashboard.show()
        self.close()

    def open_admin_dashboard(self):
        # Load Admin Dashboard
        self.admin_dashboard = AdminDashboard()
        self.admin_dashboard.show()
        self.close()

    def open_staff_dashboard(self):
        # Load Staff Dashboard
        self.staff_dashboard = StaffDashboard()
        self.staff_dashboard.show()
        self.close()


# Doctor Dashboard
class DoctorDashboard(QtWidgets.QMainWindow):
    def __init__(self):
        super().__init__()
        uic.loadUi('doctor.ui', self)  # Load Doctor Dashboard UI


# Admin Dashboard
class AdminDashboard(QtWidgets.QMainWindow):
    def __init__(self):
        super().__init__()
        uic.loadUi('admin.ui', self)  # Load Admin Dashboard UI


# Staff Dashboard
class StaffDashboard(QtWidgets.QMainWindow):
    def __init__(self):
        super().__init__()
        uic.loadUi('admin.ui', self)  # Load Staff Dashboard UI


# Main Function
def main():
    app = QtWidgets.QApplication(sys.argv)
    login = LoginUI()
    login.show()
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
