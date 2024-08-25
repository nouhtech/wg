#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Error: This script must be run as root!${NC}"
  exit 1
fi

# Function to check and install WireGuard if not installed
install_wireguard() {
  if ! command -v wg > /dev/null; then
    echo -e "${YELLOW}WireGuard is not installed. Installing...${NC}"
    
    # Check the package manager and install WireGuard
    if command -v apt-get > /dev/null; then
      sudo apt-get update && sudo apt-get install -y wireguard
    elif command -v dnf > /dev/null; then
      sudo dnf install -y wireguard-tools
    elif command -v yum > /dev/null; then
      sudo yum install -y epel-release && sudo yum install -y wireguard-tools
    elif command -v pacman > /dev/null; then
      sudo pacman -S --noconfirm wireguard-tools
    elif command -v zypper > /dev/null; then
      sudo zypper install -y wireguard-tools
    else
      echo -e "${RED}Unsupported package manager. Please install WireGuard manually.${NC}"
      exit 1
    fi
    
    echo -e "${GREEN}WireGuard has been installed.${NC}"
  fi
}

# Function to display the menu and handle user input
show_menu() {
  echo -e "${YELLOW}====================================="
  echo -e "         WireGuard Manager           "
  echo -e "=====================================${NC}"
  echo
  echo -e "${YELLOW}Follow me on X (Twitter):${NC} ${GREEN}https://x.com/nouhtech${NC}"
  echo -e "${YELLOW}Choose an option by typing the corresponding number:${NC}"
  echo -e "${YELLOW}1)${NC} Start WireGuard"
  echo -e "${YELLOW}2)${NC} Stop WireGuard"
  echo -e "${YELLOW}3)${NC} Open WireGuard Configuration File"
  echo -e "${YELLOW}4)${NC} Check WireGuard Status"
  echo -e "${YELLOW}5)${NC} Exit"
  echo
}

# Function to execute user choice
execute_choice() {
  case $1 in
      1)
          echo -e "${GREEN}Starting WireGuard...${NC}"
          wg-quick up wg0
          echo -e "${GREEN}WireGuard started.${NC}"
          ;;
      2)
          echo -e "${RED}Stopping WireGuard...${NC}"
          wg-quick down wg0
          echo -e "${RED}WireGuard stopped.${NC}"
          ;;
      3)
          echo -e "${YELLOW}Opening WireGuard Configuration File...${NC}"
          nano /etc/wireguard/wg0.conf
          ;;
      4)
          echo -e "${GREEN}Checking WireGuard Status...${NC}"
          if wg show wg0 &> /dev/null; then
              echo -e "${GREEN}WireGuard is running.${NC}"
          else
              echo -e "${RED}WireGuard is not running.${NC}"
          fi
          ;;
      5)
          echo -e "${GREEN}Exiting...${NC}"
          exit 0
          ;;
      *)
          echo -e "${RED}Invalid choice. Please enter 1, 2, 3, 4, or 5.${NC}"
          ;;
  esac
}

# Main script
install_wireguard
show_menu
while true; do
  read -p "Enter your choice (1, 2, 3, 4, or 5): " choice
  execute_choice $choice
  if [ "$choice" -eq 5 ]; then
    break
  fi
done
