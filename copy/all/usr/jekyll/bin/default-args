#!/usr/bin/env ruby
require "shellwords"

def to_bool(val)
  %w(true 1).include?(val) \
    ? "true" : nil
end

%w(VERBOSE DRAFTS FORCE_POLLING).each do |v|
  ENV[v] = to_bool(
    ENV[v]
  )
end

def build?; %w(b build).include?(ARGV[0]); end
def serve?; %w(s serve server).include?(ARGV[0]); end
def safe?; ENV["JEKYLL_DOCKER_TAG"] == "pages" || ENV["JEKYLL_DOCKER_NAME"] == "minimal"; end
def debug?; ENV["VERBOSE"]; end

ARGV.shift and ARGV.unshift("serve") if "s" == ARGV[0]
ARGV.push("--force_polling") if ENV["FORCE_POLLING"] && (build? || serve?)
ARGV.unshift(ARGV.shift, "-H", "0.0.0.0") if serve?
ARGV.push("--drafts") if ENV["DRAFTS"]
ARGV.push("--verbose") if debug?

$stdout.puts Shellwords.shelljoin(
  ARGV
)
