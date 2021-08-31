defmodule AstraeaVirgo.Token.SecretFetcher do
  use Guardian.Token.Jwt.SecretFetcher

  @moduledoc false

  def fetch_signing_secret(mod, opts) do
    case Keyword.get(opts, :secret) do
      nil -> {:ok, apply(mod, :config, [:secret_key])}
      password when is_binary(password) -> {:ok, password <> apply(mod, :config, [:secret_key])}
      _ -> {:error, :secret_not_found}
    end
  end

  def fetch_verifying_secret(mod, _token_header, opts) do
    case Keyword.get(opts, :secret) do
      nil -> {:ok, apply(mod, :config, [:secret_key])}
      password when is_binary(password) -> {:ok, password <> apply(mod, :config, [:secret_key])}
      _ -> {:error, :secret_not_found}
    end
  end

end
