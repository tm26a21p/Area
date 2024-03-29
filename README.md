# Area: Automation Platform of Digital Life

## Overview

**A**ction **REA**ction is an automation platform designed to streamline and automate various digital tasks in a user's life. This project was developed using **Go** with the **Gin framework** for the backend and **VueJS** for the frontend. The platform functions similarly to popular automation tools like IFTTT and Zapier, allowing users to create interconnections between different digital services.

## Project Structure

The project consists of two main components:

1. **Application Server**: Implements the core business logic using Go and the Gin framework, and exposes functionalities via a REST API.
2. **Web Client**: A browser-based client developed using VueJS for accessing and using the platform.

## Features

### User Management
- Registration and account creation
- Authentication via username/password or OAuth2
- User profile management
- Create, update, and delete workflows

### Services
- Subscription to various digital services (e.g., Outlook 365, Yammer, OneDrive, ~~Twitter~~X, Instagram, etc..)
- OAuth2-based authentication for service subscriptions

### Action Components
- Define triggers based on various digital activities (e.g., project completion, new message, file upload)

### REAction Components
- Perform specific tasks in response to triggers (e.g., send a message, add a file, post on social media)

### AREA
- User-defined interconnections between Actions and REActions to automate workflows

### Trigger
- Detects and activates REActions based on predefined Actions and their conditions

> The main idea behind the platform is to allow users to create custom workflows by connecting different digital services and automating tasks based on specific triggers.

## Architecture

- **Application Server**: Hosts the core business logic developed using Go and the Gin framework, and exposes functionalities via a REST API.
- **Web Client**: A frontend application developed using VueJS for user interaction.

## Development Tools and Technologies

- **Backend**: Go programming language with the Gin framework
- **Frontend**: Javascript with VueJS framework
- **Docker Compose**: Used for containerization and orchestration of services.

## Project Construction

### Docker Compose Configuration
A `docker-compose.yml` file is included at the root of the project, defining the services:

- `server`: Application server running on port 8080
- `client_web`: Web client running on port 8081

### File Structure
All source files related to the project are included in the delivery, excluding unnecessary files (binary, temp files, obj files, etc.).
---

For more details, please refer to the project documentation and codebase.
