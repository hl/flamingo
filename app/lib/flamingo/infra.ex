defmodule Flamingo.Infra do
  use Boundary, exports: [Repo, Mailer]
end
