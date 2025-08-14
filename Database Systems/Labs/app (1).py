from PyQt6.QtWidgets import QMainWindow, QTableWidgetItem, QMessageBox
from PyQt6 import QtWidgets, uic, QtCore
import sys

# List of books with ISBN, Title, Category, Type, and Issued
books = [
    ["0201144719 9780201144710", "An introduction to database systems", "Database", "Reference Book", "True"],
    ["0805301453 9780805301458", "Fundamentals of database systems", "Database", "Reference Book", "False"],
    ["1571690867 9781571690869", "Object oriented programming in Java", "OOP", "Text Book", "False"],
    ["1842652478 9781842652473", "Object oriented programming using C++", "OOP", "Text Book", "False"],
    ["0070522618 9780070522619", "Artificial intelligence", "AI", "Journal", "False"],
    ["0865760047 9780865760042", "The Handbook of artificial intelligence", "AI", "Journal", "False"],
]

class View_form(QtWidgets.QMainWindow):
    def __init__(self, book_details):
        super(View_form, self).__init__()
        uic.loadUi('view_form.ui', self)
        #seting the fields according to the view form
        self.isbn.setText(book_details[0])
        self.title.setText(book_details[1])
        self.category_view.setText(book_details[2])

        # Setting radio buttons here
        if book_details[3] == "Reference Book":
            self.reference_view.setChecked(True)
        elif book_details[3] == "Text Book":
            self.textbook_view.setChecked(True)
        else:
            self.journal_view.setChecked(True)

        # Setting the issued box here
        if book_details[4] == "True":
            self.issued_view.setChecked(True)
        else:
            self.issued_view.setChecked(False)

        #making all the inputs non editable here:
        self.isbn.setReadOnly(True)
        self.title.setReadOnly(True)
        self.category_view.setReadOnly(True)
        self.reference_view.setEnabled(False)
        self.textbook_view.setEnabled(False)
        self.journal_view.setEnabled(False)
        self.issued_view.setEnabled(False)

class UI(QtWidgets.QMainWindow):
    def __init__(self):
        super(UI, self).__init__()
        uic.loadUi('lab02.ui', self)
        self.booksTableWidget.setColumnCount(5)
        self.booksTableWidget.setHorizontalHeaderLabels(["ISBN", "Title", "Category", "Type", "Issued"])
        self.insertion(books)

        # Connecting the buttons here:
        self.searchbutton.clicked.connect(self.search)
        self.viewbutton.clicked.connect(self.view)
        self.deletebutton.clicked.connect(self.delete)
        self.closebutton.clicked.connect(self.close_form)

    def insertion(self, book_list):
        self.booksTableWidget.setRowCount(len(book_list))
        row=0
        for book in book_list:
            column=0
            for j in range(5):
                item=QtWidgets.QTableWidgetItem(book[j])
                # Make the items non-editable
                item.setFlags(QtCore.Qt.ItemFlag.ItemIsEnabled | QtCore.Qt.ItemFlag.ItemIsSelectable)
                self.booksTableWidget.setItem(row, column, item)
                column=column+1
            row=row+1

    def search(self):
        category=self.category.currentText()
        title=self.title.text().strip().lower()

        if self.reference.isChecked()==True:
            type_of_book="Reference Book"
        elif self.textbook.isChecked()==True:
            type_of_book="Text Book"
        else:
            type_of_book="Journal"

        if self.issuedbox.isChecked()==True:
            issued=True
        else:
            issued=False

        books_to_show=[]
        for book in books:
            if category.lower()==book[2].lower():
                category_matches=True
            else:
                category_matches=False

            if type_of_book==book[3]:
                type_matches=True
            else:
                type_matches=False

            if issued==False:
                issued_matches=True
            elif book[4]=="True":
                issued_matches=True
            else:
                issued_matches=False

            if category_matches==True and type_matches==True and issued_matches==True:
                books_to_show.append(book)

        self.insertion(books_to_show) #calling the insertion function here which will insert the books into the table

    def view(self):
        row_clicked= self.booksTableWidget.currentRow()
        if row_clicked<0:
            QtWidgets.QMessageBox.warning(self, "Warning", "No book selected")
            return

        #getting the details of the selected book
        book_details = []
        for column in range(5):
            book_details.append(self.booksTableWidget.item(row_clicked, column).text())

        # Create and show the ViewBook form
        self.view_book_window = View_form(book_details)
        self.view_book_window.show()

    def delete(self):
        row_clicked = self.booksTableWidget.currentRow()
        if row_clicked < 0:
            QtWidgets.QMessageBox.warning(self, "Warning", "No book selected")
            return
        reply = QtWidgets.QMessageBox.question(
            self,
            'Confirmation box',
            'Are you sure you want to delete this book?',
            QtWidgets.QMessageBox.StandardButton.Yes | QtWidgets.QMessageBox.StandardButton.No,
            QtWidgets.QMessageBox.StandardButton.No
        )
        if reply == QtWidgets.QMessageBox.StandardButton.Yes:
            self.booksTableWidget.removeRow(row_clicked)
            del books[row_clicked]
        else:
            pass

    def close_form(self):
        #Close the application
        self.close()

app = QtWidgets.QApplication(sys.argv)  # Create an instance of QtWidgets.QApplication
window = UI()  # Create an instance of our UI class
window.show()
app.exec()  # Start the application
