# test/nge/csv_generator_test.exs.exs

defmodule Nge.CSVGeneratorTest do
  use ExUnit.Case
  alias Nge.CSVGenerator

  @activities List.wrap(%Strava.SummaryActivity{
                start_latlng: [34.401293, -119.728302],
                external_id: "garmin_push_4896694605",
                commute: false,
                kilojoules: nil,
                timezone: "(GMT-08:00) America/Los_Angeles",
                athlete: %Strava.MetaAthlete{id: 13_075_000},
                comment_count: 0,
                average_watts: nil,
                flagged: false,
                photo_count: 0,
                elev_high: 54.8,
                has_kudoed: false,
                gear_id: "g5772424",
                map: %Strava.PolylineMap{
                  id: "a3414375043",
                  polyline: nil,
                  summary_polyline:
                    "e_~pExpwyU\\FvA@NL@LGh@Un@Ud@Qh@e@xBAxDK|AAj@Bl@CXBd@AxBB^?n@Av@Gf@B`AB^AdANlBZlAB^FLAl@CTa@nAW`@]P{@F}BAsCS}@?e@FEBSb@MpA[jAHbAHXD`@Kp@@\\FLRZ`@\\Rb@Xd@Pb@Hn@HpAJn@?x@Ep@Kn@BNJf@DD\\DDCj@gBv@kBv@kC~@oBHq@Ha@`Aq@\\[bAkBr@_CTg@Ji@^iAZoAfAcD\\aBFm@@GIUEAaAH_ARi@`@]Ra@p@Ob@W\\]y@Kc@CaA@eBEgB@_AAiBBm@H]AuBDgBI{DDq@NiAp@sBTeADm@?GGKGE{@M"
                },
                name: "Shakeout pre Standup ",
                trainer: false,
                weighted_average_watts: nil,
                start_date: ~U[2020-05-07 16:54:00Z],
                elev_low: 40.7,
                achievement_count: 0,
                workout_type: 0,
                max_watts: nil,
                upload_id: 3_647_345_641,
                elapsed_time: 944,
                max_speed: 4.6,
                moving_time: 938,
                kudos_count: 2,
                private: false,
                type: "Run",
                end_latlng: [34.401382, -119.728287],
                start_date_local: ~U[2020-05-07 09:54:00Z],
                distance: 3434.7,
                total_photo_count: 0,
                device_watts: nil,
                id: 3_414_375_043,
                total_elevation_gain: 13.3,
                athlete_count: 1,
                manual: false,
                average_speed: 3.662
              })

  @invalid ["something that's not a map"]

  describe "generate_csv_stream/1" do
    test 'it provides a csv file' do
      assert {:ok, list} = CSVGenerator.generate_csv_stream(@activities)
      assert is_list(list)
      assert length(list) == 2
    end

    test 'it handles bad inputs' do
      assert {:error, _err} = CSVGenerator.generate_csv_stream(@invalid)
    end
  end
end
