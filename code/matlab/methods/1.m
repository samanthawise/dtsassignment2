%add kmeans output
for i = 1:3
    a{i}=K1(find(K_train(:,42)==i),:);
    [I,C{i}]=kmeans(a{i},100);
end
for i = 4:9
    a{i}=K1(find(K_train(:,42)==i),:);
    [I,C{i}]=kmeans(a{i},20);
end
for i = 10:23
    a{i}=K1(find(K_train(:,42)==i),:);
    [I,C{i}]=kmeans(a{i},1);
end
%result > 0.99
