# Pomegranite-Airbnb

# MakersBnB specification

We would like a web application that allows users to list spaces they have available, and to hire spaces for the night.

### Headline specifications- Also MVP

- Any signed-up user can list a new space
- Users can list multiple spaces.

- Users should be able to name their space, provide a short description of the space, and a price per night.

- Users should be able to offer a range of dates where their space is available.

- Any signed-up user can request to hire any space for one night, and this should be approved by the user that owns that space.

- Nights for which a space has already been booked should not be available for users to book that space.

- Until a user has confirmed a booking request, that space can still be booked for that night.

### User Stories

As a X, so that i can Y, I want to do Z

As a User, I want to be able to create an account with a email address and a password

As a User, I want to be able to sign in with a email address and a password (that matches a record in the database).

As a User, I want to be able to list one space with a name, description, price, dates.

As a User, I want to be able to list multiple spaces.

As a User, I want to offer a specific range of dates where their space is available.

As a User, I want to be able to send a request to hire any space for one night.

As a User, I want to able to approve / deny a request to hire any space I own from another user.

As a User, I want to be to show that booked spaces are not available for other users on a specific day.

As a User, I want others to be able to request to book a space available until a user has confirmed a booking request.

### Nice-to-haves

- Users should receive an email whenever one of the following happens:
- They sign up
- They create a space
- They update a space
- A user requests to book their space
- They confirm a request
- They request to book a space
- Their request to book a space is confirmed
- Their request to book a space is denied
- Users should receive a text message to a provided number whenever one of the following happens:
- A user requests to book their space
- Their request to book a space is confirmed
- Their request to book a space is denied
- A ‘chat’ functionality once a space has been booked, allowing users whose space-booking request has been confirmed to chat with the user that owns that space
- Basic payment implementation though Stripe.

### Mockups

Mockups for MakersBnB are available [here](https://github.com/makersacademy/course/blob/main/makersbnb/makers_bnb_images/MakersBnB_mockups.pdf).

Checklist for getting setup.

1. Setting up - Gem files + RSpec + Sinatra
2. Turning User stories into tickets

   Setting up the databases
   Figuring out how sessions
   Figuring out how to deploy code to heroku

Use multi-class design recipe to setup multiple classes + plan them out  
Model and repository class design recipe.
