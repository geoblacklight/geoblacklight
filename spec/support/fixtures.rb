def read_fixture(fname)
  File.read(File.join(fixture_dir, fname))
end

def fixture_dir
  @fixture_dir ||= File.join(File.dirname(__FILE__), '../fixtures')
end
