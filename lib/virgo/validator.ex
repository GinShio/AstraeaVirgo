defmodule AstraeaVirgo.Validator do
  @moduledoc false

  @doc """
  Check param is email
  """
  def is_email(email) do
    case is_binary(email) do
      true ->
        email =~ ~r<^[\w!#$%&'*+\/=?^`{|}~-]+[\w.!#$%&'*+\/=?^`{|}~-]*@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$>
      _ -> false
    end
  end
  def is_email({_param_name, param_value}, _params), do: is_email(param_value)

  @doc """
  Check param is id
  id is a string, consist of [A-Za-z0-9_-], length at most 36, and not starting with '-'
  """
  def is_id(id) do
    case is_binary(id) do
      true -> id =~ ~r/^\w[\w-]{0,35}$/
      _ -> false
    end
  end
  def is_id({_param_name, param_value}, _params), do: is_id(param_value)

  @doc """
  Check param is time
  time is a string, consist of yyyy-mm-ddThh:mm:ss(.uuu)?[+-]zz(:mm)
  """
  def is_time(time) do
    case is_binary(time) do
      true ->
        time =~ ~r/^(-?(?:[1-9]\d*)?\d{4})-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12]\d)T(2[0-3]|[01]\d):([0-5]\d):([0-5]\d)(.\d{3})?(\+|-)(1[0-2]|0[1-9])(:[0-5]\d){0,1}$/
      _ -> false
    end
  end
  def is_time({_param_name, param_value}, _params), do: is_time(param_value)

  @doc """
  Check param is HEX string
  """
  def is_hex(hex) do
    case is_binary(hex) do
      true -> hex =~ ~r/^[A-Fa-f0-9]+$/
      _ -> false
    end
  end
  def is_hex({_param_name, param_value}, _params), do: is_hex(param_value)

  @doc """
  Check param is snowflake String
  """
  def is_snowflake(snowflake) do
    try do
      with id when id !== 0 <- snowflake |> String.to_integer(32),
           0 <- Bitwise.>>>(id, 63) do
        id |> Snowflake.Util.real_timestamp_of_id() < Timex.now() |> DateTime.to_unix(:millisecond)
      else
        _ -> false
      end
    rescue
      _e in ArgumentError -> false
    end
  end
  def is_snowflake({_param_name, param_value}, _params), do: is_snowflake(param_value)

  @doc """
  Check param is base64 string
  """
  def is_base64(base64) do
    case is_binary(base64) and byte_size(base64) > 0 do
      true -> base64 =~ ~r<^([A-Za-z0-9+\/]{4})*([A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{2}==){0,1}$>
      _ -> false
    end
  end
  def is_base64({_param_name, param_value}, _params), do: is_base64(param_value)

  @doc """
  Check param is URL
  """
  def is_url(url) do
    case is_binary(url) do
      true ->
        url =~ ~r<^((?:http|https):\/\/)(?:\S+(?:\S*)?@)?(?:(?:(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:\d\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\\u00a1-\\uffff0-9]+-?)*[a-z\\u00a1-\\uffff0-9]+)(?:\.(?:[a-z\\u00a1-\\uffff\d]+-?)*[a-z\\u00a1-\\uffff\d]+)*(?:\.(?:[a-z\\u00a1-\\uffff]{2,})))|localhost)(?::\d{2,5})?(?:(\/|\?|#)[^\s]*){0,1}$>
      _ -> false
    end
  end
  def is_url({_param_name, param_value}, _params), do: is_url(param_value)

  @doc """
  Check param is MIME Type
  """
  def is_mime(mime) do
    case is_binary(mime) do
      true -> mime =~ ~r<^\w+\/[-.\w]+(?:\+[-.\w]+){0,1}$>
      _ -> false
    end
  end
  def is_mime({_param_name, param_value}, _params), do: is_mime(param_value)

  @doc """
  Check param is File Type
  File Type is: %{"href" => URL / Base64, "mime" => MIME}
  """
  def is_file_type(%{"href" => href, "mime" => nil}), do: is_url(href) or is_base64(href)
  def is_file_type(%{"href" => href, "mime" => mime}), do: (is_url(href) or is_base64(href)) and is_mime(mime)
  def is_file_type(%{"href" => href}), do: is_url(href) or is_base64(href)
  def is_file_type(_), do: false
  def is_file_type({_param_name, param_value}, _params), do: is_file_type(param_value)

 end
