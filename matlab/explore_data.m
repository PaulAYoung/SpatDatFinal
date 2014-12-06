load('./fields.mat');
[oak, oak_data] = shaperead('oak_union.shp', 'UseGeoCoords', true);
%%
[mforc, i_forc] =  max(Forclosures.forclosures(:));

[year, lon, lat] =  ind2sub(size(Forclosures.forclosures),  i_forc);

%%

figure
hold on
axis xy
colorbar

imagesc(squeeze(Forclosures.forclosures(4, :, :)))

for i=1:length(oak)
    plot(oak(i).Lon, oak(i).Lat, 'g')
end

%%
figure
hold on
for g=1:length(StarScores.grades)
    color = [1/g, 1-1/g, 0]
    plot(StarScores.years, StarScores.scores(:, g, 2, 48, 50), 'Color', color);
end
legend('2', '3', '4', '5');

%%
i_size = 101;
j_size = 101;

regress_pre = nan(i_size, j_size);
grid_size=10;
cutoff = 2006;


%%
% for i=1:101
%     for j=1:101
%    

cut_index = find(cutoff==StarScores.years);
i=50;
j=50;
        i_min = max([i-grid_size/2, 1]);
        i_max = min([i+grid_size/2, i_size]);
        j_min = max([j-grid_size/2, 1]);
        j_max = min([j+grid_size/2, j_size]);
        
        %%
        y = squeeze(StarScores.scores(1:4,1,1,i_min:i_max, j_min:j_max));
        x = nan(size(y));
        y = reshape(data, numel(data), 1);
        
        
%     end
% end
