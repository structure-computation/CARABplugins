#  Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2014 jeremie Bellec
#

class MatriceItem extends TreeItem
    constructor: ( ) ->
        super()
  
    m_get :(matrice,i,j)->
        return matrice.subset(math.index(i-1,j-1))
      
    m_set :(matrice,i,j,val)->
        return matrice.subset(math.index(i-1,j-1), val)
      
    m_length :(matrice)->   
        matrice_size = math.size(matrice)
        matrice_length = matrice_size.subset(math.index(0))
        return matrice_length
      
    m_change_rep :(m0,m1)->  
        m0_trans = math.transpose(m0) 
        k1 = math.multiply(m1, m0)
        m1_rep = math.multiply(m0_trans, k1)
        return m1_rep
     
    #copy for square matrix 
    m_copy :(m0)->  
        m1 = math.zeros(@m_length(m0), @m_length(m0))
        for i in [1 .. @m_length(m0) ]
            for j in [1 .. @m_length(m0) ]
                @m_set  m1, i, j, @m_get(m0,i,j)
        return m1
     
    m_pop_lin :(m0,num_line)-> 
        matrice_size = math.size(m0)
        sl = matrice_size.subset(math.index(0))
        sc = matrice_size.subset(math.index(1))
        m1 = math.zeros(sl-1, sc)
        ii = 0
        for i in [1 .. sl]
            if i != num_line
                ii += 1
                for j in [1 .. sc ]
                    @m_set  m1, ii, j, @m_get(m0,i,j)
                    
        return m1
        
                
    m_pop_col :(m0,num_col)-> 
        matrice_size = math.size(m0)
        sl = matrice_size.subset(math.index(0))
        sc = matrice_size.subset(math.index(1))
        m1 = math.zeros(sl, sc-1)
        jj = 0
        for j in [1 .. sc]
            if j != num_col
                jj += 1
                for i in [1 .. sl ]
                    @m_set  m1, i, jj, @m_get(m0,i,j)

        return m1           
                
    m_triu : (m0) ->
        m1 = @m_copy m0
        for i in [1 .. @m_length(m0) ]
            for j in [1 .. @m_length(m0) ]
                if i > j
                    @m_set m1, i, j, 0
        return m1
                
            