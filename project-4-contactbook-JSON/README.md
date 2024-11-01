# Project 4: Contact Book with JSON Persistence

This project involves building a simple contact book application where contact details are stored using a JSON persistence layer. The contact book allows adding, viewing, and removing contacts, and all data is saved in a JSON file for persistence across sessions.

### Learning Objectives:
- Use GH Copilot to build a contact management system.
- Understand how to read and write data using JSON for persistent storage.

- Write a JavaScript/Python or Java program that allows users to:
  - Add a contact (name, phone number, email).
  - View all contacts.
  - Remove a contact by name (and/or other attribute).
  - Save the contacts to a JSON file, so that they persist across program runs.
  
Steps:
1. Setting up the project: Create a JavaScript/Java or Python file called `contact_book.js or .py or ContactBook.java`.
   - For Java projects, use the command palette and "create a new java project"
  
2. Use GH Copilot to write a script that:
   - Uses a JSON file to store contact data.
   - Implements the ability to add, view, and remove contacts.
   - Handles saving and loading contacts from a JSON file.
  
3. GitHub Copilot Usage:
   - Use either GH Copilot Chat or Code Completions to structure for contact management (e.g., adding contacts), and let Copilot assist in implementing file reading and writing using the `json` module.

4. Generate Unit tests for each function - Do all the functions in the program work correctly?


<details>

<summary>Completed Python implementation, for emergency reference only</summary>

```python
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
```

</details>

<details>

<summary>Completed Java implementation, for emergency reference only</summary>

```Java
/*
 * This source file was generated by the Gradle 'init' task
 */
package contactbook;

import java.util.ArrayList;
import java.util.Scanner;
import java.io.FileWriter;
import java.io.File;
import java.io.IOException;

public class App {
    public static ArrayList<String> contacts = new ArrayList<>();

public static void main(String[] args) {
    Scanner scanner = new Scanner(System.in);
    while (true) {
        System.out.println("Welcome to your Contact Book!");
        System.out.println("1. Add a contact");
        System.out.println("2. View contacts");
        System.out.println("3. Remove a contact");
        System.out.println("4. Exit");
        System.out.print("Choose an option: ");
        int choice = scanner.nextInt();
        scanner.nextLine(); // Consume newline

        switch (choice) {
            case 1:
                addContact(scanner);
                break;
            case 2:
                viewContacts(true);
                break;
            case 3:
                removeContact(scanner);
                break;
            case 4:
                System.out.println("Goodbye!");
                scanner.close();
                return;
            default:
                System.out.println("Invalid option. Please try again.");
        }
    }
}

public static void addContact(Scanner scanner) {
    System.out.print("Enter contact name: ");
    String name = scanner.nextLine();
    System.out.print("Enter phone number: ");
    String phoneNumber = scanner.nextLine();
    System.out.print("Enter email: ");
    String email = scanner.nextLine();
    String contact = name + "," + phoneNumber + "," + email;
    contacts.add(contact);
    saveContactsToFile();
    System.out.println("Contact added.");
}

/**
 * Saves the list of contacts to a file named "contacts.json".
 * The contacts are written in JSON array format.
 * If the directory for the file does not exist, it will be created.
 * 
 * The method handles any IOExceptions that may occur during the file writing process.
 * In case of an error, an error message is printed to the console.
 */
public static void saveContactsToFile() {
    try {
        File file = new File("contacts.json");
        if (file.getParentFile() != null) {
            file.getParentFile().mkdirs(); // Ensure the directory exists
        }
        FileWriter writer = new FileWriter(file);
        writer.write("[\n");
        for (int i = 0; i < contacts.size(); i++) {
            writer.write("  \"" + contacts.get(i) + "\"");
            if (i < contacts.size() - 1) {
                writer.write(",");
            }
            writer.write("\n");
        }
        writer.write("]");
        writer.close();
    } catch (IOException e) {
        System.out.println("An error occurred while saving the contacts to a file.");
    }
}

public static void viewContacts(boolean loadFromFile) {
    if (loadFromFile) {
        loadContactsFromJson();
    }
    if (contacts.isEmpty()) {
        System.out.println("No contacts found.");
    } else {
        System.out.println("Your contacts:");
        for (int i = 0; i < contacts.size(); i++) {
            System.out.println((i + 1) + ". " + contacts.get(i));
        }
    }
}

public static void loadContactsFromJson() {
    contacts.clear(); // Clear existing contacts before loading from file
// load the json file and parse it into a list of strings
    try {
        Scanner scanner = new Scanner(new File("contacts.json"));
        StringBuilder json = new StringBuilder();
        while (scanner.hasNextLine()) {
            json.append(scanner.nextLine());
        }
        scanner.close();
        // remove leading and trailing whitespace
        String jsonString = json.toString().strip();
        // remove leading and trailing brackets
        String data = jsonString.substring(1, jsonString.length() - 1);
        // split the data into an array of strings
        String[] dataArray = data.split("(?<=\\\"),\\s*(?=\\\")");
        // remove leading and trailing quotes from each string and add to the contacts list
        for (String contact : dataArray) {
            contacts.add(contact.replaceAll("^\\s*\"|\"\\s*$", ""));
        }
    } catch (IOException e) {
        System.out.println("An error occurred while loading the contacts from the file.");
    }
}


public static void removeContact(Scanner scanner) {
    loadContactsFromJson();
    System.out.print("Enter the number of the contact to remove: ");
    int index = scanner.nextInt() - 1;
    if (index >= 0 && index < contacts.size()) {
        contacts.remove(index);
        saveContactsToFile();
        System.out.println("Contact removed.");
    } else {
        System.out.println("Invalid contact number.");
    }
}


    }

```

</details>