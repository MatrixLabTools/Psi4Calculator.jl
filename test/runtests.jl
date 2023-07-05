using Test

using Distributed
#addprocs(2)

@everywhere using PotentialCalculation
@everywhere using Psi4Calculator

fname = tempname() * ".jld2"
rname = tempname() * ".jld2"
sname = tempname() * ".jld2"
xyzname = tempname() * ".xyz"

formic_acid=Cluster(
 [-6.7041359778      1.3501192944      0.0102209137
-5.3688853815      1.2229556023      0.0440598937
-7.2470157373      2.4374213225      0.0651311769
 -5.0398812618      2.1435406993      0.1155201154
 -7.2001330967      0.3718768293     -0.0703451879]',
  AtomOnlySymbol.(["C", "O", "O", "H", "H"]) )

Ar = Cluster( Atom(:Ar, rand(3)u"Å"  )  )
N2 = isolated_system( [Atom(:N, [1., 0., 0.].*u"Å"), Atom(:N, [0., 0., 0.].*u"Å")] )

open(xyzname,"w") do io
    print_xyz(io, formic_acid)
end

pbar=true

testrestarts = false

@testset "Psi4Calculator.jl" begin
    ca = Calculator("blyp", "def2-svp",Psi4(memory="1000MiB", nthreads=2))

    input1=create_inputs(xyzname, Ar, ca)
    inputs=create_inputs(xyzname, N2, ca; npoints=5)
    inputss=create_inputs(xyzname, xyzname, ca)

    data1=calculate_potential(inputs, save_file=fname, pbar=pbar)
    data2=calculate_potential(fname,ca,save_file=sname, restart_file=rname, pbar=pbar)
    data3=continue_calculation(rname,ca, save_file=sname, restart_file=rname, pbar=pbar)

    calculate_energy(ca, N2)
    calculate_energy(ca, [N2,N2])
    @test all(isapprox.(data1["Energy"], data2["Energy"], atol=2E-6))
    @test all(isapprox.(data1["Energy"], data3["Energy"], atol=2E-6))
    @test all(isapprox.(data2["Energy"], data3["Energy"], atol=2E-6))
end
