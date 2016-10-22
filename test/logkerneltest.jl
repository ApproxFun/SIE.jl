using Base.Test, ApproxFun, SingularIntegralEquations
    import ApproxFun: ∞


a=1.0;b=2.0
d=Interval(a,b)
z=Fun(d)
f=real(exp(z)/(sqrt(z-a)*sqrt(b-z)))
S=space(f)
x=4.0+2im;
@test_approx_eq linesum(f*log(abs(x-z))) logkernel(f,x)*π

a=1.0;b=2.0+im
d=Interval(a,b)
z=Fun(d)
f=real(exp(z)/(sqrt(z-a)*sqrt(b-z)))
S=space(f)
x=4.0+2im;
@test_approx_eq linesum(f*log(abs(x-z))) 13.740676344264614
@test_approx_eq linesum(f*log(abs(x-z))) logkernel(f,x)*π



linesum(f)
sum(f)
a=1.0;b=2.0+im
d=Interval(a,b)
z=Fun(d)
f=real(exp(z)*(sqrt(z-a)*sqrt(b-z)))
S=space(f)
x=4.0+2im;
@test_approx_eq linesum(f*log(abs(x-z))) logkernel(f,x)*π


a=1.0;b=2.0
d=Interval(a,b)
z=Fun(d)
f=real(exp(z)/(sqrt(z-a)*sqrt(b-z)))
x=1.5
@test_approx_eq (SingularIntegral(space(f),0)*f)(x) logkernel(f,x)

f=real(exp(z)*(sqrt(z-a)*sqrt(b-z)))
x=1.5
@test_approx_eq (SingularIntegral(space(f),0)*f)(x) logkernel(f,x)

a=1.0;b=2.0+im
d=Interval(a,b)
z=Fun(d)
f=real(exp(z)/(sqrt(z-a)*sqrt(b-z)))
x=1.5+0.5im
H=SingularIntegral(space(f),0)
@test_approx_eq (H*f)(x) logkernel(f,x)


f=real(exp(z)*(sqrt(z-a)*sqrt(b-z)))
@test_approx_eq (SingularIntegral(space(f),0)*f)(x) logkernel(f,x)

a=1.0;b=2.0+im
d=Interval(a,b)
z=Fun(d)
f=real(exp(z)/(sqrt(z-a)*sqrt(b-z)))
S=JacobiWeight(-0.5,-0.5,ChebyshevDirichlet{1,1}(d))
H=OffSingularIntegral(S,Chebyshev([3,4]),0)
@test_approx_eq (H*f)(3.5) logkernel(f,3.5)

H=OffSingularIntegral(S,Chebyshev([3,4.0+im]),0)
@test_approx_eq (H*f)(3.5+0.5im) logkernel(f,3.5+0.5im)


## Circle

d=Circle(0.2,3.0)
S=Fourier(d)
ζ=Fun(d)
f=real(ζ+1/(ζ-0.1))
#z=0.1+0.1im;@test_approx_eq linesum(log(abs(ζ-z))*f) logkernel(f,z)*π
#z=5.0+0.1im;@test_approx_eq linesum(log(abs(ζ-z))*f) logkernel(f,z)*π

d=Circle(0.2,3.0)
S=Fourier(d)
H=Hilbert(S,0)
ζ=Fun(d)
f=real(ζ+1/(ζ-0.1))
z=0.2+3im;@test_approx_eq (H*f)(z) logkernel(f,z)



## LogKernel for Legendre and Jacobi on intervel

x=Fun()
f=exp(x)
@test isa(logkernel(f,2.0+im),Real)
@test_approx_eq logkernel(f,2.0+im) sum(f*log(abs(2.0+im-x)))/π


f=sqrt(1-x^2)*exp(x)
@test_approx_eq logkernel(f,2.0+im) sum(f*log(abs(2.0+im-x)))/π

x=Fun()
f=(1-x)^0.1
sp=space(f)
@test_approx_eq logjacobimoment(sp.β,sp.α,2.0) sum((1-x)^sp.β*(1+x)^sp.α*log(abs(2.0-x)))

@test_approx_eq logkernel(f,2.0) sum(f*log(abs(2.0-x))/π)


f=(1-x)^0.1*exp(x)

@test_approx_eq stieltjes(f,2.0) sum(f/(2.0-x))

@test_approx_eq logkernel(f,2.0) sum(f*log(abs(2.0-x))/π)

@test isa(logkernel(f,2.0+im),Real)
@test_approx_eq logkernel(f,2.0+im) sum(f*log(abs(2.0+im-x))/π)

f=(1-x^2)^0.1*exp(x)
sp=space(f)
@test_approx_eq logjacobimoment(sp.β,sp.α,2.0)  sum((1-x^2)^0.1*log(abs(2.0-x)))
@test_approx_eq logkernel(f,2.0+im)  sum(f*log(abs(2.0+im-x))/π)


f=(1-x)^(-0.1)*(1+x)^(-0.2)*exp(x)
@test_approx_eq logkernel(f,2.0+im)  sum(f*log(abs(2.0+im-x))/π)
@test isa(logkernel(f,2.0+im),Real)