# Categories Specification

## Requirements

### Requirement: Default Category Seeding
The system SHALL seed 7 default Portuguese-language categories on first run, only when the categories table is currently empty.

#### Scenario: Fresh install
- GIVEN the categories table has zero rows
- WHEN the app starts
- THEN Alimentação, Transporte, Moradia, Saúde, Lazer, Educação, and Outros are inserted

#### Scenario: Categories already exist
- GIVEN the categories table already has at least one row
- WHEN the app starts again
- THEN no seeding occurs and existing categories are left untouched

### Requirement: Single Default Category
The system SHALL allow at most one category to be marked default at a time, and pre-select it in the transaction creation form.

#### Scenario: Marking a new default
- GIVEN category A is the current default
- WHEN the user marks category B as default
- THEN A's default flag is cleared and B's is set

### Requirement: Deletion Blocked for In-Use Categories
The system SHALL refuse to delete a category that has transactions referencing it.

#### Scenario: Deleting a category with linked transactions
- GIVEN a category has at least one transaction using it
- WHEN the user attempts to delete that category
- THEN the deletion is blocked
