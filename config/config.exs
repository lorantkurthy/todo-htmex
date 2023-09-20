import Config

config :logger, :console,
  metadata: [:mfa],
  format: "$time [$level] [$metadata] $message\n",
  truncate: :infinity,
  level: :debug
