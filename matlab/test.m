% read data
star_scores = readtable('./oak_star.csv', 'TreatAsEmpty', 'NULL', ...
    'format', '%f%f%s%s%f%f%f%f%f%f%s%s%u%u', ...
    'Delimiter', '\t' ...
    );

%%
[oak, oak_data] = shaperead('Oakland.shp', 'UseGeoCoords', true);

%% Create field

data_filter = star_scores.year==2003 & ...
                strcmp(star_scores.Charter, 'N') & ...
                star_scores.testid==7 & ...
                star_scores.grade==2 ...
                ;

range = [
    -122.35, 37.65
    -122.1, 37.9
    ];
resolution = [100, 100];
x = star_scores.Longitude(data_filter);
y = star_scores.Latitude(data_filter);
values = star_scores.meanscaledscore(data_filter);
weights = star_scores.totaltestedatentitylevel(data_filter);
bandwidth = .015;
filter = oak;

%%

F = nan(resolution);
xstep = abs(range(1,1)-range(2,1))/resolution(1);
ystep = abs(range(1,2)-range(2,2))/resolution(2);

x_grid = range(1,1):xstep:range(2,1);
y_grid = range(1,2):ystep:range(2,2);


%%


%             if inpolygon(x_grid(i), y_grid(j), filter.Lon, filter.Lat)==0
%                 continue;
%             end

i=83;
j=43;

distances = sqrt(((x_grid(i)+.5*xstep)-x).^2+((y_grid(j)+.5*ystep)-y).^2);

nearby = [double(values(distances<=bandwidth, :)), ...
    double(weights(distances<=bandwidth, :)), ...
    double(distances(distances<=bandwidth))...
    ];

value = 0;
total_weights = 0;
s = size(nearby);
for n=1:s(1)
    if isnan(nearby(n,1))
        continue;
    end
    weight = nearby(n, 2) * (1-nearby(n, 3)/bandwidth);
    total_weights = total_weights + weight;
    value = value + nearby(n, 1) * weight;
end
F(j,i)= value/total_weights;

%%

figure
hold on
colorbar
axis xy

imagesc(x_grid, y_grid, F, [0,500])

for i=1:length(x)
    %color = [values(i)/600, 1-values(i)/600, 0];
    if isnan(values(i))
        continue;
    end
    plot(x(i), y(i), 'go')
    %text(x(i), y(i), num2str(values(i)))
end

for i=1:length(oak)
    plot(oak(i).Lon, oak(i).Lat, 'g')
end
