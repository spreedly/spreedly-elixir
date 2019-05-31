use Mix.Config

if File.exists?("#{__DIR__}/test.secret.exs") do
  import_config "test.secret.exs"
else
  Mix.shell().info([:yellow, "\nExpected a config/test.secret.exs file to exist."])

  msg = """
  We use this file to specify gitignored configuration information
  used to run remote tests.
  See the top-level README.md for instructions.
  """

  Mix.shell().info([:yellow, msg])
end
