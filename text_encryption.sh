#!/bin/bash

# Function to display the main menu
show_menu() {
  echo ""
  echo "=========================================="
  echo "     🔐 TEXT ENCRYPTION TOOL (Bash)       "
  echo "=========================================="
  echo "Select an encryption algorithm:"
  echo "1. AES (Advanced Encryption Standard)"
  echo "2. DES (Data Encryption Standard)"
  echo "3. RSA (Rivest–Shamir–Adleman)"
  echo "4. Exit"
  echo "=========================================="
}

# Function to encrypt using AES
encrypt_aes() {
  echo "Enter text to encrypt:"
  read plaintext
  echo "Enter a password for AES encryption:"
  read -s aes_password
  echo "$plaintext" | openssl enc -aes-256-cbc -salt -pbkdf2 -k "$aes_password" -out aes_encrypted.txt
  echo "✅ Text encrypted using AES and saved in aes_encrypted.txt"
}

# Function to decrypt using AES
decrypt_aes() {
  echo "Enter the password used for AES encryption:"
  read -s aes_password
  openssl enc -aes-256-cbc -d -salt -pbkdf2 -k "$aes_password" -in aes_encrypted.txt -out aes_decrypted.txt
  echo "✅ Text decrypted using AES and saved in aes_decrypted.txt"
}

# Function to encrypt using DES
encrypt_des() {
  echo "Enter text to encrypt:"
  read plaintext
  echo "Enter a password for DES encryption:"
  read -s des_password
  echo "$plaintext" | openssl enc -des -salt -pbkdf2 -k "$des_password" -out des_encrypted.txt
  echo "✅ Text encrypted using DES and saved in des_encrypted.txt"
}

# Function to decrypt using DES
decrypt_des() {
  echo "Enter the password used for DES encryption:"
  read -s des_password
  openssl enc -des -d -salt -pbkdf2 -k "$des_password" -in des_encrypted.txt -out des_decrypted.txt
  echo "✅ Text decrypted using DES and saved in des_decrypted.txt"
}

# Function to encrypt using RSA
encrypt_rsa() {
  echo "Generating RSA key pair..."
  openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048 > /dev/null 2>&1
  openssl rsa -pubout -in private_key.pem -out public_key.pem > /dev/null 2>&1
  echo "RSA keys generated (private_key.pem, public_key.pem)."

  echo "Enter text to encrypt:"
  read plaintext
  echo "$plaintext" | openssl rsautl -encrypt -inkey public_key.pem -pubin -out rsa_encrypted.txt
  echo "✅ Text encrypted using RSA and saved in rsa_encrypted.txt"
}

# Function to decrypt using RSA
decrypt_rsa() {
  echo "Decrypting using RSA private key..."
  openssl rsautl -decrypt -inkey private_key.pem -in rsa_encrypted.txt -out rsa_decrypted.txt
  echo "✅ Text decrypted using RSA and saved in rsa_decrypted.txt"
}

# Main program loop
while true; do
  show_menu
  read -p "Enter your choice [1-4]: " choice

  case $choice in
    1)
      echo "1. Encrypt using AES"
      echo "2. Decrypt using AES"
      read -p "Enter your choice [1-2]: " aes_choice
      if [ "$aes_choice" -eq 1 ]; then
        encrypt_aes
      elif [ "$aes_choice" -eq 2 ]; then
        decrypt_aes
      else
        echo "❌ Invalid choice."
      fi
      ;;
    2)
      echo "1. Encrypt using DES"
      echo "2. Decrypt using DES"
      read -p "Enter your choice [1-2]: " des_choice
      if [ "$des_choice" -eq 1 ]; then
        encrypt_des
      elif [ "$des_choice" -eq 2 ]; then
        decrypt_des
      else
        echo "❌ Invalid choice."
      fi
      ;;
    3)
      echo "1. Encrypt using RSA"
      echo "2. Decrypt using RSA"
      read -p "Enter your choice [1-2]: " rsa_choice
      if [ "$rsa_choice" -eq 1 ]; then
        encrypt_rsa
      elif [ "$rsa_choice" -eq 2 ]; then
        decrypt_rsa
      else
        echo "❌ Invalid choice."
      fi
      ;;
    4)
      echo "👋 Exiting the program. Goodbye!"
      break
      ;;
    *)
      echo "❌ Invalid choice. Please select a valid option."
      ;;
  esac
done
