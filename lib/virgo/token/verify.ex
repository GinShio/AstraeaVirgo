defmodule AstraeaVirgo.Token.Verify do

  @moduledoc false

  @audience "Astraea OnlineJudge Project"

  use Guardian.Token.Verify

  def verify_claim(mod, "iss", %{"iss" => iss} = claims, _opts) do
    case apply(mod, :config, [:issuer]) == iss do
      true -> {:ok, claims}
      _ -> {:error, :invalid_issuer}
    end
  end

  def verify_claim(_mod, "nbf", %{"nbf" => nil} = claims, _opts), do: {:error, :token_not_yet_valid}
  def verify_claim(mod, "nbf", %{"nbf" => nbf} = claims, _opts) do
    case Guardian.Token.Verify.time_within_drift?(mod, nbf) || nbf <= Guardian.timestamp() do
      true -> {:ok, claims}
      _ -> {:error, :token_not_yet_valid}
    end
  end

  def verify_claim(_mod, "exp", %{"exp" => nil} = claims, _opts), do: {:error, :token_not_yet_valid}
  def verify_claim(mod, "exp", %{"exp" => exp} = claims, _opts) do
    case Guardian.Token.Verify.time_within_drift?(mod, exp) || exp >= Guardian.timestamp() do
      true -> {:ok, claims}
      _ -> {:error, :token_expired}
    end
  end

  def verify_claim(_mod, "aud", claims, _opts) do
    if claims["aud"] === @audience do
      {:ok, claims}
    else
      {:error, :invalid_audience}
    end
  end

  def verify_claim(_mod, "sub", claims, _opts) do
    with sub when is_binary(sub) <- claims["sub"],
         true <- AstraeaVirgo.Validator.is_snowflake(sub) do
      {:ok, claims}
    else
      _ -> {:error, :invalid_sub}
    end
  end

  def verify_claim(
    _mod, _claim_key,
    %{"iss" => _, "nbf" => _, "exp" => _, "aud" => _, "sub" => _} = claims,
    _opts), do: {:ok, claims}
  def verify_claim(_mod, _claims_key, _claims, _opts), do: {:error, :token_not_yet_valid}

 end
