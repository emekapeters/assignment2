%%Emeka Peters - 100953293
%ELEC 4700 - Assignment 2 - Question 2

numx = 120;
numy = 80;
Gmat = sparse((numx * numy), (numx * numy));
Vmat = zeros(1, (numx * numy));
vo = 1;

cond1 = 1; %Conductivity outside the boxes
cond2 = 1e-2; %Conductivity inside the boxes

box1dim = [(numx * 2/5), (numx * 3/5),  numy, (numy * 4/5)]; %Dimensions of box1 (bottom box)
box2dim = [(numx * 2/5), (numx * 3/5), 0, (numy * 1/5)]; %Dimensions of box2 (top box)
%{
Fractions were chosen for the box dimensions to give integer values after
multiplying with overall box size
%}

%Creating Conductivity Map
condmap = ones(numx, numy);

for i = 1:numx
    
    for j = 1:numy
        if(i > box1dim(1) && i < box1dim(2) && ((j < box2dim(4)) || (j > box1dim(4))))
            condmap(i,j) = 1e-2;
        end
    end
    
end

figure(1);
surf(condmap);
title('Conductivity Map');


%Creating G-Matrix
for i = 1:numx

    for j = 1:numy
        
        n = j + (i - 1) * numy;
        
        if i == 1
            Gmat(n, :) = 0;
            Gmat(n, n) = 1;
            Vmat(1, n) = 1;
        elseif i == numx
            Gmat(n, :) = 0;
            Gmat(n, n) = 1;
            
        elseif j == 1 && i > 1 && i < numx
            
            if i == box1dim(1)
                Gmat(n, n) = -3;
                Gmat(n, n + 1) = cond2;
                Gmat(n, n + numy) = cond2;
                Gmat(n, n - numy) = cond1;
            
            elseif i == box1dim(2)
                Gmat(n, n) = -3;
                Gmat(n, n + 1) = cond2;
                Gmat(n, n + numy) = cond1;
                Gmat(n, n - numy) = cond2;
                
            elseif (i > box1dim(1) && i < box1dim(2))
                Gmat(n, n) = -3;
                Gmat(n, n + 1) = cond2;
                Gmat(n, n + numy) = cond2;
                Gmat(n, n - numy) = cond2;
            else
                Gmat(n, n) = -3;
                Gmat(n, n + 1) = cond1;
                Gmat(n, n + numy) = cond1;
                Gmat(n, n - numy) = cond1;
            end
            
        elseif j == numy && i > 1 && i < numx
            
            if i == box1dim(1)
                Gmat(n, n) = -3;
                Gmat(n, n - 1) = cond2;
                Gmat(n, n + numy) = cond2;
                Gmat(n, n - numy) = cond1;
            
            elseif i == box1dim(2)
                Gmat(n, n) = -3;
                Gmat(n, n - 1) = cond2;
                Gmat(n, n + numy) = cond1;
                Gmat(n, n - numy) = cond2;
                
            elseif (i > box1dim(1) && i < box1dim(2)) 
                Gmat(n, n) = -3;
                Gmat(n, n - 1) = cond2;
                Gmat(n, n + numy) = cond2;
                Gmat(n, n - numy) = cond2;
            else 
                Gmat(n, n) = -3;
                Gmat(n, n - 1) = cond1;
                Gmat(n, n + numy) = cond1;
                Gmat(n, n - numy) = cond1;
            end
            
        else
            
            if i == box1dim(1) && ((j < box2dim(4)) || (j > box1dim(4)))
                Gmat(n, n) = -4;
                Gmat(n, n + 1) = cond2;
                Gmat(n, n - 1) = cond2;
                Gmat(n, n + numy) = cond2;
                Gmat(n, n - numy) = cond1;
            
            elseif i == box1dim(2) && ((j < box2dim(4)) || (j > box1dim(4)))
                Gmat(n, n) = -4;
                Gmat(n, n + 1) = cond2;
                Gmat(n, n - 1) = cond2;
                Gmat(n, n + numy) = cond1;
                Gmat(n, n - numy) = cond2;
                
            elseif (i > box1dim(1) && i < box1dim(2) && ((j < box2dim(4)) || (j > box1dim(4))))
                Gmat(n, n) = -4;
                Gmat(n, n + 1) = cond2;
                Gmat(n, n - 1) = cond2;
                Gmat(n, n + numy) = cond2;
                Gmat(n, n - numy) = cond2;
            else
                Gmat(n, n) = -4;
                Gmat(n, n + 1) = cond1;
                Gmat(n, n - 1) = cond1;
                Gmat(n, n + numy) = cond1;
                Gmat(n, n - numy) = cond1;
            end
           
        end
    end
                

end 

figure (2);
spy(Gmat);
title('G Matrix Spy');
sol1 = Gmat\Vmat';
figure (2);
%surf(sol1);

actmat = zeros(numx, numy);



for i = 1:numx

    for j = 1:numy
        n = j + (i - 1) * numy;
        actmat(i, j) = sol1(n);
    end
end

figure (3);
surf(actmat);
title('Voltage Map with Bottleneck');


[Efieldx, Efieldy] = gradient(actmat);
Efieldx = -Efieldx;
Efieldy = -Efieldy;

figure (4);
quiver(Efieldx', Efieldy');

title('Electric Field  Quiver Plot')
axis tight


Jx = Efieldx .* condmap;

Jy = Efieldy .* condmap;


figure (5);
quiver(Jx, Jy);
title('Quiver Plot of Current Density')
axis tight

%cflow1 = sum(Jx(1, :));
cflow2 = sum(Jx(numx/2, :));
%avcflow = (cflow1 + cflow2)/2; 

Jmag = ((Jx .^ 2) + (Jy .^ 2)) .^ 0.5;
figure (6);
surface(Jmag);
title('Plot of Current Density Magnitude')
axis tight
cflow2

figure (7);
surface(Efieldx');
title('Electric Field in y-direction');

figure (8);
surface(Efieldy');
title('Electric Field in x-direction');

