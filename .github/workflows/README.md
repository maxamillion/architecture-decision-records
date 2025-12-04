# GitHub Actions Workflows

This directory contains automated workflows for validating and maintaining the architecture decision records repository.

## Workflows

### Validate Mermaid Diagrams (`validate-mermaid.yml`)

Automatically validates all Mermaid diagrams to ensure they render correctly on GitHub.

#### Triggers

- **Pull Requests**: Runs on any PR that modifies files in `mermaid-diagrams/` directory
- **Push to main/master**: Validates diagrams on merge to main branch
- **Manual**: Can be triggered manually via workflow_dispatch

#### What It Does

1. **Syntax Validation**: Uses `@mermaid-js/mermaid-cli` to validate Mermaid syntax
2. **Common Error Detection**: Checks for common issues:
   - `<br/>` tags in edge labels
   - Unquoted parentheses in edge labels
   - Unquoted special characters (colons, slashes)
3. **Rendering Test**: Attempts to render each diagram to ensure it works
4. **Reporting**: Generates detailed validation report
5. **PR Comments**: Automatically comments on PRs with validation results

#### Validation Rules

The workflow enforces GitHub's Mermaid rendering constraints:

##### ✅ Allowed in Edge Labels
- Simple text: `|mTLS|`, `|Watches|`
- Quoted strings: `|"text with (special) chars"|`
- Alphanumeric with quotes: `|"Creates/Manages"|`

##### ❌ Not Allowed in Edge Labels
- `<br/>` tags (use only in node labels)
- Unquoted parentheses: `|text (A)|`
- Unquoted special characters: `|text: value|`, `|path/to/resource|`

#### Artifacts

The workflow produces the following artifacts:

- **mermaid-validation-report.md**: Detailed validation report with pass/fail status
- **mermaid-validation-errors.log**: Detailed error messages for failed validations

Artifacts are retained for 30 days.

#### Exit Codes

- `0`: All diagrams validated successfully
- `1`: One or more diagrams failed validation

#### Local Testing

You can run the validation locally before pushing:

```bash
# Install dependencies
cd .github
npm install

# Run validation
cd ..
./scripts/validate-mermaid.sh
```

#### Fixing Validation Errors

Common fixes for validation errors:

1. **Edge labels with parentheses**:
   ```diff
   - A -->|https (B)| C
   + A -->|"https (B)"| C
   ```

2. **Edge labels with `<br/>` tags**:
   ```diff
   - A -->|Line 1<br/>Line 2| B
   + A -->|"Line 1 Line 2"| B
   ```
   Note: `<br/>` is allowed in node labels: `Node["Line 1<br/>Line 2"]`

3. **Edge labels with special characters**:
   ```diff
   - A -->|Creates/Manages| B
   + A -->|"Creates/Manages"| B
   ```

#### Resources

- [Mermaid Documentation](https://mermaid.js.org/)
- [GitHub Mermaid Support](https://github.blog/2022-02-14-include-diagrams-markdown-files-mermaid/)
- [Mermaid Live Editor](https://mermaid.live/) - Test diagrams interactively

## Workflow Maintenance

### Updating Dependencies

To update the Mermaid CLI version:

1. Edit `.github/package.json`
2. Update version in `dependencies` section
3. Commit changes
4. Workflow will use new version on next run

### Modifying Validation Rules

To modify validation rules:

1. Edit `scripts/validate-mermaid.sh`
2. Update the `check_common_errors()` function
3. Test locally before committing
4. Update this documentation

### Caching

The workflow caches npm dependencies to speed up subsequent runs. The cache is keyed by the workflow file hash, so it automatically invalidates when the workflow changes.

## Troubleshooting

### Workflow Fails on Valid Diagrams

If a diagram is valid but the workflow fails:

1. Check the error log artifact
2. Test locally with `./scripts/validate-mermaid.sh`
3. Verify mermaid-cli version compatibility
4. Test in [Mermaid Live Editor](https://mermaid.live/)

### Permission Issues

If the workflow can't comment on PRs:

1. Verify the repository has Actions enabled
2. Check that `GITHUB_TOKEN` has appropriate permissions
3. Ensure PR isn't from a fork (forks have restricted permissions)

### Cache Issues

If caching causes problems:

1. Clear the cache manually in GitHub repository settings
2. Update the cache key in the workflow file
3. Disable caching by removing the `cache` step

## Contributing

When adding new validation rules:

1. Document the rule in this README
2. Add examples to the validation script
3. Test against existing diagrams
4. Update VALIDATION.md in mermaid-diagrams directory
