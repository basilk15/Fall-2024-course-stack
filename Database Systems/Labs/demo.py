import sys
from PyQt6.QtWidgets import QApplication, QMainWindow, QWidget, QVBoxLayout, QLabel, QPushButton, QLineEdit, QRadioButton, QComboBox
from PyQt6 import uic
# Hard coded Python for storing student entries
data = [["Ahmed","4289","CS",3.85],["Hammad","4305","CS",3.53],["Mohsin","4333","CS",3.92]]

class MainForm(QMainWindow):
    def __init__(self):
        super().__init__()
        # Load the .ui file
        uic.loadUi('main_form.ui', self) 
    
        # Set Window Title
        self.setWindowTitle('Main Form')
        # Set Dimensions
        self.setGeometry(100, 100, 400, 300)

        
        
        # ID items in combo box
        self.id_combo.addItems([i[1] for i in data])
        # set default data
        self.name_input.setText(data[0][0])

        # Connect Submit Button to Event Handling Code
        self.submit_button.clicked.connect(self.open_view_form)
        # Connect ID Combo Box to Event Handling Code
        self.id_combo.activated.connect(self.handle_id_toggle)

    def open_view_form(self):
        index = self.id_combo.currentIndex()
        # Get id of student
        id = data[index][1]
        # Get value from name_input
        name = data[index][0]
        # Get value from radio_button
        major = data[index][2]
        # Get value from combo_box
        gpa = data[index][3]

        # Pass all the data to view form as parameters
        self.view_form = ViewForm(id,name,major,gpa, 1)
        self.view_form.show()

    def handle_id_toggle(self):
        id = self.id_combo.currentIndex()
        self.name_input.setText(data[id][0])

class ViewForm(QMainWindow):
    def __init__(self, id,name,major,gpa,x):
        super().__init__()
        uic.loadUi('view_form.ui', self)

        # Receive Data from the Main Form
        self.name = name
        self.id = id
        self.major = major
        self.gpa = gpa
    

        # Set Window Title
        self.setWindowTitle('View Form')
        # Set Dimensions
        self.setGeometry(100, 100, 400, 300)

        # Set Name Value
        self.name_input.setText(self.name)

        # Set Name Value
        self.major_input.setText(self.major)

        # Set Name Value
        self.gpa_input.setText(str(self.gpa))

if __name__ == '__main__':
    app = QApplication(sys.argv)
    main_form = MainForm()
    main_form.show()
    sys.exit(app.exec())
