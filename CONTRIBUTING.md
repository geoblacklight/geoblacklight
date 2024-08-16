# GeoBlacklight Codebase Contribution Guide
GeoBlacklight is a collaborative, open source project where contributions are :sparkles:welcome:sparkles:.

### Who can contribute?
**Anyone** is welcome to contribute to GeoBlacklight. We follow a set of contribution practices to maintain a technically sustainable and stable software project for everyone. We expect all contributors to adhere to our [Code of Conduct](https://github.com/geoblacklight/geoblacklight/blob/main/CODE_OF_CONDUCT.md).

### Join the community
See the [community page](https://geoblacklight.org/community/) on our website for information about our community calendar, slack, volunteer opportunities, and more.

If you have questions or want to get more involved, join [GeoBlacklight Slack](https://geoblacklight.slack.com/join/shared_invite/zt-1p7dcay40-Ye_WTt5_iCqU8rDjzhkoWw#/shared-invite/email) or email the [GeoBlacklight Community](https://groups.google.com/g/geoblacklight-community) at [geoblacklight-community@googlegroups.com](mailto:geoblacklight-community@googlegroups.com).

## Issues
Issues are used in the GeoBlacklight community as a convenient way to document bugs, propose new functionality and enhancements, and discuss important code changes.

### Creating an issue
Did you find a bug in GeoBlacklight? Looking to suggest a new feature? Add an issue for it in the [issue tracker](https://github.com/geoblacklight/geoblacklight/issues). 

 - Make sure you have a [GitHub account](https://github.com/signup/free)
 - Submit a new issue that:
    - Clearly describes the issue
    - Provides a descriptive summary
    - Explains the expected behavior
    - Explains the actual behavior
    - Provides steps to reproduce the actual behavior

### Assigning an issue

In the GeoBlacklight community, issue assignment helps signal who is interested in working on an issue or who can assist in moving it forward. If you find an issue you’d like to contribute to, you can assign yourself to it. If an issue is already assigned, you are still welcome to contribute or provide support. Active issues will be marked with a status of “In progress” on our Project boards.

## Contributing to the codebase
GeoBlacklight welcomes code contributions. You do *not* need to be a "GeoBlacklight Committer" to contribute code or documentation. We follow the [pull request](https://help.github.com/articles/using-pull-requests/) model for contributing on GitHub. GeoBlacklight uses a suite of tests to express its features and protect from bugs :bug:.

When proposing major new features or changes that may introduce an API or schema change, please make sure to communicate with the [community](https://geoblacklight.org/community/) so the full implications are understood. Likely there are ways to introduce these changes in a backwards compatible way that others may be able to help with.

To contribute to our website or documentation pages, see the [GeoBlacklight Website Contribution Guide](https://github.com/geoblacklight/geoblacklight.github.io/blob/main/CONTRIBUTING.md).

### Pull request overview
Given the multi-institutional nature of the project, communitiy code review is important. **We discourage individuals from merging their own requests.** We also prefer that developers from the same institutions do not merge their colleagues code.

**Contributors:**

1. If there isn't already an associated issue in the repository, create one
1. Clone or fork the geoblacklight repository
1. Create a new feature branch and publish it
1. Make changes to the files
1. Commit your changes
1. Push to the new branch
1. Open a Pull Request to the appropriate branch, like **main**, **release-4.x**, etc.
1. If you want specific others to chime in, create a +1 comment and tag them. You can tag the [GeoBlacklight Developers](#who-are-the-geoblacklight-developers) with their @username: `@geoblacklight/geoblacklight-developers`
1. Add the GeoBlacklight Developers team as a requested reviewer
1. Mention the pull request in the associated issue

**Reviewers:**

1. Review the Pull Request
1. Merge changes to the appropriate branch

### Tips for contributions
Please take the time to review the changes you made. Make sure that:
- New and changed code has comments
- The commit summary explains what has been changed
- Each commit addresses just a single concern
- If your code requires testing, you wrote a new test for it
- The GitHub Actions CI tests completed successfully

### Who are the GeoBlacklight Developers?
The [GeoBlacklight Developers](https://github.com/orgs/geoblacklight/teams/geoblacklight-developers) team consists of contributors with GitHub privileges to review and merge pull requests (PRs) for the GeoBlacklight project. This team brings together individuals with varying types of expertise, including experience in the codebase, documentation, metadata, GIS data, and web services. If you have any questions or need guidance, this team or its individual members are a great starting point. When you submit a PR, a member of this team will review it and, if appropriate, merge it into the project.
