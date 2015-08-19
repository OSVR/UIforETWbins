# UIforETW Binaries

This repository exists solely as a convenient way to re-use [UIforETW][] in Git repos that might be built without Visual Studio or a Windows SDK from Microsoft, as well as simplifying use even from Visual Studio.

With the exception of the text files in this root directory, all contents of the repo tree are extracted from a [UIforETW etwpackage.zip release](https://github.com/google/UIforETW/releases). This README will be the only file other than the upstream files touched when committing a new release.

## License
UIforETW itself and its components (including ETWProviders.dll) are provided under the Apache Software License, version 2.0 - see `LICENSE` in this directory. The binaries do bundle redistributable installers under other licenses, see the `third_party` directory for details.

[UIforETW]: https://github.com/google/UIforETW