# Nge

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

## WIP

This project did what I needed it to, but it's not ready for prime-time

### Known Issues

- CLI tool that requires you to have an Elixir installation / BEAM vm 
- Rate limiting (600req/15min) means multiple runs
- Strava oauth means you need to open a browser
- Runs are de-duplicated based on `date` so this will not include double days
