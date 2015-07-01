function axesSet = GetAxisSet( figH, ob )
%GETAXISSET returns a handle to a 3-dimensional set of orthogonal basis
%vectors and optionally an arbitrary 3-dimensional object
%
% axesSet = GetAxisSet(figH, ob) creates the objects in figure (figH) and
% returns a handle to the objects. If (ob) is true, the handle will include 
% a 3-dimensional object for better visualization.
%

    figure(figH);
    
    if ~exist('ob','var') || isempty(ob)
        ob = false;
    end
    
    % Get arrow shaft data
    [xshaft, yshaft, zshaft] = cylinder(0.005, 24);
    
    % Get arrowhead data
    [xhead, yhead, zhead] = cylinder([0.015, 0.001], 24);
    
    % Scale and shift z-data of arrowhead
    zhead = zhead/10 + .95;
    
    % Create Surfaces
    % Create X-Axis
    sx = surface(zshaft, yshaft, xshaft, 'FaceColor', 'r');
    hx = surface(zhead, yhead, xhead, 'FaceColor', 'r');
    
    % Create Y-Axis
    sy = surface(xshaft, zshaft, yshaft, 'FaceColor', 'b');
    hy = surface(xhead, zhead, yhead, 'FaceColor', 'b');
    
    % Create Z-Axis
    sz = surface(xshaft, yshaft, zshaft, 'FaceColor', 'g');
    hz = surface(xhead, yhead, zhead, 'FaceColor', 'g');
    
    % Arrange Axes in figure window
    axis equal vis3d;
    axis([-2 2 -2 2 -2 2]);
    view(105, 9);
    grid on;
    box on;
    set(gca,...
        'LineWidth', 0.0001,...
        'XTick', -2:.1:2 ,...
        'YTick', -2:.1:2 ,...
        'ZTick', -2:.1:2 ,...
        'GridAlpha', .09 ,...
        'XTickLabel', '',...
        'YTickLabel', '',...
        'ZTickLabel', '',...
        'TickLength', [0.001, 0.001] ...
    );
    xlabel('x');
    ylabel('y');
    zlabel('z');
    
    % Set some options for the axis vectors
    axesSet = [sx hx sy hy sz hz];
    
    for j = 1:length(axesSet)
        axesSet(j).LineStyle = 'none';
        axesSet(j).AmbientStrength = 0.3;
        axesSet(j).DiffuseStrength = 0.6;
        axesSet(j).SpecularStrength = 0.0;
        axesSet(j).SpecularExponent = 20;
        axesSet(j).SpecularColorReflectance = 0.0;
    end
    
    % If selected, add object
    if ob
        [x, y, z] = cylinder([.2 .01], 48);
        x = x/2;
        y = y/2;
        z = z/2;
        h(1) = surface(x,y,z,'FaceColor', [0.2, 0.85, 0.66]);
        h(2) = surface(x,y,-z,'FaceColor', [0.2, 0.85, 0.66]);
        h(3) = surface(z,x,y,'FaceColor', [0.99, 0.6, 0.57]);
        h(4) = surface(-z,x,y,'FaceColor', [0.99, 0.6, 0.57]);
        h(5) = surface(y,z,x,'FaceColor', [0.2, 0.67, 0.88]);
        h(6) = surface(y,-z,x,'FaceColor', [0.2, 0.67, 0.88]);
        
        for j = 1:6
           h(j).EdgeAlpha = .5;
           h(j).LineStyle= 'none';
           h(j).AmbientStrength = 0.3;
           h(j).DiffuseStrength = 0.6;
           h(j).SpecularStrength = 0.9;
           h(j).SpecularExponent = 20;
           h(j).SpecularColorReflectance = 1.0;
        end
        
        % Return handle to the set of objects
        axesSet = [axesSet h];
    end

end

