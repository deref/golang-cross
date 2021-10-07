# deref/golang-cross

Docker image configured for cross-compiling Go programs with CGO support as
needed by [exo](https://github.com/deref/exo). May be useful for others as
well.

See [entrypoint](./bin/entrypoint) for supported operating systems and
architectures.

See [Dockerfile](./Dockerfile) for details on which MacOS SDK is used.

The cross-compilation toolchain is provided by [Zig](https://ziglang.org/).

## Usage

Based on the official [golang](https://hub.docker.com/_/golang) image, so you
use this image in much the same way. Primarily, the go is rooted at
`/go`, so you put your code into `/go/src/YOURAPP`.

Cross-compilation is driven by the `GOOS` and `GOARCH` variables.
This image inherits from the base golang image, so you mount your code into `/go/src`.

Example:

```bash
docker run \
  -e GOOS=darwin \
  -e GOARCH=amd64 \
  --mount "type=bind,source=${PWD},target=/go/src/example" \
  deref/golang-cross \
  -w /go/src/example \
  go build .
```

To speed up builds, you can also mount cached package sources by adding another
mount:

```bash
  --mount "type=bind,source=${GOPATH}/pkg/mod,target=/go/pkg/mod"
```
