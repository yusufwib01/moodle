@core @core_message @javascript
Feature: Unable to message user
  In order to prevent sending messages when I am not allowed to
  As a user
  I need to be unable to send messages to users I am not permitted to contact

  Background:
    Given the following "users" exist:
      | username | firstname  | lastname | email                  |
      | student1 | Student   | 1        | student1@example.com   |
      | teacher1 | Teacher   | 1        | teacher1@example.com   |
    And the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1        |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | student1 | C1     | student        |
      | teacher1 | C1     | editingteacher |

  Scenario: Student cannot reply to a message from a teacher not in their course
    Given I log in as "teacher1"
    When I open messaging
    And I send "Hi!" message to "Student 1" user
    And I am on "C1" course homepage
    And I navigate to course participants
    And I click on "Unenrol" "link" in the "student1" "table_row"
    And I click on "Unenrol" "button" in the "Unenrol" "dialogue"
    And I should not see "Student 1" in the "participants" "table"
    And I log in as "student1"
    Then I open messaging
    And I select "Teacher 1" conversation in messaging
    And I should see "Cannot send message"
