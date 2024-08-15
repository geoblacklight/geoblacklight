## Contributing
GeoBlacklight is a collaborative, open source project where contributions are :sparkles:welcome:sparkles:.

### Who can contribute?
**Anyone** is welcome to contribute to GeoBlacklight. We follow a set of contribution practices to maintain a technically sustainable and stable software project for everyone.

### Join the community
See the [community page](https://geoblacklight.org/community/) on our website for information about our community calendar, slack, volunteer opportunities, and more.

If youhave questions, email the [GeoBlacklight Community Google Group](https://groups.google.com/g/geoblacklight-community) at [geoblacklight-community@googlegroups.com](mailto:geoblacklight-community@googlegroups.com).

### Reporting issues
Did you find a bug in GeoBlacklight or interested in a new feature? Make sure to add an issue for it in the [issue tracker](https://github.com/geoblacklight/geoblacklight/issues).
Issues are used in the GeoBlacklight community as a convenient way to document bugs, propose new functionality and enhancements, and discuss important code changes.
If someone is already assigned to an issue, that does not mean you can't contribute.

 - Make sure you have a [GitHub account](https://github.com/signup/free)
 - Submit a [GitHub issue](./issues) by:
    - Clearly describing the issue
    - Provide a descriptive summary
    - Explain the expected behavior
    - Explain the actual behavior
    - Provide steps to reproduce the actual behavior

### Contributing code or documentation
GeoBlacklight welcomes code and documentation contributions. You do *not* need to be a "GeoBlacklight Committer" to contribute code or documentation. We follow the [pull request](https://help.github.com/articles/using-pull-requests/) model for contributing on GitHub. GeoBlacklight uses a suite of tests to express its features and protect from bugs:bug:.

When proposing major new features or changes that may introduce an API or schema change, please make sure to communicate with the [community](http://geoblacklight.org/connect) so the full implications are understood. Likely there are ways to introduce these changes in a backwards compatible way that others may be able to help with.

#### Pull request overview
1. If there isn't already an associated issue in the repository, create one.
1. Fork it ( http://github.com/my-github-username/geoblacklight/fork )
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create new Pull Request
1. Mention the pull request in the associated issue.

#### Merging Changes
- Please take the time to review the changes and get a sense of what is being changed. Things to consider:
  - Do the commit messages explain what is going on?
  - Do the code changes have tests? _Not all changes need new tests, some changes are refactorings_
  - Do all new methods, modules, and classes have comments? Do changed methods, modules, and classes have comments?
  - Does the commit contain more than it should? Are two separate concerns being addressed in one commit?
  - Did the GitHub Actions CI tests complete successfully?
- It is considered "poor form" to merge your own request.
  - Given the multi-institutional nature of the project, communitiy code review is important.
  - Bring the [GeoBlacklight Developers Team](https://github.com/srappel/geoblacklight/edit/main/CONTRIBUTING.md#who-are-the-github-developers-team) into the conversation by creating a comment that tags their @username: `@geoblacklight/geoblacklight-developers`.
  - If you want specific others to chime in, create a +1 comment and tag them.

### Who are the GitHub Developers Team?
[The GeoBlacklight Developers Team](https://github.com/orgs/geoblacklight/teams/geoblacklight-developers)
consists of contributors with GitHub privileges to review and merge pull requests (PRs) for the GeoBlacklight project. This team brings together individuals with varying types of expertise, including experience in the codebase, documentation, metadata, GIS data, and web services. If you have any questions or need guidance, this team or its individual members are a great starting point. When you submit a PR, a member of this team will review it and, if appropriate, merge it into the project.

### GeoBlacklight Software Versioning
GeoBlacklight follows the practice of [Semantic Versioning](https://semver.org/) for software releases. The declared semantically versioned public API includes:
 - the GeoBlacklight-Schema
 - the [public GeoBlacklight Ruby codebase classes](http://www.rubydoc.info/github/geoblacklight/geoblacklight/master/frames)
 - the GeoBlacklight JavaScript interface
 - the GeoBlacklight view interface
