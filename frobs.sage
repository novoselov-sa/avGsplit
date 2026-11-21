R.<T,q> = PolynomialRing(QQ, 'T,q')

_cache = {}

def cache_get(key):
    if (key in _cache.keys()):
        #print key+ ": cache hit"
        return _cache[key]
    else:
        #print key + ": cache miss, computation"
        return None

def cache_set(key, val):
    global _cache
    _cache[key] = val

def init_ring(dimension, exts=[], var="b", ring=QQ):
    names = 'T'
    for i in range(1,dimension+1):
        names = names + f",{var}" + str(i)
        if var != 'a':
            names = names + ",a" + str(i)
    for i in range(1,2*dimension+1):
        names = names + f",lambda" + str(i)
    for k in exts:
        for i in range(1,dimension+1):
            names = names + f",{var}" + str(i) + "_" + str(k)
            if var != 'a':
                names = names + f",a" + str(i) + "_" + str(k)
    names += ",z"
    names = names + ",q"
    #R = PolynomialRing(ring, names, order='lex')
    R0 = PolynomialRing(ring, names)
    return R0

def init(dimension, exts = [], var="b", ring=QQ):
    global R
    R = init_ring(dimension, exts, var, ring)
    R.inject_variables(verbose=False)
    return R

def frob_pol(dimension, q, ring, k=1, var="b"):
    t = ring('T')
    res = t^(2*dimension)
    for i in range(1,dimension):
        if k == 1:
            a_i = ring(var + str(i))
        else:
            a_i = ring(var + str(i) + "_" + str(k))
        res = res + a_i * t^(2*dimension-i) + a_i*q^(k*(dimension-i))*t^i
    if k==1:
        a_g = ring(var + str(dimension))
    else:
        a_g = ring(var + str(dimension) + "_" + str(k))
    res = res + a_g * t^dimension + q^(dimension*k)
    return res

def frob_a_k_from_a(i, k, g, q, ring, a):
    res = cache_get("a_t{}_{}_{}_{}_{}_{}".format(i,k,g,q,ring,a))
    if res != None:
        return res
    if i == 0:
        res = ring(1)
    elif i > 2*g:
        res = ring(0)
    elif i > g:
        res = ring(q)^((i-g)*k) * frob_a_k_from_a(2*g-i, k, g, q, ring, a)
    elif k == 1:
        res = a[i-1]
    elif i == 1:
        res = ring(k)*frob_a_k_from_a(k, 1, g, q, ring, a)
        for j in range(1,k):
            res = res - frob_a_k_from_a(j, 1, g, q, ring, a)*frob_a_k_from_a(1, k-j, g, q, ring, a)
    else:
        res = frob_a_k_from_a(1, i*k, g, q, ring, a)
        for j in range(1,i):
            res = res + frob_a_k_from_a(j, k, g, q, ring, a) * frob_a_k_from_a(1, (i-j)*k, g, q, ring, a)
        res = res / i

    cache_set("a_t{}_{}_{}_{}_{}_{}".format(i,k,g,q,ring,a), res)
    return res

def frob_k_from_frob(pol, k, q):
    if pol.parent().ngens() == 1:
        var = pol.parent().gen()
    else:
        var = T

    if pol.parent().ngens() == 1:
        g = ZZ(pol.degree() / 2)
    else:
        g = ZZ(pol.degree(T) / 2)

    a = []
    for i in range(1,g+1):
        if pol.parent().ngens() == 1:
            a.append(pol.coefficient(2*g-i))
        else:
            a.append(pol.coefficient({T: 2*g-i}))
    a_k = []
    for i in range(1,g+1):
        tm = frob_a_k_from_a(i, k, g, q, QQ, a)
        a_k.append(tm)
    pol_k = var^(2*g) + q^(g*k) + a_k[g-1] * var^g
    for i in range(1,g):
        pol_k += var^(2*g-i) * a_k[i-1] + var^i * a_k[i-1] * q^((g-i) * k)
    return pol_k

def frob_primitive_group(g,e):
    ''' Frobenius polynomial for the group V_e(B) in terms of roots of chi_B,q(T)'''
    pol = cyclotomic_polynomial(e)
    r = 1
    for i in range(1,2*g+1):
        li = eval(f"lambda{i}")
        r *= li^euler_phi(e)*pol(T/li)
    return r

def frob_primitive_group2(g, e, q, ring, k=1, pol=None):
    ''' Frobenius polynomial for the group V_e(B) in terms of coefficients of chi_{B,q^k}(T). '''

    if pol == None:
        pol = frob_pol(g, q, ring, k=k)
    z0 = ring("z")
    T0 = ring("T")
    cycl = cyclotomic_polynomial(e)(z0)
    r = 1
    for j in range(1,e+1):
        if gcd(e,j) != 1:
            continue
        h = z0^(2*g*j) * pol.subs({T0: T0/z0^j})
        h = ring(h.numerator().mod(cycl)) / ring(h.denominator().mod(cycl))
        r *= h
        # TODO: Implement faster way to do this.
        r = ring(r.numerator().mod(z0^e-1)) / ring(ring(r.denominator()).mod(z0^e-1))
        r = ring(r.numerator().mod(cycl)) / ring(ring(r.denominator()).mod(cycl))
    return r
