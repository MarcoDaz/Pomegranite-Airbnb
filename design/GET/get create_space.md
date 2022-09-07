GET /create_space Route Design Recipe
Copy this design recipe template to test-drive a Sinatra route.

1. Design the Route Signature
   You'll need to include:

the HTTP method
the path
any query parameters (passed in the URL)
or body parameters (passed in the request body) 2. Design the Response
The route might return different responses, depending on the result.

METHOD: GET
PATH: /create_space


<!-- EXAMPLE -->
<!-- Response when the post is found: 200 OK -->
```html
<html>
  <head>
    <title>List a Space</title>
  </head>
  <body>
    <h1>List a Space</h1>
    <form>
      <!-- name, descript, price, available_from, available_to -->
    </form>
  </body>
</html>
```

3. Write Examples
Replace these with your own design.

# Request:

GET /posts?id=1

# Expected response:

Response for 200 OK

# Request:

GET /posts?id=276278

# Expected response:

Response for 404 Not Found 4. Encode as Tests Examples

# EXAMPLE

# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
include Rack::Test::Methods

let(:app) { Application.new }

context "GET /" do
it 'returns 200 OK' do # Assuming the post with id 1 exists.
response = get('/posts?id=1')

      expect(response.status).to eq(200)
      # expect(response.body).to eq(expected_response)
    end

    it 'returns 404 Not Found' do
      response = get('/posts?id=276278')

      expect(response.status).to eq(404)
      # expect(response.body).to eq(expected_response)
    end

end
end 5. Implement the Route
Write the route and web server code to implement the route behaviour.
