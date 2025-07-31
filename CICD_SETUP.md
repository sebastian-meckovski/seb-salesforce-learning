# GitHub Actions CI/CD Setup for Salesforce

## Required Environment Variables (GitHub Secrets)

You need to set up the following secrets in your GitHub repository settings (Settings → Secrets and variables → Actions):

### 1. `SFDX_INTEGRATION_URL`
- **Purpose**: Authentication URL for your integration/sandbox org used for validation
- **How to get it**: 
  ```bash
  sf org login web --alias integration
  sf org display --target-org integration --verbose
  ```
  Copy the "Sfdx Auth Url" value

### 2. `SFDX_STAGING_URL` (Optional)
- **Purpose**: Authentication URL for your staging environment
- **How to get it**:
  ```bash
  sf org login web --alias staging
  sf org display --target-org staging --verbose
  ```
  Copy the "Sfdx Auth Url" value

### 3. `SFDX_PRODUCTION_URL`
- **Purpose**: Authentication URL for your production org
- **How to get it**:
  ```bash
  sf org login web --alias production
  sf org display --target-org production --verbose
  ```
  Copy the "Sfdx Auth Url" value

## Workflow Explanation

### Validation Job
- Runs on every push and pull request
- Validates metadata against integration org
- Runs Apex tests
- Performs check-only deployment

### Deploy to Staging
- Triggers only on pushes to `develop` branch
- Deploys to staging environment
- Runs tests after deployment

### Deploy to Production
- Triggers only on pushes to `master` branch
- Requires manual approval (production environment protection)
- Runs with `RunLocalTests` test level
- Runs comprehensive tests after deployment

### Destructive Changes (Optional)
- Triggers when commit message contains `[destructive]`
- Handles metadata deletions safely
- Requires `manifest/destructiveChanges.xml` file

## Setup Steps

1. **Set up GitHub Secrets**:
   - Go to your GitHub repository
   - Navigate to Settings → Secrets and variables → Actions
   - Add the three SFDX_*_URL secrets with their respective auth URLs

2. **Create Environment Protection Rules** (Recommended):
   - Go to Settings → Environments
   - Create a "production" environment
   - Add required reviewers for production deployments
   - Set up deployment protection rules

3. **Branch Strategy**:
   - `master/main`: Production deployments
   - `develop`: Staging deployments
   - Feature branches: Validation only

## Getting SFDX Auth URLs

For each org you want to deploy to:

```bash
# Login to the org
sf org login web --alias your-org-alias

# Get the auth URL
sf org display --target-org your-org-alias --verbose
```

Look for the "Sfdx Auth Url" in the output and copy that entire URL to the corresponding GitHub secret.

## Optional: Destructive Changes

If you need to delete metadata components:

1. Create `manifest/destructiveChanges.xml`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types>
        <members>ComponentToDelete</members>
        <name>CustomField</name>
    </types>
    <version>61.0</version>
</Package>
```

2. Include `[destructive]` in your commit message
3. The workflow will handle the destructive deployment

## Security Best Practices

- Never commit SFDX auth URLs or session tokens to your repository
- Use GitHub environment protection rules for production
- Regularly rotate your org authentication
- Consider using connected apps for enhanced security

## Troubleshooting

### Common Issues:
1. **Invalid SFDX Auth URL**: Re-authenticate and get a fresh URL
2. **Test Failures**: Check test coverage and fix failing tests locally first
3. **Deployment Timeout**: Increase wait times in the workflow if needed
4. **Missing Permissions**: Ensure the authenticated user has deployment permissions

### Debugging Tips:
- Check the Actions tab in GitHub for detailed logs
- Use `sf project deploy start --check-only` locally to validate before pushing
- Run `sf apex run test` locally to ensure tests pass
