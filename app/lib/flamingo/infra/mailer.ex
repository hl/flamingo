defmodule Flamingo.Infra.Mailer do
  use Swoosh.Mailer, otp_app: :flamingo
  use Boundary
end
