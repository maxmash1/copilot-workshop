# Completed implementation, for emergency reference only

import json
import os

class Contact:
    def __init__(self, first_name, last_name, phone, email):
        self.first_name = first_name
        self.last_name = last_name
        self.phone = phone
        self.email = email

    def __repr__(self):
        return f"Contact(first_name={self.first_name}, last_name={self.last_name}, phone={self.phone}, email={self.email})"

class ContactBook:
    def __init__(self):
        self.contacts = []

    def add_contact(self, first_name, last_name, phone, email):
        new_contact = Contact(first_name, last_name, phone, email)
        self.contacts.append(new_contact)

    def view_contacts(self):
        for contact in self.contacts:
            print(f"First Name: {contact.first_name}\nLast Name: {contact.last_name}\nPhone: {contact.phone}\nEmail: {contact.email}\n")

    def remove_contact(self, first_name, last_name):
        self.contacts = [contact for contact in self.contacts if not (contact.first_name == first_name and contact.last_name == last_name)]

    def update_contact(self, first_name, last_name, new_last_name=None, new_phone=None, new_email=None):
        for contact in self.contacts:
            if contact.first_name == first_name and contact.last_name == last_name:
                if new_last_name:
                    contact.last_name = new_last_name
                if new_phone:
                    contact.phone = new_phone
                if new_email:
                    contact.email = new_email
                return True
        return False

    def save_to_file(self, filename):
        with open(filename, 'w') as file:
            json.dump([contact.__dict__ for contact in self.contacts], file)

    def load_from_file(self, filename):
        if not os.path.exists(filename) or os.path.getsize(filename) == 0:
            with open(filename, 'w') as file:
                json.dump([], file)
        else:
            with open(filename, 'r') as file:
                contacts_data = json.load(file)
                self.contacts = [Contact(**data) for data in contacts_data]

def main():
    contact_book = ContactBook()
    contact_book.load_from_file('contacts.json')

    while True:
        print("\nContact Book Menu:")
        print("1. Add Contact")
        print("2. View Contacts")
        print("3. Remove Contact")
        print("4. Update Contact")
        print("5. Exit")
        choice = input("Enter your choice: ")

        if choice == '1':
            first_name = input("Enter first name: ")
            last_name = input("Enter last name: ")
            phone = input("Enter phone number: ")
            email = input("Enter email: ")
            contact_book.add_contact(first_name, last_name, phone, email)
        elif choice == '2':
            contact_book.view_contacts()
        elif choice == '3':
            first_name = input("Enter the first name of the contact to remove: ")
            last_name = input("Enter the last name of the contact to remove: ")
            contact_book.remove_contact(first_name, last_name)
        elif choice == '4':
            first_name = input("Enter the first name of the contact to update: ")
            last_name = input("Enter the last name of the contact to update: ")
            new_last_name = input("Enter new last name (leave blank to keep current): ")
            new_phone = input("Enter new phone number (leave blank to keep current): ")
            new_email = input("Enter new email (leave blank to keep current): ")
            if contact_book.update_contact(first_name, last_name, new_last_name or None, new_phone or None, new_email or None):
                print("Contact updated successfully.")
            else:
                print("Contact not found.")
        elif choice == '5':
            contact_book.save_to_file('contacts.json')
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()
