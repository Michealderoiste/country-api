Feature: Manage Users Country data via the RESTful API

  In order to offer the User resource via an hypermedia API
  As a client software developer
  I need to be able to retrieve, and update JSON encoded User resources

  Background:
    Given there are Users with the following details:
      | uid | username | email              | password  |
      | u1  | testuser | testuser@email.com | testpass  |
      | u2  | brian    | brian@email.com    | testpass1 |
    And there are Countries with the following details
      | cid | name    | code |
      | c1  | Ireland | ie   |
    And I am successfully logged in with username: "testuser", and password: "testpass"
    And when consuming the endpoint I use the "headers/content-type"  of "application/json"

  Scenario: User cannot GET a Collection of User objects
    When I send a "GET" request to "/users"
    Then the response code should 405

  Scenario: User can GET their personal data by their unique ID
    When I send a "GET" request to "/users/u1"
    Then the response code should be 200
    And the response header "Content-Type" should be equal to "application/json; charset=utf-8"
    And the response should contain json
    """
    {
      "id": "u1",
      "email": "testuser@email.com",
      "username": "testuser"
    }
    """

  Scenario: User cannot GET a different User's personal data
    When I send a "GET" request to "/users/u2"
    Then the response code should 403

  Scenario: User cannot determine if another User ID is active
    When I send a "GET" request to "/users/u100"
    Then the response code should 403

  Scenario: User cannot POST to the Users collection
    When I send a "POST" request to "/users"
    Then the response code should 405

  Scenario: User can PATCH to update their personal data
    When I send a "PATCH" request to "/users/u1" with body:
      """
      {
        "email": "testuser@email2.com",
        "current_password": "testpass"
      }
      """
    Then the response code should 204
    And I send a "GET" request to "/users/u1"
    And the response should contain json:
      """
      {
        "id": "u1",
        "email": "testuser@email2.com",
        "username": "testuser"
      }
      """

  Scenario: User cannot PATCH without a valid password
    When I send a "PATCH" request to "/users/u1" with body:
      """
      {
        "email": "testuser@email2.com",
        "current_password": "jimbo"
      }
      """
    Then the response code should 400

  Scenario: User cannot PATCH a different User's personal data
    When I send a "PATCH" request to "/users/u2"
    Then the response code should 403

  Scenario: User cannot PATCH a none existent User
    When I send a "PATCH" request to "/users/u100"
    Then the response code should 403

  Scenario: User cannot PUT to replace their personal data
    When I send a "PUT" request to "/users/u1"
    Then the response code should 405

  Scenario: User cannot PUT a different User's personal data
    When I send a "PUT" request to "/users/u2"
    Then the response code should 405

  Scenario: User cannot PUT a none existent User
    When I send a "PUT" request to "/users/u100"
    Then the response code should 405

  Scenario: User cannot DELETE their personal data
    When I send a "DELETE" request to "/users/u1"
    Then the response code should 405

  Scenario: User cannot DELETE a different User's personal data
    When I send a "DELETE" request to "/users/u2"
    Then the response code should 405

  Scenario: User cannot DELETE a none existent User
    When I send a "DELETE" request to "/users/u100"
    Then the response code should 405