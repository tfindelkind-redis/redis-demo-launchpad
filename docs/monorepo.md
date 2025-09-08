# Monorepo Handling

## Securing a Monorepo by Folder Ownership

In GitHub, repository permissions are repo-wide, so you cannot directly grant write access to only a subfolder. However, you can enforce project boundaries in a monorepo using a combination of branch protection rules, CODEOWNERS, and rulesets (push rules).

### 1. Enforce Pull Requests for All Changes

Protect the main branch (main or master) so that direct pushes are forbidden.

Require pull requests for merging, with status checks and reviews enabled.

This ensures that every change, regardless of folder, goes through review and CI.

### 2. Use CODEOWNERS to Require Reviews

Define ownership per folder in a `.github/CODEOWNERS` file:

```plaintext
/apps/app-a/**      @org/app-a-team
/apps/app-b/**      @org/app-b-team
/libs/common/**     @org/platform-team
*                   @org/platform-team
```

Then enable "Require review from Code Owners" in branch protection.

Result: any PR that touches `apps/app-a/**` must be reviewed by `@org/app-a-team`.

This enforces social and process boundaries — teams cannot merge changes outside their domain without approval.

### 3. Apply Rulesets (Restrict File Paths)

GitHub Rulesets let you define push rules that restrict what paths contributors may modify.

Example: a ruleset for Team A could block all paths except `apps/app-a/**`.

You can add bypass permissions for maintainers/admins, so they can override when necessary.

This turns folder boundaries into enforceable technical policies, not just review guidelines.
