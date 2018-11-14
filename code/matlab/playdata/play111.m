   K_t = [];
    trainnumber = 130448;
    %xitong chouyang
    for i = 1 : 2
        num = find(k(:,42)==i);
        n = ceil(length(num)/length(K)*trainnumber);
        % choose the data randomly
        index = num(randperm(ceil(length(num)),n));
        %K_t is a training data and K_t has 42 colunms 
        K_t = [K_t;K(index,[1:41]) i*ones(length(index),1)];
    end

    K_train = K_t;
    K1 = K_t(:,[1:41]);
    a=cell(23,1);
    C=a;
    for i = 1
        %temp = num2str(i);
        a{i}=K1(find(K_train(:,42)==i),:);
        [I,C{i}]=kmeans(a{i},100);
        %eval(['a_' temp '=K1(find(K_train(:,39)==' temp '),:);'])
        %eval(['[I,C_' temp ']=kmeans(a_' temp ',10);'])
    end
    for i = 2
        %temp = num2str(i);
        a{i}=K1(find(K_train(:,42)==i),:);
        [I,C{i}]=kmeans(a{i},100);
        %eval(['a_' temp '=K1(find(K_train(:,39)==' temp '),:);'])
        %eval(['[I,C_' temp ']=kmeans(a_' temp ',1);'])
    end

    %K = mapminmax(kddcup,0,1);

    Bag=[];
    %len: lenth
    len=length(Kfortest)-1;
    %s start point
    s = 1;
    %try just 1 nearest neighor
    %parfor -- for
    parfor j = s:s+len
        distance = [];
        for i = 1:2
            %temp = num2str(i);
            %temp2 = num2str(j);
            distance = [distance min(dist(Kfortest(j,[1:41]),C{i}'))];
            %eval(['distance = [distance min(dist(K(' temp2 ',:),C_' temp '''))];'])
        end
        [a,b] = sort(distance);
        Bag = [Bag b(1)];

    end
    length(find(Kfortest([s:s+len],42)'==Bag))/(len+1)