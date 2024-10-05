# README
## Version: Sprint 1 MVP
## Links
Deployment: https://teamup-neo-ba74edfc326f.herokuapp.com
Code Climate: https://codeclimate.com/github/shahakanksha-tamu/teamup-neo-backend
TWA link: https://docs.google.com/document/d/1UJPuRpy88v_93F4VPQSZGwPWX9yjqdwD4mbKQIw6viM/edit?usp=sharing
## Features
#### Login Using Google OAuth
Users can log in via OAuth.
User sessions persist after login.
Error handling and redirects for failed logins.
#### Logout Using Google OAuth
Users can log out and clear their session.
Error handling and redirects for illegal logout attempts.
#### Page UI
Landing page UI.
Basic dashboard place holder.
#### Session Management and Access Authority Check
Authority check for resources requiring logging in.
## Setting Up Locally
#### 1. bundle install
#### 2. configure the credential file and master key
#### 4. rails db: create
#### 5. rails db: migrate
#### 6. rails db: seed
#### 7. rails server
