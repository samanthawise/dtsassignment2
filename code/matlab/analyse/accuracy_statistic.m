K = zscore(WholeK(:,[1:41]));
ACCU=[];
k=WholeK;
for i =1:200
training_num = 100;
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
        %temp = num2str(i);
        a{i}=K1(find(K_train(:,42)==i),:);
        [I,C{i}]=kmeans(a{i},10);
        %eval(['a_' temp '=K1(find(K_train(:,39)==' temp '),:);'])
        %eval(['[I,C_' temp ']=kmeans(a_' temp ',10);'])
    end
    for i = 6:23
        %temp = num2str(i);
        a{i}=K1(find(K_train(:,42)==i),:);
        [I,C{i}]=kmeans(a{i},1);
        %eval(['a_' temp '=K1(find(K_train(:,39)==' temp '),:);'])
        %eval(['[I,C_' temp ']=kmeans(a_' temp ',1);'])
    end

    %K = mapminmax(kddcup,0,1);

    Bag=[];
    %len: lenth
    len=length(K)-1;
    %s start point
    s = 1;
    %try just 1 nearest neighor
    %parfor -- for
    parfor j = s:s+len
        distance = [];
        for i = 1:23
            %temp = num2str(i);
            %temp2 = num2str(j);
            distance = [distance min(dist(K(j,:),C{i}'))];
            %eval(['distance = [distance min(dist(K(' temp2 ',:),C_' temp '''))];'])
        end
        [a,b] = sort(distance);
        Bag = [Bag b(1)];

    end
    Whole_Bag{ll}=Bag;
    ACCU=[ACCU length(find(k([s:s+len],42)'==Bag))/(len+1)];
    ll
end
sum(ACCU)/length(ACCU)
eval(['csvwrite("\\ads.bris.ac.uk\filestore\myfiles\StudentPG1\mw18386\Downloads\Data Science\visualize\1000_plus\ACCU' num2str(i) '",ACCU)'])
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
