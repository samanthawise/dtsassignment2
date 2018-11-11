%K is standardized
mappedX = tsne(K(:,[1:41]))
figure
subplot(2,2,1)
gscatter(mappedX(:,1), mappedX(:,2),Bag);
title("Test result")
subplot(2,2,2)
gscatter(mappedX(:,1), mappedX(:,2),K(:,42));
title("The real result")
subplot(2,2,3)
gscatter(mappedX(:,1), mappedX(:,2),(Bag==1));
title("Test result")
subplot(2,2,4)
gscatter(mappedX(:,1), mappedX(:,2),(K_test(:,42)==1));
title("The real result")
