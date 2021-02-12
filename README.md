# Nge

## WIP

This project did what I needed it to, but it's not ready for prime-time

Personal projects have taken a back seat recently, but I hope to eventually fold in functionality from [Road Rash](https://github.com/wcpines/road-rash) enabling imports and exports to Strava using a CSV format.

Downsides:

- no GPX (primarily designed with spreadsheet users in mind)
- Strava no longer includes descriptions in activities, requiring separate calls for detailed activity data. Workarounds TBD

--

Given a CSV, upload run-based activities to Strava

```sh
export RUNNING_LOGS=<path_to_your_csv>
```

CSV required headers:

- Date
- Name
- Distance
- Minutes
- Seconds
- is_xt
- Notes

### Known Issues

- CLI tool that requires you to have an Elixir installation / BEAM vm
- Rate limiting (600req/15min) means multiple runs
- Strava oauth means you need to open a browser
- Runs are de-duplicated based on `date` so this will not include double days
