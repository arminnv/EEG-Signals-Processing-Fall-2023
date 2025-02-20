% EEG CHW2 Q1
close all
clear

% Part a
% Loading data
X = load('Ex1.mat').EEG_Sig;
fs = 200;
Mean = mean(X, 2);
X = X - Mean;
% Plotting data
figure
t = (0:size(X, 2)-1)/fs;
sgtitle('Raw signal')

for i=1:3
    subplot(3, 1, i)
    plot(t, X(i, :))
    xlabel('Time(s)')
end
saveas(gcf, 'raw signal.png')



% Plotting 3D data
figure
scatter3(X(1, :), X(2, :), X(3, :), 20, X(1, :)-X(2, :)- X(3, :), '.')
title('3D data')
saveas(gcf, '3D raw.png')

Cov = X*X'/size(X, 2);
[U,D] = eig(Cov);

disp("vars :")
disp(D)
[D,I] = sort(diag(D), 'descend');

U = U(:, I);

u1 = 20*U(:, 1);
u2 = 20*U(:, 2);
u3 = 20*U(:, 3);
hold on
quiver3(Mean(1),Mean(2),Mean(3),u1(1), u1(2), u1(3),'black');
quiver3(Mean(1),Mean(2),Mean(3),u2(1), u2(2), u2(3))
quiver3(Mean(1),Mean(2),Mean(3),u3(1), u3(2), u3(3))
hold off
saveas(gcf, 'raw data + directions.png')

X_whitened = diag(D.^(-1/2))*U'*X;
X1 = X_whitened;
C = cov(X_whitened');
disp(C)

figure
scatter3(X_whitened(1, :), X_whitened(2, :), X_whitened(3, :), 20, X_whitened(1, :)- X_whitened(2, :)- X_whitened(3, :), '.')
title("Whitened data 3D")
saveas(gcf, '3D white.png')

figure
t = (0:size(X, 2)-1)/fs;


for i=1:3
    subplot(3, 1, i)
    plot(t, X_whitened(i, :))
    xlabel('Time(s)')
end
sgtitle('Whitened signal')
saveas(gcf, 'signal white.png')


[coeff, score, latent] = pca(X');

U = coeff;
D = latent;

% Plotting 3D data
figure
scatter3(X(1, :), X(2, :), X(3, :), 20, X(1, :)-X(2, :)- X(3, :), '.')

u1 = 20*U(:, 1);
u2 = 20*U(:, 2);
u3 = 20*U(:, 3);
hold on
quiver3(Mean(1),Mean(2),Mean(3),u1(1), u1(2), u1(3),'black');
quiver3(Mean(1),Mean(2),Mean(3),u2(1), u2(2), u2(3))
quiver3(Mean(1),Mean(2),Mean(3),u3(1), u3(2), u3(3))
hold off

title('PCA - raw data')
saveas(gcf, 'PCA - raw data.png')

X_whitened = diag(D.^(-1/2))*U'*X;
C = cov(X_whitened');
disp(C)

figure
scatter3(X_whitened(1, :), X_whitened(2, :), X_whitened(3, :), 20, X_whitened(1, :)- X_whitened(2, :)- X_whitened(3, :), '.')
title("PCA - Whitened data 3D")
saveas(gcf, "PCA - Whitened data 3D.png")

figure
t = (0:size(X, 2)-1)/fs;
sgtitle('PCA - Whitened signal')
xlabel('Time(s)')
for i=1:3
    subplot(3, 1, i)
    plot(t, X_whitened(i, :))
end
saveas(gcf, "PCA - Whitened signal.png")

[U, S, V] = svd(X);
new_components = [u1, u2, u3];
variance = diag(S).^2 ./ size(X,2);
Whitened_signal = V(:, 1:3)' * size(X,2)^(1/2);

disp("new_components :")
disp(new_components)
disp("variance :")
disp(variance)

figure
t = (0:size(X, 2)-1)/fs;
sgtitle('SVD - transformed signal')

for i=1:3
    subplot(3, 1, i)
    hold on
    plot(t, -Whitened_signal(i, :))    
    xlabel('Time(s)')
    hold off
end
saveas(gcf, 'SVD - whitened signal.png')
