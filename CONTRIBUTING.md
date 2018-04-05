## Contributing
GeoBlacklight is a collaborative open source projects where contributions are :sparkles:welcome:sparkles:. This contributing guide is borrowed in part from the [Samvera Contributing Guide](https://github.com/samvera/hydra/blob/master/CONTRIBUTING.md) and the [Blacklight Contributing Wiki](https://github.com/projectblacklight/blacklight/wiki/Contributing-to-Blacklight).

### Who can contribute?
**Anyone** is welcome to contribute to GeoBlacklight. We follow a set of contribution practices to maintain a technically sustainable and stable software project for everyone.

### Reporting issues
Did you find a bug in GeoBlacklight or interested in a new feature? Make sure to add an issue for it in the [issue tracker](https://github.com/geoblacklight/geoblacklight/issues).

 - Make sure you have a [GitHub account](https://github.com/signup/free)
 - Submit a [GitHub issue](./issues) by:
    - Clearly describing the issue
    - Provide a descriptive summary
    - Explain the expected behavior
    - Explain the actual behavior
    - Provide steps to reproduce the actual behavior

### GeoBlacklight Software Versioning
GeoBlacklight follows the practice of [Semantic Versioning](https://semver.org/) for software releases. The declared semantically versioned public API includes:
 - the GeoBlacklight-Schema
 - the [public GeoBlacklight Ruby codebase classes](http://www.rubydoc.info/github/geoblacklight/geoblacklight/master/frames)
 - the GeoBlacklight JavaScript interface
 - the GeoBlacklight view interface

### Contributing code or documentation
GeoBlacklight welcomes code and documentation contributions. You do *not* need to be a "GeoBlacklight Committer" to contribute code or documentation. We follow the [pull request](https://help.github.com/articles/using-pull-requests/) model for contributing on GitHub. GeoBlacklight uses a suite of tests to express its features and protect from bugs:bug:.

When proposing major new features or changes that may introduce an API or schema change, please make sure to communicate with the [community](http://geoblacklight.org/connect) so the full implications are understood. Likely there are ways to introduce these changes in a backwards compatible way that others may be able to help with.

#### Pull request overview
1. Fork it ( http://github.com/my-github-username/geoblacklight/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

#### Merging Changes

- It is considered "poor form" to merge your own request.
- Please take the time to review the changes and get a sense of what is being changed. Things to consider:
  - Does the commit message explain what is going on?
  - Does the code changes have tests? _Not all changes need new tests, some changes are refactorings_
  - Do all new methods, modules, and classes have comments? Do changed methods, modules, and classes have comments?
  - Does the commit contain more than it should? Are two separate concerns being addressed in one commit?
  - Did the Travis tests complete successfully?
- If you are uncertain, bring other contributors into the conversation by creating a comment that includes their @username.
- If you like the pull request, but want others to chime in, create a +1 comment and tag a user.

If you wish to ask questions or participate further, email the [GeoBlacklight Working Group](https://groups.google.com/forum/#!forum/geoblacklight-working-group) at [geoblacklight-working-group@googlegroups.com](mailto:geoblacklight-working-group@googlegroups.com).
