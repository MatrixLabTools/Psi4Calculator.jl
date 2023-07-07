using Test

using PotentialCalculation
using Psi4Calculator

formic_acid=Cluster(
 [-6.7041359778      1.3501192944      0.0102209137
-5.3688853815      1.2229556023      0.0440598937
-7.2470157373      2.4374213225      0.0651311769
 -5.0398812618      2.1435406993      0.1155201154
 -7.2001330967      0.3718768293     -0.0703451879]',
  AtomOnlySymbol.(["C", "O", "O", "H", "H"]) )

Ar = Cluster( Atom(:Ar, rand(3)u"Å"  )  )
N2 = isolated_system( [Atom(:N, [1., 0., 0.].*u"Å"), Atom(:N, [0., 0., 0.].*u"Å")] )

@testset "Psi4Calculator.jl" begin
    ca = Calculator("blyp", "def2-svp",Psi4(memory="1000MiB", nthreads=2))

    @test calculate_energy(ca, formic_acid) < -189
    @test all( calculate_energy(ca, [N2,Ar]) .< [-109, -527] )
    @test bsse_corrected_energy(ca, formic_acid, Ar) < 1E-6
end
