%For the whole data sets, I divided them into 3 parts, because some of them
%are string (non-double) which need to be transfer to number. First part is
%the yuchuli.m which process the column 2-4's data. Secondly, I transfered
%the labeled data into 1-23, to represent normal, smurf, ..., repectively.
%Finally, I load the whole data 
load("\\ads.bris.ac.uk\filestore\myfiles\StudentPG1\mw18386\Downloads\Data Science\code\wholedata_withlabel.mat")
load("\\ads.bris.ac.uk\filestore\myfiles\StudentPG1\mw18386\Downloads\Data Science\code\trainC.mat")
%Data details 
%Colunms 1-3: src_bytes, dst_bytes, land
%Colunms 4: duration
%Colunms 5-41: other data
%Colunms 42: labels  ---  1:normal, 2:smurf(detail in Labels2number.m)
WholeK = csvread("./Data.cvs")

%standarize 
K = [zscore(WholeK(:,[1:41])) WholeK(:,42)];

%Training
K_t = [];
%the number of kmeans trainning
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

%kmeans 10 centres for the 1-5 labels, 1 centre for the rest labels
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

%Testing
Whole_Bag=cell(10,1)
ACCU=[];
%Set the number of testing data 10000
item = [10000,50000,100000,200000,500000,1000000,2000000,3000000,4000000,length(K)]
for ll = 1:length(item)
    Bag=[];
    %len: lenth
    len=item(ll)-1;
    %s start point
    s = 1;
    %try just 1 nearest neighor
    %parfor -- for
    K_test = K(randperm(length(K),item(ll)),:);
    parfor j = s:s+len
        distance = [];
        for i = 1:23
            distance = [distance min(dist(K_test(j,[1:41]),C{i}'))];
        end
        [a,b] = sort(distance);
        Bag = [Bag b(1)];
    end
    Whole_Bag{ll}=Bag;
    ACCU=[ACCU length(find(K_test([s:s+len],42)'==Bag))/(len+1)]
    ll
end
sum(ACCU)/length(ACCU)
plot(item([1:10]),ACCU,'*-')
accuracy = ACCU;
plot(item, accuracy, '*')
x=item;
y=accuracy;
EXPR = {'x','1/x','1'};
p=fittype(EXPR)
f=fit(x',y',p)
plot(f,x',y');
xlabel('Size of testing data')
ylabel('Accuracy')
print -djpeg '\\ads.bris.ac.uk\filestore\myfiles\StudentPG1\mw18386\Downloads\Data Science\visualize\400000\increasingtestdata.jpg' -r800
