# frozen_string_literal: true

# Helpers for interacting with Solr via docker compose

require "open3"

# Run in a thread with error handling, so we can ensure Solr gets stopped on failure
def system_with_error_handling(*args)
  Open3.popen3(*args) do |_stdin, stdout, stderr, thread|
    puts stdout.read
    raise "Unable to run #{args.inspect}: #{stderr.read}" unless thread.value.success?
  end
end

# Downstream applications can create their own compose.yml which will shadow
# ours; in that case they can change the name of the solr service and set it here.
def solr_service
  ENV.fetch("SOLR_SERVICE", "solr")
end

def wait_for_solr
  script = File.expand_path("../../script/wait-for-solr", __dir__)
  # Not system_with_error_handling: that buffers stdout until the process exits, so the
  # progress lines would only appear once the wait was already over.
  raise "Unable to run #{script}" unless system(script)
end

# Replacement for solr_wrapper.
def with_solr(&block)
  puts "Starting Solr"
  system_with_error_handling "docker compose up -d #{solr_service}"
  wait_for_solr
  yield
ensure
  puts "Stopping Solr"
  system_with_error_handling "docker compose stop #{solr_service}"
end
