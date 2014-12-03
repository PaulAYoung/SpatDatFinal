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