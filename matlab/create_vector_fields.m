% read data
star_scores = readtable('./oak_star.csv', 'TreatAsEmpty', 'NULL', ...
    'format', '%f%f%s%s%f%f%f%f%f%f%s%s%u%u', ...
    'Delimiter', '\t' ...
    );

%%
[oak, oak_data] = shaperead('oak_union.shp', 'UseGeoCoords', true);

%%
grades = sort(unique(star_scores.grade));
years = sort(unique(star_scores.year));
tests = sort(unique(star_scores.testid));

%%

score_fields = nan(length(years), length(grades), length(tests), 101,101);
bandwidth = .015;
filter = oak;
grid_size=.0025;

%% Create language test fields

for year=1:length(years)
for grade=1:length(grades)
for test=1:length(tests)

    strcat(num2str(years(year)), ' - ', num2str(grades(grade)), ' - ',  num2str(tests(test)))
    data_filter = star_scores.year==years(year) & ...
                    strcmp(star_scores.Charter, 'N') & ...
                    star_scores.testid==tests(test) & ...
                    star_scores.grade==grades(grade) ...
                    ;

    range = [
        -122.35, 37.65
        -122.1, 37.9
        ];
    x = star_scores.Longitude(data_filter);
    y = star_scores.Latitude(data_filter);
    values = star_scores.meanscaledscore(data_filter);
    weights = star_scores.totaltestedatentitylevel(data_filter);

    [score_field, x_grid, y_grid] = make_score_field(x, y, values, weights, grid_size, range, bandwidth, filter);

    score_fields(year, grade, test, :, :) = score_field;
end
end
end


%%
description = 'scores is a matrix of star tests scores indexed by [year,grade,test,lon,lat]';

StarScores = struct('scores', score_fields, ...
    'years', years, ...
    'grades', grades, ...
    'tests', tests, ...
    'description', description);

%%

forclosures = readtable('./forclosures.csv');

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
    x = forclosures.Longitude(data_filter);
    y = forclosures.Latitude(data_filter);
    filter = oak;


    [score_field, x_grid, y_grid] = make_intensity_field(x, y, grid_size, range, bandwidth, filter);

    intensity_fields(year, :, :) = score_field;
end

%%

%%

description = 'forclosures is a matrix of forclosure intensity indexed by [year,lon,lat]';

Forclosures = struct;
Forclosures.years = years;
Forclosures.forclosures = intensity_fields;
Forclosures.description = description;

%%

save('fields.mat', 'Forclosures', 'StarScores')