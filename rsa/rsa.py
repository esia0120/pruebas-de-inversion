from scipy.io import loadmat
import numpy as np

data = loadmat('examenDatos1_21.mat')
x=data.get('x').T
y=data.get('y').T
G=np.hstack((x**0,x**1))

mi=np.array([[1],[1]])
yi=G.dot(mi)
Ei=np.sqrt(np.sum((y-yi)**2))
itermax=100
Tol=20
k=0
ndp=2
Amp=np.array([50, 1, .01]).reshape(1,3)
mp=mi
mo=mi
Eo=Ei
AmpMax=np.array([50, 1, .01])
AmpMin=np.array([10, 0.1, .001])
Ti=100000000
Tf=0.0000001
RT=(Tf/Ti)**(1/itermax)
ct=10

while(Tol<Ei and k<itermax):
    k+=1
    ma=np.zeros((1,ndp))
    
    for c2 in range(1,ct+1):
        for c1 in range(0,ndp):
            a=(np.random.rand()*2-1)*Amp[0][c1]
            mp[c1]=mi[c1]+a
            
            if (mp[c1]<0):
                mp[c1]=0
            
            if (mp[c1]>500):
                mp[c1]=500
            yp=G.dot(mp)
            Ep=np.sqrt(np.sum((yp-y)**2))
            
            if(Ep<Ei):
                mi[c1]=mp[c1]
                Ei=Ep
                ma[c1]=ma[c1]+1
                if (Ep<Eo):
                    mo=mp
                    Eo=Ep
            else:
                
                a=np.random.rand()
                DP=np.exp(-(Ep-Ei)/Ti)
                if (a<DP): 
                    mi[c1]=mp[c1]
                    Ei=Ep
                else:
                    mp[c1]=mi[c1]
    for c3 in range(0,ndp):
        r=ma[0][c3]/ct
        if (r>0.6):
            Amp[0][c3]=Amp[0][c3]*(1+2*(r-0.6)/0.4)
        if (Amp[0][c3]>AmpMax[c3]):
            Amp[0][c3]=AmpMax[c3]
        if (r<0.4):
            Amp[0][c3]=Amp[0][c3]/(1+2*(0.4-r)/0.4)
        if (Amp[0][c3]<AmpMin[c3]):
            Amp[0][c3]=AmpMin[c3]
    # Aplicamos el factor de reduccion de Temp
    Ti=Ti*RT
    mi=mo
    Ei=Eo
    #vE[k]=Ei
yf3=G.dot(mi)
