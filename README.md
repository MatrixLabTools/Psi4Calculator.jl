# Psi4Calculator

[![Build Status](https://github.com/MatrixLabTools/Psi4Calculator.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/MatrixLabTools/Psi4Calculator.jl/actions/workflows/CI.yml?query=branch%3Amain)

This is a [Psi4](https://psicode.org) calculator for [PotentialCalculation](https://github.com/MatrixLabTools/PotentialCalculation.jl)

## Installation

Hit "]" to enter "pkg>"

```julia
pkg> add registry add https://github.com/MatrixLabTools/PackageRegistry
pkg> add https://github.com/MatrixLabTools/Psi4Calculator.jl
```

## Example use case

```julia
using PotentialCalculation
using Psi4Calculator

N2 = isolated_system( [Atom(:N, [1., 0., 0.].*u"Å"), Atom(:N, [0., 0., 0.].*u"Å")] )

ca = Calculator("blyp", "def2-svp",Psi4(memory="1000MiB", nthreads=2))

calculate_energy(ca, N2)
```

## Note

This is still experimental and may or may not work.
