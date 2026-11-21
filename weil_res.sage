load("av.sage")
load("prim_group.sage")

class WeilRes(AV):
    def __init__(self,B,d,v):
        assert B.base_field_deg() == None or mod(d,B.base_field_deg())==0, f"the finite field F_q^{B.base_field_deg()} must be a subfield of F_q^{d}"
        assert mod(d,v)==0, f"the field of definition of {B} must be a subfield of F_q^{d}"
        self.d = d
        self.v = v
        self.B = B
        self._frob = None
        _label = self.__repr__()
        _dim = ZZ(self.B.dim() * self.d / self.v)
        super().__init__(_dim, self.v, _label)

    def __eq__(self, w):
        return (type(self), self.B, self.d, self.v) == (type(w), w.B, w.d, w.v)

    def __repr__(self):
        return f"W_{{{self.d},{self.v}}}({self.B})"
    
    def base_av(self):
        return self.B
    
    def out(self):
        # Res_{F_q^out} / {F_q^to}(AV)
        return self.d
    
    def to(self):
        # Res_{F_q^out} / {F_q^to}(AV)
        return self.v

    def primitive_groups(self):
        assert mod(self.v, self.B.base_field_deg()) == 0, f"Weil restriction {self} can not be decomposed when F_q^{self.B.base_field_deg()} is not a subfield of F_q^{self.v}"
        groups = []
        for et in divisors(ZZ(self.d/self.v)):
            pg = PrimGroup(self.B, et)
            groups.append(pg)
        return groups

    def decompose(self):
        '''
        The method decomposes Weil restriction into a product of abelian varieties.
        '''

        e = self.B.base_field_deg()
        if e == self.d:
            return [self]

        if mod(self.v, e) == 0:
            return self.primitive_groups()
        
        if mod(e, self.v) == 0:
            # F_q^v ⊆ F_q^e ⊆ F_q^d and B is defined over F_q^e
            # W_{d,v}(B) = W_{v,e}(W_{d,e}(B)) ~ prod_{i|d/e} W_{v,e}(V_i)
            res = []
            W = WeilRes(self.B, self.d, e)
            for gr in W.primitive_groups():
                V = WeilRes(gr, e, self.v)
                res.append(V)
            return res

        return [self]
    
    def frob(self, ring=None):
        if self._frob != None:
            return self._frob

        var = self.B.label[0].lower()
        if ring == None:
            ring = init_ring(self.B.g, exts=[self.to(), self.B.r], var=var)

        t = ring('T')
        dg = ZZ(self.out()/self.to())
        self._frob = self.B.frob(ring=ring).subs({t: t^dg})
        return self._frob
    
    def frob_label(self, var='T'):
        G = f"{self.B}"
        dg = ZZ(self.out() / self.to())
        if dg == 1:
            return f"\\chi_{{{G},q}}({var})"
        else:
            return f"\\chi_{{{G},q^{dg}}}({var}^{dg})"
