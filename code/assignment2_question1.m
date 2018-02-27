%Emeka Peters - 100953293
%ELEC 4700 - Assignment 2 - Question 1

numx = 40;
numy = 60;
Gmat = sparse((numx * numy), (numx * numy));
Vmat = zeros(1, (numx * numy));
vo = 1;

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
            %Vmat(1, n) = 0;
        elseif j == 1 && i > 1 && i < numx
            %Gmat(n,:) = 0;
            Gmat(n, n) = -3;
            Gmat(n, n - numy) = 1;
            Gmat(n, n + numy) = 1;
            Gmat(n, n - 1) = 1;
            %Vmat(1, n) = -3;
        elseif j == numy && i > 1 && i < numx
            %Gmat(n, :) = 0;
            Gmat(n, n) = -3;
            Gmat(n, n - numy) = 1;
            Gmat(n, n + numy) = 1;
            Gmat(n, n + 1) = 1;
            %Vmat(1, n) = -3;
        else
            %Gmat(n, :) = 0;
            Gmat(n, n) = -4;
            Gmat(n, n - numy) = 1;
            Gmat(n, n + numy) = 1;
            Gmat(n, n - 1) = 1;
            Gmat(n, n + 1) = 1;
            %Vmat(1, n) = 0;
        end
    end
                

end 

figure (1);
spy(Gmat);

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
   
surf(actmat);



%%Question 1: Part B


numx = 40;
numy = 60;
Gmat2 = sparse((numx * numy), (numx * numy));
Vmat2 = zeros(1, (numx * numy));
vo = 1;

for i = 1:numx

    for j = 1:numy
        n = j + (i - 1) * numy;
        
        if i == 1
            Gmat2(n, :) = 0;
            Gmat2(n, n) = 1;
            Vmat2(1, n) = vo;
        elseif i == numx
            Gmat2(n, :) = 0;
            Gmat2(n, n) = 1;
            Vmat2(1, n) = vo;
        elseif j == 1
            Gmat2(n, :) = 0;
            Gmat2(n, n) = 1;
        elseif j == numy
            Gmat2(n, :) = 0;
            Gmat2(n, n) = 1;
        else
            Gmat2(n, :) = 0;
            Gmat2(n, n) = -4;
            Gmat2(n, n - numy) = 1;
            Gmat2(n, n + numy) = 1;
            Gmat2(n, n - 1) = 1;
            Gmat2(n, n + 1) = 1;
        end
    end
                

end 

figure (3);
spy(Gmat2);

sol2 = Gmat2\Vmat2';
figure (4);

actmat2 = zeros(numx, numy);



for i = 1:numx

    for j = 1:numy
        n = j + (i - 1) * numy;
        actmat2(i, j) = sol2(n);
    end
end
   
surf(actmat2);


%%Question 1: Part B - Analytical Solution Approach

zone = zeros(60, 40);
a = 60;
b = 20;

xs = linspace(-20,20,40);
ys = linspace(0,60,60);

[xm, ym] = meshgrid(xs, ys);



for n = 1:2:300
    
    zone = (4 * vo/pi) .* (zone + (cosh((n * pi * xm)/a) .* sin((n * pi * ym)/a)) ./ (n * cosh((n * pi * b)/a)));
    
    figure(5);
    surf(xs, ys, zone);
    title("Analytical Approach Solution");
    pause(0.01);
    
end



   