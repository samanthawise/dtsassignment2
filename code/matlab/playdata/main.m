Choose_normal_randomly = randperm(length(K_normal),97278);
Normal1 = Choose_normal_randomly(1:97278/2);
Noraml2 = Choose_normal_randomly(97278/2:97278);
Choose_smurf_randomly = randperm(length(K_smurf),97278/2*4);
Choose_others_randomly = randperm(length(K_others),97278/2*4);
% Because the number of other attacks is little, we need to maximize the
% number of other attacks.
Choose_normal_randomly = randperm(length(K_normal),97278);
Normal1 = Choose_normal_randomly(1:97278/2);
Noraml2 = Choose_normal_randomly(97278/2:97278);
Choose_smurf_randomly = randperm(length(K_smurf),97278/2*4);
%or we even don't need to choose it randomly.
Choose_others_randomly = randperm(length(K_others),length(K_others));


%begin
Numberofnormal = ceil(length(K_others)/0.8*0.2)+1;
Choose_normal_randomly = randperm(length(K_normal),Numberofnormal);
Normal1 = Choose_normal_randomly(1:Numberofnormal/2);
Noraml2 = Choose_normal_randomly(Numberofnormal/2:Numberofnormal);
Choose_smurf_randomly = randperm(length(K_smurf),length(K_others));
K_others;

Kfortrain = [K_normal(Normal1,:);K_smurf(Choose_smurf_randomly,:)];
Kfortest = [K_normal(Normal1,:);K_others];

play111;

Kfortrain = [K_normal(Normal1,:);K_others];
Kfortest = [K_normal(Normal1,:);K_smurf(Choose_smurf_randomly,:)];

play111;
