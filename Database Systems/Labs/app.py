import sys
from PyQt6 import QtWidgets, uic
from PyQt6.QtWidgets import QMessageBox
from datetime import datetime

class UI(QtWidgets.QMainWindow):
    def __init__(self):
        super(UI, self).__init__()
        uic.loadUi('Example.ui', self)
        self.show()

        # Event handling for categories and subcategories
        self.categoryComboBox = self.findChild(QtWidgets.QComboBox, "category")
        self.subCategoryComboBox = self.findChild(QtWidgets.QComboBox, "subcategory")
        self.categoryComboBox.currentIndexChanged.connect(self.category_combobox_changed)

        # Event handling for authors
        self.authorname = self.findChild(QtWidgets.QLineEdit, "authorname")
        self.addAuthorButton = self.findChild(QtWidgets.QPushButton, "add")
        self.authors_list = self.findChild(QtWidgets.QListWidget, "authors")
        self.addAuthorButton.clicked.connect(self.add_author_clicked)

        # Event handling for issuance
        self.checkbox = self.findChild(QtWidgets.QCheckBox, "checkbox")
        self.issuedToLineEdit = self.findChild(QtWidgets.QLineEdit, "issuedby")
        self.issueDateEdit = self.findChild(QtWidgets.QDateEdit, "issuedate")
        self.checkbox.stateChanged.connect(self.issue)

        self.isbnLineEdit = self.findChild(QtWidgets.QLineEdit, "isbn")
        self.purchaseDateEdit = self.findChild(QtWidgets.QDateEdit, "purchasedate")
        self.okayButton = self.findChild(QtWidgets.QPushButton, "okay")
        self.okayButton.clicked.connect(self.validate)
        self.issue()

    def category_combobox_changed(self):        
        self.subCategoryComboBox.clear()
        text = self.categoryComboBox.currentText()
        if text == "Database systems":
            self.subCategoryComboBox.addItem("ERD")
            self.subCategoryComboBox.addItem("SQL")
            self.subCategoryComboBox.addItem("OLAP")
            self.subCategoryComboBox.addItem("Data Mining")
        elif text == "OOP":
            self.subCategoryComboBox.addItem("C++")
            self.subCategoryComboBox.addItem("Java")
        elif text == "Artificial Intelligence":
            self.subCategoryComboBox.addItem("Machine Learning")
            self.subCategoryComboBox.addItem("Robotics")
            self.subCategoryComboBox.addItem("Computer Vision")

    def add_author_clicked(self):
        author_name = self.authorname.text()
        if author_name:
            self.authors_list.addItem(author_name)
            self.authorname.clear()

    def issue(self):
        checked = self.checkbox.isChecked()
        self.issuedToLineEdit.setEnabled(checked)
        self.issueDateEdit.setEnabled(checked)

    def validate(self):
        error_messages = []
        isbn = self.isbnLineEdit.text().strip()
        if len(isbn) > 12:
            error_messages.append("The Length of ISBN is greater than 12.")

        
        purchase_date = self.purchaseDateEdit.date().toPyDate()
        today = datetime.today().date()
        if purchase_date >= today:
            error_messages.append("Purchased On Date is greater than today.")

        
        if self.categoryComboBox.currentText() == "Journal" and self.authors_list.count() > 0:
            error_messages.append("A 'Journal' should not have any authors.")
        elif self.categoryComboBox.currentText() != "Journal" and self.authors_list.count() == 0:
            error_messages.append("This book must have at least one author.")

        
        if self.checkbox.isChecked():
            issued_to = self.issuedToLineEdit.text().strip()
            issue_date = self.issueDateEdit.date().toPyDate()
            if not issued_to:
                error_messages.append("The 'Issued to' field must not be empty.")
            if not (purchase_date < issue_date < today):
                error_messages.append("The 'Issue date' must be after the 'Purchased on' date and before today.")

        
        if error_messages:
            QMessageBox.information(self, "Message Box", "\n".join(error_messages))
        else:
            QMessageBox.information(self, "Message Box", "Book added successfully!")


app = QtWidgets.QApplication(sys.argv)
window = UI()  
app.exec()  
