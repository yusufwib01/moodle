@core
Feature: Login using email address
  Users should be able to access their site
  As a user
  I should be able to login using email

  Background:
    Given the following "users" exist:
      | username | password | firstname | lastname | email            |
      | testuser | test     | Test      | User     | user@example.com |

  Scenario Outline: A user can login using their email address
    Given the following config values are set as admin:
      | authloginviaemail | <authloginviaemail> |
    When I am on homepage
    Then "<usernameiconselector>" "css_element" should exist
    And "<otherusernameiconselector>" "css_element" should not exist
    And ".login-form-password .login-input-icon .fa-lock[aria-hidden='true']" "css_element" should exist
    And I set the field "Username" to "<login>"
    And I set the field "Password" to "test"
    And I press "Log in"
    Then I should see "<message>"

    Examples:
      | authloginviaemail | usernameiconselector                                             | otherusernameiconselector                                         | login            | message              |
      | 0                 | .login-form-username .login-input-icon .fa-user[aria-hidden='true']     | .login-form-username .login-input-icon .fa-envelope[aria-hidden='true'] | testuser         | You are logged in as |
      | 0                 | .login-form-username .login-input-icon .fa-user[aria-hidden='true']     | .login-form-username .login-input-icon .fa-envelope[aria-hidden='true'] | user@example.com | Unable to log in     |
      | 1                 | .login-form-username .login-input-icon .fa-envelope[aria-hidden='true'] | .login-form-username .login-input-icon .fa-user[aria-hidden='true']     | testuser         | You are logged in as |
      | 1                 | .login-form-username .login-input-icon .fa-envelope[aria-hidden='true'] | .login-form-username .login-input-icon .fa-user[aria-hidden='true']     | user@example.com | You are logged in as |
