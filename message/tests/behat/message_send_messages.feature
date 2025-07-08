@core @core_message @javascript
Feature: Message send messages
  In order to communicate with fellow users
  As a user
  I need to be able to send a message

  Background:
    Given the following "courses" exist:
      | fullname | shortname | category | groupmode |
      | Course 1 | C1        | 0        | 1         |
    And the following "users" exist:
      | username | firstname | lastname | email                |
      | student1 | Student   | 1        | student1@example.com |
      | student2 | Student   | 2        | student2@example.com |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | student1 | C1     | student        |
      | student2 | C1     | student        |
      | teacher1 | C1     | editingteacher |
    And the following "groups" exist:
      | name    | course | idnumber | enablemessaging |
      | Group 1 | C1     | G1       | 1               |
    And the following "group members" exist:
      | user     | group |
      | student1 | G1 |
      | student2 | G1 |
    And the following config values are set as admin:
      | messaging        | 1 |
      | messagingminpoll | 1 |

  Scenario: Send a message to a group conversation
    Given I log in as "student1"
    And I open messaging
    And I open the "Group" conversations list
    And "Group 1" "core_message > Message" should exist
    And I select "Group 1" conversation in messaging
    When I send "Hi!" message in the message area
    Then I should see "Hi!" in the "Group 1" "core_message > Message conversation"
    And I should see "##today##%d %B##" in the "Group 1" "core_message > Message conversation"
    And I log out
    And I log in as "student2"
    And I open messaging
    And "Group 1" "core_message > Message" should exist
    And I select "Group 1" conversation in messaging
    And I should see "Hi!" in the "Group 1" "core_message > Message conversation"

  Scenario: Send a message to a starred conversation
    Given I log in as "student1"
    When I open messaging
    And I open the "Group" conversations list
    Then "Group 1" "core_message > Message" should exist
    And I select "Group 1" conversation in the "group-messages" conversations list
    And I open contact menu
    And I click on "Star conversation" "link" in the "conversation-actions-menu" "region"
    And I go back in "view-conversation" message drawer
    And I open the "Starred" conversations list
    And I should see "Group 1"
    And I select "Group 1" conversation in the "favourites" conversations list
    And I send "Hi!" message in the message area
    And I should see "Hi!" in the "Group 1" "core_message > Message conversation"
    And I should see "##today##%d %B##" in the "Group 1" "core_message > Message conversation"
    And I go back in "view-conversation" message drawer
    And I open the "Group" conversations list
    And I should not see "Group 1" in the "Group" "core_message > Message tab"

  Scenario: Send a message to a private conversation via contact tab
    Given the following "message contacts" exist:
      | user     | contact |
      | student1 | student2 |
    And I log in as "student1"
    And I open messaging
    And I click on "Contacts" "link"
    And I click on "Student 2" "link" in the "//*[@data-section='contacts']" "xpath_element"
    When I send "Hi!" message in the message area
    Then I should see "Hi!" in the "Student 2" "core_message > Message conversation"
    And I should see "##today##%d %B##" in the "Student 2" "core_message > Message conversation"

  Scenario: Try to send a message to a private conversation is not contact but you are allowed to send a message
    Given I log in as "student1"
    And I open messaging
    When I send "Hi!" message to "Student 2" user
    Then I should see "Hi!" in the "Student 2" "core_message > Message conversation"
    And I should see "##today##%d %B##" in the "Student 2" "core_message > Message conversation"
    And I log out
    And I log in as "student2"
    And I open messaging
    And I select "Student 1" conversation in messaging
    And I should see "Hi!" in the "Student 1" "core_message > Message conversation"

  Scenario: Unsent messages will notify users and give them a chance to send it
    Given I log in as "student1"
    And I open messaging
    And I send "Hi!" message to "Student 2" user
    And I select "Student 2" user in messaging
    And I set the field "Write a message..." to "What you doing?"
    When I follow "Dashboard"
    Then I should see "You have an unsent message. It will be lost if you leave this page."
    And I press "Send message"
    And I should see "What you doing?" in the "Student 2" "core_message > Message conversation"

  Scenario: Student cannot reply to a message from a teacher not in their course
    Given I log in as "teacher1"
    And I open messaging
    And I send "Hi!" message to "Student 1" user
    And I am on "C1" course homepage
    And I navigate to course participants
    And I click on "Unenrol" "link" in the "student1" "table_row"
    And I click on "Unenrol" "button" in the "Unenrol" "dialogue"
    And I log in as "student1"
    When I open messaging
    And I select "Teacher 1" conversation in messaging
    Then I should see "Cannot send message"
    And the "disabled" attribute of "textarea[data-region='send-message-txt']" "css_element" should contain "true"
    And the "disabled" attribute of "button[data-action='send-message']" "css_element" should contain "true"
    And the "disabled" attribute of "button[data-action='toggle-emoji-picker']" "css_element" should contain "true"
