# test/nge/log_filter_test.exs
defmodule Nge.ActivityLogFilterTest do
  alias Nge.ActivityLogFilter
  use ExUnit.Case

  @strava_sample [
    %Strava.SummaryActivity{
      type: "Run",
      name: "Recovery jog",
      elapsed_time: 1479,
      average_speed: 3.387,
      start_date_local: ~U[2020-01-13 18:39:11Z],
      moving_time: 1476,
      distance: 4999.5
    },
    %Strava.SummaryActivity{
      type: "Run",
      name: "Afternoon Run",
      elapsed_time: 982,
      average_speed: 3.446,
      start_date_local: ~U[2018-07-19 13:19:08Z],
      moving_time: 873,
      distance: 3008.1
    }
  ]

  @dupe_record_logs [
    %{
      datetime: ~N[2011-10-18 12:00:00.0000],
      description: "Just jogged around the field for a bit",
      distance: 4425.7,
      moving_time: 1.2e3,
      name: "First run back in 6+ weeks",
      type: "Run"
    },
    %{
      type: "Run",
      name: "Afternoon Run",
      datetime: ~N[2018-07-19 12:00:00.0000],
      description: "Description",
      distance: 3008.1,
      moving_time: 873
    }
  ]

  describe "ActivityLogFilter.new_activities_by_date/2" do
    test "it returns a list of new-by-date runs" do
      new = ActivityLogFilter.new_activities_by_date(@strava_sample, @dupe_record_logs)
      assert length(new) == 1
    end
  end

  describe "ActivityLogFilter.filterable_dates/2" do
    test "it returns a list of naive datetimes" do
      assert ActivityLogFilter.filterable_dates(@strava_sample) == [~D[2020-01-13], ~D[2018-07-19]]
    end
  end
end
