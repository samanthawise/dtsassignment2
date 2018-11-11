%WholeK is the whole dataset
K = zscore(WholeK(:,[1:41]));
ACCU=[];
k=WholeK;
training_num = 1000;
Whole_Bag = cell(training_num, 1);
for ll = 1:training_num
    K_t = [];
    trainnumber = 5000;
    %xitong chouyang
    for i = 1 : 23
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
    for i = 1:5
        a{i}=K1(find(K_train(:,42)==i),:);
        [I,C{i}]=kmeans(a{i},10);
    end
    for i = 6:23
        a{i}=K1(find(K_train(:,42)==i),:);
        [I,C{i}]=kmeans(a{i},1);
    end

    Bag=[];
    %len: lenth
    len=length(K)-1;
    %s start point
    s = 1;
    %try just 1 nearest neighor
    %parfor -- for
    parfor j = s:s+len
        distance = [];
        % calculate the distance and find the nearest one for every cluster
        for i = 1:23
            distance = [distance min(dist(K(j,:),C{i}'))];
        end
        %find the global nearest
        [a,b] = sort(distance);
        Bag = [Bag b(1)];
    end
    Whole_Bag{ll}=Bag;
    ACCU=[ACCU length(find(k([s:s+len],42)'==Bag))/(len+1)];
end
sum(ACCU)/length(ACCU)
end
figure
%pdf
ymin=min(ACCU);
ymax=max(ACCU);
x=linspace(ymin,ymax,20);
yy=hist(ACCU,x);
yy=yy/length(ACCU);
bar(x,yy)
xlabel('Accuracy')
ylabel('Frequency')
title('1000 times training')
print -dbitmap '\\ads.bris.ac.uk\filestore\myfiles\StudentPG1\mw18386\Downloads\Data Science\visualize\1000\Accuracy.bmp' -r800
print -djpeg '\\ads.bris.ac.uk\filestore\myfiles\StudentPG1\mw18386\Downloads\Data Science\visualize\1000\Accuracy.jpg' -r800
