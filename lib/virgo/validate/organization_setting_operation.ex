defmodule AstraeaVirgo.Validate.OrganizationSettingOperation do
  use Exop.Operation

  @moduledoc """
  Validate Param for Setting Organization API
    - `POST /api/organizations`
    - `PUT /api/organizations/<organization_id>`

  Authorization: Bearer Token

  Permission: admin

  Request params: **application/json** Object

    | field       | type   | required | null | defalut | descript |
    |-------------|--------|----------|------|---------|----------|
    | id          | ID     | yes      | no   |         |          |
    | name        | string | yes      | no   |         | 名称     |
    | formal_name | string | no       | yes  | ""      | 全称     |
    | url         | URL    | no       | yes  | ""      | 官网     |
    | logo        | File   | no       | yes  |         |          |
  Note:
    保留大写两位的 ID，用于存储 [ISO 3166-1 alpha-2](https://zh.wikipedia.org/wiki/ISO_3166-1%E4%BA%8C%E4%BD%8D%E5%AD%97%E6%AF%8D%E4%BB%A3%E7%A0%81)
  """

  parameter "id", type: :string, func: &AstraeaVirgo.Validator.is_id/2
  parameter "name", type: :string, length: %{min: 1}
  parameter "formal_name", type: :string, required: false, allow_nil: true, default: ""
  parameter "url", type: :string, required: false, allow_nil: true, default: ""
  parameter "logo", type: :map, inner: %{
                      "href" => [type: :string],
                      "mime" => [type: :string, required: false, allow_nil: true]
                   }, required: false, allow_nil: true,
                   func: &AstraeaVirgo.Validator.is_file_type/2

  def process(params) do
    with true <- params["url"] === "" or AstraeaVirgo.Validator.is_url(params["url"]),
         false <- params["id"] =~ ~r/^[A-Z][A-Z]$/ do
      case AstraeaVirgo.Cache.Organization.exist?(params["id"]) do
        true -> {:ok, {:exist, params}}
        false -> {:ok, {:not_exist, params}}
      end
    else
      false -> {:error, {:validation, %{"url" => ["not valid."]}}}
      true -> {:error, {:validation, %{"id" => ["is reserved."]}}}
    end
  end

end
