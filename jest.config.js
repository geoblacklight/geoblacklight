const util = require('util');
const exec = util.promisify(require('child_process').exec);

module.exports = async () => {
  console.log('Getting asset pipeline lookup path from Rails');
  const { stdout, stderr } = await exec('bundle exec rake geoblacklight:asset_paths');
  if (stderr) {
    console.error(stderr);
  }
  const paths = stdout.trim().split('\n');
  return {
    moduleDirectories: [
      'node_modules',
      'spec/javascripts',
      ...paths,
    ],
    rootDir: './',
    setupFilesAfterEnv: [
      '<rootDir>/setupJest.js',
    ],
    testMatch: [
      '<rootDir>/spec/javascripts/**/*_spec.js',
    ],
  };
};
