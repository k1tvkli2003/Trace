# Package dependency direction

`trace_domain`: plain Dart contracts, no Flutter/network/DB imports.
`trace_data`: local/remote repositories, depends on domain.
`trace_design`: Flutter semantic presentation, depends on domain.
`trace_flutter`: app composition; depends on all packages.
No package here has a production feature yet; generated sample code will be replaced test-first in Stage 3.
