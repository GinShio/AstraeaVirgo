defmodule AstraeaVirgo.Cache.Utils.Parse do

  @moduledoc false

  def formal_name(object, value) do
    case value do
      nil -> object
      "" -> object
      _ -> object |> Map.put(:formal_name, value)
    end
  end

  def url(object, value) do
    case value do
      nil -> object
      "" -> object
      _ -> object |> Map.put(:url, value)
    end
  end

  def message(object, value) do
    case value do
      nil -> object
      "" -> object
      _ -> object |> Map.put(:message, value)
    end
  end

  def file(object, key, value) do
    with _value when is_binary(value) <- value,
         %{"href" => href, "mime" => nil} <- value |> Jason.decode!() do
      object |> Map.put(key, %{"href" => href})
    else
      nil -> object
      file -> object |> Map.put(key, file)
    end
  end

  def contest(object, value) do
    case value do
      nil -> object
      _ -> object |> Map.put(:contest, value)
    end
  end

end
