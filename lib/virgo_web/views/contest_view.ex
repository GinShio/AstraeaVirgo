defmodule AstraeaVirgoWeb.ContestView do
  use AstraeaVirgoWeb, :view

  @moduledoc """
  Response for Contest API
  """

  @doc """
  Response

  ## index.json
  Response for index Contest API: `GET /api/contests`

  Response: list of Object (unsorted)

    | field                      | type    | required | null | descript                                   |
    |----------------------------|---------|----------|------|--------------------------------------------|
    | id                         | ID      | yes      | no   | 当前比赛的ID                               |
    | name                       | string  | yes      | no   | 当前比赛的名称                             |
    | formal_name                | string  | no       | no   | 当前比赛的全称                             |
    | public                     | boolean | no       | yes  | 当前比赛是否公开                           |
    | anonymous                  | boolean | no       | yes  | 当前比赛是否匿名                           |
    | start_time                 | Time    | yes      | yes  | 比赛的预定开始时间                         |
    | duration                   | RelTime | yes      | no   | 比赛时长                                   |
    | scoreboard_freeze_duration | RelTime | no       | yes  | 封榜距比赛结束的时间, 0 或 null 表示不封榜 |
    | penalty_time               | integer | no       | no   | 错误提交的处罚时间 (单位: 分钟)            |
    | logo                       | Image   | no       | yes  | 当前比赛的 logo                            |

  Example:
  ```json
  [
      {
          "id": "wf14",
          "name": "2014 ICPC World Finals",
          "start_time": "2014-06-25T10:00:00+01",
          "duration": 18000000,
          "scoreboard_freeze_duration": 3600000,
          "penalty_time": 20
      },
      {
          "id": "wf15",
          "name": "2015 ICPC World Finals",
          "start_time": "2015-06-25T10:00:00+01",
          "duration": 18000000,
          "scoreboard_freeze_duration": 3600000,
          "penalty_time": 20,
          "logo": null
      }
  ]
  ```

  ## show.json
  Response for show Contest API: `GET /api/contests/<contest_id>`

  Response: Object

    | field                      | type    | required | null | descript                                   |
    |----------------------------|---------|----------|------|--------------------------------------------|
    | id                         | ID      | yes      | no   | 当前比赛的ID                               |
    | name                       | string  | yes      | no   | 当前比赛的名称                             |
    | formal_name                | string  | no       | no   | 当前比赛的全称                             |
    | public                     | boolean | no       | yes  | 当前比赛是否公开                           |
    | start_time                 | Time    | yes      | yes  | 比赛的预定开始时间                         |
    | duration                   | RelTime | yes      | no   | 比赛时长                                   |
    | scoreboard_freeze_duration | RelTime | no       | yes  | 封榜距比赛结束的时间, 0 或 null 表示不封榜 |
    | penalty_time               | integer | no       | no   | 错误提交的处罚时间 (单位: 分钟)            |
    | logo                       | Image   | no       | yes  | 当前比赛的 logo                            |

  Example:
  ```json
  {
      "id": "wf14",
      "name": "2014 ICPC World Finals",
      "start_time": "2014-06-25T10:00:00+01",
      "duration": 18000000,
      "scoreboard_freeze_duration": 3600000,
      "penalty_time": 20
  }
  ```

  ## create.json
  Response for create Contest API: `POST /api/contests`

  Response: Object

    | field      | type | required | null | descript      |
    |------------|------|----------|------|---------------|
    | contest_id | ID   | yes      | no   | 当前比赛的 ID |

  Example:
  ```json
  {"contest_id": "9fceb61e-1a22-46ba-8776-44fc4a7e4efe"}
  ```
  """
  def render("index.json", assigns), do: assigns.data
  def render("show.json", assigns), do: assigns.data
  def render("create.json", assigns) do
    %{contest_id: assigns[:contest_id]}
  end

end
