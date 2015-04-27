# SST &mdash; Semaphore Status

This package contains the source code of SST, a command line utility 
for [SemaphoreCI](https://semaphoreci.com/).

SST started as a [Ruby gem](https://github.com/renderedtext/semaphore-status),
but the need to produce a native binary executable led to a new forked version
written in Haskell.

**Note**: The haskell version of SST is still unstable.

## Usage

``` sh
$ sst <api_token>
base_app
  - master
  - development
  - is/testing

sst
  - master
  - staging
  - is/haskell
```

## Licence

Semaphore Status is released under the [MIT Licence](http://opensource.org/licenses/MIT).
