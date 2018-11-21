K=[K_normal;K_others;K_smurf]; 
A = {'duration';'protocol_type';'service';'flag';'src_bytes';'dst_bytes'; 'land';'wrong_fragment';'urgent';'hot';'num_failed_logins';'logged_in';'num_compromised';'root_shell';'su_attempted';'num_root'; 'num_file_creations';'num_shells';'num_access_files';'num_outbound_cmds';'is_host_login';'is_guest_login';'count';'srv_count';'serror_rate';'srv_serror_rate';'rerror_rate';'srv_rerror_rate';'same_srv_rate';'diff_srv_rate';'srv_diff_host_rate';'dst_host_count';'dst_host_srv_count';'dst_host_same_srv_rate';'dst_host_diff_srv_rate';'dst_host_same_src_port_rate';'dst_host_srv_diff_host_rate';'dst_host_serror_rate';'dst_host_srv_serror_rate';'dst_host_rerror_rate';'dst_host_srv_rerror_rate';'label'}
p = 1
A(find(sd2>p))
[len1 tem]= size(A(find(sd2>p)))
K=K(:,[find(sd2>p),42]);
%K = [zscore(K(:,[1:length(K(1,:))-1])) K(:,length(K(1,:)))];
K = [K(:,[1:length(K(1,:))-1]) K(:,length(K(1,:)))];
k=K;
%K=[K(:,4) K(:,42)];
K_t = [];
    trainnumber = 130448;
    %xitong chouyang
    for i = 1 : 2
        num = find(k(:,len1+1)==i);
        n = ceil(length(num)/length(K)*trainnumber);
        % choose the data randomly
        index = num(randperm(ceil(length(num)),n));
        %K_t is a training data and K_t has 42 colunms 
        K_t = [K_t;K(index,[1:len1]) i*ones(length(index),1)];
    end

    K_train = K_t;
    K1 = K_t(:,[1:len1]);
    a=cell(2,1);
    C=a;
    for i = 1
        %temp = num2str(i);
        a{i}=K1(find(K_train(:,len1+1)==i),:);
        [I,C{i}]=kmeans(a{i},5);
        %eval(['a_' temp '=K1(find(K_train(:,39)==' temp '),:);'])
        %eval(['[I,C_' temp ']=kmeans(a_' temp ',10);'])
    end
    for i = 2
        %temp = num2str(i);
        a{i}=K1(find(K_train(:,len1+1)==i),:);
        [I,C{i}]=kmeans(a{i},5);
        %eval(['a_' temp '=K1(find(K_train(:,39)==' temp '),:);'])
        %eval(['[I,C_' temp ']=kmeans(a_' temp ',1);'])
    end

    %K = mapminmax(kddcup,0,1);
Kfortest=K;
    Bag=[];
    %len: lenth
    len=length(Kfortest)-1;
    %s start point
    s = 1;
    %try just 1 nearest neighor
    %parfor -- for
    tic

    parfor j = s:s+len
        distance = [];
        for i = 1:2
            %temp = num2str(i);
            %temp2 = num2str(j);
            distance = [distance min(dist(Kfortest(j,[1:len1]),C{i}'))];
            %eval(['distance = [distance min(dist(K(' temp2 ',:),C_' temp '''))];'])
        end
        [a,b] = sort(distance);
        Bag = [Bag b(1)];

    end
    length(find(Kfortest([s:s+len],len1+1)'==Bag))/(len+1)
    C1 = confusionmat(Kfortest(:,len1+1),Bag')
    FPR = C1(2,1)/(C1(2,1)+(C1(1,1)))
    FNR = C1(1,2)/(C1(1,2)+(C1(2,2)))
    Recall = C1(2,2)/(C1(2,2)+C1(1,2))
    Precision = C1(2,2)/(C1(2,2)+C1(2,1))
    F_score=2*Recall*Precision/(Precision+Recall)
    toc