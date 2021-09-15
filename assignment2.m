clear;
clc;
pop_size =1000;
st_l =40; %for accuracy upto 6 decimal points
pc=0.95; %cross over probability
pm=0.01; %mutation probability
gen=400; %iterations or generations

%RANDOM SOLUTIONS GENERATION

sol_set=randi([0 1],pop_size,st_l); %generating an initial solution set
A=2.^(0:st_l*0.5-1); %tensor which maps binary values to decoded value
xmin=0;xmax=0.5; 
X=(1:gen);
Y=zeros(gen,1);
Z=zeros(gen,1);
for g=1:gen

%FITNESS EVALUATION    

     dx1=(A*sol_set(:,1:st_l/2)')';  %decoded value of x1
     dx2=(A*sol_set(:,st_l/2+1:st_l)')'; %decoded value of x2
     dec=[dx1 dx2];
     cod(:,:)= xmin + ((xmax-xmin)/(2^(st_l/2)-1)).*dec(:,:); %coded values for x1,x2
   
    fit=zeros(pop_size,1);
    avg_fit=0;
    for i=1:pop_size
        fit(i,1)=obj_fn(cod(i,1),cod(i,2)); %fitness evaluation for each soln
        avg_fit=avg_fit+fit(i,1)/pop_size; %average fitness for genertion
    end
    
 %ROULETTE WHEEL SELECTION
 
   fit_p=fit/(avg_fit*pop_size); %fitness percentage for each solution
   fit_r=zeros(pop_size,1);
   s=0;
   for i=1:pop_size
       fit_r(i,1)=fit_p(i,1)+s; % fitness range of each solution
       s=fit_r(i,1);
   end
   mat_p=zeros(pop_size,st_l);
   R=rand(pop_size,1); 
   for i=1:pop_size
       k=0;
       for j=1:pop_size
           if(fit_r(j,1)>=R(i,1))&&(k<=R(i,1))
               mat_p(i,:)=sol_set(j,:);
           end
           k=fit_r(j,1);
       end
   end
   
   %crossover
   ch=zeros(pop_size,st_l);
   rmat_p = mat_p;%(randperm(pop_size),:); %randomizing the mating pool
   for i=1:pop_size/2
       rc=rand;
       ch_m=zeros(pop_size,st_l);
       if (rc<=pc) %checking whether the ith parent set taking part in crossover
         m=randi([1 st_l-1]);  %cross over point
         n=randi([1 st_l-1]);  %cross over point
         ch_m(i*2-1,:)=[rmat_p(i*2-1,1:m) rmat_p(i*2,m+1:st_l)]; %crossover operation from mth bit
         ch_m(i*2,:)=[rmat_p(i*2,1:m) rmat_p(i*2-1,m+1:st_l)]; 
         ch(i*2-1,:)=[ch_m(i*2-1,1:n) ch_m(i*2,n+1:st_l)]; %crossover operation from nth bit
         ch(i*2,:)=[ch_m(i*2,1:n) ch_m(i*2-1,n+1:st_l)];
       else
           ch(i*2-1,:)=rmat_p(i*2-1,:); %parents not taking part in crossover coming themselves in the solution
           ch(i*2,:)=rmat_p(i*2,:);

       end
   end
   sol=ch;
%MUTATION
        rm=rand(pop_size,st_l);
        for i=1:pop_size
          for j=1:st_l
              if(rm(i,j)<=pm)
                  sol(i,j)=1-ch(i,j);
              end
          end
        end
     
          sol_set=sol;
          Y(g,1)=avg_fit; %avg fitness of each generation
          [Z(g,1) index]=max(fit); %max fitness of each generation and its index
          M(g,1)=min(fit); %minimum fitness value for each generation
          N(g,:)=cod(index,:); %values of x1.x2 corresponding to that index
          z(g,:)=mean(cod); %mean value of x1,x2 for each gen
end
[q w]=max(fit);
e=cod(w,1:2);
figure(1)
plot(X,z)
axis([0 gen 0 0.5])
legend('X1','X2')
xlabel('No. of generations')
ylabel('Variables')
title('average values of variable vs generation')

figure(2)
plot(X,Y,'linewidth',1.2)
xlabel('No. of generations')
ylabel('Average fitness value')

title('Average fitness value vs number of generation') 
axis([0 gen 0 1])

figure(3)
plot(X,Z,X,M,'linewidth',1.2)
xlabel('No. of generations')
ylabel('Fitness value')
legend('maximum fitness','minimum fitness')
title('fitness values vs number of generation') 
axis([0 gen 0 1.2])
fprintf('THE MINIMUM VALUE OF THE GIVEN FUNCTION IS :%d\n',1/mode(Z)-1)
fprintf('THE OPTIMUM VALUES OF X1 AND X2 IS :%d and %d\n',mode(N))

          
          
          
       
   
   
   