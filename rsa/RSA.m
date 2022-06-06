load examenDatos1_21
G=[x(:).^0 x(:).^1];
d=y(:);
x=x';
y=y';
% Create the initial model
mi=[1;1];
% evaluate the forward problem 
yi=G*mi;
Ei=sqrt(sum((y-yi).^2)); % initial error
% set the inversion(optimization) parameters 
itermax=100; % max iteractions
TOL=20; % Tolerance
k=0;
np=2; % number of parameters
AMP=[50 1 .01]; %amplitude
mp=mi; % perturbated model
mo=mi; % model o
Eo=Ei; % Error o
AMP_MAX=[50 1 0.01];
AMP_MIN=[10 0.1 0.001];
Ti=100000000; % Initial temperature
Tf=0.0000001; % Final temperature
RT=(Tf/Ti)^(1/itermax);
ct=10;
while (TOL<Ei && k<itermax)
    k=k+1;
    ma=zeros(1,np);
    % Inner loop, it depends of the number or parameters
    for c2=1:ct
        for c1=1:np
            a=(rand*2-1)*AMP(c1);
            mp(c1)=mi(c1)+a;
            if mp(c1)<0
                mp(c1)=0;
            end
            if mp(c1)>500
                mp(c1)=500;
            end
            yp=G*mp;
            Ep=sqrt(sum((yp-y).^2));
            % We decide a model
            if Ep<Ei
                mi(c1)=mp(c1);
                Ei=Ep;
                ma(c1)=ma(c1)+1;
                if Ep<Eo
                    mo(:)=mp(:);
                    Eo=Ep;
                end
            else
                % we generate a random number
                a=rand;
                DP=exp(-(Ep-Ei)/Ti);
                %figure(2)
                %hold on
                %plot(k,DP,'*')
                %hold off
                %pause
                if a<DP % if model is acceptable or not 
                mi(c1)=mp(c1);
                Ei=Ep;
                else
                    mp(c1)=mi(c1);
                end
            end
        end
    end
    for c3=1:np
        r=ma(c3)/ct;
        if r>0.6
            AMP(c3)=AMP(c3)*(1+2*(r-0.6)/0.4);
        end
        if AMP(c3)>AMP_MAX(c3)
            AMP(c3)=AMP_MAX(c3);
        end
        if r<0.4
            AMP(c3)=AMP(c3)/(1+2*(0.4-r)/0.4);
        end
        if AMP(c3)<AMP_MIN(c3)
            AMP(c3)=AMP_MIN(c3);
        end
    end
    % temperature reduction factor applied
    Ti=Ti*RT;
    mi=mo;
    Ei=Eo;
    vE(k)=Ei;
end
yf=G*mi;