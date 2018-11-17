from sklearn.metrics import classification_report
predicted = knn.predict(X_test.iloc[:,:raw_data.shape[1]-1])
report = classification_report(X_test.iloc[:,raw_data.shape[1]-1:], predicted)
print(report)
