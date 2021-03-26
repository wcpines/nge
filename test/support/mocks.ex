# test/support/mocks.ex

Mox.defmock(Nge.MockCSVParser, for: Nge.Parser)
Mox.defmock(Nge.MockStravaApiAdapter, for: Nge.ApiAdapter)
