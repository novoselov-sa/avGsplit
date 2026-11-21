def numfield_label(K, deg=None):
    if K.absolute_degree() == 2:
        D = K.discriminant()
        if K.is_isomorphic(QuadraticField(D)):
            label = f"Q(sqrt({D}))"
        else:
            label = f"Q(x)/({K.absolute_polynomial()})"
    else:
        label = f"Q(x)/({K.absolute_polynomial()})"
    if deg != None and deg != K.absolute_degree():
        label = "⊃ " + label
    return label

def endB_cyc_enum(g, s, d):
    '''Enumeration of possible End0(B) when End0(A) = Q(zeta_d). In this case End0(B) is CM-subfield of Q(zeta_d) of degree 2g/s.
    '''
    K = CyclotomicField(d)
    endB = []
    conditions = []
    for Ks in K.subfields(2*g/s):
        if Ks[0].is_CM():
            if g/s == 2:
                L = Ks[0]
                imag_quad_subfield = False
                for Ls in L.subfields(2):
                    if Ls[0].is_totally_imaginary():
                        imag_quad_subfield = True
                        #print_log(f"-> End0(B) ⊃ Q(x)/({Ls[0].absolute_polynomial()}) with discriminant D = {Ls[0].discriminant()}")
                if not imag_quad_subfield:
                    #print_log("-> B is absolutely simple, since End0(B) is primitive quartic CM-field\n")
                    conditions += ["B is absolutely simple, since End0(B) is primitive quartic CM-field"]
                else:
                    #print_log("-> B is geometrically split\n")
                    conditions += ["B is geometrically split"]
            else:
                conditions += [""]
            endB += [Ks[0]]
    return endB, conditions

def endB_intersection_enum(g, s, d):
    zdeg = euler_phi(d)
    assert zdeg > 1
    inter_dg = zdeg/s
    endB = []
    conditions = []
    K = CyclotomicField(d, "z")
    for Ks in K.subfields(inter_dg):
        if Ks[0].is_totally_real() and mod(2*g/s, 2*inter_dg) != 0:
            # check failed: if End0(B) contains a real subfield K+ of degree inter_dg, it must contain CM-subfield of degree 2*inter_dg that has K+ as maximal real subfield.
            continue
        #print_log(f"-> End0(B) ⊃ {numfield_label(Ks[0])} with discriminant D = {Ks[0].discriminant()}")
        endB += [Ks[0]]
        if Ks[0].is_CM() and inter_dg == 2 and g/s==2:
            #print_log(", B is geom. split")
            conditions += ["B is geom. split"]
        else:
            #print_log("")
            conditions += [""]
    return endB, conditions