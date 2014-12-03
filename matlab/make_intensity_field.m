function [F, x_grid, y_grid] = ...
    make_intensity_field(x, y, grid_size, range, bandwidth, filter)
  
    x_grid = range(1,1):grid_size:range(2,1);
    y_grid = range(1,2):grid_size:range(2,2);
    
    F = nan(length(y_grid), length(x_grid));

    for i=1:length(x_grid)
        for j=1:length(y_grid)
             if inpolygon(x_grid(i), y_grid(j), filter.Lon, filter.Lat)==0
                 continue;
             end
            distances = sqrt(((x_grid(i)+.5*grid_size)-x).^2+((y_grid(j)+.5*grid_size)-y).^2);
            
            nearby = double(distances(distances<=bandwidth));
            
            if isempty(nearby)==1
                continue;
            end
            value = 0;
            for n=1:length(nearby)
                if isnan(nearby(n))
                    continue;
                end
                value = value + (1-nearby(n)/bandwidth);
            end
            F(j, i)= value;
        end
    end
end