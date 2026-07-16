# Dashboard Specification

## Requirements

### Requirement: Reserve Balance From Debit Accounts
The system SHALL compute the reserve balance as the sum of `balance` over all debit accounts where `excludeFromReserve = false`.

#### Scenario: Two eligible debit accounts
- GIVEN debit account A has balance R$1000 (not excluded) and debit account B has balance R$500 (not excluded)
- WHEN the reserve balance is computed
- THEN it equals R$1500

#### Scenario: Excluded account is skipped
- GIVEN debit account C has balance R$2000 and `excludeFromReserve = true`
- WHEN the reserve balance is computed
- THEN account C's balance does not contribute to the total

### Requirement: Total Spent From Credit Transactions Only
The system SHALL compute total spent as the sum of transaction values for transactions whose account has `isCredit = true`, within the active period; debit transactions are excluded because they already directly affect account balance.

#### Scenario: Mixed debit and credit transactions in period
- GIVEN a period contains a R$100 debit transaction and a R$200 credit transaction
- WHEN total spent is computed
- THEN it equals R$200 (only the credit transaction counts)

### Requirement: Remaining Budget Formula
The system SHALL compute remaining budget as `(monthlySalary + reserveBalance * maxReserveUsagePercentage / 100) - totalSpent`.

#### Scenario: Salary covers spending
- GIVEN monthlySalary=R$5000, reserveBalance=R$1000, maxReserveUsagePercentage=20, totalSpent=R$4000
- WHEN remaining budget is computed
- THEN it equals (5000 + 1000*0.20) - 4000 = R$1200

### Requirement: Final Reserve Reduced Only on Overspending
The system SHALL leave the reserve intact when spending does not exceed salary, and reduce it by exactly the overspent amount otherwise.

#### Scenario: Spending under salary
- GIVEN monthlySalary=R$5000 and totalSpent=R$4000
- WHEN final reserve is computed from an initial reserveBalance of R$1000
- THEN final reserve equals R$1000 (unchanged)

#### Scenario: Spending exceeds salary
- GIVEN monthlySalary=R$5000 and totalSpent=R$5500
- WHEN final reserve is computed from an initial reserveBalance of R$1000
- THEN final reserve equals R$1000 - (5500-5000) = R$500

### Requirement: Reserve Usage Percentage
The system SHALL compute reserve usage percentage as `(overspending / maxAllowedReserveUsage) * 100`, or 0 when `maxAllowedReserveUsage` is 0.

#### Scenario: No overspending
- GIVEN totalSpent does not exceed monthlySalary
- WHEN reserve usage percentage is computed
- THEN it equals 0%

### Requirement: Transaction Filtering by Account Type
The system SHALL filter each account's transactions by its own billing period: credit accounts with a `creditPaymentDay` use their dynamically computed billing cycle; debit accounts (and credit accounts without a payment day) use the plain calendar month.

#### Scenario: Explicit invoice period overrides per-account cycles
- GIVEN a `BillingCyclePeriod` is explicitly provided (invoice navigation)
- WHEN dashboard data is computed
- THEN all accounts' transactions are filtered by that exact date range, regardless of their individual billing cycles

### Requirement: Reactive Recomputation
The system SHALL recompute dashboard data automatically whenever the current month's transaction stream emits.

#### Scenario: New transaction added
- GIVEN the dashboard is displayed
- WHEN a new transaction is saved anywhere in the app
- THEN the dashboard's displayed values update without manual refresh
