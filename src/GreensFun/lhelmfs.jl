#
# This function calculates Φ(x,y,E), the fundamental solution of the Helmholtz equation in a linearly stratified medium:
#
# -(Δ + E + x_2)Φ(x,y,E) = δ(x-y)
#
# also known as the gravity Helmholtz equation.
#
# This is a Julia wrapper for the C-library described in:
#
# A. H. Barnett, B. J. Nelson, and J. M. Mahoney, High-order boundary integral equation solution of high frequency wave scattering from obstacles in an unbounded linearly stratified medium, accepted, J. Comput. Phys., 22 pages (2014).
#
#
# Below:
#
# x = trg is the target variable,
# y = src is the source variable,
# E is the energy, and
# derivs allows for calculation of partial derivatives as well.
#

const lhelmfspath = joinpath(Pkg.dir("SIE"), "deps", "liblhelmfs")

export lhelmfs

function lhelmfs(trg::Union(Vector{Float64},Vector{Complex{Float64}}),src::Union(Vector{Float64},Vector{Complex{Float64}}),E::Float64;derivs::Bool=false)
    trgn,srcn = length(trg),length(src)
    @assert trgn == srcn
    n = trgn

    meth = 1
    stdquad = 200
    h = 0.35
    gamout = 0
    nquad = zeros(Int64,1)

    x1 = real(trg)-real(src)
    x2 = imag(trg)-imag(src)
    energies = E+imag(src)
    u = zeros(Complex{Float64},n)
    #if derivs
        ux = zeros(Complex{Float64},n)
        uy = zeros(Complex{Float64},n)
    #end

    ccall((:lhfs,lhelmfspath),Void,(Ptr{Float64},Ptr{Float64},Ptr{Float64},Int64,Int64,Ptr{Complex{Float64}},Ptr{Complex{Float64}},Ptr{Complex{Float64}},Int64,Float64,Int64,Int64,Ptr{Int64}),x1,x2,energies,derivs ? 1 : 0,n,u,ux,uy,stdquad,h,meth,gamout,nquad)

    if derivs
        return u/4π,ux/4π,uy/4π
    else
        return u/4π
    end
end

function lhelmfs(trg::Union(Float64,Complex{Float64}),src::Union(Float64,Complex{Float64}),E::Float64;derivs::Bool=false)
    if derivs
        u,ux,uy = lhelmfs([trg],[src],E;derivs=derivs)
        return u[1],ux[1],uy[1]
    else
        u = lhelmfs([trg],[src],E;derivs=derivs)
        return u[1]
    end
end

function lhelmfs(trg::Union(Matrix{Float64},Matrix{Complex{Float64}}),src::Union(Matrix{Float64},Matrix{Complex{Float64}}),E::Float64;derivs::Bool=false)
    sizetrg,sizesrc = size(trg),size(src)
    @assert sizetrg == sizesrc

    if derivs
        u,ux,uy = lhelmfs(vec(trg),vec(src),E;derivs=derivs)
        return reshape(u,sizetrg),reshape(ux,sizetrg),reshape(uy,sizetrg)
    else
        u = lhelmfs(vec(trg),vec(src),E;derivs=derivs)
        return reshape(u,sizetrg)
    end
end

lhelmfs{T<:Union(Float64,Complex{Float64})}(trg::VecOrMat{T},src::Union(Float64,Complex{Float64}),E::Float64) = lhelmfs(trg,fill(src,size(trg)),E)

lhelmfs{T<:Union(Float64,Complex{Float64})}(trg::Union(T,VecOrMat{T}),E::Float64) = lhelmfs(trg,zero(T),E)
