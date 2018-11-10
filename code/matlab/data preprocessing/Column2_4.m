%kddcup contains the data: src_bytes, dst_bytes, land
for j = 1:3
    A = unique(kddcup(:,j));
    for i =1:length(A)
        f = find(kddcup(:,j)==A(i));
        kddcup(f,j) = i;
    end
end
temp = cellstr(kddcup);
temp = char(temp);
%str2num for the colunm 2 - 4
K_24 = str2num(temp);
Part1ofWholeK = reshape(K_24,length(kddcup),3);

WholeK=[Part1ofWholeK data label];
