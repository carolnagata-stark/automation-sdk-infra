# automation-sdk-infra

Test environment for the Stark Infra SDKs in nine languages: Python, Node, Go, Java, PHP, Ruby,
Clojure, Elixir and .NET. This repository does not contain SDK code. It provides the containers
that run each SDK's own test suite against the sandbox, and a minimal client example per language.

## Layout

| Path | Purpose |
| --- | --- |
| `docker-compose.yml` | One service per language, each mounting `sdk/<language>` as `/workspace`. |
| `docker/php.Dockerfile` | PHP image with Composer, `gmp`, `zip` and `bcmath`. |
| `sdk/<language>/` | Where each SDK is cloned. Git-ignored, each SDK is its own repository. |
| `examples/<language>/` | Minimal client integration, installing the published package. |
| `.env.example` | Template for the sandbox credentials. |

## Setup

Host prerequisites and disk usage are in [REQUIREMENTS.md](REQUIREMENTS.md).

```bash
cp .env.example .env        # fill in the SANDBOX_* variables
```

Then clone each SDK into its directory, as described under "SDK status". The private keys in `.env`
carry the PEM text itself, not a path, so quote the value.

## SDK status

| Language | Repository | Branch | Cloned |
| --- | --- | --- | --- |
| python | `starkinfra/sdk-python` | `master` | yes |
| node | `starkinfra/sdk-node` | `master` | yes |
| go | `starkinfra/sdk-go` | `master` | yes |
| java | `starkinfra/sdk-java` | `master` | yes |
| php | `starkinfra/sdk-php` | `master` | yes |
| ruby | `starkinfra/sdk-ruby` | `master` | yes |
| clojure | `starkinfra/sdk-clojure` | `master` | yes, patched |
| elixir | `starkinfra/sdk-elixir` | `master` | yes |
| dotnet | `starkinfra/sdk-dotnet` | `master` | yes |

The default branch is `master`, unlike the bank project's `development`. Clone each SDK into its
directory:

```bash
git clone https://github.com/starkinfra/sdk-node.git sdk/node
```

`sdk/*/` is git-ignored as a whole, so the outer repository never records a clone as an embedded
repository.

## Running an SDK's tests

Run every command from the repository root. Each `run --rm` starts a fresh container, so install
and test go in the same command.

```bash
docker compose run --rm python sh -c "pip install -q -r requirements.txt && python -m unittest tests.sdk.testIssuingBalance"
docker compose run --rm node sh -c "npm install --silent && npx mocha tests/testIssuingBalance.js --timeout 20000"
docker compose run --rm go go test ./tests/sdk -run TestIssuingBalanceQuery -v
docker compose run --rm java mvn test -Dtest=TestIssuingBalance
docker compose run --rm elixir sh -c "mix local.hex --force && mix local.rebar --force && mix deps.get && mix test test/issuing_balance_test.exs"
docker compose run --rm dotnet dotnet test StarkInfra/StarkInfraTests --filter FullyQualifiedName~IssuingBalanceTest
docker compose run --rm clojure lein test :only starkinfra.issuing-balance-test
```

Ruby needs a workaround because `rubocop` pulls a gem that does not compile on Ruby 3.3, and
`minitest` is a development dependency too:

```bash
docker compose run --rm -e BUNDLE_WITHOUT=development ruby sh -c "bundle install -q && gem install minitest -v 5.14.4 --no-document -q && ruby -Itest -Ilib test/starkinfra/test_issuingbalance.rb"
```

The PHP runner has no per-test filter, so one test goes through a stdin bootstrap:

```bash
echo '<?php require "vendor/autoload.php"; \StarkInfra\Settings::setUser(new \StarkInfra\Project(["environment" => "sandbox", "id" => $_SERVER["SANDBOX_INFRA_ID"], "privateKey" => $_SERVER["SANDBOX_INFRA_PRIVATE_KEY"]])); include "tests/issuingBalance.php";' | docker compose run --rm -T php sh -c "composer install -q && php"
```

Package caches live in named volumes, so dependencies download once.

## Test results

| Test | python | node | go | java | php | ruby | clojure | elixir | dotnet |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| IssuingBalance | pass | pass | pass | pass | pass | pass | pass | pass | pass |

## Examples

`examples/<language>/` holds the client view: how an integrator uses the SDK in their own project,
installing the published package at a pinned version. Each one fetches the issuing balance.

| Language | File | Package | Status |
| --- | --- | --- | --- |
| python | `issuing_balance.py` | `starkinfra==0.28.0` | verified |
| node | `issuing_balance.js` | `starkinfra ^0.20.0` | verified |
| go | `issuing_balance.go` | `sdk-go v1.2.0` | verified |
| java | `IssuingBalanceExample.java` | `com.starkinfra:sdk:0.22.0` | verified |
| php | `issuing_balance.php` | `starkinfra/sdk ^0.17.0` | verified |
| ruby | `issuing_balance.rb` | `starkinfra ~> 0.6.0` | verified |
| elixir | `issuing_balance.exs` | `starkinfra ~> 0.1.0` | verified |
| dotnet | `IssuingBalance.cs` | `StarkInfra 0.13.0` | verified |
| clojure | `src/issuing_balance/core.clj` | `starkinfra/sdk 0.1.0`, installed locally | verified |

Run from the repository root. Examples that write lockfiles run from a copy:

```bash
docker compose run --rm -v "$PWD/examples/python:/example" -w /example python sh -c "pip install -r requirements.txt && python issuing_balance.py"
docker compose run --rm -v "$PWD/examples/node:/example:ro" node sh -c "cp -r /example /tmp/ex && cd /tmp/ex && npm install --silent && npm start"
docker compose run --rm -v "$PWD/examples/go:/example:ro" go sh -c "cp -r /example /tmp/ex && cd /tmp/ex && go mod tidy && go run issuing_balance.go"
docker compose run --rm -v "$PWD/examples/java:/example" -w /example java mvn -q compile exec:java
docker compose run --rm -v "$PWD/examples/php:/example:ro" php sh -c "cp -r /example /tmp/ex && cd /tmp/ex && composer install -q && php issuing_balance.php"
docker compose run --rm -v "$PWD/examples/ruby:/example:ro" ruby sh -c "cp -r /example /tmp/ex && cd /tmp/ex && bundle install --quiet && bundle exec ruby issuing_balance.rb"
docker compose run --rm -v "$PWD/examples/elixir:/example:ro" elixir sh -c "cp -r /example /tmp/ex && cd /tmp/ex && mix local.hex --force >/dev/null && mix local.rebar --force >/dev/null && elixir issuing_balance.exs"
docker compose run --rm -v "$PWD/examples/dotnet:/example" -w /example dotnet dotnet run
docker compose run --rm -v "$PWD/examples/clojure:/example:ro" clojure sh -c "cp -r /example /tmp/ex && cd /tmp/ex && lein run"
```

The Clojure SDK is not on Clojars, although its README says `[starkinfra/sdk "0.1.0"]`. Install it
once into the shared Maven volume, then the example resolves it like a published package:

```bash
docker compose run --rm -e LEIN_SNAPSHOTS_IN_RELEASE=true clojure lein install
```

`LEIN_SNAPSHOTS_IN_RELEASE` is needed because the release depends on a SNAPSHOT of `core-clojure`.
The volume survives between runs, so this is a one-time step until it is removed.

`go mod tidy` is needed because the example also imports `starkinfra/core-go`, which `go.mod` does
not list. All examples read `SANDBOX_INFRA_ID` and `SANDBOX_INFRA_PRIVATE_KEY` from `.env`.

The published packages lag the cloned SDKs in places (PHP 0.17.0, .NET 0.13.0, Go v1.2.0), so an
example proves the published version, not the cloned one.

## Credentials

Unlike the bank project, the infra suites need several credentials. `.env.example` lists them all:

| Variable | Used by |
| --- | --- |
| `SANDBOX_INFRA_ID`, `SANDBOX_INFRA_PRIVATE_KEY` | the `Project` user in every SDK |
| `SANDBOX_ORGANIZATION_ID`, `SANDBOX_ORGANIZATION_PRIVATE_KEY` | the `Organization` user |
| `SANDBOX_BANK_CODE` | Pix tests that build an end-to-end id |
| `SANDBOX_TEMPLATE_ID` | the credit note test |
| `SANDBOX_SIGNED_CREDIT_NOTE_ID` | two python tests |

The SDKs do not agree on the variable names, so `docker-compose.yml` maps `SANDBOX_INFRA_*` to what
each one reads:

| Service | Reads |
| --- | --- |
| python, php, clojure | `SANDBOX_INFRA_ID`, `SANDBOX_INFRA_PRIVATE_KEY` |
| node, java, ruby, dotnet, elixir | `SANDBOX_ID`, `SANDBOX_PRIVATE_KEY` |
| go | `PROJECT_ID`, `PRIVATE_KEY`, `ORGANIZATION_ID` |

`tests/utils/user.py` reads its variables at import time, so a missing one fails every Python test
with a `KeyError`. An empty value is enough to import: `SANDBOX_TEMPLATE_ID` and
`SANDBOX_SIGNED_CREDIT_NOTE_ID` were empty when the issuing balance tests passed. Which tests need
real values for them is recorded here as the suites run.

## Local patches

- **clojure:** `project.clj` asks for `com.starkinfra:starkcore 0.2.0`, which is not published.
  `sdk/clojure/project.clj` was changed to `[org.clojars.stark-mtkgs/core-clojure "0.1.14-SNAPSHOT"]`,
  the namespace the code requires. Re-apply it after a fresh clone.
- **ruby:** no patch, the workaround is the command above.

## TODO

- Clojure: ask the SDK team to publish `starkinfra/sdk` and a release of `core-clojure`. Today the
  only `core-clojure` on Clojars is a SNAPSHOT under a personal group, `org.clojars.stark-mtkgs`.
- Add the next test to every SDK, then record it in "Test results".
