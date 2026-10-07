# Requirements

Everything runs inside containers, so **none of the nine languages is installed on the host**.
The list below is the complete set of host prerequisites.

## Host

| Tool | Minimum |
| --- | --- |
| Docker Engine | 20.10 |
| Docker Compose v2 | **2.24** |
| git | any |

Compose **2.24** is a hard floor, not a preference: `docker-compose.yml` marks the env file as
optional (`env_file: [{path: .env, required: false}]`) and the `required:` key was introduced in
that release. On anything older the file fails to parse.

Nothing else. No language runtime, no package manager, no `make`.

## Disk

About **12 GB** of images once all nine services have been pulled or built, plus whatever the
dependency caches grow to. Layers are shared between the base and the built images, so the figure
on disk comes out lower than the sum of the rows.

| Service | Image | Size |
| --- | --- | --- |
| dotnet | `mcr.microsoft.com/dotnet/sdk:8.0` | 1.29 GB |
| elixir | `elixir:1.18-otp-27` | 2.38 GB |
| go | `golang:1.24` | 1.33 GB |
| java | `maven:3.9-eclipse-temurin-21` | 847 MB |
| node | `node:22` | 1.63 GB |
| php | `sdk-tests-infra/php:8.3` (built) | 799 MB |
| python | `python:3.12` | 1.62 GB |
| ruby | `ruby:3.3` | 1.61 GB |
| clojure | `clojure:temurin-21-lein` | 735 MB |

Sizes were measured on the sibling `automation-sdk-bank` project, which uses the same images.

The PHP image is built locally because `php:8.3-cli` ships without Composer, `gmp`, `zip` and
`bcmath` (see `docker/php.Dockerfile`). The other eight run the official image as is.

## Docker Hub

Anonymous pulls are rate-limited, and pulling nine base images reaches the cap quickly.
Authenticate once:

```bash
docker login
```

## Credentials

The test suites read sandbox credentials from the environment. Copy the template and fill it in:

```bash
cp .env.example .env
```

`.env` is git-ignored and is loaded into every container. It is optional at the Compose level, so
the containers still start without it — only the suites that sign requests will fail.

**Never commit `.env`, a `.pem`, or a private key in any form.**

## The SDKs themselves

They are not versioned in this repository. Clone each one into the directory its service mounts:

```bash
git clone git@github.com:starkinfra/sdk-python.git sdk/python
git clone git@github.com:starkinfra/sdk-go.git     sdk/go
```

`sdk/*` is git-ignored precisely because each SDK is its own git repository.
