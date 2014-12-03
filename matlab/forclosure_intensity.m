forclosures = readtable('./forclosures.csv');

%%
%%
[oak, oak_data] = shaperead('oak_union.shp', 'UseGeoCoords', true);

%%
figure
hold on
axis xy

plot(forclosures.Longitude, forclosures.Latitude, 'ro')

for i=1:length(oak)
    plot(oak(i).Lon, oak(i).Lat)
end

%%

years = sort(unique(forclosures.Year));

%%

intensity_fields = nan(length(years), 101,101);

%%

for year=1:length(years)

    years(year)
    data_filter = forclosures.Year==years(year);

    range = [
        -122.35, 37.65
        -122.1, 37.9
        ];
    grid_size=.0025;
    x = forclosures.Longitude(data_filter);
    y = forclosures.Latitude(data_filter);
    bandwidth = .015;
    filter = oak;


    [score_field, x_grid, y_grid] = make_intensity_field(x, y, grid_size, range, bandwidth, filter);

    intensity_fields(year, :, :) = score_field;
end

%%

figure
hold on
axis xy
colorbar

imagesc(x_grid, y_grid, squeeze(intensity_fields(4, :, :)))

for i=1:length(oak)
    plot(oak(i).Lon, oak(i).Lat, 'g')
end

%%

Forclosures = struct;

%%

Forclosures.years = years;
Forclosures.forclosures = intensity_fields;

%%

save('forclosures.mat', 'Forclosures')