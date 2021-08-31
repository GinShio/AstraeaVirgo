defmodule AstraeaVirgoWeb.SubmissionView do
  use AstraeaVirgoWeb, :view

  @moduledoc """
  Response for Submission API
  """

  @doc """
  Response

  ## index.json
  Response for index Contest API: `GET /api/submissions`

  Response: list of Object

    | field     | type | required | descript                |
    |-----------|------|----------|-------------------------|
    | id        | ID   | yes      | 当前提交的 ID           |
    | language  | ID   | yes      | 提交所使用的编程语言 ID |
    | problem   | ID   | yes      | 提交的题目的 ID         |
    | submitter | ID   | yes      | 提交者的 ID             |
    | time      | Time | yes      | 提交的时间              |
    | judgement | ID   | yes      | 提交的判题结果          |

  Note: The final results will be arranged in increasing order of time

  Example:
  ```json
  [
      {
          "id": "a61d1e78-5d62-4aa6-a1e9-f756174eec26",
          "language": "c",
          "problem": "1000",
          "submitter": "IQHV2FVS00",
          "time": "2014-06-25T11:00:00+01",
          "judgement": "AC"
      },
      {
          "id": "ec1cd4e4-7e85-47f6-8d61-1297d5415c66",
          "language": "cpp",
          "problem": "1002",
          "submitter": "IQHV2FVS00",
          "time": "2014-06-25T12:00:00+01",
          "judgement": "WA"
      }
  ]
  ```

  ## show.json
  Response for show Contest API: `GET /api/submissions/<submission_id>`

  Response: Object

    | field     | type | required | descript                |
    |-----------|------|----------|-------------------------|
    | id        | ID   | yes      | 当前提交的 ID           |
    | language  | ID   | yes      | 提交所使用的编程语言 ID |
    | problem   | ID   | yes      | 提交的题目的 ID         |
    | submitter | ID   | yes      | 提交者的 ID             |
    | time      | Time | yes      | 提交的时间              |
    | judgement | ID   | yes      | 提交的判题结果          |

  Example:
  ```json
  {
      "id": "a61d1e78-5d62-4aa6-a1e9-f756174eec26",
      "language": "c",
      "problem": "1000",
      "submitter": "IQHV2FVS00",
      "time": "2014-06-25T11:00:00+01",
      "judgement": "AC"
  }
  ```

  ## detail.json
  Reponse for show Submission Detail API
    - `GET /api/submissions/<submission_id>/detail`

  Response: Object

    | field     | type   | required | null | descript           |
    |-----------|--------|----------|------|--------------------|
    | id        | ID     | yes      | no   | 当前提交的 ID      |
    | submitter | ID     | yes      | no   | 提交者的 ID        |
    | judgement | ID     | yes      | no   | 提交的判题结果     |
    | code      | Base64 | yes      | no   | 提交的代码         |
    | message   | string | no       | yes  | 判题机所返回的消息 |

  Example:
  ```json
  {
      "id": "a61d1e78-5d62-4aa6-a1e9-f756174eec26",
      "submitter": "IQHV2FVS00",
      "judgement": "AC",
      "code": "I2luY2x1ZGUgPHN0ZGlvLmg+CmludCBtYWluKHZvaWQpIHsKICBwcmludGYoIkhlbGxvIFdvcmxkISIpOwp9"
  }
  ```

  ## create.json
  Reponse for create Submission API
    - `POST /api/submissions`

  Response: Object

    | field         | type | required | null | descript  |
    |---------------|------|----------|------|-----------|
    | submission_id | ID   | yes      | no   | 提交的 ID |
  """
  def render("index.json", assigns), do: assigns.data
  def render("show.json", assigns), do: assigns.data
  def render("detail.json", assigns), do: assigns.data
  def render("create.json", assigns) do
    %{
      submission_id: assigns.submission_id
    }
  end

end
