function [F, x_grid, y_grid] = ...
    make_score_field(x, y, values, weights, grid_size, range, bandwidth, filter)
  
    x_grid = range(1,1):grid_size:range(2,1);
    y_grid = range(1,2):grid_size:range(2,2);
    
    F = nan(length(y_grid), length(x_grid));

    for i=1:length(x_grid)
        for j=1:length(y_grid)
             if inpolygon(x_grid(i), y_grid(j), filter.Lon, filter.Lat)==0
                 continue;
             end
            distances = sqrt(((x_grid(i)+.5*grid_size)-x).^2+((y_grid(j)+.5*grid_size)-y).^2);
            
            nearby = [double(values(distances<=bandwidth, :)), ...
                double(weights(distances<=bandwidth, :)), ...
                double(distances(distances<=bandwidth))...
                ];
            
            if isempty(nearby)==1
                continue;
            end
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
            F(j, i)= value/total_weights;
        end
    end
end